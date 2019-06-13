//
//  NSString+XQCPwdRsaTool.m
//  XqcDev
//
//  Created by huangwenwu on 2018/7/19.
//

#import "NSString+XQCPwdRsaTool.h"
#import "RSAEncryptor.h"
#import "NSString+XQCMd5.h"


#define Pwd_PublicKey  @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCA3+uOOSPIfCszVdz6NPHhjgfSCNoPPUWmDcKWSW5yepiDw6Met7XKy2ETLbUCBcTTJXMqZNTh2I4b72oQgcF62JTzuV1faCJUQTM73vJUwxbXJKTGBIn2dZYHGG35whdgqL5dcL53oU7cUaXqXHCn5rfJVo7FHnC+ePEKAtSGzQIDAQAB" //加密密码用的公钥


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

@end
