//
//  ZilliqaService.swift
//  Zesame iOS
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import EllipticCurveKit
import JSONRPCKit
import Result
import APIKit
import RxSwift
import CryptoSwift

public protocol ZilliqaService: AnyObject {
    var apiClient: APIClient { get }

    func verifyThat(encryptionPasshrase: String, canDecryptKeystore: Keystore, done: @escaping Done<Bool>)
    func createNewWallet(encryptionPassphrase: String, done: @escaping Done<Wallet>)
    func restoreWallet(from restoration: KeyRestoration, done: @escaping Done<Wallet>)
    func exportKeystore(address: AddressChecksummedConvertible, privateKey: PrivateKey, encryptWalletBy passphrase: String, done: @escaping Done<Keystore>)

    func getBalance(for address: AddressChecksummedConvertible, done: @escaping Done<BalanceResponse>)
    func send(transaction: SignedTransaction, done: @escaping Done<TransactionResponse>)
}

public protocol ZilliqaServiceReactive {

    func verifyThat(encryptionPasshrase: String, canDecryptKeystore: Keystore) -> Observable<Bool>
    func createNewWallet(encryptionPassphrase: String) -> Observable<Wallet>
    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet>
    func exportKeystore(address: AddressChecksummedConvertible, privateKey: PrivateKey, encryptWalletBy passphrase: String) -> Observable<Keystore>
    func extractKeyPairFrom(keystore: Keystore, encryptedBy passphrase: String) -> Observable<KeyPair>

    func getBalance(for address: AddressChecksummedConvertible) -> Observable<BalanceResponse>
    func sendTransaction(for payment: Payment, keystore: Keystore, passphrase: String) -> Observable<TransactionResponse>
    func sendTransaction(for payment: Payment, signWith keyPair: KeyPair) -> Observable<TransactionResponse>

    func hasNetworkReachedConsensusYetForTransactionWith(id: String, polling: Polling) -> Observable<TransactionReceipt>
}

public extension ZilliqaServiceReactive {

    func extractKeyPairFrom(wallet: Wallet, encryptedBy passphrase: String) -> Observable<KeyPair> {
        return extractKeyPairFrom(keystore: wallet.keystore, encryptedBy: passphrase)
    }

    func extractKeyPairFrom(keystore: Keystore, encryptedBy passphrase: String) -> Observable<KeyPair> {
        return Observable.create { observer in

            keystore.toKeypair(encryptedBy: passphrase) {
                switch $0 {
                case .success(let keyPair):
                    observer.onNext(keyPair)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func hasNetworkReachedConsensusYetForTransactionWith(id: String) -> Observable<TransactionReceipt> {
        return hasNetworkReachedConsensusYetForTransactionWith(id: id, polling: .twentyTimesLinearBackoff)
    }

}
