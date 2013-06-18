//
//  AppDelegate.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-7-27.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "AppDelegate.h"
#import "UserKeychain.h"
#import "Notice.h"
#import "Employee.h"
#import "SystemConfig.h"
#import "Calendar.h"
#import "Mail.h"
#import "MyFolder.h"
#import "MainViewController.h"
#import "Customer.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize calendarIdentifier;
@synthesize deviceTokenNum;
@synthesize deviceType;
@synthesize calendarMessage;
@synthesize noticeMessage;
@synthesize emailMessage;
@synthesize activeFlag;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[UserKeychain delete:KEY_LOGINID_PASSWORD];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hzoa.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:databasePath] == NO) 
    {
        [Employee createMostContactTable];
        [Employee createEmployeeTable];
        [Notice createNoticeTable];
        //[Calendar createCalendarTable];
        [Mail createEmailTable];
        [MyFolder createMyFolderTable];
        [SystemConfig createNotificationTable];
    }
    BOOL flag = YES;
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    NSArray *listCalendars = [eventStore calendars];
    for (EKCalendar *calendar in listCalendars) {
        NSLog(@"%@", calendar.title);
        if ([calendar.title isEqualToString:KEY_CALENDAR]) {
            flag = NO;
            break;
        }
    }
    if (flag) {
        EKCalendar *calendar = [EKCalendar calendarWithEventStore:eventStore];
        calendar.title = KEY_CALENDAR;
        EKSource *theSource = nil;
        for (EKSource *source in eventStore.sources) {
            if (source.sourceType == EKSourceTypeLocal) {
                theSource = source;
                break;
            }
        }
        if (theSource) {
            calendar.source = theSource;
        } else {
            NSLog(@"Error: Local source not available");
        }
        NSError *error = nil;
        BOOL result = [eventStore saveCalendar:calendar commit:YES error:&error];
        if (result) {
            NSLog(@"Saved calendar to event store.");
        } else {
            NSLog(@"Error saving calendar: %@.", error);
        }
    }
    
    if (launchOptions != nil)
	{
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
            NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
            id alertCalendar = [dictionary objectForKey:@"Calendar"];
            id alertNotice = [dictionary objectForKey:@"Notice"];
            id alertEmail = [dictionary objectForKey:@"Email"];
            if ([alertCalendar isKindOfClass:[NSString class]]) {
                if ([alertCalendar isEqualToString:@"1"]) {
                    calendarMessage = @"1";
                    [usernamepasswordKVPairs setObject:calendarMessage forKey:KEY_NOTIFIY_CALENDAR];
                } else {
                    calendarMessage = @"0";
                }
                
            } else {
                //calendarMessage = @"0";
            }
            if ([alertNotice isKindOfClass:[NSString class]]) {
                if ([alertNotice isEqualToString:@"1"]) {
                    noticeMessage = @"1";
                    [usernamepasswordKVPairs setObject:noticeMessage forKey:KEY_NOTIFIY_NOTICE];
                } else {
                    noticeMessage = @"0";
                }
            } else {
                //noticeMessage = @"0";
            }
            if ([alertEmail isKindOfClass:[NSString class]]) {
                if ([alertEmail isEqualToString:@"1"]) {
                    emailMessage = @"1";
                    [usernamepasswordKVPairs setObject:emailMessage forKey:KEY_NOTIFIY_EMAIL];
                } else {
                    emailMessage = @"0";
                }
            } else {
                //emailMessage = @"0";
            }
		}
	}
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
    
    NSString *model = [[UIDevice currentDevice] model];
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    if (usernamepasswordKVPairs == nil) {
        
    } else {
        Customer *customer = [[Customer alloc] init];
        customer.LoginType = @"0";
        customer.deviceType = model;
        customer.deviceToken = [usernamepasswordKVPairs objectForKey:KEY_DEVICETOKEN];;
        customer.Location = @"";
        customer.EmpID = [usernamepasswordKVPairs objectForKey:KEY_USERID];
        [Customer takeStatus:customer];
        
        
//        NSLog(@"%@",model);
//        NSLog(@"%@",customer.EmpID);
        
    }

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    activeFlag = @"1";
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    
	NSLog(@"My token is: %@", deviceToken);
    NSString *dToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dToken = [dToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"STR == %@",dToken);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)  
    {  
        deviceType = @"1";
    } else {
        deviceType = @"0";
    }
    deviceTokenNum = dToken;
    
    [usernamepasswordKVPairs setObject:deviceTokenNum forKey:KEY_DEVICETOKEN];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    id alertCalendar = [userInfo objectForKey:@"Calendar"];
    id alertNotice = [userInfo objectForKey:@"Notice"];
    id alertEmail = [userInfo objectForKey:@"Email"];
    if ([alertCalendar isKindOfClass:[NSString class]]) {
        if ([alertCalendar isEqualToString:@"1"]) {
            calendarMessage = @"1";
            [usernamepasswordKVPairs setObject:calendarMessage forKey:KEY_NOTIFIY_CALENDAR];
        } else {
            calendarMessage = @"0";
        }
        
    } else {
        //calendarMessage = @"0";
    }
    if ([alertNotice isKindOfClass:[NSString class]]) {
        if ([alertNotice isEqualToString:@"1"]) {
            noticeMessage = @"1";
            [usernamepasswordKVPairs setObject:noticeMessage forKey:KEY_NOTIFIY_NOTICE];
        } else {
            noticeMessage = @"0";
        }
    } else {
        //noticeMessage = @"0";
    }
    if ([alertEmail isKindOfClass:[NSString class]]) {
        if ([alertEmail isEqualToString:@"1"]) {
            emailMessage = @"1";
            [usernamepasswordKVPairs setObject:emailMessage forKey:KEY_NOTIFIY_EMAIL];
        } else {
            emailMessage = @"0";
        }
    } else {
        //emailMessage = @"0";
    }
}

@end
