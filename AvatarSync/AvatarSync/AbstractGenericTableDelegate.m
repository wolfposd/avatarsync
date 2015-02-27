//
//  AbstractGenericTableDelegate.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
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
