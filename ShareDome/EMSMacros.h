//
//  EMSMacros.h
//  ShareDome
//
//  Created by 大亨fly on 15/12/11.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#ifndef EMSMacros_h
#define EMSMacros_h

#define ScreenHeight      [UIScreen mainScreen].bounds.size.height
#define ScreenWidth       [UIScreen mainScreen].bounds.size.width
#define ScreenScale       [UIScreen mainScreen].scale
#define ScreenBounds      [[UIScreen mainScreen] bounds]
#define LayoutWidthRatio  (ScreenWidth/320.0)
#define LayoutHeightRatio (ScreenHeight/480.0)

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                 blue:((float)(rgbValue & 0xFF))/255.0 \
                alpha:1.0]

#define DefaultColor      UIColorFromRGB(0x06b160)

#endif /* EMSMacros_h */
