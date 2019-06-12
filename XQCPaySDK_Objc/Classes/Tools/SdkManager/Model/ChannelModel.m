//
//  ChannelModel.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import "ChannelModel.h"

@implementation ChannelModel

- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.channelType = [dict valueForKey:@"channelType"];
        self.channelLogoUrl = [dict valueForKey:@"channelLogoUrl"];
        self.channelName = [dict valueForKey:@"channelName"];
        self.bizCode = [dict valueForKey:@"bizCode"];
        self.isCheckPayPwd = [[dict valueForKey:@"isCheckPayPwd"] boolValue];
        self.paymentUrl = [dict valueForKey:@"paymentUrl"];
        self.sort = [[dict valueForKey:@"sort"] integerValue];
        if (self.sort == 1) {
            self.isClick = true;
        }else {
            self.isClick = false;
        }
    }
    return self;
}

@end
