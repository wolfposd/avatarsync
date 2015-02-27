//
//  ImageURL.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "ImageURL.h"


@interface ImageURL ()

@property (nonatomic, weak) id<SingleDownloadOwner> delegate;

@end

@implementation ImageURL


-(void) startDownloading:(NSString*) filetext
{
    if([filetext rangeOfString:@"http://"].location == NSNotFound)
    {
        filetext = [@"http://" stringByAppendingString:filetext];
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^(){
    
        
        NSURL* url = [NSURL URLWithString:filetext];
        
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        [self finishUp:image];
    });
}

-(void) setOwner:(id<SingleDownloadOwner>) owner
{
    self.delegate = owner;
}

-(NSString*) titleForLabel
{
    return NSLocalizedString(@"Enter a URL:",nil);
}

-(UIColor*) backgroundColor
{
    return [UIColor grayColor];
}
-(UIColor*) labelColor
{
    return [UIColor whiteColor];
}

-(NSString*) titleForNav
{
    return NSLocalizedString(@"Image download",nil);
}

-(NSString*) errorNoText
{
    return NSLocalizedString(@"Please enter a URL first.",nil);
}


-(void) finishUp:(UIImage*) image;
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        if(image)
        {
            [self.delegate reportDownloadFinishedWithImage:image];
        }
        else
        {
            [self.delegate errorHappenedDuringDownload:NSLocalizedString(@"Error",nil)];
        }
    });
}


@end
