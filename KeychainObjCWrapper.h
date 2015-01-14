//
//  KeychainObjCWrapper.h
//  PAKeychainService
//
//  Created by Andrew Ebling on 02/01/2015.
//

#import <Foundation/Foundation.h>

@interface KeychainObjCWrapper : NSObject

+ (NSString *)keychainValueForDictionary: (NSDictionary *)inQueryDict;

@end
