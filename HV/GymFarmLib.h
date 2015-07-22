//
//  GymFarmLib.h
//  GymFarmLib
//
//  Created by troy simon on 11/18/14.
//  Copyright (c) 2014 Gym Farm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

#define GYMFARM_NOTIF_REGION_ENTERED @"GYMFARM_NOTIF_REGION_ENTERED"
#define GYMFARM_NOTIF_REGION_EXITED @"GYMFARM_NOTIF_REGION_EXITED"
#define GYMFARM_NOTIF_BEACON_RANGE_UPDATE @"GYMFARM_NOTIF_BEACON_RANGE_UPDATE"

#define GYMFARM_NOTIF_EQUIOMENT_UPDATE @"GYMFARM_NOTIF_EQUIOMENT_UPDATE"

#define  GYMFARM_NOTIFICATION_CHEKCIN_UPDATE @"GYMFARM_NOTIFICATION_CHEKCIN_UPDATE"
#define  GYMFARM_NOTIFICATION_CHEKCOUT_UPDATE @"GYMFARM_NOTIFICATION_CHEKCOUT_UPDATE"

#define GYMFARM_BEACON_RANGE_KEY_BEACON_ID @"beacon_id"
#define GYMFARM_BEACON_RANGE_KEY_BEACON_NAME @"beacon_name"
#define GYMFARM_BEACON_RANGE_KEY_BEACON_TAGS @"beacon_tags"
#define GYMFARM_BEACON_RANGE_KEY_PROXIMITY_VALUE @"beacon_procimity_value"
#define GYMFARM_BEACON_RANGE_KEY_PROXIMITY_STRING @"beacon_proximity"

#define BEACONTIMEUPDATE @"beacontimeupdate"

#define SHOWAWARD @"showaward"

@interface GymFarmLib : NSObject <CLLocationManagerDelegate>

/******* Set your tracking ID here *******/

@property (nonatomic, strong) NSString *applicationGoogleID;

@property (nonatomic, strong) NSString *applicationID;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSMutableDictionary *supportedProximityUUIDs;
@property (nonatomic) NSMutableDictionary *beaconAnalytics;

@property (nonatomic,strong) id delegate;

@property (nonatomic, strong) NSMutableDictionary *allBeacons;
@property (nonatomic, strong) NSMutableDictionary *activityBeacons;

@property (nonatomic) BOOL processingBeacon;

@property (nonatomic) NSString *deviceUuid;

@property (nonatomic, strong) NSString *gymName;

@property (nonatomic, strong) NSString *deviceUUID;

@property (nonatomic, strong) PFObject *user;

@property (nonatomic) int timer;
@property CLProximity lastProximity;

@property (nonatomic, strong) PFObject *dailyCounterObject;


-(void)sendLocalNotificationWithMessage:(NSString*)message;
-(void) obtainBeacons;
-(void) playSound;
-(void) sendToGA:(NSString *) sBeacon withAction:(NSString *) sAction withLabel:(NSString *) slabel withValue:(NSNumber *) snumber;
-(NSDate *) stringToDate: (NSString *) dateString;
-(void) manageBeacons;
+ (instancetype)sharedManager;

-(NSString *) stripDownArray:(NSArray *) a;
-(BOOL)tags:(NSArray *)a contain:(NSString *)s;
-(UIColor *)colorFromHexString:(NSString *)hexString;
- (NSDate *)dateBeginningOfDay:(NSDate *) date;

-(BOOL) isCheckedForToday:(NSString *) stype;
-(void) updateDailyCounter:(NSString *) stype;
-(void) getDailyCounter;

@end
