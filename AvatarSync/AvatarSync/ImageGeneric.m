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

#import "ImageGeneric.h"
#import "PhotoFile.h"
#import "ContactsTableViewController.h"


@interface ImageGeneric ()

@property (nonatomic,retain) NSArray* photofiles;

@end

@implementation ImageGeneric


-(id) initWithContact:(ASPerson *)person andPhotofiles:(NSArray*) photofiles
{
    self = [super initWithContact:person];
    if(self)
    {
        _photofiles = photofiles;
    }
    return self;
}


-(NSString *)titleForHeader
{
    return NSLocalizedString(@"Images",nil);
}

-(NSString *)descriptionForHeader
{
    return NSLocalizedString(@"Select an image from the following",nil);
}

-(NSInteger)numberOfSections
{
    return 1;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return self.photofiles.count;
}

-(void)updateCell:(BigImageCell *__autoreleasing *)cell atIndex:(NSIndexPath *)indexpath
{
    PhotoFile* f = self.photofiles[indexpath.row];
    (*cell).bigImage.image = f.image;
    (*cell).bigLabel.text = f.filename;
}

-(void)clickedIndexAt:(NSIndexPath *)indexpath from:(UIViewController *)controller
{
    [super clickedIndexAt:indexpath from:controller];
    [self showAskAlert:controller];
}

-(void)alertViewClickedButtonAtIndex:(NSInteger)buttonIndex controller:(UIViewController *)controller
{
    if(buttonIndex == 0 && self.lastClickedIndex && self.photofiles.count > self.lastClickedIndex.row)
    {
        PhotoFile* f = self.photofiles[self.lastClickedIndex.row];
        [self.person updateImage:f.image];
        id firstCon = controller.navigationController.viewControllers.firstObject;
        if([firstCon respondsToSelector:@selector(saveAddressbook)])
        {
            [firstCon saveAddressbook];
            [controller.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

@end
