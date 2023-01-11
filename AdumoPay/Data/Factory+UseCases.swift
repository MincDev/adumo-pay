//
//  Factory+UseCases.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

extension Container {
    // Should only be accessible through Facade
    fileprivate static let authenticateUseCase = Factory<AuthenticateUseCase> { AuthenticateUseCaseImpl() }
    fileprivate static let initiateTransactionUseCase = Factory<InitiateTransactionUseCase> { InitiateTransactionUseCaseImpl() }
    fileprivate static let verifyTransactionUseCase = Factory<VerifyTransactionUseCase> { VerifyTransactionUseCaseImpl() }
    fileprivate static let authoriseTransactionUseCase = Factory<AuthoriseTransactionUseCase> { AuthoriseTransactionUseCaseImpl() }
    fileprivate static let reverseTransactionUseCase = Factory<ReverseTransactionUseCase> { ReverseTransactionUseCaseImpl() }
    fileprivate static let settleTransactionUseCase = Factory<SettleTransactionUseCase> { SettleTransactionUseCaseImpl() }
    fileprivate static let refundTransactionUseCase = Factory<RefundTransactionUseCase> { RefundTransactionUseCaseImpl() }

    static let useCases = Factory<AdumoPayUseCases> { AdumoPayUseCasesFacade() }
}

protocol AdumoPayUseCases {
    var authenticate: AuthenticateUseCase { get }
    var initiate: InitiateTransactionUseCase { get }
    var verify: VerifyTransactionUseCase { get }
    var authorise: AuthoriseTransactionUseCase { get }
    var reverse: ReverseTransactionUseCase { get }
    var settle: SettleTransactionUseCase { get }
    var refund: RefundTransactionUseCase { get }
}

struct AdumoPayUseCasesFacade: AdumoPayUseCases {
    @Injected(Container.authenticateUseCase) var authenticate: AuthenticateUseCase
    @Injected(Container.initiateTransactionUseCase) var initiate: InitiateTransactionUseCase
    @Injected(Container.verifyTransactionUseCase) var verify: VerifyTransactionUseCase
    @Injected(Container.authoriseTransactionUseCase) var authorise: AuthoriseTransactionUseCase
    @Injected(Container.reverseTransactionUseCase) var reverse: ReverseTransactionUseCase
    @Injected(Container.settleTransactionUseCase) var settle: SettleTransactionUseCase
    @Injected(Container.refundTransactionUseCase) var refund: RefundTransactionUseCase
}
