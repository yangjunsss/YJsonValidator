//
//  NSObject+Plugin.m
//  YJsonValidator
//
//  Created by yj on 7/13/16.
//  Copyright © 2016 yj. All rights reserved.
//

#import "NSObject+Plugin.h"
#import "YJsonValidator.h"
#import <objc/runtime.h>

@implementation NSObject (Plugin)

-(void) yjsonValidator_ide_saveDocument:(id) arg{
    [self yjsonValidator_ide_saveDocument:arg];
    if([self isKindOfClass:NSClassFromString(@"IDEEditorDocument")]){
        if ([YJsonValidator sharedPlugin].bEnable) {
            [[YJsonValidator sharedPlugin] doValidate];
        }
    }
}

+ (void)swizzleClass:(nullable Class)class originalSelector:(nullable SEL)originalSelector swizzledSelector:(nullable SEL)swizzledSelector instanceMethod:(BOOL)instanceMethod{
    if (class) {
        Method originalMethod;
        Method swizzledMethod;
        if (instanceMethod) {
            originalMethod = class_getInstanceMethod(class, originalSelector);
            swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        } else {
            originalMethod = class_getClassMethod(class, originalSelector);
            swizzledMethod = class_getClassMethod(class, swizzledSelector);
            class          = object_getClass((id)class);
        }
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

@end
