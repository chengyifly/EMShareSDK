//
//  EMSImageLoader.m
//  ShareDome
//
//  Created by 大亨fly on 15/12/16.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import "EMSImageLoader.h"
#import "EMSConstant.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"

@interface EMSImageLoader ()

@property (nonatomic, copy) CompletedBlock completed;

@end

@implementation EMSImageLoader

- (void)getImageForUrl:(NSString *)url completed:(CompletedBlock)completed
{
    /**< 创建计时器 >**/
    __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(needStop:) userInfo:nil repeats:NO];
    
    self.completed = completed;
    NSURL             *httpUrl = [NSURL URLWithString:url];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    SDImageCache   *imageCache = [SDImageCache sharedImageCache];
    
    UIImage  *image    = nil;
    NSString *cacheKey = [manager cacheKeyForURL:httpUrl];
    
    /**< 从内存中获取缓存 >**/
    image = [imageCache imageFromMemoryCacheForKey:cacheKey];
    if (image) {
        [timer invalidate];
        SAFE_BLOCK(completed, image);
        NSLog(@"INFO: 读取内存缓存");
        return;
    }
    
    /**< 从磁盘获取缓存 >**/
    image = [imageCache imageFromDiskCacheForKey:cacheKey];
    if (image) {
        [timer invalidate];
        SAFE_BLOCK(completed, image);
        NSLog(@"INFO: 读取磁盘缓存");
        return;
    }
    
    /**< 下载图片 >**/
    [manager downloadImageWithURL:httpUrl
                          options:0
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            if (finished && image) {
                                [timer invalidate];
                                SAFE_BLOCK(completed, image);
                                NSLog(@"INFO: 图片下载完成");
                                [manager saveImageToCache:image forURL:imageURL];
                            }
                            
                        }];
}

/**
 *  如果时间已到，则停止所有下载线程，返回默认图
 *
 *  @param timer 计时器timer
 */
- (void)needStop:(NSTimer *)timer
{
    [timer invalidate];
    
    [[SDWebImageManager sharedManager] cancelAll];
    
    UIImage *image = [UIImage imageNamed:DefaultShareImgName];
    SAFE_BLOCK(self.completed, image);
    
    //TODO::返回默认图，微信\QQ不传图也OK
}

@end
