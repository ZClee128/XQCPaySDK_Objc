//
//  PasswordModel.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/13.
//

#import "PasswordModel.h"

@implementation PasswordModel


- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.state = [dict valueForKey:@"state"];
        self.info = [dict valueForKey:@"info"];
    }
    return self;
}
@end
