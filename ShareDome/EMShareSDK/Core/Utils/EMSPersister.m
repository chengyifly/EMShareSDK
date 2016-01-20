//
//  EMSPersister.m
//  ShareDome
//
//  Created by 大亨fly on 15/12/18.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import "EMSPersister.h"

@implementation EMSPersister

+ (void)setValue:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getValueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSDictionary *)fetchAppIDsOfPlatform:(EMSPlatformOptions)platform
{
    NSURL *fileUrl    = [[NSBundle mainBundle] URLForResource:@"EMSConfigure" withExtension:@"plist"];
    NSAssert(fileUrl, @"EMShareSDK：The file EMSConfigure.plist doesn't exist in MainBundle.");
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfURL:fileUrl];
    NSAssert(dic, @"The Content of file EMSConfigure.plist is null, it must be set.");
    
    return dic;
}

@end
