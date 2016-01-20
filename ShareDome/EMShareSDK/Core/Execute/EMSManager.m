//
//  EMSManager.m
//  ShareDome
//
//  Created by 大亨fly on 15/12/12.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import "EMSManager.h"
#import "EMSConstant.h"

/* 第三方平台api */
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>

@implementation EMSManager

//////////////// 微信 ///////////////
+ (NSError *)sendWeChatRequestWithMessage:(WXMediaMessage *)message inScene:(EMSShareType)shareType
{
    /**< 参数合法性验证 >**/
    NSUInteger titleLength   = [message.title lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (titleLength > 512) {
        return EMSError(EMSErrorCodeWXInvalid, @"分享到微信标题长度不能超过512字节");
        //TODO::截取规定长度字符串
    }
    
    NSUInteger descripLength = [message.description lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (descripLength > 1024) {
        return EMSError(EMSErrorCodeWXInvalid, @"分享到微信描述内容长度不能超过1k");
    }
    
    NSUInteger urlLength     = [((WXWebpageObject *)message.mediaObject).webpageUrl lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (urlLength > 10240) {
        return EMSError(EMSErrorCodeWXInvalid, @"分享到微信url地址长度不能超过10k");
    }
    

    /**< 创建Req >**/
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    
    enum WXScene wxScene = WXSceneSession;
    if (shareType == EMSShareTypeWXTimeline) {
        wxScene = WXSceneTimeline;
    } else if (shareType == EMSShareTypeWXFavorite) {
        wxScene = WXSceneFavorite;
    }
    
    req.scene = wxScene;
    
    /**< 发送 >**/
    if (![WXApi sendReq:req]) {
        return EMSError(EMSErrorCodeWXSentFail, @"发送失败");
    }
    
    return nil;
//TODO:: Test WeChat This Method    +(BOOL) sendAuthReq:(SendAuthReq*) req viewController : (UIViewController*) viewController delegate:(id<WXApiDelegate>) delegate;
}

//////////////// QQ ///////////////
+ (NSInteger)sendQQRequestWithMessage:(QQApiNewsObject *)message inScene:(EMSShareType)shareType
{
    //TODO::参数合法性验证
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:message];
    
    QQApiSendResultCode resultCode;
    
    if (shareType == EMSShareTypeQQ) {
        
        resultCode = [QQApiInterface sendReq:req];
        
    } else if (shareType == EMSShareTypeQZone) {
        
        resultCode = [QQApiInterface SendReqToQZone:req];
        
    }
    
    return resultCode;
}

//////////////// 微博 ///////////////
+ (NSError *)sendWeiboRequestWithMessage:(WBMessageObject *)message
{
    //TODO::参数合法性验证
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message
                                                                                  authInfo:authRequest
                                                                              access_token:nil];
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    /**< 发送 >**/
    if (![WeiboSDK sendRequest:request]) {
        return EMSError(EMSErrorCodeWXSentFail, @"发送失败");
    }

    return nil;
}

@end
