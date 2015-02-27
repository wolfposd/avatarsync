//
//  DickButtMultipleMatcher.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 28.01.15.
//  Copyright (c) 2015 Wolf Posdorfer. All rights reserved.
//

#import "DickButtMultipleMatcher.h"
#import "PhotoFile.h"

@implementation DickButtMultipleMatcher

@synthesize isChecked = _isChecked;


-(NSArray*) getPhotosForPerson:(ASPerson*) person
{
    return @[[PhotoFile photoFile:@"Dickbutt" image:[UIImage imageNamed:@"dickbutt"]]];
}

-(UIImage*) imageForMatcher
{
    return [UIImage imageNamed:@"dickbutt"];
}

-(NSString*) textForMatcher
{
    return @"Dickbutt";
}



@end
