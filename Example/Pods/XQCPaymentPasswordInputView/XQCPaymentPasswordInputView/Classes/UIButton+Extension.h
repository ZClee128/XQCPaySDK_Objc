//
//  UIButton+Extension.h
//  Xqc.local
//
//  Created by 刘军军 on 17/5/26.
//
//

#import <UIKit/UIKit.h>

@interface UIButton (Block)

+ (instancetype)buttonWithAction:(void(^)(UIButton *button))action;

@end
