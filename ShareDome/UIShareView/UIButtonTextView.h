//
//  UIButtonTextView.h
//  JinYuanBao
//
//  Created by 易达正丰 on 14-4-26.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButtonTextView : UIView

@property (nonatomic,copy) NSString *iconImage;
@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong)UILabel *titleLB;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;


@end
