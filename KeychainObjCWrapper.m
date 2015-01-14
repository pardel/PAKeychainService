//
//  KeychainObjCWrapper.m
//  PAKeychainService
//
//  Created by Andrew Ebling on 02/01/2015.
//

#import "KeychainObjcWrapper.h"
#import <Security/Security.h>

@implementation KeychainObjCWrapper

+ (NSString *)keychainValueForDictionary: (NSDictionary *)inQueryDict {

    CFTypeRef cfKeychainResult = NULL;
    OSStatus err = SecItemCopyMatching((__bridge CFDictionaryRef)inQueryDict, &cfKeychainResult);

    if(err == noErr) {

        // transfer ownership so ARC will take care of releasing underlying CF object
        id resultObj = (__bridge_transfer id)cfKeychainResult;

        // programmer error if query to constructed to return something else
        NSAssert([resultObj isKindOfClass: [NSData class]],
                 @"Expected an instance of NSData as keychain result");

        if([resultObj isKindOfClass: [NSData class]]) {
            return [[NSString alloc] initWithData: resultObj encoding: NSUTF8StringEncoding];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

@end
