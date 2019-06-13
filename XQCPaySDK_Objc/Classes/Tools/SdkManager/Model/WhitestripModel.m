//
//  WhitestripModel.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/13.
//

#import "WhitestripModel.h"

@implementation WhitestripModel

- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.bizKind = [[dict valueForKey:@"bizKind"] integerValue];
        self.canUseAmt = [dict valueForKey:@"canUseAmt"];
        self.iousCode = [dict valueForKey:@"iousCode"];
        self.iousUsage = [dict valueForKey:@"iousUsage"];
        self.totalAmt = [dict valueForKey:@"totalAmt"];
        self.name = self.bizKind == 71 ? @"因公白条" : @"消费预结";
        self.isCheck = false;
    }
    return self;
}

@end
