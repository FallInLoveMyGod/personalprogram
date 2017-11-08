//
//  SystemFunction.h
//  TiWeiAnYao
//
//  Created by 田耀琦 on 2017/5/23.
//  Copyright © 2017年 田耀琦. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sys/utsname.h>
#import "AppDelegate.h"

@interface SystemFunction : NSObject

//  字符串是否为空
+ (BOOL)xfunc_emptyWithString:(NSString *)string;

//  电话号码是否合法
+ (BOOL)xfunc_isValidMobileNumber:(NSString *)mobileNum;

//判断是否有中文
+ (BOOL)xfunc_isChinese:(NSString *)str;

//  获取根代理
+ (AppDelegate *)xfunc_getAppDelegate;

//  获取当前时间
+ (NSString *)xfunc_getStringFromNow:(NSDate *)date;

//  根据小时给出小时的正确格式
+ (NSString *)xfunc_getHourStringFromHour:(int)hour;

//  根据分钟给出分钟的正确格式
+ (NSString *)xfunc_getMiniteStringFromMinite:(int)minite;

//  根据字符串长度自动获取lab宽度或高度
+ (CGSize)xfunc_getStringSizeWith:(NSString *)goalString withStringFont:(CGFloat)font withWidthOrHeight:(CGFloat)fixedSize isWidthFixed:(BOOL)isWidth;

//  是否有网络
+ (BOOL)xfunc_canConnectNet;

//  当前网络是否是wifi
+ (BOOL)xfunc_canConnectWifi;

// 去除字典中的空值 （数据安全处理）
+ (NSDictionary *)deleteEmptyDict:(NSDictionary *)dic;

// 去除数组中的空值 （数据安全处理）
+ (NSArray *)deleteEmptyArr:(NSArray *)arr;

// 生成二维码
- (UIImage *)generateQRCode:(NSString*)code width:(CGFloat)width height:(CGFloat)height;

//生成条形码
- (UIImage *)generateBarCode:(NSString*)code width:(CGFloat)width height:(CGFloat)height;

//提示声
+ (void)playPoint:(NSString*)sound type:(NSString*)type;

//捕捉在线视频第一帧
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

// 获取视频大小
+ (NSInteger)getFileSize:(NSString*) path;

//获取视频的时间
+ (CGFloat)getVideoDuration:(NSURL*) URL;

//获取mac地址
+ (NSString*)getMacaddress;

// 获取当前设备的型号 iPhone5s
+ (NSString*)deviceModelName;

// 强制横屏
+ (void)forceChangeOrientation:(UIInterfaceOrientation)orientation;

@end
