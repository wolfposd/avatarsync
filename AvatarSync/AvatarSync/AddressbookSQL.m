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

#import "AddressbookSQL.h"
#import "SQLController.h"
#import <UIKit/UIKit.h>
#import "ASPersonSQL.h"


@interface AddressbookSQL ()

@property (nonatomic,retain) SQLController* sqlBook;
@property (nonatomic,retain) SQLController* sqlImages;

@end

@implementation AddressbookSQL


- (instancetype)init
{
    self = [super init];
    if (self) {
        _sqlBook = [SQLController sqlControllerWithFile:@"/var/mobile/Library/AddressBook/AddressBook.sqlitedb"];
        _sqlImages = [SQLController sqlControllerWithFile:@"/var/mobile/Library/AddressBook/AddressBookImages.sqlitedb"];
    }
    return self;
}



-(NSArray*) getUsersFromDB
{
    return [self convertUserDictionaryToPersons:[self queryUsers]];
}



-(void) printNames
{
    NSLog(@"%@", [self queryUsers]);
}

-(NSArray*) convertUserDictionaryToPersons:(NSArray*) userDictionaries
{
    NSMutableArray* resultArray = [NSMutableArray new];

    
    for(NSDictionary* udict in userDictionaries)
    {
        ASPersonSQL* person = [ASPersonSQL personWithDict:udict];
        if(person)
        {
            [resultArray addObject:person];
        }
    }
    
    return resultArray;
}




-(NSArray*) queryUsers
{
    NSArray* results = [self.sqlBook select:@"ROWID, First, Last, Organization" From:@"ABPerson" where:nil];

    for (NSMutableDictionary* dict in results)
    {
        NSString* rowid = dict[@"ROWID"];
        if(rowid)
        {
            
            NSArray* phonesAndEmails = [self.sqlBook select:@"value" From:@"ABMultiValue" where:[NSString stringWithFormat:@"record_id = '%@'",rowid]];
            
            NSMutableArray* emails = [NSMutableArray new];
            NSMutableArray* phones = [NSMutableArray new];
            
            for(NSDictionary* dict in phonesAndEmails)
            {
                NSString* value = dict[@"value"];
                if(value)
                {
                    if([self isEmail:value])
                    {
                        [emails addObject:value];
                    }
                    else // isPhone
                    {
                        [phones addObject:[self formatPhone:value]];
                    }
                }
            }
            
            if(emails.count > 0)
            [dict setObject:emails forKey:@"email"];
            if(phones.count > 0)
            [dict setObject:phones forKey:@"phone"];
            
            NSArray* imagesArray = [self.sqlImages selectData:@"data" From:@"ABFullSizeImage" where:[NSString stringWithFormat:@"record_id = '%@'",rowid]];
            
            if(imagesArray.count == 1)
            {
                UIImage* img = [UIImage imageWithData:imagesArray[0][@"data"]];
                if(img)
                {
                    [dict setObject:img forKey:@"image"];
                }
            }
        }
    }
    
    return results;
}



-(NSString*) formatPhone:(NSString*) phone
{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: @"[^\\d]" options:0  error:nil];
    
    
    NSMutableString* mut = [phone mutableCopy];
    [regex replaceMatchesInString:mut options:0 range:NSMakeRange(0, phone.length) withTemplate:@""];
    
    if([mut characterAtIndex:0] == '0')
    {
        [mut replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    return mut;
}

-(BOOL) isEmail:(NSString*) stringtocheck
{
    return [stringtocheck rangeOfString:@"@"].location != NSNotFound;
}


-(void)dealloc
{
    [_sqlBook closeDb];
    [_sqlImages closeDb];
}


@end
