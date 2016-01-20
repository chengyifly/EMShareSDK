//
//  EMSShareViewController.m
//  ShareDome
//
//  Created by 大亨fly on 15/12/11.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import "EMSShareViewController.h"
#import "UIShareView.h"
#import "EMSShareSDK.h"

@interface EMSShareViewController () <UIShareViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation EMSShareViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://view.inews.qq.com/w/WXN20151211015161071?refer=nwx&cur_pos=1&openid=o04IBAA-3mAOl1sJwg7KQ2g2ExYY&groupid=1449797324&msgid=1&key=ac89cba618d2d976a78d3aaf1ab25870377b40f6aaeae561023fffe29c6ea319d765ed2111e2abbd9e7735d298b41659&version=11020113&devicetype=iMac+MacBookPro12%2C1+OSX+OSX+10.11.1+build(15B42)&cv=0x11020113&dt=14&lang=zh_CN&pass_ticket=vuoXqP4EPzBC8rXg2D2aUk4Vs88Kp5lVaZfqw16Hw6vH%2BgFm81gvBuOS%2F9s5bfgN"]];
    [self.webView loadRequest:request];
}

- (IBAction)action:(UIBarButtonItem *)sender
{
    [UIShareView showInView:self.view.window delegate:self];
}

- (void)shareView:(UIShareView *)shareView doWithShareType:(EMSShareType)shareType
{
    NSString *url         = @"http://www.baidu.com";
    NSString *title       = @"分享测试";
    NSString *description = @"这是一个测试链接，用于测试分享功能";
//    UIImage  *image       = [UIImage imageNamed:@"launch_icon"];//小图
//    UIImage  *image       = [UIImage imageNamed:@"test"];//大图
    UIImage  *image       = nil;
    
//    NSString *imgUrl = @"http://www.jinyuanbao.cn/Public/Web/offical/images/down.png"; //小图
    NSString *imgUrl = @"http://pic22.nipic.com/20120705/668573_091208280175_2.jpg"; //大图
    
    

    EMSNewsObject *content = [EMSShareSDK objectWithURL:url title:title description:description thumb:image orThumbURL:imgUrl];
    
    [EMSShareSDK shareContent:content toPlatform:shareType success:^{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } failure:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"code: %@, %@", @(error.code), error.localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"Error：%@, %@", @(error.code), error.localizedFailureReason);
        
    }];
}













@end
