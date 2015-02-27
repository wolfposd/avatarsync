//
//  FacebookMessengerMultipleMatcher.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 10.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "FacebookMessengerMultipleMatcher.h"
#import "FacebookMessenger.h"
#import "SQLController.h"
#import "PhotoFile.h"

@interface FacebookMessengerMultipleMatcher ()

@property (nonatomic,retain) SQLController* sql;

@end

@implementation FacebookMessengerMultipleMatcher

@synthesize isChecked = _isChecked;

-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        _sql = [SQLController sqlControllerWithFile:[FacebookMessenger findContactsDBPathMessenger]];
        _isChecked = false;
    }
    
    return self;
}

-(NSArray *)getPhotosForPerson:(ASPerson *)person
{
    NSMutableArray* result = [NSMutableArray new];
    
    SQLController* con = _sql;
    
    NSString* idForUser = [FacebookMessenger fbIdforUser:person sql:&con];
    if(idForUser)
    {
        UIImage* image = [FacebookMessenger downloadImageForUserId:idForUser];
        if(image)
        {
            PhotoFile* f = [PhotoFile photoFile:[self textForMatcher] image:image];
            
            [result addObject:f];
        }
    }
    
    return result;
}


-(UIImage *)imageForMatcher
{
    return [UIImage imageNamed:@"fbmessenger.png"];
}


-(NSString *)textForMatcher
{
    return @"Facebook Messenger";
}

-(NSString *)textDetailForMatcher
{
    return NSLocalizedString(@"requires webconnection",nil);
}

-(void)dealloc
{
    [_sql closeDb];
}

@end