//
//  OnboardingCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import Zesame

final class OnboardingCoordinator: AbstractCoordinator<OnboardingCoordinator.Step> {
    enum Step {
        case userFinishedOnboording
    }

    private let useCaseProvider: UseCaseProvider
    
    private lazy var onboardingUseCase = useCaseProvider.makeOnboardingUseCase()
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()

    init(presenter: Presenter?, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(presenter: presenter)
    }

    override func start() {
        toNextStep()
    }
}

private extension OnboardingCoordinator {

    func toNextStep() {
        guard onboardingUseCase.hasAcceptedTermsOfService else {
            return toTermsOfService()
        }

        guard onboardingUseCase.hasAskedToSkipERC20Warning else {
            return toWarningERC20()
        }

        guard walletUseCase.hasConfiguredWallet else {
            return toChooseWallet()
        }

        guard !onboardingUseCase.shouldPromptUserToChosePincode else {
            return toChoosePincode()
        }

        finish()
    }

    func toTermsOfService() {
        let viewModel = TermsOfServiceViewModel(useCase: onboardingUseCase)
        present(type: TermsOfService.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .acceptTermsOfService: self.toWarningERC20()
            }
        }
    }

    func toWarningERC20() {
        let viewModel = WarningERC20ViewModel(useCase: onboardingUseCase)
        present(type: WarningERC20.self, viewModel: viewModel) { [unowned self] in
            switch $0 {
            case .understandRisks: self.toChooseWallet()
            }
        }
    }

    func toChooseWallet() {
        let coordinator = ChooseWalletCoordinator(
            presenter: presenter,
            useCaseProvider: useCaseProvider
        )

        start(coordinator: coordinator) { [unowned self] in
            switch $0 {
            case .userFinishedChoosingWallet: self.toChoosePincode()
            }
        }
    }

    func toChoosePincode() {
        let coordinator = ManagePincodeCoordinator(
            intent: .setPincode,
            presenter: presenter,
            useCase: useCaseProvider.makePincodeUseCase()
        )

        start(coordinator: coordinator) { [unowned self] in
            switch $0 {
            case .userFinishedChoosingOrRemovingPincode: self.finish()
            }
        }
    }

    func finish() {
        stepper.step(.userFinishedOnboording)
    }
}
