//
//  EMSShareSDK.h
//  ShareDome
//
//  Created by 大亨fly on 15/12/12.
//  Copyright © 2015年 Easymob. All rights reserved.
//
/// 外部调用统一接口
//*  [所有外部调用方法 **有且只有** 该文件提供] *//
//

#import <Foundation/Foundation.h>
#import "EMSTypedef.h"

@class EMSNewsObject;

@interface EMSShareSDK : NSObject

/**
 *  [- NO.01 -] 注册第三方平台SDK（默认全部平台）
 *
 *  @return 注册结果
 */
+ (BOOL)registerPlatform;

/**
 *  [- NO.02 -] 注册第三方平台SDK（任意平台）
 *
 *  @param platform 需要注册的平台类型
 *
 *  @return 注册结果
 */
+ (BOOL)registerPlatform:(EMSPlatformOptions)platform;

/**
 *  [- NO.03 -] 处理第三方平台通过URL启动App时传递的数据
 *  需要在 application:openURL:sourceApplication:annotation: 或者 application:handleOpenURL 中调用
 *
 *  @param url 第三方平台传递过来的url
 *
 *  @return 成功返回YES，失败NO
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

/**
 *  [- NO.04 -] 执行分享操作
 *
 *  @param content      第三方需要的消息体
 *  @param platformType 平台类型
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)shareContent:(EMSNewsObject *)content
          toPlatform:(EMSShareType)platformType
             success:(void (^)())success
             failure:(void (^)(NSError *error))failure;

/**
 *  [- NO.12 -] 创建分享消息体
 *
 *  @param urlStr      分享目的地链接
 *  @param title       标题
 *  @param description 描述
 *  @param thumbURL  缩略图url
 *
 *  @return 消息体数据模型
 */
+ (EMSNewsObject *)objectWithURL:(NSString *)urlStr
                           title:(NSString *)title
                     description:(NSString *)description
                        thumbURL:(NSString *)thumbUrlStr;

/**
 *  [- NO.13 -] 创建分享消息体
 *
 *  @param urlStr      分享目的地链接
 *  @param title       标题
 *  @param description 描述
 *  @param thumb       缩略图image对象
 *  @param orThumbURL  缩略图url (*！和上一个参数 thumb 不能同时为空 *)
 *
 *  @return 消息体数据模型
 */
+ (EMSNewsObject *)objectWithURL:(NSString *)urlStr
                           title:(NSString *)title
                     description:(NSString *)description
                           thumb:(UIImage  *)thumb
                      orThumbURL:(NSString *)thumbUrlStr;

@end
