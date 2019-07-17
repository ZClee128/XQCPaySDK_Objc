//
//  NSString+XQCPwdRsaTool.m
//  XqcDev
//
//  Created by huangwenwu on 2018/7/19.
//

#import "NSString+XQCPwdRsaTool.h"
#import "NSString+XQCMd5.h"
#import "RSAEncryptor.h"
#import <CommonCrypto/CommonDigest.h>

#define Pwd_PublicKey  @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCA3+uOOSPIfCszVdz6NPHhjgfSCNoPPUWmDcKWSW5yepiDw6Met7XKy2ETLbUCBcTTJXMqZNTh2I4b72oQgcF62JTzuV1faCJUQTM73vJUwxbXJKTGBIn2dZYHGG35whdgqL5dcL53oU7cUaXqXHCn5rfJVo7FHnC+ePEKAtSGzQIDAQAB" //加密密码用的公钥

#define Pwd_iousForSDKPublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCbFKoIqU+V7H0gFgVH6649W+kw8ye/mP30Nfv+x4PD8yFW8rvlsI6DJCYWvtgT9XFYuwHuFMPdQAVznKozd0Xjwai8WPGA5pS/EKWQNHWSWMYiPu5mU5iqzAhm/AkANpxGhMjviNdsJTeRTisOxWQPIQljFPZsBXTwmQm5bt5LyQIDAQAB"

@implementation NSString (XQCPwdRsaTool)

-(NSString *)rasedPwdStr{
    
    NSString *md5edStr = [self md532BitLowerWithSalt];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *needRasStr = [NSString stringWithFormat:@"%@##&&&%@",md5edStr,nowtimeStr];
    
    NSString *rsaedStr =  [RSAEncryptor encryptString:needRasStr publicKey:Pwd_PublicKey];
    
    return rsaedStr;
    
}

//白条
- (NSString *)rasedPwdStrForSDKWithiousPwd
{
    NSString *md5edStr = [self md532BitLowerWithSalt];

    NSString *nowtimeStr = [NSString getNowTimeTimestamp3];
    NSString *needRasStr = [NSString stringWithFormat:@"%@##&&&%@##&&&%@",md5edStr,nowtimeStr,self];
    
    NSString *rsaedStr =  [RSAEncryptor encryptString:needRasStr publicKey:Pwd_iousForSDKPublicKey];
    
    return rsaedStr;
}

-(NSString*)rasedPwdStrWithOldPwd{
    
    NSString *md5edStr = [self md532BitLowerWithSalt];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *needRasStr = [NSString stringWithFormat:@"%@##&&&%@##&&&%@",md5edStr,nowtimeStr,self];
    
    NSString *rsaedStr =  [RSAEncryptor encryptString:needRasStr publicKey:Pwd_PublicKey];
    
    return rsaedStr;
}

-(NSString *)md532BitLowerWithSalt{
    
    NSString *str = [NSString stringWithFormat:@"%@xqc1254548787244",self];
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}
@end
