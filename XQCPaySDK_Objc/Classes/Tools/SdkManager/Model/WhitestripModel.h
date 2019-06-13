//
//  WhitestripModel.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WhitestripModel : NSObject

@property (nonatomic,assign) NSInteger  bizKind;
@property (nonatomic,copy)NSString *canUseAmt;
@property (nonatomic,copy)NSString *iousCode;
@property (nonatomic,copy)NSString *iousUsage;
@property (nonatomic,copy) NSString  *totalAmt;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign) BOOL  isCheck;

- (id)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
