//
//  AppDelegate.m
//  GDemo
//
//  Created by Wingle Wong on 8/13/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "LoginViewController.h"
#import "V2FirstViewController.h"
#import "FocusViewController.h"
#import "DiscoverViewController.h"

#import "CCRGlobalConf.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [_navigationController release];
    [super dealloc];
}

- (void) loginSuccess {
    if (_navigationController) {
        [_navigationController.view removeFromSuperview];
        [_navigationController release];
        _navigationController =nil;
    }
    [self.tabBarController.view removeFromSuperview];
    UINavigationController *viewController1 = [[UINavigationController alloc] initWithRootViewController:[[[V2FirstViewController alloc] initWithNibName:@"V2FirstViewController" bundle:nil] autorelease]];
    viewController1.navigationBar.tintColor = [UIColor colorWithRed:0 green:129.0/255 blue:190.0/255 alpha:1.0];
    
    UINavigationController *viewController2 = [[UINavigationController alloc] initWithRootViewController:[[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil] autorelease]];
    viewController2.navigationBar.tintColor = [UIColor colorWithRed:0 green:129.0/255 blue:190.0/255 alpha:1.0];
    
    UINavigationController *viewController3 = [[UINavigationController alloc] initWithRootViewController:[[[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil] autorelease]];
    viewController3.navigationBar.tintColor = [UIColor colorWithRed:0 green:129.0/255 blue:190.0/255 alpha:1.0];
    
    UINavigationController *viewController4 = [[UINavigationController alloc] initWithRootViewController:[[[FocusViewController alloc] initWithNibName:@"FocusViewController" bundle:nil] autorelease]];
    viewController4.navigationBar.tintColor = [UIColor colorWithRed:0 green:129.0/255 blue:190.0/255 alpha:1.0];
    
    UINavigationController *viewController5 = [[UINavigationController alloc] initWithRootViewController:[[[DiscoverViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease]];
    viewController5.navigationBar.tintColor = [UIColor colorWithRed:0 green:129.0/255 blue:190.0/255 alpha:1.0];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = @[viewController1, viewController2, viewController3, viewController4,viewController5];
    [viewController1 release];
    [viewController2 release];
    [viewController3 release];
    [viewController4 release];
    [viewController5 release];
    
    self.window.rootViewController = self.tabBarController;
    
    //location update--
    [CCRConf startLocationManagerService];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    sleep(2);
    if (CCRConf.isLogin) {
        [self loginSuccess];
    }else {
        UINavigationController *viewController0 = [[UINavigationController alloc] initWithRootViewController:[[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease]];
        viewController0.navigationBar.tintColor = [UIColor colorWithRed:0 green:129.0/255 blue:190.0/255 alpha:1.0];
        self.navigationController = viewController0;
        [viewController0 release];
        [self.window addSubview:self.navigationController.view];
    }
    
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
    [CCRConf startLocationManagerService];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
