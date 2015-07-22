//
//  AppDelegate.h
//  HV
//
//  Created by troy simon on 5/26/15.
//  Copyright (c) 2015 Gym Farm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <AVFoundation/AVFoundation.h>

#import "GridViewController.h"

#import "GymFarmLib.h"
#import "MYTextField.h"

#define parseApiKey          @"qJWprALmNVrxKK2nTcjhdLcoJPx6L94Vw4kBzups"
#define parseClientKey       @"Bl2Bmk26agH7thTBajE3ZLhwdqPAS6mVG2Wz0zgF"

#define UPDATEAWARD @"updateaward"
#define SHOWAWARD @"showaward"
#define SHOWCOUPON @"showcoupon"
#define HIDEKEYBOARD @"hidekeyboard"
#define CHANNELREADY @"channelReady"
#define STEPCOUNTER @"stepcounter"
#define DATECHANGE @"datechange"
#define BEACONTIMEUPDATE @"beacontimeupdate"

#define MOTIONCOUNTER @"motioncounter"
#define REMOTENOTIFICATION @"#ReceiveRemoteNotification"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UINavigationController *parentNavigationController;


-(UIImage *) getLogo;
//-(BOOL) isCheckedForToday:(NSString *) stype;
//-(void) updateDailyCounter:(NSString *) stype;
//-(BOOL)tags:(NSArray *)a contain:(NSString *)s;
//-(NSString *) stripDownArray:(NSArray *) a;
//- (NSDate *)dateBeginningOfDay:(NSDate *) date;
@end

