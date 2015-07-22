//
//  WelcomeViewController.h
//  GymAssist
//
//  Created by troy simon on 2/20/15.
//  Copyright (c) 2015 Gym Farm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface WelcomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *message;

@property (nonatomic,weak) IBOutlet UIImageView *zeroRing;
@property (nonatomic,weak) IBOutlet UIImageView *oneRing;
@property (nonatomic,weak) IBOutlet UIImageView *twoRing;
@property (nonatomic,weak) IBOutlet UIImageView *threeRing;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIScrollView *topmenu;

@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@end
