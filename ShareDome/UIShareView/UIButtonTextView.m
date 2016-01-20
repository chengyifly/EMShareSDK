//
//  UIButtonTextView.m
//  JinYuanBao
//
//  Created by 易达正丰 on 14-4-26.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import "UIButtonTextView.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)


@interface UIButtonTextView ()
{
    UIControl *_bgControl;
    UIImageView *_imageView;
//    UILabel *_titleLB;
    
    id _target;
    SEL _action;
}

@end

@implementation UIButtonTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self shareInit];
    }
    return self;
}

- (void)shareInit
{
    _bgControl = [[UIControl alloc] init];
    _bgControl.backgroundColor = [UIColor clearColor];
    [_bgControl addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bgControl];
    
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];

    _titleLB = [[UILabel alloc] init];
    _titleLB.backgroundColor = [UIColor clearColor];
    _titleLB.textAlignment = NSTextAlignmentCenter;
    _titleLB.font = [UIFont systemFontOfSize:12];
    _titleLB.textColor = UIColorFromRGB(0x777777);
    [self addSubview:_titleLB];
}

#pragma mark -
#pragma mark - UIView
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGRect lframe = self.frame;
//    lframe.size = _imageView.image.size;
//    self.frame = lframe;
//    _bgControl.frame = self.bounds;
//    _imageView.frame = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
////    _imageView.frame = CGRectMake(5, 0, self.width - 10, self.width - 10);
//    _titleLB.frame   = CGRectMake(0, _imageView.bottom+6, self.width, 14);
    
}
- (void)refreshFrame{
    CGRect lframe = self.frame;
    lframe.size = _imageView.image.size;
    lframe.size.height +=20;
    self.frame = lframe;
    _bgControl.frame = self.bounds;
    _imageView.frame = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
    //    _imageView.frame = CGRectMake(5, 0, self.width - 10, self.width - 10);
    _titleLB.frame   = CGRectMake(0, _imageView.bottom+6, self.width, 14);
}
#pragma mark -
#pragma mark - UIButtonTextView

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    _target = target;
    _action = action;
}

- (void)setIconImage:(NSString *)iconImage
{
    _iconImage = iconImage;
    _imageView.image = [UIImage imageNamed:iconImage];
    [self refreshFrame];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLB.text = title;
}

#pragma mark - Control
#pragma mark -
- (void)controlClick:(id)sender
{
    SuppressPerformSelectorLeakWarning([_target performSelector:_action withObject:self]);
}

@end
