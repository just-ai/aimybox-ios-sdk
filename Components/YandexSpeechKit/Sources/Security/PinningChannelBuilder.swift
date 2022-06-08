//
//  PinningChannelBuilder.swift
//  YandexSpeechKit
//
//  Created by Alexey Sakovykh on 11.05.2022.
//  Copyright © 2022 Just Ai. All rights reserved.
//

import CommonCrypto
import Foundation
import GRPC
import NIO
import NIOCore
import NIOSSL
import NIOTransportServices

internal final
class PinningChannelBuilder {

    static
    func createPinningChannel(with config: PinningConfig, group: EventLoopGroup) -> GRPCChannel? {

        guard let encodedPin = Data(base64Encoded: config.pin, options: .ignoreUnknownCharacters) else {
            return nil
        }

        let tlsConfiguration =
            GRPCTLSConfiguration
            .makeClientConfigurationBackedByNIOSSL(configuration: TLSConfiguration.clientDefault) { certs, eventLoopVerification in

            if let leaf = certs.first, let publicKey = try? leaf.extractPublicKey() {

                if let certSPKI = try? sha256(data: Data(publicKey.toSPKIBytes())), encodedPin == certSPKI {
                    eventLoopVerification.succeed(.certificateVerified)
                } else {
                    eventLoopVerification.fail(NIOSSLError.unableToValidateCertificate)
                }

            } else {
                eventLoopVerification.fail(NIOSSLError.noCertificateToValidate)
            }
            }

        let builder = ClientConnection.usingTLS(with: tlsConfiguration, on: group)
        return builder.connect(host: config.host, port: config.port)
    }

    static
    func sha256(data: Data) -> Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH) )
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
}
