//
//  AddressbookSQL.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 10.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
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
