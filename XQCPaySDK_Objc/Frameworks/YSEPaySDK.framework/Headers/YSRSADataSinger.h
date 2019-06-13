//
//  YSRSADataSinger.h
//  YSEPaySDK
//
//  Created by JoakimLiu on 2017/5/5.
//  Copyright © 2017年 银盛通信有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSRSADataSinger : NSObject

- (NSString *)signString:(NSString *)string keyName:(NSString *)keyName;
@end

