//
//  WATableFeed.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 23.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
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

    
    NSString* path = [WAImageFinder findWhatsappFolder];
    NSString* dbpath = [WAImageFinder contactsDBFullPath];
    if(dbpath)
    {
        SQLController* con = [SQLController sqlControllerWithFile:dbpath];
        
        NSMutableArray* picturePaths = [NSMutableArray new];
        
        for (NSString* fone in self.person.phoneNumbers)
        {
            if(fone.length > 4)
            {
                NSString* where2 = [NSString stringWithFormat:@"ZWHATSAPPID LIKE '%%%@%%'", fone];

                NSArray* medias = [con selectAllFrom:@"ZWASTATUS" where:where2];
                
                for(NSDictionary* row in medias)
                {
                    NSString* picpath = row[@"ZPICTUREPATH"];
                    if(picpath)
                    {
                        [picturePaths addObject:picpath];
                    }
                }
            }
        }
        [con closeDb];
        
        for(NSString* pp in picturePaths)
        {
            NSString* ff = [NSString stringWithFormat:@"%@/Library/%@.jpg",path, pp];
            UIImage* img = [UIImage imageWithContentsOfFile:ff];
            if(img)
            {
                PhotoFile* pf = [PhotoFile photoFile:NSLocalizedString(@"Profile Picture from WA-DB",nil) image:img];
                [(NSMutableArray*)_matchingImages addObject:pf];
            }
        }
        
        [self walkfolderforThumbs];

    }
}


-(void) walkfolderforThumbs
{
    NSArray* imgs = [WAImageFinder thumbimagesFromWAFolder:[WAImageFinder findWhatsappFolder]];
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
                NSArray* images = [WAImageFinder imagesFromWAFolder:[WAImageFinder findWhatsappFolder]];
                images = [WAImageFinder matchFotosInArrayToPeople:images];
                ig = [[ImageGeneric alloc] initWithContact:self.person andPhotofiles:images];
                break;
            }
            case 1:
                ig = [[ImageGeneric alloc] initWithContact:self.person andPhotofiles:[WAImageFinder tempimagesFromWAFolder:[WAImageFinder findWhatsappFolder]]];
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
