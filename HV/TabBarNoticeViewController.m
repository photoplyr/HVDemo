//
//  TabBarNoticeViewController.m
//  Gym
//
//  Created by troy simon on 10/14/14.
//  Copyright (c) 2014 troy simon. All rights reserved.
//

#import "TabBarNoticeViewController.h"
#import "AppDelegate.h"

@interface TabBarNoticeViewController ()
{
    AppDelegate *appDelegate;
}

@end

@implementation TabBarNoticeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor clearColor];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButton:(id)sender
{
}


- (IBAction)closeButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
