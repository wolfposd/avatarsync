//
//  TwitterDownload.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "TwitterDownload.h"


@interface TwitterDownload ()

@property (nonatomic,retain) ASPerson* person;
@property (nonatomic,weak) id<SingleDownloadOwner> ownerDownloader;
@end

@implementation TwitterDownload

-(id) initWithPerson:(ASPerson*) person
{
    self = [super init];
    if (self)
    {
        _person = person;
    }
    return self;
}


-(void) setOwner:(id<SingleDownloadOwner>) owner
{
    self.ownerDownloader = owner;
    
    NSString* twitterAcc = self.person.socialNetworks[@"twitter"];
    if(twitterAcc)
    {
        [self.ownerDownloader putStringInTextfield:twitterAcc];
    }
}

-(NSString*) titleForNav
{
    return @"Twitter";
}

-(NSString*) titleForLabel
{
    return NSLocalizedString(@"Enter Twitter Name:",nil);
}
-(UIColor*) backgroundColor
{
    return [UIColor colorWithRed:0.0 green:0.6 blue:0.72 alpha:1.0];
}
-(UIColor*) labelColor
{
    return [UIColor whiteColor];
}

-(NSString*) errorNoText
{
    return NSLocalizedString(@"Please enter a Twitter-Username first.",nil);
}

-(void)startDownloading:(NSString *)filetext
{
    filetext = [filetext stringByReplacingOccurrencesOfString:@"@" withString:@""];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^(){
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@",filetext]];
    
        NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15.0];
        
        NSURLResponse* response;
        NSError* error;
        NSData* resultdata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
        if(resultdata)
        {
            [self parseResultData:resultdata];
        }

    });
}

-(void) parseResultData:(NSData*) data
{
    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    string = [string substringFromIndex:1000];
    
    NSRange range = [string rangeOfString:@"https://pbs.twimg.com/profile_images/"];
    
    if(range.location != NSNotFound)
    {
        string = [string substringWithRange:NSMakeRange(range.location, 100)];
        
        NSRange endrange = [string rangeOfString:@"\""];
        NSRange rr = NSMakeRange(0, endrange.location);
        
        NSString* imageURL = [string substringWithRange:rr];

        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        
        [self finishUp:image];
    }
    else
    {
        [self finishUp:nil];
    }

    
    
}

-(void) finishUp:(UIImage*) image;
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        if(image)
        {
            [self.ownerDownloader reportDownloadFinishedWithImage:image];
        }
        else
        {
            [self.ownerDownloader errorHappenedDuringDownload:NSLocalizedString(@"Error",nil)];
        }
    });
}






@end
