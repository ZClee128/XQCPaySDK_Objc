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
//    订单名  订单id
    XQCPayViewController *pay = [[XQCPayViewController alloc] initWithOrderTitle:@"薪起程测试" OrderId:[self getOrderId]];
    [pay sendPrice:0.1 feeType:(feeTypeLife)]; // 设置金额
    [XQCPayManager defaultManager].result = ^(ResponseModel * _Nonnull model) {
//        支付结果回调
        NSLog(@"model===>%@",model.message);
    };
//    pay.back = ^{
////        这里是手动返回操作，如果不需要则不需要实现
//    };
//
    [self presentViewController:pay animated:YES completion:nil];
    
//    [XQCPayManager showPasswordViewControllerResult:^{
//    
//    }];
    
//    弹框忘记密码回调
//    [XQCPayManager defaultManager].ForgetPassword = ^{
//        NSLog(@"forget");
//    };
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
