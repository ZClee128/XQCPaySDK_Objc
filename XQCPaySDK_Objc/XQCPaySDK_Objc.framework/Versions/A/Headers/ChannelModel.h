//
//  ChannelModel.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChannelModel : NSObject

@property (nonatomic,copy)NSString *channelLogoUrl;
@property (nonatomic,copy)NSString *channelType;
@property (nonatomic,copy)NSString *channelName;
@property (nonatomic,copy)NSString *bizCode;
//@property (nonatomic,assign) BOOL  enable;
@property (nonatomic,assign) BOOL  isCheckPayPwd;
@property (nonatomic,copy)NSString *paymentUrl;
@property (nonatomic,assign) NSInteger  sort;
@property (nonatomic,assign) BOOL  isClick;

- (id)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
