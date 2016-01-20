//
//  EMSImageLoader.h
//  ShareDome
//
//  Created by 大亨fly on 15/12/16.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletedBlock)(UIImage *image);

@interface EMSImageLoader : NSObject

- (void)getImageForUrl:(NSString *)url completed:(CompletedBlock)completed;

@end
