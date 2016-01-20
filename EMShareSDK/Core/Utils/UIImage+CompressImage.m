//
//  UIImage+CompressImage.m
//  ShareDome
//
//  Created by 大亨fly on 15/12/15.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import "UIImage+CompressImage.h"

@implementation UIImage (CompressImage)

- (NSData *)scaleImageToSize:(CGSize)newSize maxFileSize:(NSInteger)maxFileSize
{
    CGFloat newWidth  = newSize.width;
    CGFloat newHeight = newSize.height;
    
    UIImage *newImage = self;
    
    if (self.size.width < newWidth) {
        if (self.size.height > newHeight) {
            CGSize reDrawSize = CGSizeZero;
            reDrawSize.height = newHeight;
            reDrawSize.width = (self.size.width * newHeight) / self.size.height;
            reDrawSize.width = floorf(reDrawSize.width);
            newImage = [self drawImageWithSize:reDrawSize];
        }
    } else {
        CGSize reDrawSize = CGSizeZero;
        reDrawSize.width  = newWidth;
        reDrawSize.height = (self.size.height * newWidth) / self.size.width;
        reDrawSize.height = floorf(reDrawSize.height);
        newImage = [self drawImageWithSize:reDrawSize];
    }
    
    NSData *imageData = [self compressImage:newImage toMaxFileSize:maxFileSize];
    
    return imageData;
}

- (UIImage *)drawImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize
{
    CGFloat compression    = 0.9f;
    CGFloat maxCompression = 0.1f;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while (imageData.length > maxFileSize && compression > maxCompression) {
        compression -= 0.1f;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    NSLog(@"INFO：imageDataLength = %@, compression = %@", @(imageData.length), @(compression));
    return imageData;
}

@end
