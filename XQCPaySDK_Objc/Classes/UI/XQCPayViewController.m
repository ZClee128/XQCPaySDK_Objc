//
//  XQCPayViewController.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import "XQCPayViewController.h"
#import "XQCPayManager.h"
@interface XQCPayViewController ()

@end

@implementation XQCPayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[XQCPayManager defaultManager] getChannels:@"" agentNo:[[XQCPayManager defaultManager] getSignKey] respon:^(NSArray * _Nonnull list) { 
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
