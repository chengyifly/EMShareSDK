//
//  EMSHandler.m
//  ShareDome
//
//  Created by 大亨fly on 15/12/12.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import "EMSHandler.h"
#import "EMSConstant.h"
#import "EMSPersister.h"

@interface EMSHandler ()

@property (nonatomic, copy  ) dispatch_block_t success;
@property (nonatomic, copy  ) FailBlock        failure;

@end

@implementation EMSHandler

+ (instancetype)sharedHandler
{
    static dispatch_once_t onceToken;
    static EMSHandler *instance;
    dispatch_once(&onceToken, ^{
        instance = [[EMSHandler alloc] init];
    });

    return instance;
}

- (void)setSuccessBlock:(dispatch_block_t)success failBlock:(FailBlock)failure
{
    self.success = success;
    self.failure = failure;
}


#pragma mark - ## Delegate ##

- (void)onResp:(id)resp
{
#pragma mark - WXApiDelegate
    
    if ([resp isKindOfClass:[BaseResp class]]) {
        BaseResp *wxResp = resp;
        
        if (wxResp.errCode == WXSuccess) {
            
            SAFE_BLOCK(self.success,);
            self.success = nil;
            
        } else {
            
            //TODO::错误码
            SAFE_BLOCK(self.failure, EMSError(wxResp.errCode, [self safaString:wxResp.errStr]));
            self.failure = nil;
            
        }
        
#pragma mark - QQApiInterfaceDelegate
        
    } else if ([resp isKindOfClass:[QQBaseResp class]]) {
        
        QQBaseResp *qqResp = resp;
        
        if (qqResp.type == 2) {
            
            if ([qqResp.result integerValue] == 0) {
                
                SAFE_BLOCK(self.success,);
                self.success = nil;
                
            } else {//TODO::错误码
                
                SAFE_BLOCK(self.failure, EMSError([qqResp.result integerValue], [self safaString:qqResp.errorDescription]));
                self.failure = nil;
                
            }
        }
        
    }
}

#pragma mark - TencentLoginDelegate
/** QQ登录成功后的回调 */
- (void)tencentDidLogin
{
    [self.tencentOAuth getUserInfo];
}

/** QQ登录失败后的回调 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

/** QQ登录时网络有问题的回调 */
- (void)tencentDidNotNetWork
{
    
}

/** QQ获取用户个人信息回调 */
- (void)getUserInfoResponse:(APIResponse*) response
{
    NSLog(@"INFO: QQ userInfo => %@", response.jsonResponse);
}


#pragma mark - QQ分享错误处理
- (void)handleQQSendResult:(NSInteger)sendResult
{
    NSString *errorDescrip;
    
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
            errorDescrip = @"未注册TencentApi";
            
            break;
        
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
            errorDescrip = @"发送到QQ参数不合法";
            
            break;
        
        case EQQAPIQQNOTINSTALLED:
            errorDescrip = @"未安装手机QQ";
            
            break;
        
        case EQQAPIQQNOTSUPPORTAPI:
            errorDescrip = @"该版本QQ不支持分享操作";
            
            break;
        
        case EQQAPISENDFAILD:
            errorDescrip = @"发送失败";
            
            break;
        
        default:
            break;
    }
    
    if (errorDescrip) {//TODO::错误码
        SAFE_BLOCK(self.failure, EMSError(sendResult, [self safaString:errorDescrip]));
        self.failure = nil;
    }
}

#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        
        if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
            WBAuthorizeResponse *authResp = (WBAuthorizeResponse *)response;
            [EMSPersister setValue:authResp.accessToken forKey:WeiboAccessToken];
            [EMSPersister setValue:authResp.userID forKey:WeiboUserID];
        }
        
        SAFE_BLOCK(self.success,);
        self.success = nil;
        
    } else {
        
        //TODO::错误码
        NSLog(@"INFO: 收到微博回调，‘%@’", response.requestUserInfo);
        SAFE_BLOCK(self.failure, EMSError(response.statusCode, @""));
        self.failure = nil;
        
    }
}


#pragma mark - Helper
- (NSString *)safaString:(NSString *)oldStr
{
    if (oldStr) {
        return oldStr;
    }
    return @"";
}


@end
