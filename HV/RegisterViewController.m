//
//  RegisterViewController.m
//  GymAssist
//
//  Created by troy simon on 3/12/15.
//  Copyright (c) 2015 Gym Farm LLC. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
{
    NSUserDefaults *defaults;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * logoImage =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trulee_square"]];
    self.navigationItem.titleView = logoImage;

    UIImage *image = [UIImage imageNamed:@"left_arrow"];
    
    UIBarButtonItem *messagesItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(closeButton:)];
    
    self.navigationItem.leftBarButtonItem = messagesItem;

    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    
    defaults = [NSUserDefaults standardUserDefaults];

}

-(void) viewWillAppear:(BOOL)animated
{
    [self.username becomeFirstResponder];
        self.email.placeholder = @"Email";
        self.password.placeholder = @"Password";
        self.username.placeholder = @"Username";
        
        self.welcome.text = @"WELCOME";
        [self.pressButton setTitle:@"Continue" forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.message.text =  @"";
    [self signup:nil];
    return  YES;
}

-(IBAction)signup:(id)sender
{
    PFUser *user = [PFUser user];
    user.username = self.username.text;
    user.password = self.password.text;
    user.email = self.email.text;
    
    if ([self.username.text length] < 1)
        return;
    if ([self.password.text length] < 1)
        return;
    if ([self.email.text length] < 1)
        return;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            GridViewController *v = [self.storyboard instantiateViewControllerWithIdentifier:@"checkin"];
            NSMutableArray *controls = [[NSMutableArray alloc] init];
            [controls addObject:v];
            self.navigationController.navigationBarHidden = YES;
            [self.navigationController setViewControllers:controls animated:YES];
        }
        else
        {
            NSString *errorString = [error userInfo][@"error"];
            
            
            NSLog(@"%@",errorString);
            self.message.text = errorString;
        }
    }];
}

- (IBAction)closeButton:(id)sender
{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self.email resignFirstResponder];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
