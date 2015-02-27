//
//  SelectionCell.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 03.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "SelectionCell.h"

@implementation SelectionCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self.selectionSwitch.selected = selected;
}



- (NSString *) reuseIdentifier
{
    return @"BigImageCell";
}

- (IBAction)selectionValueChanged:(id)sender
{
    if(self.selectiondelegate)
    {
        [self.selectiondelegate selectionStateChanged:self.selectionSwitch.on forIndex:self.currentIndex];
    }
}


@end
