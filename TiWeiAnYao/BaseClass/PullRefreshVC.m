//
//  PullRefreshVC.m
//  TiWeiAnYao
//
//  Created by 田耀琦 on 2017/5/23.
//  Copyright © 2017年 田耀琦. All rights reserved.
//

#import "PullRefreshVC.h"

#define REFRESH_HEADER_HEIGHT 52.0f
#define Pix_X App_Width/2.0-40

@interface PullRefreshVC () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong)UIView *refreshHeaderView;

@property (nonatomic,strong)UIView *footerView;

@property (nonatomic,strong)UIView *noDataView;

@end

@implementation PullRefreshVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UI
- (UITableView *)mytable {
    if (!_mytable) {
        _mytable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Width, App_Height - 64 - 49) style:UITableViewStyleGrouped];
        _mytable.delegate = self;
        _mytable.dataSource = self;
        _mytable.showsVerticalScrollIndicator = NO;
        _mytable.emptyDataSetSource = self;
        _mytable.emptyDataSetDelegate = self;
        [_mytable addSubview:self.refreshHeaderView];
    }
    return _mytable;
}

- (UIView *)refreshHeaderView {
    if (!_refreshHeaderView) {
        _refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, -REFRESH_HEADER_HEIGHT, App_Width, REFRESH_HEADER_HEIGHT)];
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        UILabel *refreshLab = [[UILabel alloc] initWithFrame:CGRectMake(App_Width/2.0 - 10, 10, App_Width/2.0, REFRESH_HEADER_HEIGHT-20)];
        refreshLab.backgroundColor = [UIColor clearColor];
        refreshLab.textAlignment = NSTextAlignmentLeft;
        refreshLab.font = [UIFont systemFontOfSize:12];
        refreshLab.text = @"下拉刷新";
        
        UIImageView *headerRefreshImageV = [[UIImageView alloc] initWithFrame:CGRectMake(Pix_X, floorf((REFRESH_HEADER_HEIGHT-36)/2), 19.5, 36)];
        headerRefreshImageV.image = [UIImage imageNamed:@""];
        
        UIActivityIndicatorView *refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        refreshSpinner.frame = CGRectMake(Pix_X, floorf((REFRESH_HEADER_HEIGHT-36)/2), 20, 20);
        refreshSpinner.hidesWhenStopped = YES;
        
        [_refreshHeaderView addSubview:refreshLab];
        [_refreshHeaderView addSubview:headerRefreshImageV];
        [_refreshHeaderView addSubview:refreshSpinner];
    }
    return _refreshHeaderView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - DZNEmptyDataSetSource ,DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon-empty-page"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"狮子王";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"你好，我的名字叫辛巴，大草原是我的家！";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        if(scrollView.contentOffset.y > 0)
            self.mytable.contentInset = UIEdgeInsetsZero;
        else if(scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.mytable.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else {
        if (isForbidRefresh) {
            return;
        }
        if (isDrag && self.mytable.contentOffset.y < 0 ) {
            
        }
        else {
            
        }
    }
}

#pragma mark - Method
#pragma mark- 上拉加载更多
-(void)startAddMore
{
    [_footerView setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        self.mytable.contentInset = UIEdgeInsetsMake(0, 0, _footerView.frame.size.height, 0);
        _footerView.frame=CGRectOffset(_footerView.frame, 0, -_footerView.frame.size.height);
//        [_addmoreSpinner startAnimating];
//        [_addmoreLab setTextAlignment:NSTextAlignmentLeft];
//        _addmoreLab.text = @"正在加载";
    }];
    [self addMore];
}
-(void)addMore
{
    //开始请求加载更多数据，子类重写
}

@end
