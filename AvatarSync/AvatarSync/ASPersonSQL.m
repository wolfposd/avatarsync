//
// AvatarSync
// Copyright (C) 2014-2015  Wolf Posdorfer
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
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
