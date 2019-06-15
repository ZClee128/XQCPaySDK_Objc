//
//  PasswordModel.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasswordModel : NSObject

/// 校验结果 1:成功 2:失败
@property (nonatomic,copy)NSString *state;
///  校验说明
@property (nonatomic,copy)NSString *info;

- (id)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
