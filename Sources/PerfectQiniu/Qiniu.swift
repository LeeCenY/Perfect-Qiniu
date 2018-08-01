//
//  Qiniu.swift
//  COpenSSL
//
//  Created by nil on 2018/4/26.
//

import Foundation
import PerfectCrypto
import PerfectCURL
import cURL

/// 七牛配置
public struct QiniuConfiguration {

    let accessKey: String
    let secretKey: String
    let scope: String
    let fixedZone: QNFixedZone
    let DEBUG: Bool
    
    public enum QNFixedZone: String {
        case HDzone = "https://up.qiniup.com"
        case HBzone = "https://up-z1.qiniup.com"
        case HNzone = "https://up-z2.qiniup.com"
        case BMzone = "https://up-na0.qiniup.com"
        case DNYzone = "https://up-as0.qiniup.com"
    }
    
    public init(accessKey: String, secretKey: String, scope: String, fixedZone: QNFixedZone = QNFixedZone.HDzone, DEBUG: Bool = false) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.scope = scope
        self.fixedZone = fixedZone
        self.DEBUG = DEBUG
    }
}

//七牛操作
public class Qiniu {

    struct PutPolicy: Codable {
        let scope: String
        let deadline: Int
    }
    
    public enum UploadError: Error {
        case badToken
        case RequestfFailed(String)
    }
    
    func getToken(config: QiniuConfiguration) throws -> String {
        
        let deadline = Date().timeIntervalSince1970 + 36500
        let putPolicy = PutPolicy.init(scope: config.scope, deadline: Int(deadline))
        
        let jsonData = try JSONEncoder().encode(putPolicy)
        let base64String = jsonData.base64EncodedString().urlSafeBase64()
        
        guard let encodeData = base64String.sign(Digest.sha1, key: HMACKey.init(config.secretKey)),
            let encodeBase64 = encodeData.encode(.base64),
            let encodeString = String.init(validatingUTF8: encodeBase64) else {
                throw UploadError.badToken
        }
        
        let encodedSignString = encodeString.urlSafeBase64()
        return "\(config.accessKey):\(encodedSignString):\(base64String)"
    }
    
   public static func upload(fileName: String = "?", file: String, config: QiniuConfiguration) throws -> [String:Any] {
        
        let token = try Qiniu().getToken(config: config)
        
        let fields = CURL.POSTFields()
        let _ = fields.append(key: "token", value: token)
        let _ = fields.append(key: "key", value: fileName)
        let _ = fields.append(key: "file", path: file)
        
        let curl = CURL(url: config.fixedZone.rawValue)
        let ret = curl.formAddPost(fields: fields)
        defer { curl.close() }
        guard ret.rawValue == 0 else {
            throw UploadError.RequestfFailed(curl.strError(code: ret))
        }
        let _ = curl.setOption(CURLOPT_VERBOSE, int: config.DEBUG ? 1 : 0 )
        let r = curl.performFullySync()
        
        var ptr = r.bodyBytes
        ptr.append(0)
        let s = String(cString: ptr)
        guard r.resultCode == 0, r.responseCode == 200 else {
            throw UploadError.RequestfFailed(s)
        }
        return try s.jsonDecode() as? [String:Any] ?? [:]
    }
}

public extension String {
    func urlSafeBase64() -> String {
        return self.replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_")
    }
}
