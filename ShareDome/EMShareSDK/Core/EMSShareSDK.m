//
//  EMSShareSDK.m
//  ShareDome
//
//  Created by 大亨fly on 15/12/12.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import "EMSShareSDK.h"
#import "EMSConstant.h"
#import "EMSObject.h"
#import "EMSManager.h"
#import "EMSHandler.h"
#import "EMSPersister.h"

@implementation EMSShareSDK

+ (BOOL)registerPlatform
{
    return [self registerPlatform:EMSPlatformAll];
}

+ (BOOL)registerPlatform:(EMSPlatformOptions)platform
{
    if (platform == EMSPlatformAll) {
        platform = EMSPlatformWeChat|EMSPlatformWeibo|EMSPlatformQQ;
    }

    //TODO::result分别按类型判空
    //TODO::第三方平台注册成功与否
    //TODO::注册失败的处理
    //TODO::断网有没有影响
    
    NSDictionary *result = [EMSPersister fetchAppIDsOfPlatform:platform];
    
    if (platform & EMSPlatformWeChat) { // 注册微信SDK
        [WXApi registerApp:result[WXAppID]];
    }
    
    if (platform & EMSPlatformWeibo) { // 注册微博SDK
        [WeiboSDK registerApp:result[WeiboAppKey]];
        [WeiboSDK enableDebugMode:NO];
    }
    
    if (platform & EMSPlatformQQ) { // 注册QQ SDK
        TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:result[QQAppID] andDelegate:[EMSHandler sharedHandler]];
#pragma unused(tencentOAuth)
    }
    
    return YES;
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    if ([url.absoluteString rangeOfString:@"wechat"].length) {
        return [WXApi handleOpenURL:url delegate:[EMSHandler sharedHandler]];
    } else if ([url.absoluteString rangeOfString:@"QQ"].length) {
        return [QQApiInterface handleOpenURL:url delegate:[EMSHandler sharedHandler]];
    } else if ([url.absoluteString rangeOfString:@"tencent"].length) {
        return [TencentOAuth HandleOpenURL:url];
    } else if ([url.absoluteString rangeOfString:@"wb"].length) {
        return [WeiboSDK handleOpenURL:url delegate:[EMSHandler sharedHandler]];
    }
    
    return YES;
}

+ (EMSNewsObject *)objectWithURL:(NSString *)urlStr
                           title:(NSString *)title
                     description:(NSString *)description
                        thumbURL:(NSString *)thumbUrlStr
{
    EMSNewsObject *object = [self objectWithURL:urlStr
                                          title:title
                                    description:description
                                          thumb:nil
                                     orThumbURL:thumbUrlStr];
    
    return object;
}

+ (EMSNewsObject *)objectWithURL:(NSString *)urlStr
                           title:(NSString *)title
                     description:(NSString *)description
                           thumb:(UIImage  *)thumb
                      orThumbURL:(NSString *)thumbUrlStr
{
    EMSNewsObject *object = [[EMSNewsObject alloc] initWithURL:urlStr
                                                         title:title
                                                   description:description
                                                         thumb:thumb
                                                    orThumbURL:thumbUrlStr];
    
    return object;
}

+ (void)shareContent:(EMSNewsObject *)content
          toPlatform:(EMSShareType)platformType
             success:(void (^)())success
             failure:(void (^)(NSError *error))failure
{
    /**< 处理回调 >**/
    EMSHandler *handler = [EMSHandler sharedHandler];
    [handler setSuccessBlock:success failBlock:failure];
    
    switch (platformType) {
        case EMSShareTypeWXSession:
        case EMSShareTypeWXTimeline:
        {
            if (![WXApi isWXAppInstalled]) {
                SAFE_BLOCK(failure, EMSError(EMSErrorCodeWXUninstall, @"未安装微信"));
                return;
            }
            
            if (![WXApi isWXAppSupportApi]) {
                SAFE_BLOCK(failure, EMSError(EMSErrorCodeWXUnsupport, @"该版本微信不支持分享操作"));
                return;
            }
            
            [content getWeChatObjectComleted:^(WXMediaMessage *messageObj) {
                
                NSError *error = [EMSManager sendWeChatRequestWithMessage:messageObj inScene:platformType];
                if (error) {
                    SAFE_BLOCK(failure, error);
                }
                
            }];
        }
            break;
            
        case EMSShareTypeWeibo:
        {
            if ([WeiboSDK isCanShareInWeiboAPP]) {
                
                [content getWeiboObjectComleted:^(WBMessageObject *messageObj) {
                    
                    NSError *error = [EMSManager sendWeiboRequestWithMessage:messageObj];
                    if (error) {
                        SAFE_BLOCK(failure, error);
                    }
                    
                }];
                
            } else {
                
                [content getWeiboObjectWhenUninstalledComleted:^(WBMessageObject *messageObj) {
                    NSError *error = [EMSManager sendWeiboRequestWithMessage:messageObj];
                    if (error) {
                        SAFE_BLOCK(failure, error);
                    }
                }];
                
            }
            
        }
            break;
            
        case EMSShareTypeQQ:
        case EMSShareTypeQZone:
        {
            [content getTencentObjectComleted:^(QQApiNewsObject *messageObj) {
                
                NSInteger code = [EMSManager sendQQRequestWithMessage:messageObj inScene:platformType];
                [handler handleQQSendResult:code];
                
            }];
        }
            break;
            
        default:
            break;
    }
//    TODO::单线程操作
}

@end
