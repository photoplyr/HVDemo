//
//  GridViewController.h
//  Trulee
//
//  Created by troy simon on 4/22/14.
//  Copyright (c) 2014 Trulee LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridViewController : UIViewController

@property (nonatomic,weak) IBOutlet UIView *workouts;
@property (nonatomic,weak) IBOutlet UIView *water;
@property (nonatomic,weak) IBOutlet UIView *food;

@property (weak, nonatomic) IBOutlet UILabel *foodHeader;

@end
