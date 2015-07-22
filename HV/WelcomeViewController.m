//
//  WelcomeViewController.m
//  GymAssist
//
//  Created by troy simon on 2/20/15.
//  Copyright (c) 2015 Gym Farm LLC. All rights reserved.
//

#import "WelcomeViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface WelcomeViewController ()
{
    MPMoviePlayerController *moviePlayerController;
    CABasicAnimation *rotation0;
    CABasicAnimation *rotation1;
    CABasicAnimation *rotation2;
    CABasicAnimation *rotation3;
    
    AVAudioPlayer *backgroundMusicPlayer;
    
    NSUserDefaults *defaults;
}
@end

@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView * logoImage =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trulee_square"]];
    self.navigationItem.titleView = logoImage;
    
    //[self startRotation];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
}

-(void) startRotation
{
    rotation0 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation0.fromValue = [NSNumber numberWithFloat:0];
    rotation0.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation0.speed =  .002; // Speed
    rotation0.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [self.zeroRing.layer addAnimation:rotation0 forKey:@"Spin"];
    
    rotation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation1.fromValue = [NSNumber numberWithFloat:0];
    rotation1.toValue = [NSNumber numberWithFloat:-(2*M_PI)];
    rotation1.speed =  .002; // Speed
    rotation1.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [self.oneRing.layer addAnimation:rotation1 forKey:@"Spin"];
    
    rotation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation2.fromValue = [NSNumber numberWithFloat:0];
    rotation2.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation2.speed =  .002; // Speed
    rotation2.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [self.twoRing.layer addAnimation:rotation2 forKey:@"Spin"];
    
    rotation3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation3.fromValue = [NSNumber numberWithFloat:0];
    rotation3.toValue = [NSNumber numberWithFloat:-(2*M_PI)];
    rotation3.speed =  .002; // Speed
    rotation3.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [self.threeRing.layer addAnimation:rotation3 forKey:@"Spin"];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    [self.topmenu setContentSize:CGSizeMake(320*4, 30)];
    
    if ([PFUser currentUser])
    {
        GridViewController *v = [self.storyboard instantiateViewControllerWithIdentifier:@"checkin"];
        NSMutableArray *controls = [[NSMutableArray alloc] init];
        [controls addObject:v];
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController setViewControllers:controls animated:YES];
        
    }
    else
    {
        self.signupButton.hidden = NO;
        self.loginButton.hidden = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int xOffset = floor(scrollView.contentOffset.x) / 320;
    NSString *language;
    
    if (xOffset == 1)
    {
        language = @"english";
        [self.loginButton setTitle:@"Log in" forState:UIControlStateNormal];
         [self.signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        [defaults setObject:language forKey:@"language"];
    }
    else if (xOffset == 2)
    {
        language = @"spanish";
        [self.loginButton setTitle:@"Iniciar Sesión" forState:UIControlStateNormal];
        [self.signupButton setTitle:@"Contratar" forState:UIControlStateNormal];
        [defaults setObject:language forKey:@"language"];
    }
    
    else if (xOffset == 3)
    {
        language = @"german";
        [self.loginButton setTitle:@"Melden Sie sich an" forState:UIControlStateNormal];
        [self.signupButton setTitle:@"Einloggen" forState:UIControlStateNormal];
        [defaults setObject:language forKey:@"language"];
    }
       [defaults synchronize];
    
    // Play welcome
    NSString *newSound = [NSString stringWithFormat:@"%@_%@_%@",@"male",language,@"welcome"];
    
    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:newSound ofType:@"m4a"];
    
    if (backgroundMusicPath == nil)
    {
        [backgroundMusicPlayer stop];
        
        NSLog(@"missing audio file: %@",newSound);
        return;
    }
    
    [backgroundMusicPlayer stop];
    
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
    
    [backgroundMusicPlayer play];
    
    NSLog(@"%i",xOffset);
}


-(void) signin
{
    [PFUser logInWithUsernameInBackground:@"Gym Farmer" password:@"12345678"
                                    block:^(PFUser *user, NSError *error) {
                                        
                                        if (user) {
                                            [self performSegueWithIdentifier:@"main" sender:nil];
                                            // Do stuff after successful login.
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSString *errorString = [error userInfo][@"error"];
                                            NSLog(@"%@",errorString);
                                            self.message.text = @"The Internet connection appears to be offline.";
                                        }
                                    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
