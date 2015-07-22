//
//  RegisterViewController.h
//  GymAssist
//
//  Created by troy simon on 3/12/15.
//  Copyright (c) 2015 Gym Farm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TabBarViewController.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UIButton *pressButton;

@property (weak, nonatomic) IBOutlet UILabel *welcome;


@end
