//
//  NSBundle+loadImage.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/12.
//

#import "NSBundle+loadImage.h"

@implementation NSBundle (loadImage)


+ (NSBundle *)my_myLibraryBundle {
    return [self bundleWithURL:[self my_myLibraryBundleURL]];
}


+ (NSURL *)my_myLibraryBundleURL {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
    bundleURL = [bundleURL URLByAppendingPathComponent:@"XQCPaySDK_Objc"];
    bundleURL = [bundleURL URLByAppendingPathExtension:@"framework"];
    if (bundleURL) {
        NSBundle *imgBundle = [NSBundle bundleWithURL:bundleURL];
        bundleURL = [imgBundle URLForResource:@"XQCPaySDK_Objc" withExtension:@"bundle"];
        if (!bundleURL) {
            bundleURL = [[NSBundle mainBundle]  URLForResource:@"XQCPaySDK_Objc" withExtension:@"bundle"];
        }
    }else{
        bundleURL = [[NSBundle mainBundle]  URLForResource:@"XQCPaySDK_Objc" withExtension:@"bundle"];
    }
    return bundleURL;
}

@end
