//
//  GridViewController.m
//  Trulee
//
//  Created by troy simon on 4/22/14.
//  Copyright (c) 2014 Trulee LLC. All rights reserved.
//

#import "GridViewController.h"
#import "AppDelegate.h"
#import "TabBarNoticeViewController.h"

@interface GridViewController ()
{
    AppDelegate *appDelegate;
}
@end

@implementation GridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIImage *getimage = [(AppDelegate *)[[UIApplication sharedApplication] delegate] getLogo];
    
    UIImageView * logoImage =  [[UIImageView alloc] initWithImage:getimage];
    
    self.navigationItem.titleView = logoImage;

    [self layoutGrid];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAwards:) name:SHOWAWARD object:nil];
}

-(void)updateAwards:(NSNotification *)notification
{
    [self getCheckins];
    [self showAward:notification];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self getCheckins];
}

-(void) layoutGrid
{
    int daysToAdd = 0;
    int tagger = 100;
    
    float awardsize = (self.view.frame.size.width) / 7.1;
    
    for (int i = 0; i < 5;i++)
    {
        for (int j = 0; j < 7; j++)
        {
            if (daysToAdd > 30)
                return;
            
            UIView *v;
            v = [[UIView alloc] initWithFrame:CGRectMake(j*(awardsize+1), (i*(awardsize+1)), awardsize, awardsize)];
            v.tag = tagger + daysToAdd + 1;
            
            UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bge_checkin_mono"] ];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            iv.frame = CGRectMake(0, 0, awardsize, awardsize);
            [v addSubview: iv];
            
            UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(0, awardsize - 5, awardsize, 10)];
            date.textAlignment = NSTextAlignmentCenter;
            date.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size: 10];
            [v addSubview: date];
            
            [self.food addSubview:v];
            
            date.text = [NSString stringWithFormat:@"%i",daysToAdd + 1];
            daysToAdd++;
        }
    }
}

- (IBAction)logout:(id)sender {
    
}

-(void) showAward:(NSNotification *) notification
{
        TabBarNoticeViewController *v =[self.storyboard instantiateViewControllerWithIdentifier:@"award"];
        v.providesPresentationContextTransitionStyle = YES;
        v.definesPresentationContext = YES;
        v.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:v animated:YES completion:^{
        }];
}

-(void) getCheckins
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"D"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    [comp setDay:1];
    NSDate *todaydate = [gregorian dateFromComponents:comp];
    
    todaydate = [[GymFarmLib sharedManager] dateBeginningOfDay:todaydate];
    NSDate *fromdaydate = [[GymFarmLib sharedManager] dateBeginningOfDay:[NSDate date]];
    
    
    NSUInteger startDayOfYear = [[formatter stringFromDate:todaydate] intValue];
    
    NSUInteger endDayOfYear = [[formatter stringFromDate:fromdaydate] intValue];
    
    PFQuery *query = [PFQuery queryWithClassName:@"DailyCounter"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"checkin" greaterThanOrEqualTo:[NSNumber numberWithInt:1]];
    
    [query whereKey:@"day" greaterThanOrEqualTo:[NSNumber numberWithInteger:startDayOfYear]];
    [query whereKey:@"day" lessThanOrEqualTo:[NSNumber numberWithInteger:endDayOfYear]];
    
    [query includeKey:@"data"];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         int tagger = 100;
         
         if (!error)
         {
             for(PFObject *data in objects)
             {
                 NSDate *currentDate = [data createdAt];
                 
                 NSCalendar* calendar = [NSCalendar currentCalendar];
                 NSDateComponents* components = [calendar components:NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
                 
                 UIView *v =  [self.food viewWithTag:tagger  + [components day]];
                 NSArray *vv = [v subviews];
                 
                 for (int i =0; i < [vv count]; i++)
                 {
                     if([[vv objectAtIndex:i] isKindOfClass:[UIImageView class]])
                     {
                         UIImageView *iv = [vv objectAtIndex:i];
                         iv.image = [UIImage imageNamed:@"bge_checkin"];
                         break;
                     }
                 }
             }
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
