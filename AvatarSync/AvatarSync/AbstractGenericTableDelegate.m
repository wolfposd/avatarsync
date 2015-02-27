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

#import "AbstractGenericTableDelegate.h"

@implementation AbstractGenericTableDelegate


-(id) initWithContact:(ASPerson*) person
{
    self = [super init];
    if(self)
    {
        _person = person;
    }
    return self;
}

-(NSString*) navTitle
{
    return nil;
}

-(NSString*) titleForHeader
{
    return nil;
}

-(NSString*) descriptionForHeader
{
    return nil;
}

-(NSInteger) numberOfRowsInSection:(NSInteger) section
{
    return 0;
}

-(NSInteger) numberOfSections
{
    return 0;
}

-(void) updateCell:(BigImageCell**) cell atIndex:(NSIndexPath*) indexpath
{
    
}

-(void) clickedIndexAt:(NSIndexPath*) indexpath from:(UIViewController*) controller
{
    self.lastClickedIndex = indexpath;
}

-(void) showAskAlert:(UIViewController*) controller
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Apply Image",nil) message:NSLocalizedString(@"Are you sure you want to apply this image to user?",nil) delegate:controller cancelButtonTitle:NSLocalizedString(@"Yes",nil) otherButtonTitles:NSLocalizedString(@"No",nil), nil];
    [alert show];
}

-(NSString*) titleForSection:(NSInteger) section
{
    return nil;
}

@end
