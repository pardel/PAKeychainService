//
//  KeychainService.swift
//
//  Created by Paul on 07/10/2014.
//

import Foundation
import Security



let kSecClassValue = kSecClass as NSString
let kSecAttrAccountValue = kSecAttrAccount as NSString
let kSecValueDataValue = kSecValueData as NSString
let kSecClassGenericPasswordValue = kSecClassGenericPassword as NSString
let kSecAttrServiceValue = kSecAttrService as NSString
let kSecMatchLimitValue = kSecMatchLimit as NSString
let kSecReturnDataValue = kSecReturnData as NSString
let kSecMatchLimitOneValue = kSecMatchLimitOne as NSString




private let _sharedService = PAKeychainService()


class PAKeychainService: NSObject {
    
    class func sharedService() -> PAKeychainService {
        return _sharedService
    }
    
    
    func saveContentsForKey(value: String, key: String) {
        
        let dataFromString = value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, serviceString(),      key,                  dataFromString],
                                                forKeys: [kSecClassValue,                kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        SecItemDelete(keychainQuery as CFDictionaryRef)
        SecItemAdd(keychainQuery as CFDictionaryRef, nil)
    }
    
    
    func getContentsOfKey(key: String) -> String? {
        
        let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, serviceString(),      key,                  kCFBooleanTrue,      kSecMatchLimitOneValue],
                                                forKeys: [kSecClassValue,                kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :Unmanaged<AnyObject>?
        let status = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        let opaque = dataTypeRef?.toOpaque()
        var contentsOfKeychain: String?
        if let op = opaque? {
            let retrievedData: NSData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue()
            contentsOfKeychain = NSString(data: retrievedData, encoding: NSUTF8StringEncoding)
        } else {
            devPrintln("Nothing was retrieved from the keychain. Status code \(status)")
        }
        return  contentsOfKeychain
    }
    
    private func serviceString() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleIdentifier") as String
    }
}
