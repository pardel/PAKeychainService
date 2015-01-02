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
        
        // we do the read in Objective-C to work around a Swift compiler optimization bug (as of Xcode 6.2 (6C101) which resulted in no data being returned
        return  KeychainObjCWrapper.keychainValueForDictionary(keychainQuery)
    }
    
    private func serviceString() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleIdentifier") as String
    }
}
