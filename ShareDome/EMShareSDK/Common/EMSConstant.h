//
//  EMSConstant.h
//  ShareDome
//
//  Created by 大亨fly on 15/12/14.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef EMSConstant_h
#define EMSConstant_h

static NSString * const WXAppID          = @"WeChatAppID";
static NSString * const WXAppSecret      = @"WeChatAppSecret";

static NSString * const WeiboAppKey      = @"WeiboAppKey";
static NSString * const WeiboAppSecret   = @"WeiboAppSecret";
static NSString * const WeiboRedirectURL = @"WeiboRedirectURL";
static NSString * const WeiboAccessToken = @"WeiboAccessToken";
static NSString * const WeiboUserID      = @"WeiboUserID";

static NSString * const QQAppID          = @"QQAppID";
static NSString * const QQAppKey         = @"QQAppKey";

static NSString * const ErrorDomain      = @"EMShareSDKError";

#define EMSError(_CODE_, _REASON_)  [NSError errorWithDomain:ErrorDomain\
                                                        code:_CODE_\
                                                    userInfo:@{NSLocalizedFailureReasonErrorKey:_REASON_}]

#define SAFE_BLOCK(_block_, _param_)   if (_block_) {_block_(_param_);}

static NSString * const DefaultShareImgName = @"launch_icon";

#define kRedirectURI    @"http://mp.jinyuanbao.cn/h5/index/"

#endif
