//
//  EncryptionManager.swift
//  PersonalCare
//
//  Created by uvionics on 3/7/18.
//  Copyright © 2018 Uvionics. All rights reserved.
//




import Foundation
import CryptoSwift

class EncryptionManager {
    func aesEncrypt(plainText: String, key: String = cryptionKey) throws -> String {
        let data = plainText.data(using: .utf8)!
        let encrypted = try! AES(key: key.bytes, blockMode: ECB.init(), padding: .pkcs7).encrypt(data.bytes)
        let encryptedData = Data(encrypted)
        return encryptedData.toHexString()
    }
    
    func aesDecrypt(cipherText: String, key: String = cryptionKey) throws -> String {
        let data = Data(hex: cipherText)//Data(cipherText.bytes)
        let decrypted = try! AES(key: key.bytes, blockMode: ECB.init(),padding: .pkcs7).decrypt(data.bytes)
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8)! ?? "Could not decrypt"
        
    }
    
    func serializeDictionary(dictionary: [String: Any]) -> String {
        
        let theJSONData = try? JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        let theJSONText = String(data: theJSONData!, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
        
        return theJSONText!
    }
    
    func deserializeDictionary(string: String) -> [String: Any]? {
        if let data = string.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        assert(true, "Serialization returns non dictionary output")
        return nil
    }
    
}
