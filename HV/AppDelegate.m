//
//  AppDelegate.m
//  HV
//
//  Created by troy simon on 5/26/15.
//  Copyright (c) 2015 Gym Farm LLC. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    AppDelegate *appDelegate;
    NSString *currentDevice;
    BOOL processing;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [Parse setApplicationId:parseApiKey clientKey:parseClientKey];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [[GymFarmLib sharedManager]  getDailyCounter];
    
    if (application.applicationIconBadgeNumber != 0)
    {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveInBackground];
    }
    
    
#ifdef __IPHONE_8_0
    UIUserNotificationSettings *settings =  [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#else
    //register to receive notifications
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    // Gym Farm
    [[GymFarmLib sharedManager] setApplicationGoogleID:@"UA-57470224-1"];
    [[GymFarmLib sharedManager] setApplicationID:@"123-123-123-13123-12313-12312-125"];
    [[GymFarmLib sharedManager] setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkInGym:) name:GYMFARM_NOTIF_REGION_ENTERED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rangeInGym:) name:GYMFARM_NOTIF_BEACON_RANGE_UPDATE object:nil];

     return YES;
}

- (NSDate *)dateBeginningOfDay:(NSDate *) date
{
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:date];
    
    [parts setHour:0];
    [parts setMinute:0];
    [parts setSecond:0];
    
    return [[NSCalendar currentCalendar] dateFromComponents:parts];
}


-(void)rangeInGym:(NSNotification *)notification
{
    if (processing)
        return;
  
    NSDictionary *beaconDict = (NSDictionary *)[notification userInfo];
    NSString *skey = [[beaconDict allKeys] objectAtIndex:0];
    beaconDict = [beaconDict objectForKey:skey];

    
    NSArray *searchFor = (NSArray *)[beaconDict objectForKey:@"beacon_tags"];
    
    NSString *foundEquipmnt = [[[GymFarmLib sharedManager]  stripDownArray:searchFor] uppercaseString];

    if (! [currentDevice isEqualToString:foundEquipmnt])
    {
        if (![[beaconDict objectForKey:@"beacon_proximity"] isEqualToString:@"unknown"])
            currentDevice = foundEquipmnt;
        
        [self checkInGym:notification];
    }
}


-(void)checkInGym:(NSNotification *)notification
{
    if ([PFUser currentUser] == nil)
        return;
    
    if (processing)
        return;
    
    NSDictionary *beaconDict = (NSDictionary *)[notification userInfo];
    NSString *skey = [[beaconDict allKeys] objectAtIndex:0];
    beaconDict = [beaconDict objectForKey:skey];
    
    if (![[GymFarmLib sharedManager]  isCheckedForToday:@"checkin"])
    {
        
        NSArray *searchFor = (NSArray *)[beaconDict objectForKey:@"beacon_tags"];
        
        NSString *foundEquipmnt = [[[GymFarmLib sharedManager]  stripDownArray:searchFor] uppercaseString];
        
        
        if (! [currentDevice isEqualToString:foundEquipmnt])
        {
            if (![[beaconDict objectForKey:@"beacon_proximity"] isEqualToString:@"unknown"])
                currentDevice = foundEquipmnt;
        }
        
        
        NSString *notificationMessage = [NSString stringWithFormat:@"Welcome back %@ to %@ %@",[PFUser currentUser].username, [beaconDict objectForKey:@"beacon_name"], [beaconDict objectForKey:@"location"]];
        
        UILocalNotification* localNotification = [[UILocalNotification
                                                   
                                                   alloc] init];
        localNotification.alertBody = notificationMessage;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        
        [[GymFarmLib sharedManager]  updateDailyCounter:@"checkin"];
        NSLog(@"Checking in to Humana Vitality!");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOWAWARD object:nil userInfo:nil];
        
        NSDictionary *dimensions = @{
                                     // Define ranges to bucket data points into meaningful segments
                                     @"user": [PFUser currentUser].username,
                                     // Did the user filter the query?
                                     @"beaconID":[beaconDict objectForKey:@"beacon_id"],
                                     @"beaconName":[beaconDict objectForKey:@"beacon_name"],
                                     @"beaconLocation":[beaconDict objectForKey:@"location"],
                                     
                                    };
        // Send the dimensions to Parse along with the 'search' event
        [PFAnalytics trackEvent:@"BeaconCheckin" dimensions:dimensions];
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    
    [self registeriBeacons:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DATECHANGE object:nil userInfo:nil];
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions for remote calls
}

#endif


//Adding the following methods for remote notification handling
-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    // When users indicate they are Giants fans, we subscribe them to that channel.
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [[NSNotificationCenter defaultCenter] postNotificationName:REMOTENOTIFICATION object:nil userInfo:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GYMFARM_NOTIF_BEACON_RANGE_UPDATE object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rangeInGym:) name:GYMFARM_NOTIF_BEACON_RANGE_UPDATE object:nil];
}


-(void) registeriBeacons:(UIApplication *)application
{
    [[GymFarmLib sharedManager] obtainBeacons];
}


-(UIImage *) getLogo
{
    return  [UIImage imageNamed:@"trulee_square"];
}

-(void) beaconRanger :(NSNotification *)notification
{
    NSDictionary *beaconDict = (NSDictionary *)[notification userInfo];
    NSString *skey = [[beaconDict allKeys] objectAtIndex:0];
    beaconDict = [beaconDict objectForKey:skey];
    
    [self updateEquipmentList:notification];
}


-(void) updateEquipmentList:(NSNotification *)notification
{
    NSDictionary *beaconDict = (NSDictionary *)[notification userInfo];
    NSString *skey = [[beaconDict allKeys] objectAtIndex:0];
    beaconDict = [beaconDict objectForKey:skey];
    
    // checkin
    if (![[GymFarmLib sharedManager]  isCheckedForToday:@"checkin"])
    {
        [[GymFarmLib sharedManager] sendToGA:[beaconDict objectForKey:@"uuid"] withAction:@"Check-In" withLabel:[[beaconDict objectForKey:@"name"] capitalizedString] withValue:nil];
    }
    
    NSArray *searchFor = (NSArray *)[beaconDict objectForKey:@"beacon_tags"];
    
    NSString *foundEquipmnt = [[[GymFarmLib sharedManager]  stripDownArray:searchFor] uppercaseString];
    
    
    if (! [currentDevice isEqualToString:foundEquipmnt])
    {
        if (![[beaconDict objectForKey:@"beacon_proximity"] isEqualToString:@"unknown"])
            currentDevice = foundEquipmnt;
    }
}

@end
