//
//  GravatarMultipleMatcher.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 10.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "GravatarMultipleMatcher.h"
#import "GravatarFeed.h"
#import "PhotoFile.h"

@implementation GravatarMultipleMatcher


@synthesize isChecked = _isChecked;

-(NSString *)textForMatcher
{
    return @"Gravatar";
}

-(NSString *)textDetailForMatcher
{
    return NSLocalizedString(@"requires webconnection", nil);
}

-(UIImage *)imageForMatcher
{
    return [UIImage imageNamed:@"gravatar_round.png"];
}


-(NSArray *)getPhotosForPerson:(ASPerson *)person
{
    
    NSMutableArray* result =[NSMutableArray new];
    
    
    for(NSString* email in person.emails)
    {
        PhotoFile* f = [GravatarFeed loadImageForEmail:email];
        if(f)
        {
            f.filename = [self textForMatcher];
            [result addObject:f];
        }
    }
    
    
    return result;
}


@end
