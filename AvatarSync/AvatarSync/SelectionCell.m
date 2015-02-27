//
// AvatarSync
// Copyright (C) 2014-2015  Wolf Posdorfer
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
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
