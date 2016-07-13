//
//  YJsonValidator.h
//  YJsonValidator
//
//  Created by yj on 7/10/16.
//  Copyright © 2016 yj. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface YJsonValidator : NSObject
@property (nonatomic) BOOL bEnable;
+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle * bundle;
- (void)doValidate;
@end