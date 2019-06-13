//
//  UIButton+Extension.m
//  Xqc.local
//
//  Created by 刘军军 on 17/5/26.
//
//

#import "UIButton+Extension.h"
#import "XQCHeader.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UIButton (Block)

+ (instancetype)buttonWithAction:(void (^)(UIButton *))action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [[[[button rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOn:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (action) {
            action((UIButton *)x);
        }
    }];
    return button;
}

@end
