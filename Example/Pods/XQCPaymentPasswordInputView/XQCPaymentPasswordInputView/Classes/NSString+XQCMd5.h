//
//  NSString+XQCMd5.h
//  XqcDev
//
//  Created by huangwenwu on 2018/7/19.
//

#import <Foundation/Foundation.h>

@interface NSString (XQCMd5)


/**
 返回32位小写md5加密后的字符串

 @return 加密后的字符串
 */
-(NSString*)md532BitLower;

/**
 返回32位小写md5加密后的字符串(加盐后的)
 
 @return 加密后的字符串
 */
-(NSString*)md532BitLowerWithSalt;

@end
