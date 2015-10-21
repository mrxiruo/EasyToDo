//
//  BaseNavigationController.m
//  EasyToDo
//
//  Created by XiRuo on 15/10/21.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    WEAKSELF
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //interactivePopGestureRecognizer默認爲YES;
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    
    self.navigationBar.backgroundColor = [AppSkin baseBackgroundColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:[AppSkin baseBackgroundColor]];
    [self.navigationBar setTranslucent:NO];
    
    //240 236 212
    UIColor * color = [AppSkin baseTextColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = dict;
    
    [[UINavigationBar appearance] setTintColor:[AppSkin baseTextColor]];
}


//pushViewController時禁用手勢，避免crash
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

//showViewController後重新激活滑動手勢，使可以滑動返回
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    //如果是在一級頁面嘗試滑動返回，delegate置爲nil
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
