//
//  ImageGeneric.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
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
