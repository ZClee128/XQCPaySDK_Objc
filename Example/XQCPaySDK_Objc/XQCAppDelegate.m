//
//  XQCAppDelegate.m
//  XQCPaySDK_Objc
//
//  Created by ZClee128 on 06/10/2019.
//  Copyright (c) 2019 ZClee128. All rights reserved.
//

#import "XQCAppDelegate.h"
#import <XQCPaySDK_Objc-umbrella.h>
@implementation XQCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[XQCPayManager defaultManager] setWechatKey:@"wx88d30b27f1df7354"];
    [[XQCPayManager defaultManager] setConfig:@"https://openfulipayapi.bndxqc.com"];
    [[XQCPayManager defaultManager] setMacSignKey:@"IZJOIBXZCLJQBIOSGVZL4FNHGL8X74PZ" AgentKey:@"CEB9011C0946E23D4959C13EE5E1B785" MerchantId:@"111401100000212" PartnerId:@"XQC_payforapp" Password:@"xQcMy20Pwd19" Notify:@"http://abc.com" AgentNo:@"1000001114" CompanyOpenId:@"123456789" UserOpenId:@"112233"];
//    [[XQCPayManager defaultManager] setConfig:@"http://172.16.2.11:8081/"];
//    [[XQCPayManager defaultManager] setMacSignKey:@"XSXORALBEXNCUIAI9RS2MEI9BAKGSJKK" AgentKey:@"AB6578B81922467C8E92E9D7B61DDC4A" MerchantId:@"137801100000583" PartnerId:@"XQC_payforapp" Password:@"xQcMy20Pwd19" Notify:@"http://abc.com" AgentNo:@"1000001378" CompanyOpenId:@"123456789" UserOpenId:@"112233"];
    return YES;
}

// iOS9 之前用此方法
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if (![XQCPayManager handler:url]) {
        /* 处理其他非微信APP回调过来的URL */
    }
    return YES;
}
// iOS9 及以上用此方法
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options{
    if (![XQCPayManager handler:url]) {
        /* 处理其他非微信APP回调过来的URL */
    }
    return YES;
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [XQCPayManager applicationWillEnterForeground:application];
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
