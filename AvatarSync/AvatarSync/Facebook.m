//
//  Facebook.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 26.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "Facebook.h"



@interface Facebook ()

@property (nonatomic,weak) id<SingleDownloadOwner> ownerDownloader;
@property (nonatomic,retain) ASPerson* person;

@end

@implementation Facebook



-(id)initWithPerson:(ASPerson *)person
{
    self = [super init];
    if(self)
    {
        _person = person;
    }
    return self;
}

-(void) setOwner:(id<SingleDownloadOwner>) owner
{
    self.ownerDownloader = owner;
    
    NSString* facebook = self.person.socialNetworks[@"facebook"];
    if(facebook)
    {
        [self.ownerDownloader putStringInTextfield:facebook];
    }
}

-(NSString*) titleForNav
{
    return @"Facebook";
}

-(NSString*) titleForLabel
{
    return NSLocalizedString(@"Enter Facebook Name:",nil);
}
-(UIColor*) backgroundColor
{
    
    // color="#3c5a98"
    
    return [UIColor colorWithRed:0.23 green:0.35 blue:0.59 alpha:1.0];
}
-(UIColor*) labelColor
{
    return [UIColor whiteColor];
}

-(NSString*) errorNoText
{
    return NSLocalizedString(@"Please enter a Facebook-Username first.",nil);
}

-(void)startDownloading:(NSString *)filetext
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^(){
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",filetext]];
        
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            if(image)
            {
                [self.ownerDownloader reportDownloadFinishedWithImage:image];
            }
            else
            {
                [self.ownerDownloader errorHappenedDuringDownload:NSLocalizedString(@"Error", nil)];
            }
        });
        
    });
}


@end
