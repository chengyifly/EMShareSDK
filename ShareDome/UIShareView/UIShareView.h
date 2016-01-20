//
//  UIShareView.h
//  JinYuanBao
//
//  Created by 易达正丰 on 14-4-21.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMSTypedef.h"

typedef enum {
    ShareWeiXin,
    SharePengyouQuan,
    ShareWXFav,
    ShareSina,
    ShareQQ,
    ShareQQZone,
    ShareCopy,
    ShareNone
} UIShareType;


typedef NS_ENUM(NSUInteger, UIShareViewType) {
    UIShareViewTypeDefault,
    UIShareViewTypeSelectPicture,
};

@class UIShareView;

@protocol UIShareViewDelegate <NSObject>

@optional
/**
 * 如果doWithOptionIndex:未实现,才会调用
 */
- (void)shareView:(UIShareView *)shareView doWithShareType:(EMSShareType)shareType;
/**
 *  用于分享弹层中,底部的[取消]等多按钮情况
 */
- (void)shareView:(UIShareView *)shareView doWithActionIndex:(NSUInteger)index;
/**
 *最原始的按钮点击方法,用于自定义的type,TypeDefault用doWithShareType:
 */
- (void)shareView:(UIShareView *)shareView doWithOptionIndex:(NSUInteger)index;

@end

@interface UIShareView : UIView

@property (nonatomic        ) UIShareViewType     type;
@property (nonatomic, assign) BOOL                isShowing;
@property (nonatomic, assign) id<UIShareViewDelegate> delegate;

@property (nonatomic, strong)UILabel *shareTitleLB;

@property (nonatomic, strong) UIFont  *controlTitleFont;
@property (nonatomic, strong) UIColor *controlTitleColor;
@property (nonatomic, strong) UIFont  *shareTitleFont;
@property (nonatomic, strong) UIColor *shareTitleColor;

@property (copy  , nonatomic) dispatch_block_t cancelBlock;

/****** 布局数据 *******/
@property (nonatomic) CGFloat      shareAreaHeight;
@property (nonatomic) UIEdgeInsets shareContainerMargin;

@property (nonatomic) NSInteger    cellCount ,rowCount;
@property (nonatomic) CGFloat      lineGap;
@property (nonatomic) CGFloat      shareMaxGap;

/**********************/

/**
 *  用于创建不同样式的shareView
 */
- (id)initWithTitle:(NSString *)title
    withShareTitles:(NSArray *)titles
    withShareImages:(NSArray *)images
      withShareType:(UIShareViewType)type
   withButtonTitles:(NSString *)buttonTitles, ...;

- (id)initWithTitle:(NSString *)title
    withShareTitles:(NSArray *)titles
    withShareImages:(NSArray *)images
   withButtonTitles:(NSString *)buttonTitles, ...;


- (void)showInView:(UIView *)view;

// 如果是默认样式，直接调用此方法即可
+ (instancetype)showInView:(UIView *)view delegate:(id)delegate;

// 通过index得到shareType,仅适用于UIShareViewTypeDefault
- (EMSShareType)shareTypeWithIndex:(NSInteger)index;

@end
