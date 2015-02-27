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
