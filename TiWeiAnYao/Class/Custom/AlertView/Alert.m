//
//  Alert.m
//  TiWeiAnYao
//
//  Created by 田耀琦 on 2017/11/8.
//  Copyright © 2017年 田耀琦. All rights reserved.
//

#import "Alert.h"

@implementation Alert

- (instancetype)init {
    self = [super init];
    if (self) {
        //点击半透明背景使界面自动消失
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        //设置类型
        self.type = MMPopupTypeCustom;
        
        //设置尺寸,self只需设置宽高,会根据类型来确定在屏幕中的位置
        //请使用Masonry相关方法来设置宽高，否则会有问题
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(200);
        }];
        self.backgroundColor = [UIColor whiteColor];
        //使用[self addSubview:subview];来添加其他控件
    }
    return self;
}

@end
