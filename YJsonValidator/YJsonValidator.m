//
//  YJsonValidator.m
//  YJsonValidator
//
//  Created by yj on 7/10/16.
//  Copyright © 2016 yj. All rights reserved.
//

#import "YJsonValidator.h"
#import "SharedXcode.h"
#import "xprivates.h"
#import "NSObject+Plugin.h"

static YJsonValidator *sharedPlugin;
#define kYJsonValidator_enable @"kYJsonValidator_enable"

@interface YJsonValidator()

@end

@implementation YJsonValidator

#pragma mark - Initialization

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    NSArray *allowedLoaders = [plugin objectForInfoDictionaryKey:@"me.delisa.XcodePluginBase.AllowedLoaders"];
    if ([allowedLoaders containsObject:[[NSBundle mainBundle] bundleIdentifier]]) {
        sharedPlugin = [[self alloc] initWithBundle:plugin];
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)bundle
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        _bundle = bundle;
        // NSApp may be nil if the plugin is loaded from the xcodebuild command line tool
        if (NSApp && !NSApp.mainMenu) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(applicationDidFinishLaunching:)
                                                         name:NSApplicationDidFinishLaunchingNotification
                                                       object:nil];
        } else {
            [self initializeAndLog];
        }
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    [self initializeAndLog];
}

- (void)initializeAndLog
{
    NSString *name    = [self.bundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *version = [self.bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *status  = [self initialize] ? @"loaded successfully" : @"failed to load";
    NSLog(@"🔌 Plugin %@ %@ %@", name, version, status);
}

#pragma mark - Implementation

- (BOOL)initialize
{
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem && ![menuItem.submenu itemWithTitle:@"Validate Json On Save"]) {
        self.bEnable = [[NSUserDefaults standardUserDefaults] objectForKey:kYJsonValidator_enable] == nil ? YES : [[NSUserDefaults standardUserDefaults] boolForKey:kYJsonValidator_enable];
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Validate Json On Save" action:@selector(doValidateMenu) keyEquivalent:@""];
        actionMenuItem.state       = self.bEnable ? NSOnState : NSOffState;
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
        
        [NSObject swizzleClass:NSClassFromString(@"IDEEditorDocument") originalSelector:NSSelectorFromString(@"ide_saveDocument:") swizzledSelector:NSSelectorFromString(@"yjsonValidator_ide_saveDocument:") instanceMethod:YES];
        
        return YES;
    } else {
        return NO;
        
    }
}

// Sample Action, for menu item:
- (void)doValidateMenu
{
    self.bEnable = !self.bEnable;
    [[NSUserDefaults standardUserDefaults] setBool:self.bEnable forKey:kYJsonValidator_enable];
}

- (void)doValidate
{
    IDESourceCodeDocument * document = [SharedXcode sourceCodeDocument];
    if (!document) {
        return;
    }
    DVTFileDataType *type = [document fileDataType];
    if (![type.identifier isEqualToString:@"public.json"]) {
        return;
    }
    
    NSError *error;
    NSTextView * textView = [SharedXcode textView];
    NSString *allcontent  = textView.string;
    [NSJSONSerialization JSONObjectWithData:[allcontent dataUsingEncoding:[document textEncoding]] options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSString *errMsg            = error.userInfo[@"NSDebugDescription"];
        NSError * error             = nil;
        NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"around character \\d+" options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray * matches           = [regex matchesInString:errMsg options:NSMatchingReportCompletion range:NSMakeRange(0, errMsg.length)];
        if (matches.count > 0) {
            NSString *posStr     = [errMsg substringWithRange:[matches[0] range]];
            posStr               = [posStr substringFromIndex:[posStr rangeOfString:@" " options:NSBackwardsSearch].location + 1];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle        = NSNumberFormatterDecimalStyle;
            NSNumber *pos        = [f numberFromString:posStr];
            if (pos) {
                NSRange errRange = NSMakeRange([pos integerValue], 1);
                [textView setSelectedRange:errRange];
                [textView scrollRangeToVisible:errRange];
            }
        }
    }
}

@end
