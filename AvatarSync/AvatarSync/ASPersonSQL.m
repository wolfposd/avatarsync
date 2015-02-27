//
//  ASPersonSQL.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 11.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "ASPersonSQL.h"




//@property (nonatomic) ABRecordRef record;
//
//@property (nonatomic,retain) NSString* firstName;
//@property (nonatomic,retain) NSString* lastName;
//@property (nonatomic,retain) NSString* company;
//
//@property (nonatomic,retain) NSDictionary* socialNetworks;
//
//@property (nonatomic,retain) UIImage* profileImage;
//@property (nonatomic,retain) NSArray* phoneNumbers;
//@property (nonatomic,retain) NSArray* emails;


@implementation ASPersonSQL


+(id) personWithDict:(NSDictionary*) dict
{
    ASPersonSQL* person = [ASPersonSQL new];
    
    
    if(!(person.firstName = dict[@"First"]))
    {
        person.firstName = @"";
    }
    
    if(!(person.lastName = dict[@"Last"]))
    {
        person.lastName = @"";
    }
    
    if(!(person.company = dict[@"Organization"]))
    {
        person.company = @"";
    }
    
    if(!(person.emails = dict[@"email"]))
    {
        person.emails = @[];
    }
    
    if(!(person.phoneNumbers = dict[@"phone"]))
    {
        person.phoneNumbers = @[];
    }
    
    person.profileImage = dict[@"image"];
    if(!person.profileImage)
    {
        person.profileImage = [UIImage imageNamed:@"noimage.png"];
    }
    
    person.socialNetworks = [NSDictionary new];
    
    return person;
}




+(id) personWith:(ABRecordRef) record
{
    return nil;
}


-(void) refetchInfos
{
    
}

-(void) updateImage:(UIImage*) newImage
{
    // TODO
}



@end
