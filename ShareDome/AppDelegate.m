//
//  AppDelegate.m
//  ShareDome
//
//  Created by 大亨fly on 15/12/2.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import "AppDelegate.h"
#import "EMSShareSDK.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initGeneralUI];

    /**< 注册第三方平台 >**/
    [EMSShareSDK registerPlatform];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"=== handleOpenURL: %@", url);
    return [EMSShareSDK handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"=== annotation url: %@", url);
    return [EMSShareSDK handleOpenURL:url];
}


//************ UI Configure ************//
- (void)initGeneralUI
{
    [[UIBarButtonItem appearance] setTintColor:DefaultColor];
    [[UITabBar appearance] setTintColor:DefaultColor];
}


@end
