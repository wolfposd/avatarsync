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

#import "FacebookMessengerTableFeed.h"
#import "FacebookMessenger.h"
#import "ContactsTableViewController.h"


@interface FacebookMessengerTableFeed ()

@property (nonatomic, retain) UIImage* imageForPerson;
@property (nonatomic,weak) id<GenericTableOwner> ownerDelegate;

@property (nonatomic) BOOL isStillLoading;
@property (nonatomic) BOOL pictureFound;


@property (nonatomic) BOOL isFacebookApp;

@end

@implementation FacebookMessengerTableFeed


-(NSString *)navTitle
{
    return @"Facebook Messenger";
}


-(NSString *)titleForHeader
{
    return [self navTitle];
}

-(NSString *)descriptionForHeader
{
    if(self.isStillLoading)
    {
        return NSLocalizedString(@"Currently loading picture",nil);
    }
    else if(!self.isStillLoading && self.pictureFound)
    {
        return NSLocalizedString(@"Picture from Facebook Graph",nil);
    }
    else
    {
        return NSLocalizedString(@"No picture found :-(",nil);
    }
}


-(id) initWithContact:(ASPerson *)person isFacebookApp:(BOOL) isFacebook
{
    self = [super initWithContact:person];
    if(self)
    {
        _isFacebookApp = isFacebook;
        _isStillLoading = YES;
        _pictureFound = NO;
        _imageForPerson = nil;
        [self loadInBackground];
    }
    return self;
}


-(id)initWithContact:(ASPerson *)person
{
    return [self initWithContact:person isFacebookApp:YES];
}

-(void) loadInBackground
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^()
    {
        NSString* user = nil;
        
        if(self.isFacebookApp)
        {
            user = [FacebookMessenger fbIdforUserApp:self.person];
        }
        else
        {
            user = [FacebookMessenger fbIdforUserMessenger:self.person];
        }

        NSString* imagePath = [FacebookMessenger downloadImageForUserId:user];
        self.isStillLoading = NO;
        dispatch_async(dispatch_get_main_queue(), ^(){
            if(imagePath)
            {
                self.pictureFound = YES;
                self.imageForPerson = [UIImage imageWithContentsOfFile:imagePath];
            }
            [self.ownerDelegate reloadTableData];
        });
        
        
    });
    
}

-(void) setOwner:(id<GenericTableOwner>) owner
{
    self.ownerDelegate = owner;
}


-(NSInteger) numberOfRowsInSection:(NSInteger) section
{
    return  self.imageForPerson ? 1 : 0;
}

-(NSInteger) numberOfSections
{
    return 1;
}


-(void) updateCell:(BigImageCell**) cell atIndex:(NSIndexPath*) indexpath
{
    (*cell).bigImage.image = self.imageForPerson;
    (*cell).bigLabel.text = [NSString stringWithFormat:@"%@ %@", self.person.firstName, self.person.lastName];
}


-(void)clickedIndexAt:(NSIndexPath *)indexpath from:(UIViewController *)controller
{
    [super clickedIndexAt:indexpath from:controller];
    
    [self showAskAlert:controller];
}


-(void)alertViewClickedButtonAtIndex:(NSInteger)buttonIndex controller:(UIViewController *)controller
{
    if(buttonIndex == 0 && self.imageForPerson)
    {
        [self.person updateImage:self.imageForPerson];
        
        id firstCon = controller.navigationController.viewControllers.firstObject;
        if([firstCon respondsToSelector:@selector(saveAddressbook)])
        {
            [firstCon saveAddressbook];
            [controller.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}



@end
