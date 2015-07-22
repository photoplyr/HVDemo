//
//  TabBarNoticeViewController.h
//  Gym
//
//  Created by troy simon on 10/14/14.
//  Copyright (c) 2014 troy simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarNoticeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *badge;
@property (weak, nonatomic) IBOutlet UILabel *message;

@property (weak, nonatomic) IBOutlet UILabel *points;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UIView *blurView;
@end
