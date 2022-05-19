//
//  PinningChannelBuilder.swift
//  YandexSpeechKit
//
//  Created by Alexey Sakovykh on 11.05.2022.
//  Copyright © 2022 Just Ai. All rights reserved.
//

import Foundation
import GRPC
import NIO
import NIOCore



internal final
class PinningChannelBuilder {
    
    func createPinningChannel(with config : PinningConfig, group: EventLoopGroup) -> GRPCChannel? {
    
        var channel : GRPCChannel? = nil
    do{
        channel = try GRPCChannelPool.with(
          target: .host(config.host, port: config.port),
          transportSecurity: .plaintext,
          eventLoopGroup: group
        )
    }
    catch{
            
    }
    
    return channel
        
//
//
//        let myPublicKey = Array(Data(base64Encoded: """
//""", options: .ignoreUnknownCharacters)!)
//
// ClientConnection.secure(group: PlatformSupport.makeEventLoopGroup(loopCount: 1))
//            .withTLSCustomVerificationCallback({ cert, eventLoopVerification in
//                // Extract the leaf certificate's public key,
//                // then compare it to the one you have.
//                if let leaf = cert.first,
//                   let publicKey = try? leaf.extractPublicKey() {
//
//                    if let certSPKI = try? publicKey.toSPKIBytes(),
//                       myPublicKey == certSPKI {
//                        eventLoopVerification.succeed(.certificateVerified)
//                    } else {
//                        eventLoopVerification.fail(NIOSSLError.unableToValidateCertificate)
//                    }
//                } else {
//                    eventLoopVerification.fail(NIOSSLError.noCertificateToValidate)
//                }
//            })
//            .connect(host: host, port: port)
//
//
    }
    
}

//https://developer.apple.com/forums/thread/679787
//let privateKey = Curve25519.KeyAgreement.PrivateKey()
//let publicKey = privateKey.publicKey
//print(publicKey.rawRepresentation.base64EncodedString())

//https://github.com/grpc/grpc-swift/pull/1107
