//
//  XQCViewController.m
//  XQCPaySDK_Objc
//
//  Created by ZClee128 on 06/10/2019.
//  Copyright (c) 2019 ZClee128. All rights reserved.
//

#import "XQCViewController.h"
#import <XQCPaySDK_Objc-umbrella.h>
@interface XQCViewController ()

@end

@implementation XQCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"支付" forState:(UIControlStateNormal)];
    [btn setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(click) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)click {
    XQCPayViewController *pay = [[XQCPayViewController alloc] initWithOrderTitle:@"薪起程测试" OrderId:[self getOrderId]];
    [pay sendPrice:0.1];
    pay.reuslt = ^(ResponseModel * _Nonnull model) {
        NSLog(@"reuslt>>>%@",model.amount);
    };
    
//    pay.back = ^{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    };
    
    [self presentViewController:pay animated:YES completion:nil];
}

- (NSString *)getOrderId {
    NSDate *now = [NSDate new];
    
    NSDateFormatter *dformatter = [[NSDateFormatter alloc] init];
    dformatter.dateFormat = @"yyyyMMddHHss";
    
    NSString *timeHeard = [dformatter stringFromDate:now];
    
    NSInteger randomNum = arc4random_uniform(999999 - 100000 + 1) + 100000;
    
    return [NSString stringWithFormat:@"%@%ld",timeHeard,(long)randomNum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
