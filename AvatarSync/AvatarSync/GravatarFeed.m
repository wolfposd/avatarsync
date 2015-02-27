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

#import "GravatarFeed.h"
#import "Crypto.h"
#import "PhotoFile.h"
#import "ContactsTableViewController.h"

@interface GravatarFeed ()

@property (nonatomic,retain) NSMutableArray* images;
@property (nonatomic, weak) id<GenericTableOwner> ownerdelegate;
@property (nonatomic) BOOL hasLoaded;
@end

@implementation GravatarFeed



-(id)initWithContact:(ASPerson *)person
{
    self = [super initWithContact:person];
    if(self)
    {
        _images = [NSMutableArray new];
        _hasLoaded = false;
        
        [self loadImages];
    }
    return self;
}


+(PhotoFile*) loadImageForEmail:(NSString*) email
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=400&d=404",[Crypto md5HexDigest:email]]];    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: url]];
    
    if(image)
    {
        return [PhotoFile photoFile:email image:image];
    }
    
    return nil;
}

-(void) loadImages
{
    if(self.person.emails.count > 0 )
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        dispatch_async(dispatch_get_global_queue(0, 0), ^()
                       {
                           for(NSString* email in self.person.emails)
                           {
                               PhotoFile* fotofile = [GravatarFeed loadImageForEmail:email];
                               if(fotofile)
                               {
                                   [self.images addObject:fotofile];
                               }
                           }
                           dispatch_async(dispatch_get_main_queue(), ^(){
                               [self loadingDone];
                           });
                           
                       });
    }
}

-(void)controllerWillDisapper
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void) loadingDone
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.hasLoaded = YES;
    [self.ownerdelegate reloadTableData];
}

-(NSString *)navTitle
{
    return [self titleForHeader];
}

-(NSString *)titleForHeader
{
    return @"Gravatar";
}

-(NSString *)descriptionForHeader
{
    
    if(self.person.emails.count == 0)
    {
        return NSLocalizedString(@"Contact does not have eMail Addresses",nil);
    }
    else if(self.hasLoaded)
    {
        if(self.images.count == 0)
        {
            return NSLocalizedString(@"No images found for this User.",nil);
        }
        else
        {
            return NSLocalizedString(@"Select images from Gravatar",nil);
        }
    }
    else
    {
        return NSLocalizedString(@"Select images from Gravatar\n\n Loading....",nil);
    }
}

-(void) setOwner:(id<GenericTableOwner>) owner
{
    self.ownerdelegate = owner;
}



-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return self.images.count;
}

-(NSInteger)numberOfSections
{
    return 1;
}


-(void)updateCell:(BigImageCell *__autoreleasing *)cell atIndex:(NSIndexPath *)indexpath
{
    PhotoFile* f = self.images[indexpath.row];
    
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
    if(buttonIndex == 0)
    {
        PhotoFile* f = self.images[self.lastClickedIndex.row];
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
