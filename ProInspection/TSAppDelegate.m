//
//  TSAppDelegate.m
//  ProInspection
//
//  Created by Aries on 14-7-8.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import "TSAppDelegate.h"

#import "TSLoginViewController.h"
#import "TSHomeViewController.h"


@implementation TSAppDelegate

//发送异常信息
void UncaughtExceptionHandler(NSException *exception)
{
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [[dic objectForKey:@"CFBundleIdentifier"] substringFromIndex:15];
    NSString *appVersion = [dic valueForKey:@"CFBundleVersion"];
    //    NSLog(@"Terminating app due to uncaught exception：%@--%@\n%@\n%@",appName,appVersion,reason,arr);
    
    NSString *error = [NSString stringWithFormat:@"Terminating app due to uncaught exception：%@--%@\n%@\n%@",appName,appVersion,reason,arr];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:error,@"log_msg",@"1",@"log_type", nil];
    
//    [GVHttpTool postWithUrl:Send_Exception_URL params:param withCache:NO success:^(NSDictionary *result) {
//        
//        GVLog(@"发送结果:%@",result);
//    } failure:^(NSError *error) {
//        
//    }];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    TSLoginViewController *loginVC = [[TSLoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginSuccess"])
    {
        self.window.rootViewController = navController;
        
        TSHomeViewController *homeVC = [[TSHomeViewController alloc] init];
//        [navController pushViewController:homeVC animated:YES];
        [loginVC.navigationController pushViewController:homeVC animated:YES];
    }
    else
    {
        self.window.rootViewController = navController;
    }
    
    

    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    [self.window makeKeyAndVisible];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
