//
//  UIShareView.m
//  JinYuanBao
//
//  Created by 易达正丰 on 14-4-21.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import "UIShareView.h"
#import "UIButtonTextView.h"

#define TitleAreaHeight  48
#define CommonMargin     10
#define CommonBtnHeight  48
#define ControlBtnColor  UIColorFromRGB(0xF0F0F0)

@interface UIShareView ()
{
    UIButton *_bgView;           //整体背景
    UIView *_actionAreaView;     //操作面板
    
    UIScrollView *_shareContainerView;
    UIView *_btnsContainerView;
    
    UIView *_titleSeparator;
    UIView *_btnSeparator;
    
    NSArray *_shareTitles;
    NSArray *_shareImages;
    NSMutableArray *_shareBtns;
    NSMutableArray *_controlbtns;
}

@property (nonatomic,copy) NSString *headerTitle;
@property (nonatomic     ) CGFloat  spaceGap;

@end


@implementation UIShareView

#pragma mark - Init

- (id)initWithTitle:(NSString *)title
    withShareTitles:(NSArray *)titles
    withShareImages:(NSArray *)images
      withShareType:(UIShareViewType)type
   withButtonTitles:(NSString *)buttonTitles, ...{
    
    self.type = type;
    if (type == UIShareViewTypeSelectPicture) {
        //根据type,配置shareView
        
//        self.shareTitleLB           = [[UILabel alloc]init];
//        self.shareTitleLB.font      = [UIFont systemFontOfSize:14];
//        self.shareTitleLB.textColor = UIColorFromRGB(0x888888);
//        
        self.cellCount       = 2;
        self.rowCount        = 1;
//        self.lineGap         = 18;
        self.shareMaxGap     = 60*LayoutWidthRatio;
        self.shareAreaHeight = 147;
//        self.shareContainerMargin = UIEdgeInsetsMake(0, 57, 0, 57);
//        
//        
//        self.controlTitleFont  = [UIFont boldSystemFontOfSize:18];
//        self.controlTitleColor = UIColorFromRGB(0xFF9B25);
//        self.shareTitleFont    = [UIFont systemFontOfSize:13];
//        self.shareTitleColor   = UIColorFromRGB(0x555555);
    }
    
    self = [self initWithTitle:title
               withShareTitles:titles
               withShareImages:images
              withButtonTitles:buttonTitles,nil];
    
    return self;
}

- (id)initWithTitle:(NSString *)title
    withShareTitles:(NSArray *)titles
    withShareImages:(NSArray *)images
   withButtonTitles:(NSString *)buttonTitles, ...
{
    self = [super init];
    if(self) {
        
        self.headerTitle = title;
        
        //MARK::ShareButtons
        _shareTitles = titles;
        _shareImages = images;
        
        _shareBtns = [[NSMutableArray alloc] init];
        
        for (int i=0; i<_shareTitles.count; i++) {
            UIButtonTextView *view = [[UIButtonTextView alloc] init];
            view.tag = i;
            NSString *key       = [_shareTitles objectAtIndex:i];
            NSString *iconImage = [_shareImages objectAtIndex:i];
            view.title = key;
            view.iconImage = iconImage;
            [view addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_shareBtns addObject:view];
        }
        
        //MARK::Buttons
        _controlbtns = [[NSMutableArray alloc] init];
        NSMutableArray *argsArray = [[NSMutableArray alloc] init];
        va_list params; //定义一个指向个数可变的参数列表指针；
        va_start(params,buttonTitles);//va_start  得到第一个可变参数地址,
        id arg;
        
        if (buttonTitles) {
            //将第一个参数添加到array
            id prev = buttonTitles;
            [argsArray addObject:prev];
            
            //va_arg 指向下一个参数地址
            //这里是问题的所在 网上的例子，没有保存第一个参数地址，后边循环，指针将不会在指向第一个参数
            while((arg = va_arg(params,id))) {
                if (arg){
                    [argsArray addObject:arg];
                }
            }
            //置空
            va_end(params);
            
            //这里循环 将看到所有参数
            for (int i = 0; i < argsArray.count; i++) {
                NSString *btnTitle  = [argsArray objectAtIndex:i];
                UIButton *btn       = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag             = i;
                btn.titleLabel.font = self.controlTitleFont;
                btn.backgroundColor = ControlBtnColor;
                [btn setTitleColor:self.controlTitleColor forState:UIControlStateNormal];
                [btn setTitle:btnTitle forState:UIControlStateNormal];

                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_controlbtns addObject:btn];
            }
        }
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    _bgView                 = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha           = 0;
    [_bgView addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bgView];
    
    _actionAreaView                 = [[UIView alloc] init];
    _actionAreaView.backgroundColor = [UIColor whiteColor];
    
//    UIBlurEffect *blur             = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
//    _actionAreaView = visualView;
    [self addSubview:_actionAreaView];
    
    _shareTitleLB                 = [[UILabel alloc] init];
    _shareTitleLB.font            = [UIFont systemFontOfSize:16];
    _shareTitleLB.textColor       = UIColorFromRGB(0x777777);
    _shareTitleLB.backgroundColor = [UIColor clearColor];
    _shareTitleLB.text            = self.headerTitle;
    _shareTitleLB.textAlignment   = NSTextAlignmentCenter;
    [self addSubview:_shareTitleLB];
    
    _titleSeparator = [[UIView alloc] init];
    _btnSeparator = [[UIView alloc] init];
    _btnSeparator.backgroundColor = _titleSeparator.backgroundColor = UIColorFromRGB(0xdddddd);
    [self addSubview:_titleSeparator];
    [self addSubview:_btnSeparator];
    
    _shareContainerView                                = [[UIScrollView alloc] init];
    _shareContainerView.pagingEnabled                  = YES;
    _shareContainerView.showsHorizontalScrollIndicator = NO;
    _shareContainerView.showsVerticalScrollIndicator   = NO;
    _shareContainerView.backgroundColor                = [UIColor clearColor];
    [self addSubview:_shareContainerView];
    
    for (UIButtonTextView *shareView in _shareBtns) {
        [_shareContainerView addSubview:shareView];
    }
    
    _btnsContainerView                 = [[UIView alloc] init];
    _btnsContainerView.backgroundColor = [UIColor clearColor];
    [self addSubview:_btnsContainerView];
    
    for (UIButton *button in _controlbtns) {
        [_btnsContainerView addSubview:button];
    }
}

#pragma mark -
#pragma mark - UIView
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger btnsCount = _controlbtns.count;
    
    CGFloat btnsAreaHeight   = btnsCount * CommonBtnHeight;
    CGFloat actionAreaHeight = btnsAreaHeight + self.shareAreaHeight + TitleAreaHeight;
    
    UIEdgeInsets margin = self.shareContainerMargin;
    
    _bgView.frame   = self.bounds;
    _bgView.height -= actionAreaHeight;
    
    _actionAreaView.frame     = CGRectMake(0, self.height - actionAreaHeight, self.width, actionAreaHeight);
    _shareTitleLB.frame       = CGRectMake(0, _actionAreaView.top, _actionAreaView.width, TitleAreaHeight);
    _titleSeparator.frame     = CGRectMake(0, _shareTitleLB.bottom-0.5, _actionAreaView.width, 0.5);

    _shareContainerView.frame = CGRectMake(0, _shareTitleLB.bottom, _actionAreaView.width, self.shareAreaHeight);
    
    
    for (int i=0; i<_shareBtns.count; i++) {
        UIButtonTextView *shareView = [_shareBtns objectAtIndex:i];
        
        if (self.shareTitleColor) {
            shareView.titleLB.textColor = self.shareTitleColor;
        }
        if (self.shareTitleFont) {
            shareView.titleLB.font = self.shareTitleFont;
        }
        
        CGFloat itemWidth  = shareView.width;
        CGFloat itemHeight = shareView.height;
        
        CGFloat contentWidth = _shareContainerView.width -margin.left - margin.right;
        self.spaceGap = (contentWidth - self.cellCount*itemWidth)/(self.cellCount - 1);

        CGFloat remainGap = 0;
        if (self.spaceGap > self.shareMaxGap) {
            //最大间距
            self.spaceGap = self.shareMaxGap;
            remainGap = (contentWidth - (self.cellCount*itemWidth +(self.cellCount-1)*self.spaceGap))/2;
        }
        
        NSUInteger cellIndex = i % self.cellCount;
        NSUInteger rowIndex  = (i / self.cellCount) % self.rowCount;
        NSUInteger pageNum   = i / (self.cellCount * self.rowCount);
        
        shareView.frame = CGRectMake(pageNum * _actionAreaView.frame.size.width +remainGap + cellIndex * itemWidth + cellIndex * self.spaceGap + margin.left, rowIndex * itemHeight + (rowIndex + 1) * self.lineGap +margin.top, itemWidth, itemHeight);
    }
    
    NSUInteger totalPageNum = _shareBtns.count / (self.cellCount * self.rowCount);
    
    if (_shareBtns.count % (self.cellCount * self.rowCount) != 0) {
        totalPageNum += 1;
    }
    
    _shareContainerView.contentSize = CGSizeMake(totalPageNum * _actionAreaView.frame.size.width, self.shareAreaHeight);
    
    _btnSeparator.frame      = CGRectMake(0, _shareContainerView.bottom-0.5, _actionAreaView.width, 0.5);
    _btnsContainerView.frame = CGRectMake(0, _shareContainerView.bottom, _actionAreaView.width, btnsAreaHeight);
    for (int i=0; i<_controlbtns.count; i++) {
        UIButton *button = [_controlbtns objectAtIndex:i];
        button.frame     = CGRectMake(0, CommonBtnHeight * i + i * CommonMargin, _btnsContainerView.width, CommonBtnHeight);
    }
    
}

#pragma mark -
#pragma mark - UIShareView

+ (id)sharedInstance
{
    static UIShareView *shareView = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        /**
         * 注: 修改ShareTitle时,需要对应修改 shareTypeWithIndex: 中的字段
         */
        shareView = [[UIShareView alloc] initWithTitle:@"分享至"
                                       withShareTitles:@[@"微信好友", @"QQ好友", @"QZONE", @"朋友圈", @"新浪微博"]
                                       withShareImages:@[@"share_weChat.png", @"share_QQ.png", @"share_QZone.png", @"share_pengyou.png", @"share_weibo.png"]
                                      withButtonTitles:@"取 消", nil];
    });
    shareView.type = UIShareViewTypeDefault;
    
    return shareView;
}

- (void)dealloc
{
    NSLog(@"### UIShareView dealloc ###");
}

+ (instancetype)showInView:(UIView *)view delegate:(id <UIShareViewDelegate>)delegate
{
    UIShareView *shareView = [self sharedInstance];
    shareView.delegate     = delegate;
    
    if (!shareView.isShowing || shareView.superview != view) {
        [shareView showInView:view];
    }
    
    return shareView;
}

- (void)showInView:(UIView *)view
{
    self.isShowing = YES;
    _bgView.alpha  = 0;
    self.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, view.frame.size.height);
    [view addSubview:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame    = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _bgView.alpha = 0.3;
        }];
    }];
}

- (void)hide
{
    self.isShowing = NO;
    CGRect frame   = self.frame;
    _bgView.alpha  = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark - Control
- (void)btnClick:(id)sender
{
    UIButton *actionBtn = (UIButton *)sender;
    NSUInteger index    = actionBtn.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareView:doWithActionIndex:)]) {
        [self.delegate shareView:self doWithActionIndex:index];
    }
    [self hide];
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)shareBtnClick:(id)sender
{
    UIButtonTextView *buttonTextView = (UIButtonTextView *)sender;
    NSUInteger index = buttonTextView.tag;
    
   
    if (self.delegate &&[self.delegate respondsToSelector:@selector(shareView:doWithOptionIndex:)]){
     
        [self.delegate shareView:self doWithOptionIndex:index];
        
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(shareView:doWithShareType:)]) {
        
        EMSShareType shareType = [self shareTypeWithIndex:index];
        
        [self.delegate shareView:self doWithShareType:shareType];
        
    }
    
    [self hide];
}

- (EMSShareType)shareTypeWithIndex:(NSInteger)index
{
    NSString *shareTtitle = [_shareTitles objectAtIndex:index];
    
    EMSShareType shareType = EMSShareTypeNone;
    if ([shareTtitle isEqualToString:@"微信好友"]) {
        shareType = EMSShareTypeWXSession;
    } else if ([shareTtitle isEqualToString:@"朋友圈"]) {
        shareType = EMSShareTypeWXTimeline;
    } else if ([shareTtitle isEqualToString:@"微信收藏"]) {
        shareType = EMSShareTypeWXFavorite;
    } else if ([shareTtitle isEqualToString:@"新浪微博"]) {
        shareType = EMSShareTypeWeibo;
    } else if ([shareTtitle isEqualToString:@"QQ好友"]) {
        shareType = EMSShareTypeQQ;
    } else if ([shareTtitle isEqualToString:@"QZONE"]) {
        shareType = EMSShareTypeQZone;
    } else if ([shareTtitle isEqualToString:@"复制链接"]) {
        shareType = EMSShareTypeNone;
    }
    return shareType;
}

#pragma mark - overWrite getter

- (CGFloat)shareAreaHeight
{
    if (_shareAreaHeight == 0) {
        _shareAreaHeight = 222;
    }
    return _shareAreaHeight;
}

- (NSInteger)rowCount
{
    if (_rowCount == 0) {
        _rowCount = 2;
    }
    return _rowCount;
}

- (NSInteger)cellCount
{
    if (_cellCount == 0) {
        _cellCount = 4;
    }
    return _cellCount;
    
}

- (CGFloat)lineGap
{
    if (_lineGap == 0) {
        _lineGap = 24;
    }
    return _lineGap;
}

- (CGFloat)spaceGap
{
    if (_spaceGap == 0) {
        _spaceGap = 14.4;
    }
    return _spaceGap;
}

- (UIFont *)controlTitleFont
{
    if (!_controlTitleFont) {
        _controlTitleFont = [UIFont systemFontOfSize:17];
    }
    return _controlTitleFont;
}

- (UIColor *)controlTitleColor
{
    if (!_controlTitleColor) {
        _controlTitleColor = UIColorFromRGB(0x555555);
    }
    return _controlTitleColor;
}

- (UIEdgeInsets)shareContainerMargin
{
    if (UIEdgeInsetsEqualToEdgeInsets(_shareContainerMargin, UIEdgeInsetsZero)) {
        _shareContainerMargin = UIEdgeInsetsMake(0, 20.4, 0, 20.4);
    }
    return _shareContainerMargin;
}

- (CGFloat)shareMaxGap
{
    if (_shareMaxGap == 0) {
        CGFloat ratio = ScreenWidth/320*2;
        _shareMaxGap  = 14.4*ratio;
    }
    return _shareMaxGap;
}

@end
