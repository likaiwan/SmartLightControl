//
//  AppDelegate.m
//  SmartLightControl
//
//  Created by 李凯 on 2019/11/20.
//  Copyright © 2019 李凯. All rights reserved.
//

#import "AppDelegate.h"
#import "config.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/******************************************************
//函数功能：应用程序启动后，要执行的委托调用。
*******************************************************/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //获取屏幕尺寸
    NSLog(@"height:%f",[UIScreen mainScreen].bounds.size.height);   //1024
    NSLog(@"width:%f",[UIScreen mainScreen].bounds.size.width);     //768
    
    return YES;
}


#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application
configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
                              options:(UISceneConnectionOptions *)options{
    
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application
didDiscardSceneSessions:(nonnull NSSet<UISceneSession *> *)sceneSessions{
    
}

///******************************************************
////函数功能：应用程序将要由活动状态切换一非活动状态时执行的委托调用，
////       【按下Home按钮、返回主屏幕、全屏之间切换应用程序】
////输入参数：application->
//*******************************************************/
//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    NSLog(@"点击【Home】按钮");
//}
//
///******************************************************
////函数功能：在应用程序已进入后台程序时，要执行的委托调用。
////       【要设置后台继续运行，在这个函数里面设置】
////输入参数：application->
//*******************************************************/
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    NSLog(@"程序已进入后台");
//}
//
///******************************************************
////函数功能：在应用程序将要进入前台时（被激活），要执行的委托调用。
////输入参数：application->
//*******************************************************/
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    NSLog(@"1程序被激活");
//}
//
///******************************************************
////函数功能：在应用程序已被激活后，要执行的委托调用。
////输入参数：
//*******************************************************/
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    NSLog(@"2程序被激活");
//}
//
///******************************************************
////函数功能：在应用程序要完全退出的时候，要执行的委托调用。
////输入参数：
//*******************************************************/
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    NSLog(@"程序退出");
//}

@end
