//
//  EMSObject.m
//  ShareDome
//
//  Created by 大亨fly on 15/12/12.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import "EMSObject.h"
#import "EMSConstant.h"
#import "EMSImageLoader.h"
#import "UIImage+CompressImage.h"

/* 第三方平台api */
#import "WXApiObject.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>

@implementation EMSNewsObject

- (instancetype)initWithURL:(NSString *)urlStr
                      title:(NSString *)title
                description:(NSString *)description
                      thumb:(UIImage  *)thumb
                 orThumbURL:(NSString *)thumbUrlStr
{
    EMSNewsObject *object = [self initWithURL:urlStr title:title description:description];
    
    if (thumb) {
        object.thumb  = thumb;
    } else if (thumbUrlStr && thumbUrlStr.length > 0) {
        object.thumbUrl = thumbUrlStr;
    } else {
        NSAssert(object.thumb && object.thumbUrl, @"image和imageURL不能同时为空");
    }
    
    return object;
}

- (instancetype)initWithURL:(NSString *)urlStr
                      title:(NSString *)title
                description:(NSString *)description
{
    self = [super init];
    
    if (self) {
        self.url            = urlStr;
        self.title          = title;
        self.descriptionMsg = description;
    }
    
    return self;
}

@end


@implementation EMSNewsObject (ThirdPartyObject)

////////////////////// 微信 ////////////////////////
- (void)getWeChatObjectComleted:(void (^)(WXMediaMessage *messageObj))completed
{
    __block WXMediaMessage *message = [WXMediaMessage message];
    message.title                   = self.title;
    message.description             = self.descriptionMsg;

    WXWebpageObject *webObject = [WXWebpageObject object];
    webObject.webpageUrl       = self.url;
    message.mediaObject        = webObject;
    
    if (self.thumb) {
        
        message.thumbData = [self.thumb scaleImageToSize:CGSizeMake(170, 170) maxFileSize:32*1024];
        SAFE_BLOCK(completed, message);
        
    } else if (self.thumbUrl && self.thumbUrl.length>0) {
        
        EMSImageLoader *imageLoader = [[EMSImageLoader alloc] init];
        
        [imageLoader getImageForUrl:self.thumbUrl completed:^(UIImage *image) {
            message.thumbData = [image scaleImageToSize:CGSizeMake(170, 170) maxFileSize:32*1024];
            SAFE_BLOCK(completed, message);
        }];
        
    }
}

////////////////////// QQ ////////////////////////
- (void)getTencentObjectComleted:(void (^)(QQApiNewsObject *messageObj))completed
{
    __block QQApiNewsObject *newsObj;
    
    if (self.thumb) {
        
        NSData *thumbData = [self.thumb scaleImageToSize:CGSizeMake(170, 170) maxFileSize:100*1024];
        
        newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.url]
                                           title:self.title
                                     description:self.descriptionMsg
                                previewImageData:thumbData];
        
        SAFE_BLOCK(completed, newsObj);
        
    } else if (self.thumbUrl && self.thumbUrl.length>0) {

        EMSImageLoader *imageLoader = [[EMSImageLoader alloc] init];
        
        [imageLoader getImageForUrl:self.thumbUrl completed:^(UIImage *image) {
            
            NSData *thumbData = [image scaleImageToSize:CGSizeMake(170, 170) maxFileSize:100*1024];
            
            newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.url]
                                               title:self.title
                                         description:self.descriptionMsg
                                    previewImageData:thumbData];
            
            SAFE_BLOCK(completed, newsObj);
        }];
        
    }
}

////////////////////// 微博 ////////////////////////
- (void)getWeiboObjectComleted:(void (^)(WBMessageObject *messageObj))completed
{
    __block WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webObject       = [WBWebpageObject object];
    webObject.objectID               = [NSString stringWithFormat:@"%@", @(arc4random() % 10000 + 1)];
    webObject.title                  = self.title;
    webObject.description            = self.descriptionMsg;
    webObject.webpageUrl             = self.url;
    message.mediaObject              = webObject;
    
    if (self.thumb) {
        
        webObject.thumbnailData = [self.thumb scaleImageToSize:CGSizeMake(170, 170) maxFileSize:32*1024];
        SAFE_BLOCK(completed, message);
        
    } else if (self.thumbUrl && self.thumbUrl.length>0) {
        
        EMSImageLoader *imageLoader = [[EMSImageLoader alloc] init];
        
        [imageLoader getImageForUrl:self.thumbUrl completed:^(UIImage *image) {
            webObject.thumbnailData = [image scaleImageToSize:CGSizeMake(170, 170) maxFileSize:32*1024];
            SAFE_BLOCK(completed, message);
        }];
        
    }
}

- (void)getWeiboObjectWhenUninstalledComleted:(void (^)(WBMessageObject *messageObj))completed  
{
    NSString *allStr = [[self.title stringByAppendingString:self.descriptionMsg] stringByAppendingString:self.url];
    
    __block WBMessageObject *message = [WBMessageObject message];
    message.text                     = allStr;
    WBImageObject *imageObj          = [WBImageObject object];
    message.imageObject              = imageObj;
    
    if (self.thumb) {
        
        imageObj.imageData = [self.thumb scaleImageToSize:CGSizeMake(700, 700) maxFileSize:1000*1024];
        SAFE_BLOCK(completed, message);
        
    } else if (self.thumbUrl && self.thumbUrl.length>0) {
        
        EMSImageLoader *imageLoader = [[EMSImageLoader alloc] init];
        
        [imageLoader getImageForUrl:self.thumbUrl completed:^(UIImage *image) {
            imageObj.imageData = [image scaleImageToSize:CGSizeMake(700, 700) maxFileSize:1000*1024];
            SAFE_BLOCK(completed, message);
        }];
        
    }
}


@end


