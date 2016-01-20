//
//  EMSHandler.h
//  ShareDome
//
//  Created by 大亨fly on 15/12/12.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 引用第三方平台的api接口 */
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

typedef void(^FailBlock)(NSError *error);


@interface EMSHandler : NSObject <WXApiDelegate, WeiboSDKDelegate, QQApiInterfaceDelegate, TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

+ (instancetype)sharedHandler;

- (void)setSuccessBlock:(dispatch_block_t)success failBlock:(FailBlock)failure;

- (void)handleQQSendResult:(NSInteger)sendResult;

@end
