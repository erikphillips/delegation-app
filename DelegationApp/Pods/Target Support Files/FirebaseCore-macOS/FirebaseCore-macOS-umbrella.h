#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FIRAnalyticsConfiguration.h"
#import "FIRApp.h"
#import "FIRConfiguration.h"
#import "FirebaseCore.h"
#import "FIRLoggerLevel.h"
#import "FIROptions.h"

FOUNDATION_EXPORT double FirebaseCoreVersionNumber;
FOUNDATION_EXPORT const unsigned char FirebaseCoreVersionString[];
