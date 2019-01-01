//
//  PrepareTransactionViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Zesame

// MARK: - PrepareTransactionUserAction
enum PrepareTransactionUserAction: TrackedUserAction {
	case cancel
	case signPayment(Payment)
	case scanQRCode
}

// MARK: - PrepareTransactionViewModel
private typealias € = L10n.Scene.PrepareTransaction
final class PrepareTransactionViewModel: BaseViewModel<
	PrepareTransactionUserAction,
	PrepareTransactionViewModel.InputFromView,
	PrepareTransactionViewModel.Output
> {
	private let transactionUseCase: TransactionsUseCase
	private let walletUseCase: WalletUseCase
	private let scannedOrDeeplinkedTransaction: Driver<TransactionIntent>

	init(walletUseCase: WalletUseCase, transactionUseCase: TransactionsUseCase, scannedOrDeeplinkedTransaction: Driver<TransactionIntent>) {
		self.walletUseCase = walletUseCase
		self.transactionUseCase = transactionUseCase
		self.scannedOrDeeplinkedTransaction = scannedOrDeeplinkedTransaction
	}

	// swiftlint:disable:next function_body_length
	override func transform(input: Input) -> Output {
		func userIntends(to intention: NavigationStep) {
			navigator.next(intention)
		}

		let wallet = walletUseCase.wallet.filterNil().asDriverOnErrorReturnEmpty()
		let activityIndicator = ActivityIndicator()
		let errorTracker = ErrorTracker()

		let fetchTrigger = Driver.merge(
			input.fromView.pullToRefreshTrigger,
			wallet.mapToVoid()
		)

		// Fetch latest balance from API
		let latestBalanceAndNonce: Driver<BalanceResponse> = fetchTrigger.withLatestFrom(wallet).flatMapLatest {
			self.transactionUseCase
				.getBalance(for: $0.address)
				.trackActivity(activityIndicator)
				.trackError(errorTracker)
				.asDriverOnErrorReturnEmpty()
		}

		let nonce = latestBalanceAndNonce.map { $0.nonce }.startWith(0)
		let _startingBalance: ZilAmount = transactionUseCase.cachedBalance ?? 0
		let balance: Driver<ZilAmount> = latestBalanceAndNonce.map { $0.balance }.startWith(_startingBalance)

		// MARK: - VALIDATION -> VALUE
		let validator = InputValidator()

		// MARK: Recipient Input ->  Value + Validation
		let recipientValidationValue = Driver.merge(
			input.fromView.recepientAddress.map { validator.validateRecipient($0) },
			scannedOrDeeplinkedTransaction.map { .valid($0.recipient) }
		)

		let recipient: Driver<Address?> = recipientValidationValue.map { $0.value }

        let recipientValidationTrigger = input.fromView.didEndEditingRecipientAddress

		let recipientValidation: Driver<Validation> = Driver.merge(
            recipientValidationTrigger.withLatestFrom(recipientValidationValue).onlyErrors(),
			recipientValidationValue.onlyValidOrEmpty()
		)

		// MARK: GasPrice Input -> Value + Validation
        let _startingGasPrice: GasPrice = .min
        let gasPriceValidationValue = input.fromView.gasPrice.map { validator.validateGasPrice($0) }.startWith(.valid(_startingGasPrice))

        let gasPrice = gasPriceValidationValue.map { $0.value }

        let gasPriceValidationErrorTrigger: Driver<Void> = Driver.merge(
            input.fromView.didEndEditingGasPrice,
            input.fromView.maxAmountTrigger
        )

		let gasPriceValidation = Driver.merge(
            gasPriceValidationErrorTrigger.withLatestFrom(gasPriceValidationValue).onlyErrors(),
			gasPriceValidationValue.onlyValidOrEmpty()
        )

		// MARK: Amount + MaxAmountTrigger Input -> Value + Validation
		let amountWithoutSufficientFundsCheckValidationValue = Driver.merge(
			input.fromView.amountToSend.map { validator.validateAmount($0) },
			scannedOrDeeplinkedTransaction.map { .valid($0.amount) }
		)

		let amountWithoutSufficientFundsCheck: Driver<ZilAmount?> = amountWithoutSufficientFundsCheckValidationValue.map { $0.value }

        let amountValidationValue: Driver<SufficientFundsValidator.Result> = Driver.combineLatest(

            Driver.merge(
                // Input from fields or deeplinked/scanned
                amountWithoutSufficientFundsCheck,

                // Max trigger -> Balance SUBTRACT GasPrice (default to min)
                input.fromView.maxAmountTrigger.withLatestFrom(
                    Driver.combineLatest(
                        balance.startWith(_startingBalance),
                        gasPrice.startWith(_startingGasPrice)
                    ) { (latestBalance: ZilAmount?, latestGasPrice: GasPrice?) -> ZilAmount? in
                        let balanceOrZero: ZilAmount = latestBalance ?? _startingBalance
                        let gasPriceOrMin: GasPrice = latestGasPrice ?? _startingGasPrice

                        guard let balanceMinusGas: ZilAmount = try? balanceOrZero - gasPriceOrMin else {
                            return nil
                        }
                        return balanceMinusGas
                    }
                ) { $1 }
            ),

            gasPrice.startWith(_startingGasPrice),
            balance.startWith(_startingBalance)
        ) { (amount: ZilAmount?, gasPrice: GasPrice?, balance: ZilAmount?) in
            validator.validate(amount: amount, gasPrice: gasPrice, lessThanBalance: balance)
        }

		let amountBoundByBalance = amountValidationValue.map { $0.value }

		let amountValidationErrorTrigger: Driver<Void> = Driver.merge(
            input.fromView.didEndEditingAmount,
			scannedOrDeeplinkedTransaction.mapToVoid()
		)

		let amountValidation = Driver.merge(
            amountValidationErrorTrigger.withLatestFrom(gasPriceValidationValue).onlyErrors(),
			amountValidationValue.onlyValidOrEmpty()
		)

		let payment: Driver<Payment?> = Driver.combineLatest(recipient, amountBoundByBalance, gasPrice, nonce) {
			guard let to = $0, let amount = $1, let price = $2, case let nonce = $3 else {
				return nil
			}
			return Payment(to: to, amount: amount, gasLimit: 1, gasPrice: price, nonce: nonce)
		}

		// Setup navigation
		bag <~ [
			input.fromController.rightBarButtonTrigger
				.do(onNext: { userIntends(to: .cancel) })
				.drive(),

			input.fromView.scanQRTrigger
				.do(onNext: { userIntends(to: .scanQRCode) })
				.drive(),

			input.fromView.sendTrigger.withLatestFrom(payment.filterNil())
				.do(onNext: { userIntends(to: .signPayment($0)) })
				.drive()
		]

		// MARK: FORMATTING
		let formatter = Formatter()
		let balanceFormatted = balance.map { formatter.format(amount: $0) }
		let recipientFormatted = recipient.filterNil().map { $0.checksummedHex }
		let amountFormatted = amountBoundByBalance.filterNil().map { $0.zilString }

		let isSendButtonEnabled = payment.map { $0 != nil }

		let gasPricePlaceholder = Driver.just(€.Field.gasPrice("\(GasPrice.min.liString) \(Unit.li.name)"))

        return Output(
            isFetchingBalance: activityIndicator.asDriver(),
            isSendButtonEnabled: isSendButtonEnabled,
            balance: balanceFormatted,

            recipient: recipientFormatted,
            recipientAddressValidation: recipientValidation,

            amount: amountFormatted,
            amountValidation: amountValidation,

            gasPriceMeasuredInLi: gasPrice.flatMapLatest {
                if let gasPrice = $0 {
                    return .just(gasPrice.liString)
                } else {
                    return input.fromView.gasPrice
                }
            },
            gasPricePlaceholder: gasPricePlaceholder,
            gasPriceValidation: gasPriceValidation
        )
	}
}

extension PrepareTransactionViewModel {

	struct InputFromView {
		let pullToRefreshTrigger: Driver<Void>
		let scanQRTrigger: Driver<Void>
		let maxAmountTrigger: Driver<Void>
		let sendTrigger: Driver<Void>

		let recepientAddress: Driver<String>
		let didEndEditingRecipientAddress: Driver<Void>

		let amountToSend: Driver<String>
		let didEndEditingAmount: Driver<Void>

		let gasPrice: Driver<String>
		let didEndEditingGasPrice: Driver<Void>
	}

	struct Output {
		let isFetchingBalance: Driver<Bool>
		let isSendButtonEnabled: Driver<Bool>
		let balance: Driver<String>

		let recipient: Driver<String>
		let recipientAddressValidation: Driver<Validation>

		let amount: Driver<String>
		let amountValidation: Driver<Validation>

		let gasPriceMeasuredInLi: Driver<String>
		let gasPricePlaceholder: Driver<String>
		let gasPriceValidation: Driver<Validation>
	}
}

// MARK: - Field Validation
extension PrepareTransactionViewModel {
	struct InputValidator {
		private let addressValidator = AddressValidator()
		private let amountValidator = AmountValidator()
		private let gasPriceValidator = GasPriceValidator()
		private let sufficientFundsValidator = SufficientFundsValidator()

		func validateRecipient(_ recipient: String?) -> AddressValidator.Result {
			return addressValidator.validate(input: recipient)
		}

		func validate(amount: ZilAmount?, gasPrice: GasPrice?, lessThanBalance balance: ZilAmount?) -> SufficientFundsValidator.Result {
			return sufficientFundsValidator.validate(input: (amount, gasPrice, balance))
		}

		func validateAmount(_ amount: String) -> AmountValidator.Result {
			return amountValidator.validate(input: amount)
		}

		func validateGasPrice(_ gasPrice: String?) -> GasPriceValidator.Result {
			return gasPriceValidator.validate(input: gasPrice)
		}
	}

	struct Formatter {
		func format(amount: ZilAmount) -> String {
            let amountString = amount.formatted(unit: .zil)
			return "\(amountString) \(L10n.Generic.zils)"
		}
	}
}
