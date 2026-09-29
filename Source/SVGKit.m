//
//  SVGKit.m
//  SVGKit-iOS
//
//  Created by Devon Blandin on 5/13/13.
//  Copyright (c) 2013 na. All rights reserved.
//

#import "SVGKit.h"

#if __has_include(<CocoaLumberjack/DDOSLogger.h>)
#import <CocoaLumberjack/DDOSLogger.h>
#define SVGKIT_HAS_DDOSLOGGER 1
#else
#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>
#define SVGKIT_HAS_DDOSLOGGER 0
#endif

@implementation SVGKit : NSObject

+ (void) enableLogging {
#if SVGKIT_HAS_DDOSLOGGER
    [DDLog addLogger:[DDOSLogger sharedInstance]];
#else
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
#endif
}

@end
