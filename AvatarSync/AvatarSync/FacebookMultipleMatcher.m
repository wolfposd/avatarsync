//
//  FacebookMultipleMatcher.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 08.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "FacebookMultipleMatcher.h"
#import "FacebookMessenger.h"
#import "SQLController.h"
#import "PhotoFile.h"

@interface FacebookMultipleMatcher ()

@property (nonatomic,retain) SQLController* sql;

@end

@implementation FacebookMultipleMatcher

@synthesize isChecked = _isChecked;

-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        _sql = [SQLController sqlControllerWithFile:[FacebookMessenger findContactsDBPathApp]];
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
    return [UIImage imageNamed:@"facebook.png"];
}


-(NSString *)textForMatcher
{
    return @"Facebook";
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



