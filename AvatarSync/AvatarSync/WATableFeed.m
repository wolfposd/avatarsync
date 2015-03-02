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

#import <UIKit/UIKit.h>
#import "WATableFeed.h"
#import "BigImageCell.h"
#import "PhotoFile.h"
#import "ContactsTableViewController.h"
#import "SQLController.h"
#import "WAImageFinder.h"
#import "ImageGeneric.h"
#import "GenericTableViewController.h"

@interface WATableFeed ()


@property (nonatomic, retain) NSArray* matchingImages;
@property (nonatomic, retain) NSArray* matchingThumbImages;

@property (nonatomic,retain) SQLController* sql;

@end


@implementation WATableFeed


-(id)initWithContact:(ASPerson *)person
{
    self = [super initWithContact:person];
    if(self)
    {
        _matchingImages = [NSMutableArray new];
        _matchingThumbImages = [NSMutableArray new];
        [self getImagesFromWADB];
    }
    
    return self;
}

-(void) getImagesFromWADB
{
    SQLController* con = [SQLController sqlControllerWithFile:[WAImageFinder contactsDBFullPath]];
    
    NSArray* images = [WAImageFinder getImagesFromWADB:self.person sql:&con];

    [((NSMutableArray*)_matchingImages) addObjectsFromArray:images];
    
    [con closeDb];
 
    for(PhotoFile* pf in _matchingImages)
    {
        pf.filename = NSLocalizedString(@"Profile Picture from WA-DB",nil);
    }
    [self walkfolderforThumbs];
    
}


-(void) walkfolderforThumbs
{
    NSArray* imgs = [WAImageFinder thumbimagesFromWAFolder];
    for(PhotoFile* f in imgs)
    {
        NSString* phone = [f.filename stringByReplacingOccurrencesOfString:@".thumb" withString:@""];
        
        if([self.person doesPhoneMatchPerson:phone])
        {
            [(NSMutableArray*)_matchingThumbImages addObject:f];
        }
    }
}


-(NSString*) navTitle
{
    return NSLocalizedString(@"WA Images",nil);
}

-(NSString*) titleForHeader
{
    return NSLocalizedString(@"WhatsApp Profiles",nil);
}

-(NSString*) descriptionForHeader
{
    return NSLocalizedString(@"Select a profile picture from WhatsApp",nil);
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.matchingImages.count == 0 ? 1 : self.matchingImages.count;
    }
    else if(section == 1)
    {
        return  self.matchingThumbImages.count;
    }
    else return 2;
}

-(NSInteger)numberOfSections
{
    return 3;
}


-(NSString*) titleForSection:(NSInteger) section
{
    if(section == 0)
    {
        if(self.matchingImages.count == 0)
            return NSLocalizedString(@"No Image found",nil);
        else
            return  NSLocalizedString(@"Possible Matches",nil);
    }
    else if(section == 1)
    {
        return NSLocalizedString(@"Thumbnail",nil);
    }
    else
    {
        return NSLocalizedString(@"Other Profileimages",nil);
    }
}

-(void)clickedIndexAt:(NSIndexPath*) indexpath from:(UIViewController *)controller
{
    self.lastClickedIndex = indexpath;
    
    if(indexpath.section == 0 && self.matchingImages.count != 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Apply Image",nil) message:NSLocalizedString(@"Are you sure you want to apply this image to user?",nil) delegate:controller cancelButtonTitle:NSLocalizedString(@"Yes",nil) otherButtonTitles:NSLocalizedString(@"No",nil), nil];
        [alert show];
    }
    else if(indexpath.section == 1)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Apply Image",nil) message:NSLocalizedString(@"Are you sure you want to apply this image to user?",nil) delegate:controller cancelButtonTitle:NSLocalizedString(@"Yes",nil) otherButtonTitles:NSLocalizedString(@"No",nil), nil];
        [alert show];
    }
    else if(indexpath.section == 2)
    {
        ImageGeneric* ig = nil;
        switch (indexpath.row) {
            case 0:
            {
                NSArray* images = [WAImageFinder imagesFromWAFolder];
                images = [WAImageFinder matchFotosInArrayToPeople:images];
                ig = [[ImageGeneric alloc] initWithContact:self.person andPhotofiles:images];
                break;
            }
            case 1:
                ig = [[ImageGeneric alloc] initWithContact:self.person andPhotofiles:[WAImageFinder tempimagesFromWAFolder]];
                break;
        }
        
        [controller.navigationController pushViewController:[[GenericTableViewController alloc] initWithDelegate:ig]  animated:YES];
    }
}

-(void)updateCell:(BigImageCell *__autoreleasing *)cell atIndex:(NSIndexPath*) indexpath
{
    PhotoFile* f = nil;
    
    if(indexpath.section == 0)
    {
        if(self.matchingImages.count != 0)
        {
            f = self.matchingImages[indexpath.row];
            (*cell).bigLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
        }
        else
        {
            f = [PhotoFile photoFile:NSLocalizedString(@"No HD Image Found",nil) image:[UIImage imageNamed:@"noimage.png"]];
            (*cell).bigLabel.textColor = [UIColor redColor];
        }
    }
    else if(indexpath.section == 1 )
    {
        f = self.matchingThumbImages[indexpath.row];
        (*cell).bigLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
    }
    else
    {
        switch (indexpath.row)
        {
            case 0:
                f = [PhotoFile photoFile:NSLocalizedString(@"HD Profile Images",nil) image:[UIImage imageNamed:@"hd.png"]];
                break;
            case 1:
                f = [PhotoFile photoFile:NSLocalizedString(@"Cached Profile Images",nil) image:[UIImage imageNamed:@"sd.png"]];
                break;
        }
        (*cell).bigLabel.textColor = [UIColor blackColor];
    }
    
    (*cell).bigImage.image = f.image;
    (*cell).bigLabel.text = f.filename;
    
}

-(void)alertViewClickedButtonAtIndex:(NSInteger)buttonIndex controller:(UIViewController*) controller
{
    if(buttonIndex == 0)
    {
        PhotoFile* fotofile = nil;
        if(self.lastClickedIndex.section == 0)
        {
            if(self.matchingImages.count != 0)
            {
                fotofile = self.matchingImages[self.lastClickedIndex.row];
            }
        }
        else if(self.lastClickedIndex.section == 1)
        {
            if(self.matchingThumbImages.count != 0)
            {
                fotofile = self.matchingThumbImages[self.lastClickedIndex.row];
            }
        }
        if(fotofile != nil)
        {
            [self.person updateImage:fotofile.image];
            id firstCon = controller.navigationController.viewControllers.firstObject;
            if([firstCon respondsToSelector:@selector(saveAddressbook)])
            {
                [firstCon saveAddressbook];
                [controller.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
}


#pragma mark - WhatsApp-SQL


@end
