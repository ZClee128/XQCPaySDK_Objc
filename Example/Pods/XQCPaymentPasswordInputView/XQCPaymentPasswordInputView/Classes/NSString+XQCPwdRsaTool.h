//
//  NSString+XQCPwdRsaTool.h
//  XqcDev
//
//  Created by huangwenwu on 2018/7/19.
//

#import <Foundation/Foundation.h>

@interface NSString (XQCPwdRsaTool)


/**
 ras加密密码

 @return 加密后的密码
 */
-(NSString*)rasedPwdStr;

-(NSString*)rasedPwdStrWithOldPwd;

//白条
- (NSString *)rasedPwdStrForSDKWithiousPwd;

-(NSString *)md532BitLowerWithSalt;

//获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp3;

@end
