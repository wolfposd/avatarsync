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
        NSString* path =[FacebookMessenger findContactsDBPathMessenger];
        _sql = [SQLController sqlControllerWithFile:path];
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
        NSString* imagePath = [FacebookMessenger downloadImageForUserId:idForUser];
        if(imagePath)
        {
            PhotoFile* f = [PhotoFile photoFile:[self textForMatcher] filepath:imagePath];
            
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
