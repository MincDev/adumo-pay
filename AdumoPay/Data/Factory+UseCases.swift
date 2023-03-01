//
//  Factory+UseCases.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

extension Container {
    static let authenticateUseCase = Factory<AuthenticateUseCase> { AuthenticateUseCaseImpl() }
    static let initiateTransactionUseCase = Factory<InitiateTransactionUseCase> { InitiateTransactionUseCaseImpl() }
    static let verifyTransactionUseCase = Factory<VerifyTransactionUseCase> { VerifyTransactionUseCaseImpl() }
    static let authoriseTransactionUseCase = Factory<AuthoriseTransactionUseCase> { AuthoriseTransactionUseCaseImpl() }
    static let reverseTransactionUseCase = Factory<ReverseTransactionUseCase> { ReverseTransactionUseCaseImpl() }
    static let settleTransactionUseCase = Factory<SettleTransactionUseCase> { SettleTransactionUseCaseImpl() }
    static let refundTransactionUseCase = Factory<RefundTransactionUseCase> { RefundTransactionUseCaseImpl() }

    static let useCases = Factory<AdumoPayUseCases> { AdumoPayUseCasesFacade() }
    static let service = Factory<APServiceInternalProtocol> { APServiceInternal() }
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
