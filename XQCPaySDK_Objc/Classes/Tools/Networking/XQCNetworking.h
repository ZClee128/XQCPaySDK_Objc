//
//  XQCNetworking.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSString *error);

@interface XQCNetworking : NSObject

//原生GET网络请求
+ (void)getWithURL:(NSString *)url Params:(NSMutableDictionary *)params keyValue:(NSString *)keyValue success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)PostWithURL:(NSString *)url Params:(NSMutableDictionary *)params keyValue:(NSString *)keyValue success:(SuccessBlock)success failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
