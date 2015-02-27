//
//  ImageApplyOptions.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 23.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "ImageApplyOptions.h"
#import "WAImageFinder.h"
#import "WATableFeed.h"
#import "GenericTableViewController.h"
#import "SQLController.h"
#import "PhotoFile.h"
#import "GravatarFeed.h"
#import "SingleDownloadViewController.h"
#import "TwitterDownload.h"
#import "ImageURL.h"
#import "Facebook.h"
#import "FacebookMessenger.h"
#import "FacebookMessengerTableFeed.h"

@interface ImageApplyOptions ()

@property (nonatomic,retain) NSArray* icons;
@property (nonatomic,retain) NSArray* texts;

@property (nonatomic, retain) ASPerson* person;

@end



@implementation ImageApplyOptions


-(id) initWithContact:(ASPerson*) person
{
    self = [super init];
    if(self)
    {
        _person = person;
        
        
        _texts = @[
                   @[NSLocalizedString(@"WhatsApp\n(from local storage)",nil)
                     ,@"Facebook /\nFacebook Messenger",
                     @"Gravatar" ],
                   @[@"Facebook",
                     @"Twitter",
                     @"Img Download"]
                   ];

        _icons = @[
                   @[[UIImage imageNamed:@"whatsapp.png"],
                       [UIImage imageNamed:@"fb_mess.png"],
                       [UIImage imageNamed:@"gravatar.png"]],
                   @[[UIImage imageNamed:@"facebook.png"],
                     [UIImage imageNamed:@"twitter.png"],
                     [UIImage imageNamed:@"download.png"]]
                   ];
        
    }
    
    return self;
}

-(NSString*) navTitle
{
    return NSLocalizedString(@"Source Selection",nil);
}


-(NSString*) titleForHeader
{
    return NSLocalizedString(@"Pick a Source",nil);
}

-(NSString*) descriptionForHeader
{
    return [NSString stringWithFormat:NSLocalizedString(@"Select an imagesource for\n%@ %@", nil), self.person.firstName, self.person.lastName];
}

-(NSInteger) numberOfRowsInSection:(NSInteger)section
{
    NSArray* ar = self.texts[section];
    return ar.count;
}

-(NSInteger)numberOfSections
{
    return 2;
}

-(NSString *)titleForSection:(NSInteger)section
{
    if(section == 0)
    {
        return NSLocalizedString(@"Automatic",nil);
    }
    return NSLocalizedString(@"Semi-Automatic",nil);
}

-(void) updateCell:(BigImageCell**) cell atIndex:(NSIndexPath*) indexpath
{
    (*cell).bigImage.image = self.icons[indexpath.section][indexpath.row];
    (*cell).bigLabel.text = self.texts[indexpath.section][indexpath.row];
    
}

-(void) clickedIndexAt:(NSIndexPath*) indexPath from:(UIViewController*) controller
{
    if(indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                [self pushWA:controller];
                break;
            case 1:
                [self pushFBMess:controller];
                break;
            case 2:
                [self pushGR:controller];
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
                [self pushFB:controller];
                break;
            case 1:
                [self pushTw:controller];
                break;
            case 2:
                [self pushWebDownload:controller];
                break;
        }
    }
}

-(void) pushWA:(UIViewController*) co
{
    if([WAImageFinder findWhatsappFolder])
    {
        WATableFeed* feed =  [[WATableFeed alloc] initWithContact:self.person];
        [co.navigationController pushViewController:[[GenericTableViewController alloc] initWithDelegate:feed] animated:YES];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil) message:NSLocalizedString(@"WhatsApp is not installed",nil) delegate:co cancelButtonTitle:NSLocalizedString(@"Gotcha!", nil) otherButtonTitles: nil] show];
    }
    
    
}

-(void) pushFBMess:(UIViewController*) co
{
    if([FacebookMessenger findContactsDBPathMessenger])
    {
        FacebookMessengerTableFeed* fb = [[FacebookMessengerTableFeed alloc] initWithContact:self.person isFacebookApp:NO];
        [co.navigationController pushViewController:[[GenericTableViewController alloc] initWithDelegate:fb] animated:YES];
    }
    else if([FacebookMessenger findContactsDBPathApp])
    {
        FacebookMessengerTableFeed* fb = [[FacebookMessengerTableFeed alloc] initWithContact:self.person isFacebookApp:YES];
        [co.navigationController pushViewController:[[GenericTableViewController alloc] initWithDelegate:fb] animated:YES];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil) message:NSLocalizedString(@"Messenger is not installed",nil) delegate:co cancelButtonTitle:NSLocalizedString(@"Gotcha!", nil) otherButtonTitles: nil] show];
    }
    
    
}

-(void) pushFB:(UIViewController*)co
{
    Facebook* face = [[Facebook alloc] initWithPerson:self.person];
    SingleDownloadViewController* down = [[SingleDownloadViewController alloc] initWithPerson:self.person andDelegate:face];
    [co.navigationController pushViewController:down animated:YES];
}

-(void) pushGR:(UIViewController*) co
{
    GravatarFeed* feed = [[GravatarFeed alloc] initWithContact:self.person];
    [co.navigationController pushViewController:[[GenericTableViewController alloc] initWithDelegate:feed] animated:YES];
}


-(void) pushTw:(UIViewController*) co
{
    TwitterDownload* tw = [[TwitterDownload alloc] initWithPerson:self.person];
    SingleDownloadViewController* down = [[SingleDownloadViewController alloc] initWithPerson:self.person andDelegate:tw];
    [co.navigationController pushViewController:down animated:YES];
}


-(void) pushWebDownload:(UIViewController*) co
{
    ImageURL* tw = [ImageURL new];
    SingleDownloadViewController* down = [[SingleDownloadViewController alloc] initWithPerson:self.person andDelegate:tw];
    [co.navigationController pushViewController:down animated:YES];
}


@end
