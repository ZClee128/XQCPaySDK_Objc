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

@property (nonatomic,strong)UITextField *payText;
@end

@implementation XQCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.payText = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 375, 50)];
    self.payText.layer.borderWidth=1.0f;
    
    self.payText.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    self.payText.placeholder = @"请输入金额";
    self.payText.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:self.payText];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"支付" forState:(UIControlStateNormal)];
    [btn setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(100, 150, 100, 100);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(click) forControlEvents:(UIControlEventTouchUpInside)];
//    NSString *url = @"http://24p426488q.qicp.vip/api/v1&merchantId=146601100000627&bizCode=1006&amount=10&outTradeNo=2019072412345678900001&body=普通商品&notifyUrl=http://sltest.juboon.com:9500/bonade-omall-web/omall/mallPayment/v1/payCallBack&feeType=1001&key=UFVMAJWSYR8C8TUN8CZ9GJFI6U1D7QAE";
//    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)url, NULL, (CFStringRef)@"!*’();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
//    NSString *newstr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*’();:@&=+$,/?%#[]"]];
//    NSLog(@"url>>>%@",encodedString);
//    NSLog(@"url>>>%@",encodedString);
}

- (void)click {
//    订单名  订单id
    if (self.payText.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入金额"];
        return;
    }
    XQCPayViewController *pay = [[XQCPayViewController alloc] initWithOrderTitle:@"薪起程测试" OrderId:[self getOrderId]];
    [pay sendPrice:[self.payText.text floatValue] feeType:(feeTypeLife)]; // 设置金额
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
