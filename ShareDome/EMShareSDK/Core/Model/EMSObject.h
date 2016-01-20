//
//  EMSObject.h
//  ShareDome
//
//  Created by 大亨fly on 15/12/12.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMSNewsObject : NSObject

- (instancetype)initWithURL:(NSString *)urlStr
                      title:(NSString *)title
                description:(NSString *)description
                      thumb:(UIImage  *)thumb
                 orThumbURL:(NSString *)thumbUrlStr;


@property (nonatomic, copy  ) NSString *url;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *descriptionMsg;

/** ! thumbUrl和thumb不能同时为空 **/
@property (nonatomic, copy  ) NSString *thumbUrl;
@property (nonatomic, strong) UIImage  *thumb;

@end


@class WXMediaMessage;
@class QQApiNewsObject;
@class WBMessageObject;

@interface EMSNewsObject (ThirdPartyObject) /**< 获取第三方平台所需数据模型 >**/

// 微信
- (void)getWeChatObjectComleted:(void (^)(WXMediaMessage *messageObj))completed;

// QQ
- (void)getTencentObjectComleted:(void (^)(QQApiNewsObject *messageObj))completed;

// 微博
- (void)getWeiboObjectComleted:(void (^)(WBMessageObject *messageObj))completed;
- (void)getWeiboObjectWhenUninstalledComleted:(void (^)(WBMessageObject *messageObj))completed;

@end
