//
//  BorderButton.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BorderButton.h"

@implementation BorderButton


+(id) buttonWithColors:(UIColor*) textColor
{
    id bt =  [BorderButton buttonWithType:UIButtonTypeCustom];
    [bt titleLabel].textColor = textColor;
    return bt;
}


- (void)drawRect:(CGRect)rect
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = self.titleLabel.textColor.CGColor; //[UIColor blueColor].CGColor;
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
}

@end
