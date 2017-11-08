//
//  UtilsMacros.h
//  TiWeiAnYao
//
//  Created by 田耀琦 on 2017/5/23.
//  Copyright © 2017年 田耀琦. All rights reserved.
//

#ifndef UtilsMacros_h
#define UtilsMacros_h

/*
 *     工具相关宏定义
*/

#endif /* UtilsMacros_h */

#pragma mark - Font 字体大小

#define Text_Font18 [UIFont systemFontOfSize:18]
#define Text_Font16 [UIFont systemFontOfSize:16]
#define Text_Font14 [UIFont systemFontOfSize:14]
#define Text_Font12 [UIFont systemFontOfSize:12]
#define Text_Font10 [UIFont systemFontOfSize:10]

#define Font_Medium_24 [UIFont fontWithName:@".PingFangSC-Medium" size:24]
#define Font_Medium_20 [UIFont fontWithName:@".PingFangSC-Medium" size:20]
#define Font_Medium_18 [UIFont fontWithName:@".PingFangSC-Medium" size:18]
#define Font_Medium_16 [UIFont fontWithName:@".PingFangSC-Medium" size:16]
#define Font_Medium_14 [UIFont fontWithName:@".PingFangSC-Medium" size:14]
#define Font_Medium_12 [UIFont fontWithName:@".PingFangSC-Medium" size:12]
#define Font_Medium_10 [UIFont fontWithName:@".PingFangSC-Medium" size:10]

#pragma mark - Color 颜色

#define RGB_UI_Color(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]         //  RGB 颜色
#define Color_App_Background RGB_UI_Color(60,60,50)
#define Color_Gray RGB_UI_Color(100,100,100)

#define Color_Text_Black [UIColor colorWithHexString:@"#333333" alpha:1]
#define Color_Text_Gray [UIColor colorWithHexString:@"#999999" alpha:1]
#define Color_Text_White [UIColor colorWithHexString:@"#FFFFFF" alpha:1]
#define Color_Text_Price [UIColor colorWithHexString:@"#FE6779" alpha:1]
#define Color_Text_Red [UIColor colorWithHexString:@"#F85979" alpha:1]


#define Color_Gradient1 [UIColor colorWithHexString:@"#5AAAFA" alpha:1]
#define Color_Gradient2 [UIColor colorWithHexString:@"#68B2FC" alpha:1]
#define Color_Gradient3 [UIColor colorWithHexString:@"#86C3FF" alpha:1] //渐变效果1 首页item

#define Color_Line_Gray [UIColor colorWithHexString:@"#DDDDDD" alpha:1]
#define Color_Line_CGray [UIColor colorWithHexString:@"#CCCCCC" alpha:1]

#define Color_Btn [UIColor colorWithHexString:@"#65B2FA" alpha:1]
#define Color_Btn_Gray [UIColor colorWithHexString:@"#F6F6F6" alpha:1]
#define Color_Btn_Red [UIColor colorWithHexString:@"#FE6779" alpha:1]
#define Color_Btn_Switch [UIColor colorWithHexString:@"#E5F2FF" alpha:1]

#define Color_Show_Price [UIColor colorWithHexString:@"#FE6779" alpha:1]
#define Color_Table_Back [UIColor colorWithHexString:@"#F3F9FF" alpha:1]
#define Color_View_Back [UIColor colorWithHexString:@"#F2F2F2" alpha:1]

#pragma mark - Custom Tool 自定义系统工具

#define ADD 0


#ifdef ADD
#define ALog(...) NSLog(__VA_ARGS__)
#else
#define ALog(...) NSLog(...);
#endif
