//
//  CZDeviceTool.h
//  EnjoyiOS
//
//  Created by ug19 on 16/5/23.
//  Copyright © 2016年 Ugood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** info.plist key */
FOUNDATION_EXPORT NSString *const kTCInfoBundleDisplayName;
FOUNDATION_EXPORT NSString *const kTCInfoBundleShortVersionString;
FOUNDATION_EXPORT NSString *const kTCInfoBundleVersion;
FOUNDATION_EXPORT NSString *const kTCInfoCFBundleName;

@interface CZDeviceTool : NSObject

+ (NSDictionary *)infoDictionary;
+ (NSString *)bundleIdentifier;
+ (NSString *)bundleDisplayName;
+ (NSString *)bundleShortVersionString;
+ (NSString *)bundleVersion;
+ (NSString *)bundleName;

/** 获取设备所有者设置的名称，如：Clay's iPhone */
+ (NSString *)deviceName;
+ (NSString *)systemName;
+ (NSString *)systemVersion;
/** 返回当前系统的语言环境（en：英文，zh-Hans：简体中文，zh-Hant：繁体中文，ja：日本） */
+ (NSString *)systemLanguage;

// 判断系统版本
+ (BOOL)iOS;
+ (BOOL)iOS6orLess;
+ (BOOL)iOS7System;
+ (BOOL)iOS8System;
+ (BOOL)iOS9System;
+ (BOOL)iOS10System;

// 判断屏幕尺寸
+ (BOOL)isScreen35;
+ (BOOL)isScreen40;
+ (BOOL)isScreen47;
+ (BOOL)isScreen55;

/** 屏幕宽度 */
+ (CGFloat)screenWidth;
/** 屏幕高度 */
+ (CGFloat)screenHeight;
/** 屏幕长的一边 */
+ (CGFloat)screenMaxLength;
/** 屏幕短的一边 */
+ (CGFloat)screenMinLength;
/** 根据开发所用的点（pt）计算屏幕上的物理像素值（px） */
+ (CGFloat)pxWithPt:(CGFloat)pt;

/** 设备型号，如：iPhone 6 */
+ (NSString *)deviceModel;

@end
