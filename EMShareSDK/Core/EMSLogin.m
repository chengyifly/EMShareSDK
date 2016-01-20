//
//  EMSLogin.m
//  ShareDome
//
//  Created by 大亨fly on 15/12/17.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import "EMSLogin.h"
#import "EMSConstant.h"
#import "EMSHandler.h"
#import "EMSPersister.h"

/* 第三方平台api */
#import "WeiboUser.h"

@implementation EMSLogin

+ (void)loginToPlatform:(EMSPlatformOptions)platform
                success:(void (^)())success
                failure:(void (^)(NSError *error))failure
{
    switch (platform) {
        case EMSPlatformWeChat:
            [self loginToWXSuccess:success failure:failure];
            break;
            
        case EMSPlatformWeibo:
            [self loginToWeiboSuccess:success failure:failure];
            break;
            
        case EMSPlatformQQ:
            [self loginToQQSuccess:success failure:failure];
            break;
            
        default:
            break;
    }
}

////////////////// 微信 //////////////////
+ (void)loginToWXSuccess:(void (^)())success failure:(void (^)(NSError *error))failure
{

}

////////////////// 微博 //////////////////
+ (void)loginToWeiboSuccess:(void (^)())success failure:(void (^)(NSError *error))failure
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.userInfo = @{@"type": @"SSO"};
    [WeiboSDK sendRequest:request];
    
    [[EMSHandler sharedHandler] setSuccessBlock:^{
        
        NSString *userID      = [EMSPersister getValueForKey:WeiboUserID];
        NSString *accessToken = [EMSPersister getValueForKey:WeiboAccessToken];
        
        [WBHttpRequest requestForUserProfile:userID withAccessToken:accessToken andOtherProperties:nil queue:[NSOperationQueue mainQueue] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            
            if ([result isKindOfClass:[WeiboUser class]]) {
                
                WeiboUser *user = result;
                NSLog(@"INFO: 微博userInfo => %@, %@, %@, %@", user.userID, user.name, user.location, user.profileImageUrl);
            }
            
            if (error) {
                SAFE_BLOCK(failure, EMSError(error.code, error.localizedDescription));
            } else {
                success();
            }
            
        }];
        
    } failBlock:^(NSError *error) {
        SAFE_BLOCK(failure, EMSError(error.code, error.localizedDescription));
    }];
}

////////////////// QQ //////////////////
+ (void)loginToQQSuccess:(void (^)())success failure:(void (^)(NSError *error))failure
{
    NSDictionary *result       = [EMSPersister fetchAppIDsOfPlatform:EMSPlatformQQ];
    EMSHandler *handler        = [EMSHandler sharedHandler];
    [handler setSuccessBlock:success failBlock:failure];
    
    TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:result[QQAppID] andDelegate:handler];
    handler.tencentOAuth       = tencentOAuth;
    [tencentOAuth authorize:@[@"get_user_info", @"get_simple_userinfo", @"add_t"]];
}

@end
