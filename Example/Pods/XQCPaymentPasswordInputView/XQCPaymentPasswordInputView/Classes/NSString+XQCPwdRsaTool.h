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

@end
