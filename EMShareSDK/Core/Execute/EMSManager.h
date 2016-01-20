//
//  EMSManager.h
//  ShareDome
//
//  Created by 大亨fly on 15/12/12.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMSTypedef.h"

@class WXMediaMessage;
@class QQApiNewsObject;
@class WBMessageObject;

@interface EMSManager : NSObject

+ (NSError *)sendWeChatRequestWithMessage:(WXMediaMessage *)message inScene:(EMSShareType)shareType;

+ (NSInteger)sendQQRequestWithMessage:(QQApiNewsObject *)message inScene:(EMSShareType)shareType;

+ (NSError *)sendWeiboRequestWithMessage:(WBMessageObject *)message;

@end
