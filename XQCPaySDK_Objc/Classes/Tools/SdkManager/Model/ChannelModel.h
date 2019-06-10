//
//  ChannelModel.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChannelModel : NSObject

@property (nonatomic,copy)NSString *logo;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *bizCode;
@property (nonatomic,assign) BOOL  enable;
@property (nonatomic,assign) BOOL  checkPayPwd;
@property (nonatomic,copy)NSString *paymentUrl;
@property (nonatomic,assign) NSInteger  source;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
