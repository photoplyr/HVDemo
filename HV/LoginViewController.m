//
//  LoginViewController.m
//  GymAssist
//
//  Created by troy simon on 3/12/15.
//  Copyright (c) 2015 Gym Farm LLC. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarViewController.h"

@interface LoginViewController ()
{
    NSUserDefaults *defaults;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView * logoImage =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trulee_square"]];
    self.navigationItem.titleView = logoImage;
    
    UIImage *image = [UIImage imageNamed:@"left_arrow"];
    
    UIBarButtonItem *messagesItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(closeButton:)];
    
    self.navigationItem.leftBarButtonItem = messagesItem;
    
    self.navigationController.navigationBarHidden = NO;
    
    defaults = [NSUserDefaults standardUserDefaults];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.login becomeFirstResponder];
    
    self.login.placeholder = @"Username";
    self.password.placeholder = @"Password";
    self.welcome.text = @"WELCOME";
    [self.pressButton setTitle:@"Continue" forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.message.text =  @"";
    [self signin:nil];
    return  YES;
}

-(IBAction)signin:(id)sender
{
    [PFUser logInWithUsernameInBackground:self.login.text password:self.password.text
                                    block:^(PFUser *user, NSError *error) {
                                        
                                        if (user)
                                        {
                                            GridViewController *v = [self.storyboard instantiateViewControllerWithIdentifier:@"checkin"];
                                            NSMutableArray *controls = [[NSMutableArray alloc] init];
                                            [controls addObject:v];
                                            self.navigationController.navigationBarHidden = YES;
                                            [self.navigationController setViewControllers:controls animated:YES];
                                        }
                                        else
                                        {
                                            // The login failed. Check error to see why.
                                            NSString *errorString = [error userInfo][@"error"];
                                            
                                            NSLog(@"%@",errorString);
                                            self.message.text = errorString;
                                        }
                                    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButton:(id)sender
{
    [self.login resignFirstResponder];
    [self.password resignFirstResponder];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
