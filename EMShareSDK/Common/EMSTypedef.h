//
//  EMSTypedef.h
//  ShareDome
//
//  Created by 大亨fly on 15/12/12.
//  Copyright © 2015年 Easymob. All rights reserved.
//
/// 基础公共枚举
//

#ifndef EMSTypedef_h
#define EMSTypedef_h

typedef NS_OPTIONS(NSUInteger, EMSPlatformOptions) {
    EMSPlatformAll    = 0,
    EMSPlatformWeChat = 1 << 0,
    EMSPlatformWeibo  = 1 << 1,
    EMSPlatformQQ     = 1 << 2,
};

typedef NS_ENUM(NSUInteger, EMSShareType) {
    EMSShareTypeNone,
    EMSShareTypeWXSession,
    EMSShareTypeWXTimeline,
    EMSShareTypeWXFavorite,
    EMSShareTypeWeibo,
    EMSShareTypeQQ,
    EMSShareTypeQZone,
};

typedef NS_ENUM(NSUInteger, EMSErrorCode) {
    EMSErrorCodeWXUninstall  = -1001,/**< 微信未安装           */
    EMSErrorCodeWXInvalid    = -1003,/**< 微信参数格式不合法    */
    EMSErrorCodeWXCommon     = -1,   /**< 微信普通错误类型      */
    EMSErrorCodeWXUserCancel = -2,   /**< 微信用户点击取消并返回 */
    EMSErrorCodeWXSentFail   = -3,   /**< 微信发送失败         */
    EMSErrorCodeWXAuthDeny   = -4,   /**< 微信授权失败         */
    EMSErrorCodeWXUnsupport  = -5,   /**< 微信不支持           */
    
    EMSErrorCodeWBSentFail   = -1004,/**< 微博发送失败         */
};

#endif
