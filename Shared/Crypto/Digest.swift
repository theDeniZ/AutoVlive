//
//  Digest.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 11.12.21.
//

import CommonCrypto
import Foundation

enum HMACAlgorithm {
    case md5, sha1, sha224, sha256, sha384, sha512

    // MARK: Internal

    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result = 0
        switch self {
        case .md5:
            result = kCCHmacAlgMD5
        case .sha1:
            result = kCCHmacAlgSHA1
        case .sha224:
            result = kCCHmacAlgSHA224
        case .sha256:
            result = kCCHmacAlgSHA256
        case .sha384:
            result = kCCHmacAlgSHA384
        case .sha512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }

    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .md5:
            result = CC_MD5_DIGEST_LENGTH
        case .sha1:
            result = CC_SHA1_DIGEST_LENGTH
        case .sha224:
            result = CC_SHA224_DIGEST_LENGTH
        case .sha256:
            result = CC_SHA256_DIGEST_LENGTH
        case .sha384:
            result = CC_SHA384_DIGEST_LENGTH
        case .sha512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    func digest(algorithm: HMACAlgorithm) -> String {
        digest(algorithm: algorithm, key: ApiSecret.value())
    }

    func digest(algorithm: HMACAlgorithm, key: String) -> String {
        let str = cString(using: String.Encoding.utf8)
        let strLen = UInt(lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength()
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = UInt(key.lengthOfBytes(using: String.Encoding.utf8))

        CCHmac(algorithm.toCCHmacAlgorithm(), keyStr!, Int(keyLen), str!, Int(strLen), result)
        return NSData(bytes: result, length: digestLen).base64EncodedString(options: .endLineWithCarriageReturn)
    }
}
