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

#import "AddressbookManager.h"
#import <AddressBook/AddressBook.h>
#import "ASPerson.h"
#import "FileLog.h"


@interface AddressbookManager ()

@property (nonatomic, retain) NSArray* persons;

@property (nonatomic) ABAddressBookRef addressbook;

@end

@implementation AddressbookManager

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _persons = @[];
        [self checkPermission];
    }
    return self;
}

+(AddressbookManager *)instance
{
    static AddressbookManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


-(void) checkPermission
{
    [FileLog log:@"AddressbookManager- starting check permission" level:LOGLEVEL_DEBUG];
    
    NSLog(@"ABAddressBookGetAuthorizationStatus: %ld", ABAddressBookGetAuthorizationStatus());
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted)
    {
        [FileLog log:@"showing error message access" level:LOGLEVEL_DEBUG];
        [self showErrorMessageAccess];
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        [FileLog log:@"AddressbookManager- starting to assing addressbook" level:LOGLEVEL_DEBUG];
        if(!self.addressbook)
        {
            [self assignAddressbook];
        }
    }
    else
    {
        //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        [FileLog log:@"AddressbookManager- asking for permission" level:LOGLEVEL_DEBUG];
        [self askForPermission];
    }
}

-(void) askForPermission
{
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        if (!granted)
        {
            [self showErrorMessageAccess];
        }
        else
        {
            [self assignAddressbook];
        }
    });
}

-(void) assignAddressbook
{
    NSMutableArray* allPersons = [NSMutableArray new];
    
    
    [FileLog log:@"AddressbookManager- assignAddressbook:START" level:LOGLEVEL_DEBUG];
    
    CFErrorRef errorRef = nil;
    ABAddressBookRef book =  ABAddressBookCreateWithOptions(nil, &errorRef);
    
    self.addressbook = book;

    if(!errorRef)
    {
        NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(self.addressbook);
        int i = 0;
        for(id contactRecord in allContacts)
        {
            ABRecordRef thisContact = (__bridge ABRecordRef) contactRecord;
            @try
            {
                if(thisContact != NULL)
                {
                    ASPerson* asp = [ASPerson personWith:thisContact];
                    if(asp)
                    {
                        NSString* first = asp.firstName ? @"YES" : @"NO";
                        NSString* last = asp.lastName ? @"YES" : @"NO";
                        
                        [FileLog log:[NSString stringWithFormat:@"AddressbookManager- person hasfirst:%@ hasLast:%@", first, last] level:LOGLEVEL_DEBUG];
                        [allPersons addObject:asp];
                    }
                    else
                    {
                        [FileLog log:[NSString stringWithFormat:@"There was an error getting a Contact (%d)",i] level:LOGLEVEL_ERROR];
                    }
                }
            }
            @catch (NSException *exception)
            {
                [FileLog log:@"Exception creating a person" level:LOGLEVEL_ERROR];
                [FileLog log:exception.name level:LOGLEVEL_ERROR];
                [FileLog log:exception.reason level:LOGLEVEL_ERROR];
            }
            
            i++;
        }
 
        [FileLog log:@"AddressbookManager- done getting person, sorting table"level:LOGLEVEL_DEBUG];
        [allPersons sortWithOptions:NSSortStable usingComparator:
         ^NSComparisonResult(id obj1, id obj2)
         {
             @try
             {
                 NSComparisonResult r1 =  [[obj1 lastName] compare:[obj2 lastName]];
                 
                 if(r1 == NSOrderedSame)
                 {
                     return [[obj1 firstName] compare:[obj2 firstName]];
                 }
                 return r1;
             }
             @catch (NSException *exception)
             {
                 [FileLog log:exception.name level:LOGLEVEL_ERROR];
                 [FileLog log:exception.description level:LOGLEVEL_ERROR];
                 [FileLog log:exception.reason level:LOGLEVEL_ERROR];
                 return NSOrderedSame;
             }
         }];
 
        self.persons = allPersons;
        [self.currentDelegate addressbookmanagerParsingSuccess];
    }
    else
    {
        
        @try {
            NSError* error = (__bridge NSError *)errorRef;
            if(error)
            {
                NSLog(@"%@", error);
                [FileLog log:[error domain] level:LOGLEVEL_ERROR];
                [FileLog log:[error description] level:LOGLEVEL_ERROR];
                [FileLog log:[error debugDescription] level:LOGLEVEL_ERROR];
            }
        }
        @catch (NSException *exception) {
            [FileLog log:@"wtf is happening" level:LOGLEVEL_ERROR];
        }
        
        [self.currentDelegate addressbookmanagerError:@"CFERRORREF"];
    }
    
    
}

-(NSArray*) sortedPersonsArray
{
    return self.persons;
}

-(void) showErrorMessageAccess
{
    if(self.currentDelegate)
    {
        [self.currentDelegate addressbookmanagerError:NSLocalizedString(@"AvatarSync needs access to the Addressbook",nil)];
    }
}


-(void)saveAddressbook
{
    CFErrorRef ref;
    ABAddressBookSave(self.addressbook, &ref);
}

@end
