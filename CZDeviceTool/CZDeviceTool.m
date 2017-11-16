//
//  CZDeviceTool.m
//  EnjoyiOS
//
//  Created by ug19 on 16/5/23.
//  Copyright © 2016年 Ugood. All rights reserved.
//

#import "CZDeviceTool.h"
#include <sys/sysctl.h>

NSString *const kTCInfoBundleDisplayName = @"CFBundleDisplayName";
NSString *const kTCInfoBundleShortVersionString = @"CFBundleShortVersionString";
NSString *const kTCInfoBundleVersion = @"CFBundleVersion";
NSString *const kTCInfoCFBundleName = @"CFBundleName";

@implementation CZDeviceTool

+ (NSDictionary *)infoDictionary {
	return [[NSBundle mainBundle] infoDictionary];
}
+ (NSString *)bundleIdentifier {
	return [NSBundle mainBundle].bundleIdentifier;
}
+ (NSString *)bundleDisplayName {
	return [CZDeviceTool.infoDictionary objectForKey:kTCInfoBundleDisplayName];
}
+ (NSString *)bundleShortVersionString {
	return [CZDeviceTool.infoDictionary objectForKey:kTCInfoBundleShortVersionString];
}
+ (NSString *)bundleVersion {
	return [CZDeviceTool.infoDictionary objectForKey:kTCInfoBundleVersion];
}
+ (NSString *)bundleName {
	return [CZDeviceTool.infoDictionary objectForKey:kTCInfoCFBundleName];
}

+ (NSString *)systemName {
	return [UIDevice currentDevice].systemName;
}
+ (NSString *)systemVersion {
	return [UIDevice currentDevice].systemVersion;
}
+ (NSString *)systemLanguage {
	NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
	NSString *preferredLang = [languages objectAtIndex:0];
	return preferredLang;
}

// determine system version
+ (BOOL)iOS {
	if ([CZDeviceTool.systemName isEqualToString:@"iOS"] || [CZDeviceTool.systemName isEqualToString:@"iPhone OS"]) {
		return YES;
	} else {
		return NO;
	}
}
+ (BOOL)iOS6orLess {
	if (!CZDeviceTool.iOS) {
		return NO;
	}
	return [[CZDeviceTool systemVersion] floatValue] <= 6;
}
+ (BOOL)iOS7System {
	if (!CZDeviceTool.iOS) {
		return NO;
	}
	return [[CZDeviceTool systemVersion] floatValue] >= 7 && [[CZDeviceTool systemVersion] floatValue] < 8;
}
+ (BOOL)iOS8System {
	if (!CZDeviceTool.iOS) {
		return NO;
	}
	return [[CZDeviceTool systemVersion] floatValue] >= 8 && [[CZDeviceTool systemVersion] floatValue] < 9;
}
+ (BOOL)iOS9System {
	if (!CZDeviceTool.iOS) {
		return NO;
	}
	return [[CZDeviceTool systemVersion] floatValue] >= 9 && [[CZDeviceTool systemVersion] floatValue] < 10;
}
+ (BOOL)iOS10System {
	if (!CZDeviceTool.iOS) {
		return NO;
	}
	return [[CZDeviceTool systemVersion] floatValue] >= 10 && [[CZDeviceTool systemVersion] floatValue] < 11;
}

// determine screen
+ (BOOL)isScreen35 {
	return [CZDeviceTool screenMaxLength] == 480 ? YES:NO;
}
+ (BOOL)isScreen40 {
	return [CZDeviceTool screenMaxLength] == 568 ? YES:NO;
}
+ (BOOL)isScreen47 {
	return [CZDeviceTool screenMaxLength] == 667 ? YES:NO;
}
+ (BOOL)isScreen55 {
	return [CZDeviceTool screenMaxLength] == 736 ? YES:NO;
}

/** 屏幕宽度 */
+ (CGFloat)screenWidth {
	return [UIScreen mainScreen].bounds.size.width;
}
/** 屏幕高度 */
+ (CGFloat)screenHeight {
	return [UIScreen mainScreen].bounds.size.height;
}
/** 屏幕长的一边 */
+ (CGFloat)screenMaxLength {
	return MAX(CZDeviceTool.screenWidth, CZDeviceTool.screenHeight);
}
/** 屏幕短的一边 */
+ (CGFloat)screenMinLength {
	return MIN(CZDeviceTool.screenWidth, CZDeviceTool.screenHeight);
}
/** 根据开发所用的点（pt）计算屏幕上的物理像素值（px） */
+ (CGFloat)pxWithPt:(CGFloat)pt {
    if ([CZDeviceTool isScreen55]) {
        return pt * 3;
    } else {
        return pt * 2;
    }
}

/** current device model */
+ (NSString *)deviceModel {
	int mib[2];
	size_t len;
	char *machine;
	
	mib[0] = CTL_HW;
	mib[1] = HW_MACHINE;
	sysctl(mib, 2, NULL, &len, NULL, 0);
	machine = malloc(len);
	sysctl(mib, 2, machine, &len, NULL, 0);
	
	NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];	// 手机型号，如 iPhone 6s 是 iPhone8,1
	free(machine);
	
//	// 这段代码和上面的一样
//	size_t size;
//	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//	char *machine = (char*)malloc(size);
//	sysctlbyname("hw.machine", machine, &size, NULL, 0);
//	NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
//	NSLog(@"platform:%@", platform);
	
	// iPhone
	if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
	if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
	if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3Gs";
	if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
	if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
	if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
	if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
	if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
	if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
	if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
	if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
	if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
	if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
	if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
	if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
	if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
	if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
	// iPod
	if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1";
	if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2";
	if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3";
	if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4";
	if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5";
	if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6";
	// iPad
	if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1";
	if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
	if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
	if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
	if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
	if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1";
	if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1";
	if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1";
	if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
	if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
	if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
	if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
	if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
	if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
	if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air 1";
	if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air 1";
	if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air 1";
	if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2";
	if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2";
	if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2";
	if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3";
	if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3";
	if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3";
	if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
	if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
	if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4";
	// Simulator
	if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
	if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
	
	return platform;
}

@end
