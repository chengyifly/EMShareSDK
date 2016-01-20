//
//  EMSLoginViewController.m
//  ShareDome
//
//  Created by 大亨fly on 15/12/11.
//  Copyright © 2015年 Easymob. All rights reserved.
//

#import "EMSLoginViewController.h"
#import "EMSLogin.h"

@implementation EMSLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors     = @[(__bridge id)UIColorFromRGB(0x19ce81).CGColor, (__bridge id)UIColorFromRGB(0x1d97f0).CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint   = CGPointMake(1, 1);
    layer.frame      = self.view.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
}

- (IBAction)loginButtonAction:(UIButton *)sender
{
    [EMSLogin loginToPlatform:sender.tag success:^{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } failure:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"code: %@, %@", @(error.code), error.localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }];
}


@end
