//
//  TabBarViewController.m
//  Circs
//
//  Created by troy simon on 8/14/14.
//  Copyright (c) 2014 troy simon. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()
{
    PFUser *user;
    AppDelegate *appDelegate;

    BOOL checkedin;
    BOOL inGym;
    PFObject *grid;
    
    NSDate *date;
    
    BOOL busyProcessing;
    NSDate *timerStamp;
    NSString *lastBeacon;
    
    NSMutableDictionary *beacons;
    
    NSString *foundEquipmnt;
    
    long timeInterval;
    NSDate *timeOnEquipment;
 }

@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    //[self checkForNewMessages:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    UIImage *image = [(AppDelegate *)[[UIApplication sharedApplication] delegate] getLogo];
    UIImageView * logoImage =  [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView = logoImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIImage *image = [(AppDelegate *)[[UIApplication sharedApplication] delegate] getLogo];
    UIImageView * logoImage =  [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView = logoImage;
    
    [self.navigationController setNavigationBarHidden:NO];
    
    checkedin = NO;
    
    busyProcessing = NO;
    
    beacons = [[NSMutableDictionary alloc] init];
    
    inGym = NO;
    
    self.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    
    //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showActivity) userInfo:nil repeats:YES];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    timerStamp = [NSDate date];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
