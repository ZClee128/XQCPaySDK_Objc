//
//  XQCTwoViewController.m
//  XQCPaySDK_Objc_Example
//
//  Created by lee on 2019/8/8.
//  Copyright © 2019 ZClee128. All rights reserved.
//

#import "XQCTwoViewController.h"
#import <XQCPaySDK_Objc-umbrella.h>
@interface XQCTwoViewController ()

@end

@implementation XQCTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"支付" forState:(UIControlStateNormal)];
    [btn setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(100, 150, 100, 100);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(click) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)click {
    //    订单名  订单id
    
    XQCPayViewController *pay = [[XQCPayViewController alloc] initWithOrderTitle:@"薪起程测试" OrderId:@"1112222"];
    [pay sendPrice:0.1 feeType:(1001)]; // 设置金额
    [XQCPayManager defaultManager].result = ^(ResponseModel * _Nonnull model) {
        //        支付结果回调
        NSLog(@"model===>%@,%@",model.payType,model.message);
    };
    [self presentViewController:pay animated:YES completion:nil];
    
    //    [XQCPayManager showPasswordViewControllerResult:^{
    //
    //    }];
    
    //    弹框忘记密码回调
    //    [XQCPayManager showPasswordViewControllerResult:^{
    //
    //    }];
}

@end
