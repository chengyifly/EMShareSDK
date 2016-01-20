//
//  EMSPersister.h
//  ShareDome
//
//  Created by 大亨fly on 15/12/18.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMSTypedef.h"

@interface EMSPersister : NSObject

+ (void)setValue:(id)value forKey:(NSString *)key;

+ (id)getValueForKey:(NSString *)key;

+ (NSDictionary *)fetchAppIDsOfPlatform:(EMSPlatformOptions)platform;

@end
