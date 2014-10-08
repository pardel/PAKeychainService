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

    class var sharedService: PAKeychainService {
        return _sharedService
    }


    func saveContentsForKey(value: String, key: String) {
        let service = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleIdentifier") as String
        let dataFromString = value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!

        let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service,              key,                  dataFromString],
                                                forKeys: [kSecClassValue,                kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])

        SecItemDelete(keychainQuery as CFDictionaryRef)
        SecItemAdd(keychainQuery as CFDictionaryRef, nil)
    }


    func getContentsOfKey(key: String) -> String? {
        let service = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleIdentifier") as String

        let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service,              key,                  kCFBooleanTrue,      kSecMatchLimitOneValue],
                                                forKeys: [kSecClassValue,                kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])

        var dataTypeRef :Unmanaged<AnyObject>?
        let status = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        let opaque = dataTypeRef?.toOpaque()
        var contentsOfKeychain: String?
        if let op = opaque? {
            let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue()
            contentsOfKeychain = String(NSString(data: retrievedData, encoding: NSUTF8StringEncoding))
        } else {
            devPrintln("Nothing was retrieved from the keychain. Status code \(status)")
        }
        return  contentsOfKeychain
    }

}
