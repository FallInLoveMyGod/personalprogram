//
//  SystemFunction.m
//  TiWeiAnYao
//
//  Created by 田耀琦 on 2017/5/23.
//  Copyright © 2017年 田耀琦. All rights reserved.
//

#import "SystemFunction.h"

#import <AVFoundation/AVFoundation.h>

#import <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation SystemFunction

// 获取视图根代理
+ (AppDelegate *)xfunc_getAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - 字符串 相关处理
//  字符串是否为空
+ (BOOL)xfunc_emptyWithString:(NSString *)string {
    if ([string isEqualToString:@""] || string.length == 0 || string == nil) {
        return NO;
    }
    return YES;
}

//  电话号码是否合法
+ (BOOL)xfunc_isValidMobileNumber:(NSString *)mobileNum {
    if (mobileNum.length != 11) {
        return NO;
    }
    else {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobileNum];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobileNum];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobileNum];
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }
        return NO;
    }
}

//判断是否有中文
+ (BOOL)xfunc_isChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}


#pragma mark - 根据给定日期 获取 年 月 日
+ (NSString *)xfunc_getStringFromNow:(NSDate *)date {
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:now];
    return dateStr;
}

+ (NSString *)xfunc_getHourStringFromHour:(int)hour {
    NSString *hourStr;
    if (hour < 10) {
        hourStr = [NSString stringWithFormat:@"0%d",hour];
    }
    else {
        hourStr = [NSString stringWithFormat:@"%d",hour];
    }
    return hourStr;
}

+ (NSString *)xfunc_getMiniteStringFromMinite:(int)minite {
    NSString *miniteStr;
    if (minite < 10) {
        miniteStr = [NSString stringWithFormat:@"0%d",minite];
    }
    else {
        miniteStr = [NSString stringWithFormat:@"%d",minite];
    }
    return miniteStr;
}

#pragma mark - 根据一定高度/宽度返回宽度/高度
/**
 *  @brief  根据一定高度/宽度返回宽度/高度
 *  @category
 *  @param  goalString            目标字符串
 *  @param  font                 字号
 *  @param  fixedSize            固定的宽/高
 *  @param  isWidth              是否是宽固定(用于区别宽/高)
 **/
// 根据文字（宽度/高度一定,字号一定的情况下）  算出高度/宽度
+ (CGSize)xfunc_getStringSizeWith:(NSString *)goalString withStringFont:(CGFloat)font withWidthOrHeight:(CGFloat)fixedSize isWidthFixed:(BOOL)isWidth{
    
    CGSize sizeC ;
    
    if (isWidth) {
        sizeC = CGSizeMake(fixedSize ,MAXFLOAT);
    }else{
        sizeC = CGSizeMake(MAXFLOAT ,fixedSize);
    }
    
    CGSize sizeFileName = [goalString boundingRectWithSize:sizeC options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return sizeFileName;
}

#pragma mark - 二维码 条形码生成
// 生成二维码
- (UIImage *)generateQRCode:(NSString*)code width:(CGFloat)width height:(CGFloat)height
{
    CIImage *qrcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    //消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width;
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    return [UIImage imageWithCIImage:transformedImage];
}

//生成条形码
- (UIImage *)generateBarCode:(NSString*)code width:(CGFloat)width height:(CGFloat)height
{
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    //消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width;
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

#pragma mark - 视频 声频 相关
//提示声
+ (void)playPoint:(NSString*)sound type:(NSString*)type
{
    AVAudioPlayer *avAudioPlayer;
    NSString *string = [[NSBundle mainBundle] pathForResource:sound ofType:type];
    
    NSURL *url = [NSURL fileURLWithPath:string];
    avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    avAudioPlayer.numberOfLoops = 0;
    [avAudioPlayer play];
    sleep(2);
}


//捕捉在线视频第一帧
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ?[[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
}
//获取视频的大小
+ (NSInteger)getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue]/1024;
        else
            return -1;
    }
    else
    {
        return -1;
    }
}

//获取视频的时间
+ (CGFloat)getVideoDuration:(NSURL*) URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}


#pragma mark - 网络状态
// 网络状态
+ (BOOL)xfunc_canConnectNet {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:  // 无网络
            return NO;
            break;
        case ReachableViaWiFi:  // wifi
            return YES;
            break;
        case ReachableViaWWAN:  // wwlan网络
            return YES;
            
        default:
            break;
    }
    return NO;
}

+ (BOOL)xfunc_canConnectWifi {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:  // 无网络
            return NO;
            break;
        case ReachableViaWiFi:  // wifi
            return YES;
            break;
        case ReachableViaWWAN:  // wwlan网络
            return NO;
            
        default:
            break;
    }
    return NO;
}

#pragma mark - Array Dictionary 空值安全处理 <请求数据处理>
+ (NSDictionary *)deleteEmptyDict:(NSDictionary *)dic {
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicSet = [NSMutableDictionary dictionary];
    NSMutableDictionary *arrSet = [NSMutableDictionary dictionary];
    
    for (id obj in mDic.allKeys) {
        id value = mDic[obj];
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *changeDic = [self deleteEmptyDict:value];
            [dicSet setObject:changeDic forKey:obj];
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            NSArray *changeArr = [self deleteEmptyArr:value];
            [arrSet setObject:changeArr forKey:obj];
        }
        else {
            if ([value isKindOfClass:[NSNull class]]) {
                [mArr addObject:value];
            }
        }
        
    }
    
    for (id obj in mArr) {
        mDic[obj] = @"";
    }
    
    for (id obj in dicSet.allKeys) {
        mDic[obj] = dicSet[obj];
    }
    
    for (id obj in arrSet.allKeys) {
        mDic[obj] = arrSet[obj];
    }
    
    return mDic;
}

+ (NSArray *)deleteEmptyArr:(NSArray *)arr {
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:arr];
    NSMutableArray *set = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicSet = [NSMutableDictionary dictionary];
    NSMutableDictionary *arrSet = [NSMutableDictionary dictionary];
    
    for (id obj in mArr) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *changeDic = [self deleteEmptyDict:obj];
            NSInteger index = [mArr indexOfObject:obj];
            [dicSet setObject:changeDic forKey:@(index)];
        }
        else if([obj isKindOfClass:[NSArray class]]) {
            NSArray *changeArr = [self deleteEmptyArr:obj];
            NSInteger index = [mArr indexOfObject:obj];
            [arrSet setObject:changeArr forKey:@(index)];
        }
        else {
            if ([obj isKindOfClass:[NSNull class]]) {
                NSInteger index = [mArr indexOfObject:obj];
                [set addObject:@(index)];
            }
        }
    }
    
    for (id obj in set) {
        mArr[(int)obj] = @"";
    }
    
    for (id obj in dicSet.allKeys) {
        int index = [obj intValue];
        mArr[index] = dicSet[obj];
    }
    
    for (id obj in arrSet.allKeys) {
        int index = [obj intValue];
        mArr[index] = arrSet[obj];
    }
    
    return mArr;
}

//获取mac地址
+ (NSString*)getMacaddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0 ] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0)
        return NULL;
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
        return NULL;
    if ((buf = malloc(len)) == NULL)
        return NULL;
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
        return NULL;
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

// 获取手机型号
+ (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceModel;
}

// 强制横屏
+ (void)forceChangeOrientation:(UIInterfaceOrientation)orientation
{
    int val = orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
@end
