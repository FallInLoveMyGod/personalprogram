//
//  PullRefreshVC.h
//  TiWeiAnYao
//
//  Created by 田耀琦 on 2017/5/23.
//  Copyright © 2017年 田耀琦. All rights reserved.
//

#import "AllVC.h"

@interface PullRefreshVC : AllVC
{
    BOOL isMore;
    BOOL isDrag;
    BOOL isLoading;
    BOOL isForbidMore;
    BOOL isForbidRefresh;
    BOOL isEnd;
}

@property (nonatomic,strong)UITableView *mytable;

- (void)forbidPullRefresh;

@end
