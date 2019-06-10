//
//  ChannelModel.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import "ChannelModel.h"

@implementation ChannelModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
