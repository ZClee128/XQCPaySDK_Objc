//
//  XQCNetworking.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import "XQCNetworking.h"
#import <CommonCrypto/CommonDigest.h>
NSString *const ResponseErrorKey = @"com.alamofire.serialization.response.error.response";
NSInteger const Interval = 3;

@interface XQCNetworking ()

@end

@implementation XQCNetworking

//原生GET网络请求
+ (void)getWithURL:(NSString *)url Params:(NSMutableDictionary *)params keyValue:(NSString *)keyValue success:(SuccessBlock)success failure:(FailureBlock)failure
{
    //完整URL
    NSString *urlString = [NSString string];
    if (params) {
        //参数拼接url
        NSString *paramStr = [self dealWithParam:params keyValue:keyValue];
        urlString = [url stringByAppendingString:paramStr];
    }else{
        urlString = url;
    }
    //对URL中的中文进行转码
    NSString *pathStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pathStr]];
    
    request.timeoutInterval = Interval;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                //利用iOS自带原生JSON解析data数据 保存为Dictionary
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                success(dict);
                
            }else{
                NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
                
                if (httpResponse.statusCode != 0) {
                    
                    NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
                    failure(ResponseStr);
                    
                } else {
                    NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
                    failure(ErrorCode);
                }
            }
            
        });
    }];
    
    [task resume];
}

//原生POST请求
+ (void)PostWithURL:(NSString *)url Params:(NSMutableDictionary *)params keyValue:(NSString *)keyValue success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    //把字典中的参数进行拼接
    NSString *body = [self dealWithParam:params keyValue:keyValue];
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"body%@",body);
    //设置请求体
    [request setHTTPBody:bodyData];
    //设置本次请求的数据请求格式
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置本次请求请求体的长度(因为服务器会根据你这个设定的长度去解析你的请求体中的参数内容)
    [request setValue:[NSString stringWithFormat:@"%ld", bodyData.length] forHTTPHeaderField:@"Content-Length"];
    //设置请求最长时间
    request.timeoutInterval = Interval;

    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            //利用iOS自带原生JSON解析data数据 保存为Dictionary
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([dict[@"rspCode"] integerValue] != 0000) {
                failure(dict[@"rspMsg"]);
                return;
            }
            success(dict);
            
        }else{
            NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
            
            if (httpResponse.statusCode != 0) {
                
                NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
                failure(ResponseStr);
                
            } else {
                NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
                failure(ErrorCode);
            }
        }
    }];
    [task resume];
}

#pragma mark -- 拼接参数
+ (NSString *)dealWithParam:(NSMutableDictionary *)param keyValue:(NSString *)keyValue
{
    NSArray *allkeys = [param allKeys];
    NSMutableString *result = [NSMutableString string];
    NSArray *resultArr = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2]; //升序
    }];
    
    NSLog(@"result=%@",resultArr);
    for (NSString *key in resultArr) {
        if (![param[key] isEqualToString:@""]) {
            NSString *string = [NSString stringWithFormat:@"%@=%@&", key, param[key]];
            [result appendString:string];
        }
    }
    keyValue = [NSString stringWithFormat:@"%@key=%@",result,keyValue];
    NSLog(@"keyvalue%@",keyValue);
    keyValue = [self MD5ForUpper32Bate:keyValue];
    NSLog(@"key>>%@",keyValue);
    param[@"sign"] = keyValue;
    NSLog(@"param%@",param);
    return [self convertToJsonData:param];
}

#pragma mark - MD5加密 32位 大写
+ (NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}


+ (NSString *)convertToJsonData:(NSDictionary *)dict

{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

#pragma mark
+ (NSString *)showErrorInfoWithStatusCode:(NSInteger)statusCode{
    
    NSString *message = nil;
    switch (statusCode) {
        case 401: {
            
        }
            break;
            
        case 500: {
            message = @"服务器异常！";
        }
            break;
            
        case -1001: {
            message = @"网络请求超时，请稍后重试！";
        }
            break;
            
        case -1002: {
            message = @"不支持的URL！";
        }
            break;
            
        case -1003: {
            message = @"未能找到指定的服务器！";
        }
            break;
            
        case -1004: {
            message = @"服务器连接失败！";
        }
            break;
            
        case -1005: {
            message = @"连接丢失，请稍后重试！";
        }
            break;
            
        case -1009: {
            message = @"互联网连接似乎是离线！";
        }
            break;
            
        case -1012: {
            message = @"操作无法完成！";
        }
            break;
            
        default: {
            message = @"网络请求发生未知错误，请稍后再试！";
        }
            break;
    }
    return message;
    
}

@end
