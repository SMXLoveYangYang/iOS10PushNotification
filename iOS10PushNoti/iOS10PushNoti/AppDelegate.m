//
//  AppDelegate.m
//  iOS10PushNoti
//
//  Created by lanouhn on 2016/11/7.
//  Copyright © 2016年 SMX. All rights reserved.
//

#import "AppDelegate.h"

#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    ///1.注册本地消息推送
    
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"%d - %@", granted, error);
    }];
    
    //创建本地通知
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"世上谁最帅?";
    content.body = @"哥哥最帅";
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    NSString *imgStr = @"http://b.hiphotos.baidu.com/image/pic/item/8d5494eef01f3a29b41f18fa9c25bc315c607c2b.jpg";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgStr]];
    //把图片保存到沙盒
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *localPath = [path stringByAppendingPathComponent:@"huge.jpg"];
    [data writeToFile:localPath atomically:YES];
    
    //设置通知的附件
    if (localPath && ![localPath isEqualToString:@""]) {
        UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:@"photo" URL:[NSURL URLWithString:[@"file://" stringByAppendingString:localPath]] options:nil error:nil];
        if (attachment) {
            content.attachments = @[attachment];
        }
    }
    
    //设置触发模式
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2   repeats:NO];
    //推送
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"pusswzy" content:content trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@" --- %@", error);
        }
    }];
    
    ///设置代理
    center.delegate = self;
    
    return YES;
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    //展示
    completionHandler(UNNotificationPresentationOptionSound |UNNotificationPresentationOptionAlert);
    //不展示
//    completionHandler(UNNotificationPresentationOptionNone);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
