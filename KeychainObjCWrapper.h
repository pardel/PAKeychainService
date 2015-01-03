//
//  KeychainObjCWrapper.h
//  PAKeychainService
//
//  Created by Andrew Ebling on 02/01/2015.
//  Copyright (c) 2015 Tenero Mobile Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainObjCWrapper : NSObject

+ (NSString *)keychainValueForDictionary: (NSDictionary *)inQueryDict;

@end
