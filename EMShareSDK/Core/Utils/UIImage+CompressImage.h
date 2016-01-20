//
//  UIImage+CompressImage.h
//  ShareDome
//
//  Created by 大亨fly on 15/12/15.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CompressImage)

- (NSData *)scaleImageToSize:(CGSize)newSize maxFileSize:(NSInteger)maxFileSize;

@end
