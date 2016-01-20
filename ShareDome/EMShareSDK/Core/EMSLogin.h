//
//  EMSLogin.h
//  ShareDome
//
//  Created by 大亨fly on 15/12/17.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMSTypedef.h"

@interface EMSLogin : NSObject

+ (void)loginToPlatform:(EMSPlatformOptions)platform
                success:(void (^)())success
                failure:(void (^)(NSError *error))failure;

@end
