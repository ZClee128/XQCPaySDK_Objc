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
    XQCPayViewController *pay = [[XQCPayViewController alloc] initWithOrderTitle:@"薪起程测试" OrderId:@"111111"];
    [pay sendPrice:0.01];
    [self presentViewController:pay animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
