//
//  AppDelegate.m
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/17.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import "AppDelegate.h"
#import "SoundManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    UIColor* colorBoABase = [UIColor colorWithRed:0.0f
                                            green:18.0f/255.0f
                                             blue:24.0f/255.0f
                                            alpha:1.0f];
    // --- UINavigationBarのアピアランス
    [[UINavigationBar appearance] setBarTintColor:colorBoABase];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    
    // --- サウンド設定
    [SoundManager shared];
    
    // --- スリープ有効／無効設定
    [self applySleepConfig];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [self resumeTimerDisabled];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self resumeTimerDisabled];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self applySleepConfig];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self applySleepConfig];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self resumeTimerDisabled];
}

-(void)applySleepConfig {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    if ([ud boolForKey:@"config_DontSleep"]) {
        // --- スリープしない設定
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    } else {
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
}

-(void)resumeTimerDisabled {
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

@end
