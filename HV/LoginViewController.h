//
//  LoginViewController.h
//  GymAssist
//
//  Created by troy simon on 3/12/15.
//  Copyright (c) 2015 Gym Farm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MYTextField *login;
@property (weak, nonatomic) IBOutlet MYTextField *password;
@property (weak, nonatomic) IBOutlet UILabel *welcome;
@property (weak, nonatomic) IBOutlet UIButton *pressButton;

@property (weak, nonatomic) IBOutlet UILabel *message;
@end
