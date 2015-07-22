//
//  MYTextField.m
//  Investor
//
//  Created by troy simon on 11/27/12.
//  Copyright (c) 2012 RentJuice. All rights reserved.
//

#import "MYTextField.h"

@implementation MYTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 5 , 0 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 5 , 0 );
}

@end
