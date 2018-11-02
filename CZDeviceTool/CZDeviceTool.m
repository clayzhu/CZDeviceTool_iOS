//
//  CZDeviceTool.m
//  EnjoyiOS
//
//  Created by ug19 on 16/5/23.
//  Copyright © 2016年 Ugood. All rights reserved.
//

#import "CZDeviceTool.h"
#include <sys/sysctl.h>
#import <sys/utsname.h>

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

+ (NSString *)deviceName {
    return [UIDevice currentDevice].name;
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

// 判断系统版本
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
+ (BOOL)iOS11System {
    if (!CZDeviceTool.iOS) {
        return NO;
    }
    return [[CZDeviceTool systemVersion] floatValue] >= 11 && [[CZDeviceTool systemVersion] floatValue] < 12;
}

// 判断屏幕尺寸
+ (BOOL)isScreen35 {
	return [CZDeviceTool screenMaxLength] == 480 ? YES : NO;
}
+ (BOOL)isScreen40 {
	return [CZDeviceTool screenMaxLength] == 568 ? YES : NO;
}
+ (BOOL)isScreen47 {
	return [CZDeviceTool screenMaxLength] == 667 ? YES : NO;
}
+ (BOOL)isScreen55 {
	return [CZDeviceTool screenMaxLength] == 736 ? YES : NO;
}
+ (BOOL)isScreen58 {
    return [CZDeviceTool screenMaxLength] == 812 ? YES : NO;
}

+ (CGFloat)screenWidth {
	return [UIScreen mainScreen].bounds.size.width;
}
+ (CGFloat)screenHeight {
	return [UIScreen mainScreen].bounds.size.height;
}
+ (CGFloat)screenMaxLength {
	return MAX(CZDeviceTool.screenWidth, CZDeviceTool.screenHeight);
}
+ (CGFloat)screenMinLength {
	return MIN(CZDeviceTool.screenWidth, CZDeviceTool.screenHeight);
}
+ (CGFloat)pxWithPt:(CGFloat)pt {
    CGFloat scale = [UIScreen mainScreen].scale;
    return pt * scale;
}
+ (CGFloat)physicalScreenWidth {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat screenWidth = [CZDeviceTool screenWidth];
    return screenWidth * scale;
    
//    // 下面是另一种获取物理像素的方法。这种方法不会随着屏幕旋转而改变
//    CGRect nativeBounds = [UIScreen mainScreen].nativeBounds;
}
+ (CGFloat)physicalScreenHeight {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat screenHeight = [CZDeviceTool screenHeight];
    return screenHeight * scale;
}

+ (NSString *)deviceInternalName {
    // 方法1
    int mib[2];
    size_t len;
    char *machine;

    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);

    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];    // 手机型号，如 iPhone 6s 是 iPhone8,1
    free(machine);
	
//    // 方法2
//    size_t size;
//    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//    char *machine = (char*)malloc(size);
//    sysctlbyname("hw.machine", machine, &size, NULL, 0);
//    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
//    free(machine);
    
//    // 方法3
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	
	return platform;
}

+ (NSDictionary<NSString *, NSArray *> *)modelManifest {
    // key:deviceModel_Raw
    // value:设备型号, 屏幕尺寸（英寸）, 像素密度（PPI）
    NSDictionary *modelManifest = @{// iPhone
                                    // 1
                                    @"iPhone1,1":@[@"iPhone", @3.5, @163],
                                    // 3G
                                    @"iPhone1,2":@[@"iPhone 3G", @3.5, @163],
                                    // 3Gs
                                    @"iPhone2,1":@[@"iPhone 3GS", @3.5, @163],
                                    // 4
                                    @"iPhone3,1":@[@"iPhone 4", @3.5, @326],    // iPhone 4 (GSM)
                                    @"iPhone3,2":@[@"iPhone 4", @3.5, @326],    // Verizon iPhone 4
                                    @"iPhone3,3":@[@"iPhone 4", @3.5, @326],    // iPhone 4 (CDMA/Verizon/Sprint)
                                    // 4s
                                    @"iPhone4,1":@[@"iPhone 4S", @3.5, @326],
                                    // 5
                                    @"iPhone5,1":@[@"iPhone 5", @4.0, @326],
                                    @"iPhone5,2":@[@"iPhone 5", @4.0, @326],
                                    // 5c
                                    @"iPhone5,3":@[@"iPhone 5c", @4.0, @326],
                                    @"iPhone5,4":@[@"iPhone 5c", @4.0, @326],
                                    // 5s
                                    @"iPhone6,1":@[@"iPhone 5s", @4.0, @326],
                                    @"iPhone6,2":@[@"iPhone 5s", @4.0, @326],
                                    // 6 Plus
                                    @"iPhone7,1":@[@"iPhone 6 Plus", @5.5, @401],
                                    // 6
                                    @"iPhone7,2":@[@"iPhone 6", @4.7, @326],
                                    // 6s
                                    @"iPhone8,1":@[@"iPhone 6s", @4.7, @326],
                                    // 6s Plus
                                    @"iPhone8,2":@[@"iPhone 6s Plus", @5.5, @401],
                                    // SE
                                    @"iPhone8,4":@[@"iPhone SE", @4.0, @326],
                                    // 7
                                    @"iPhone9,1":@[@"iPhone 7", @4.7, @326],    // iPhone 7 (CDMA)
                                    @"iPhone9,3":@[@"iPhone 7", @4.7, @326],    // iPhone 7 (GSM)
                                    // 7 Plus
                                    @"iPhone9,2":@[@"iPhone 7 Plus", @5.5, @401],   // iPhone 7 Plus (CDMA)
                                    @"iPhone9,4":@[@"iPhone 7 Plus", @5.5, @401],   // iPhone 7 Plus (GSM)
                                    // 8
                                    @"iPhone10,1":@[@"iPhone 8", @4.7, @326],   // iPhone 8 (CDMA)
                                    @"iPhone10,4":@[@"iPhone 8", @4.7, @326],   // iPhone 8 (GSM)
                                    // 8 Plus
                                    @"iPhone10,2":@[@"iPhone 8 Plus", @5.5, @401],  // iPhone 8 Plus (CDMA)
                                    @"iPhone10,5":@[@"iPhone 8 Plus", @5.5, @401],  // iPhone 8 Plus (GSM)
                                    // X
                                    @"iPhone10,3":@[@"iPhone X", @5.8, @458],   // iPhone X (CDMA)
                                    @"iPhone10,6":@[@"iPhone X", @5.8, @458],   // iPhone X (GSM)
                                    // XR
                                    @"iPhone11,8":@[@"iPhone XR", @6.1, @326],
                                    // XS
                                    @"iPhone11,2":@[@"iPhone XS", @5.8, @458],
                                    // XS Max
                                    @"iPhone11,4":@[@"iPhone XS Max", @6.5, @458],  // China
                                    @"iPhone11,6":@[@"iPhone XS Max", @6.5, @458],  // Global
                                    
                                    // iPad
                                    // 1
                                    @"iPad1,1":@[@"iPad", @9.7, @132],
                                    // 3G
                                    @"iPad1,2":@[@"iPad 3G", @9.7, @132],
                                    // 2
                                    @"iPad2,1":@[@"iPad 2", @9.7, @132],    // iPad 2 (Wi-Fi)
                                    @"iPad2,2":@[@"iPad 2", @9.7, @132],    // iPad 2 (GSM)
                                    @"iPad2,3":@[@"iPad 2", @9.7, @132],    // iPad 2 (CDMA)
                                    @"iPad2,4":@[@"iPad 2", @9.7, @132],    // iPad 2 (32nm)
                                    // Mini
                                    @"iPad2,5":@[@"iPad Mini", @7.9, @163], // iPad Mini (Wi-Fi)
                                    @"iPad2,6":@[@"iPad Mini", @7.9, @163], // iPad Mini (GSM)
                                    @"iPad2,7":@[@"iPad Mini", @7.9, @163], // iPad Mini (CDMA)
                                    // 3
                                    @"iPad3,1":@[@"iPad 3", @9.7, @264],    // iPad 3 (Wi-Fi)
                                    @"iPad3,2":@[@"iPad 3", @9.7, @264],    // iPad 3 (CDMA)
                                    @"iPad3,3":@[@"iPad 3", @9.7, @264],    // iPad 3 (4G)
                                    // 4
                                    @"iPad3,4":@[@"iPad 4", @9.7, @264],    // iPad 4 (Wi-Fi)
                                    @"iPad3,5":@[@"iPad 4", @9.7, @264],    // iPad 4 (4G)
                                    @"iPad3,6":@[@"iPad 4", @9.7, @264],    // iPad 4 (CDMA)
                                    // Air
                                    @"iPad4,1":@[@"iPad Air", @9.7, @264],
                                    @"iPad4,2":@[@"iPad Air", @9.7, @264],
                                    @"iPad4,3":@[@"iPad Air", @9.7, @264],
                                    // Mini 2
                                    @"iPad4,4":@[@"iPad Mini 2", @7.9, @326],
                                    @"iPad4,5":@[@"iPad Mini 2", @7.9, @326],
                                    @"iPad4,6":@[@"iPad Mini 2", @7.9, @326],
                                    // Mini 3
                                    @"iPad4,7":@[@"iPad Mini 3", @7.9, @326],
                                    @"iPad4,8":@[@"iPad Mini 3", @7.9, @326],
                                    @"iPad4,9":@[@"iPad Mini 3", @7.9, @326],
                                    // Mini 4
                                    @"iPad5,1":@[@"iPad Mini 4", @7.9, @326],
                                    @"iPad5,2":@[@"iPad Mini 4", @7.9, @326],
                                    // Air 2
                                    @"iPad5,3":@[@"iPad Air 2", @9.7, @264],
                                    @"iPad5,4":@[@"iPad Air 2", @9.7, @264],
                                    // Pro 12.9-inch
                                    @"iPad6,7":@[@"iPad Pro 12.9-inch", @12.9, @264],
                                    @"iPad6,8":@[@"iPad Pro 12.9-inch", @12.9, @264],
                                    // Pro 9.7-inch
                                    @"iPad6,3":@[@"iPad Pro 9.7-inch", @9.7, @264],
                                    @"iPad6,4":@[@"iPad Pro 9.7-inch", @9.7, @264],
                                    // 5
                                    @"iPad6,11":@[@"iPad 5", @9.7, @264],
                                    @"iPad6,12":@[@"iPad 5", @9.7, @264],
                                    // Pro 2 12.9-inch (2nd generation)
                                    @"iPad7,1":@[@"iPad Pro 2 12.9-inch", @12.9, @264],
                                    @"iPad7,2":@[@"iPad Pro 2 12.9-inch", @12.9, @264],
                                    // Pro 10.5-inch
                                    @"iPad7,3":@[@"iPad Pro 10.5-inch", @10.5, @264],
                                    @"iPad7,4":@[@"iPad Pro 10.5-inch", @10.5, @264],
                                    // 6
                                    @"iPad7,5":@[@"iPad 6", @9.7, @264],    // iPad 6 (Wi-Fi)
                                    @"iPad7,6":@[@"iPad 6", @9.7, @264],    // iPad 6 (4G)
                                    // Pro 11-inch
                                    @"iPad8,1":@[@"iPad Pro 11-inch", @11.0, @264], // iPad Pro (Cellular)
                                    @"iPad8,2":@[@"iPad Pro 11-inch", @11.0, @264], // iPad Pro (Wi-Fi, 1 TB)
                                    @"iPad8,3":@[@"iPad Pro 11-inch", @11.0, @264], // iPad Pro (Cellular)
                                    @"iPad8,4":@[@"iPad Pro 11-inch", @11.0, @264], // iPad Pro (Cellular, 1 TB)
                                    // Pro 12.9-inch (3rd generation)
                                    @"iPad8,5":@[@"iPad Pro 12.9-inch", @12.9, @264], // iPad Pro (Cellular)
                                    @"iPad8,6":@[@"iPad Pro 12.9-inch", @12.9, @264], // iPad Pro (Wi-Fi, 1 TB)
                                    @"iPad8,7":@[@"iPad Pro 12.9-inch", @12.9, @264], // iPad Pro (Cellular)
                                    @"iPad8,8":@[@"iPad Pro 12.9-inch", @12.9, @264], // iPad Pro (Cellular, 1 TB)
                                    
                                    // iPod
                                    // 1
                                    @"iPod1,1":@[@"iPod Touch 1", @3.5, @163],
                                    // 2
                                    @"iPod2,1":@[@"iPod Touch 2", @3.5, @163],
                                    // 3
                                    @"iPod3,1":@[@"iPod Touch 3", @3.5, @163],
                                    // 4
                                    @"iPod4,1":@[@"iPod Touch 4", @3.5, @326],
                                    // 5
                                    @"iPod5,1":@[@"iPod Touch 5", @4.0, @326],
                                    // 6
                                    @"iPod7,1":@[@"iPod Touch 6", @4.0, @326],
                                    
                                    // Simulator
                                    @"i386":@[@"iOS Simulator", @0.0, @0],
                                    @"x86_64":@[@"iOS Simulator", @0.0, @0],
                                    };
    return modelManifest;
}

+ (CZDeviceInfoModel *)deviceModel {
    NSString *internalName = [CZDeviceTool deviceInternalName];
    NSDictionary<NSString *, NSArray *> *modelManifest = [CZDeviceTool modelManifest];
    NSArray *modelInfoArray = modelManifest[internalName];
    if (modelInfoArray.count > 0) {
        CZDeviceInfoModel *model = [[CZDeviceInfoModel alloc] init];
        model.internalName = internalName;  // 设备型号内部名称，如：iPhone8,1
        model.modelName = modelInfoArray[0];    // 设备型号通用名称，如：iPhone 6s
        model.diagonalSize = [modelInfoArray[1] floatValue];    // 屏幕尺寸，即对角线长度，单位英寸
        model.PPI = [modelInfoArray[2] integerValue];   // 屏幕像素密度（Pixel Per Inch）
        return model;
    }
    return nil;
}

@end

@implementation CZDeviceInfoModel

@end
