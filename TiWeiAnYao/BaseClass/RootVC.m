//
//  RootVC.m
//  TiWeiAnYao
//
//  Created by 田耀琦 on 2017/5/23.
//  Copyright © 2017年 田耀琦. All rights reserved.
//

#import "RootVC.h"

#import "AHomeVC.h"
#import "PersonalCenterVC.h"
#import "APurchaseVC.h"
#import "ACommunityVC.h"


@interface RootVC ()

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    AHomeVC *homeVC = [[AHomeVC alloc] init];
    ACommunityVC *typeVC = [[ACommunityVC alloc] init];
    APurchaseVC *purchaserVC = [[APurchaseVC alloc] init];
    PersonalCenterVC *personVC = [[PersonalCenterVC alloc] init];
    
    [self creatNAVC:homeVC title:@"首页" imageName:@"icon-home-default" selectedImage:@"icon-home-select"];
    [self creatNAVC:typeVC title:@"分类" imageName:@"icon-community-default" selectedImage:@"icon-community-select"];
    [self creatNAVC:purchaserVC title:@"购物车" imageName:@"icon-purchase-default" selectedImage:@"icon-purchase-select"];
    [self creatNAVC:personVC title:@"个人中心" imageName:@"icon-mine-default" selectedImage:@"icon-mine-select"];
    
    [self configNavAndTabBar];
}

#pragma mark - Method
- (void)creatNAVC:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage{
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.title = title;
//    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
//    vc.navigationController.navigationBar.barTintColor = [UIColor redColor];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self addChildViewController:navc];
}

- (void)creatNAVC:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imageName {
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageName] tag:100];
    vc.title = title;
    [self addChildViewController:navc];
}

- (void)configNavAndTabBar {
    // 设置全局的 NavBar  TabBar
    [[UITabBar appearance] setTintColor:Color_Text_Red];
    [[UITabBar appearance] setUnselectedItemTintColor:Color_Text_Black];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTintColor:Color_Text_White];
    [[UINavigationBar appearance] setBarTintColor:Color_Text_Red];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}


@end
