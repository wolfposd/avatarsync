//
//  ASPerson.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 23.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "ASPerson.h"
#import "FileLog.h"


@implementation ASPerson


+(id) personWith:(ABRecordRef) record
{
    ASPerson* person = [ASPerson new];
    person.record = record;    
    [person refetchInfos];
    return person;
}


-(void) refetchInfos
{
    @try
    {
        self.firstName = [self getString:kABPersonFirstNameProperty];
    }
    @catch (NSException *exception)
    {
        [FileLog log:@"Couldnt fetch Firstname" level:LOGLEVEL_ERROR];
        [FileLog log:exception.reason level:LOGLEVEL_ERROR];
    }

    @try
    {
        self.lastName = [self getString:kABPersonLastNameProperty];
    }
    @catch (NSException *exception)
    {
        [FileLog log:@"Couldnt fetch Lastname" level:LOGLEVEL_ERROR];
        [FileLog log:exception.reason level:LOGLEVEL_ERROR];
    }
    
    @try
    {
        self.company = [self getString:kABPersonOrganizationProperty];
    }
    @catch (NSException *exception)
    {
        [FileLog log:@"Couldnt fetch company" level:LOGLEVEL_ERROR];
        [FileLog log:exception.reason level:LOGLEVEL_ERROR];
    }
    
    @try
    {
        self.profileImage = [self getImage];
    }
    @catch(NSException *exc)
    {
        [FileLog log:@"Couldnt fetch profileimage" level:LOGLEVEL_ERROR];
        [FileLog log:exc.reason level:LOGLEVEL_ERROR];
    }
    
    @try
    {
        self.phoneNumbers = [self makePhoneNumbers];
    }
    @catch(NSException *exc)
    {
        [FileLog log:@"Couldnt fetch phonenumbers" level:LOGLEVEL_ERROR];
        [FileLog log:exc.reason level:LOGLEVEL_ERROR];
    }
    
    @try
    {
        self.emails = [self makeEmails];
    }
    @catch(NSException *exc)
    {
        [FileLog log:@"Couldnt fetch emails" level:LOGLEVEL_ERROR];
        [FileLog log:exc.reason level:LOGLEVEL_ERROR];
    }
    
    @try
    {
        self.socialNetworks = [self populateSocialNetworks];
    }
    @catch(NSException *exc)
    {
        [FileLog log:@"Couldnt fetch Socialnetworks" level:LOGLEVEL_ERROR];
        [FileLog log:exc.reason level:LOGLEVEL_ERROR];
    }
    
}

-(NSDictionary*) populateSocialNetworks
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    ABMultiValueRef socials = ABRecordCopyValue(self.record, kABPersonSocialProfileProperty);
    
    if (socials)
    {
        CFIndex socialsCount = ABMultiValueGetCount(socials);
        
        for (int k = 0 ; k < socialsCount ; k++)
        {
            CFDictionaryRef socialValue = ABMultiValueCopyValueAtIndex(socials, k);
                  
            NSString* username = (NSString*) CFDictionaryGetValue(socialValue, kABPersonSocialProfileUsernameKey);
            
            NSString* dictKey = [self stringForDict:CFDictionaryGetValue(socialValue, kABPersonSocialProfileServiceKey)];
            
            if(dictKey && username)
            {
                [dict setObject:username forKey:dictKey];
            }
                
            CFRelease(socialValue);
           
        }
        CFRelease(socials);
    }
    
    
    return dict;
}


-(NSString*) getString:(ABPropertyID) property
{
    NSString* string = (__bridge NSString *)(ABRecordCopyValue(self.record, property));
    return string ? string : @"";
}


-(NSString*) stringForDict:(CFStringRef) ref
{
    if(!ref)
    {
        return @"nullref";
    }
    else if(CFStringCompare(kABPersonSocialProfileServiceTwitter, ref, 0) == kCFCompareEqualTo)
    {
        return @"twitter";
    }
    else if(CFStringCompare(kABPersonSocialProfileServiceFacebook, ref, 0) == kCFCompareEqualTo)
    {
        return @"facebook";
    }
    else if(CFStringCompare(kABPersonSocialProfileServiceFlickr, ref, 0) == kCFCompareEqualTo)
    {
        return @"flickr";
    }
    else if(CFStringCompare(kABPersonSocialProfileServiceMyspace, ref, 0) == kCFCompareEqualTo)
    {
        return @"myspace";
    }
    else if(CFStringCompare(kABPersonSocialProfileServiceLinkedIn, ref, 0) == kCFCompareEqualTo)
    {
        return @"linkedin";
    }
    else
    {
        return (__bridge NSString*) ref;
    }
}

-(NSArray*) makePhoneNumbers
{
    NSMutableArray* ar = [NSMutableArray new];
    
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(self.record, kABPersonPhoneProperty);
    CFIndex count = ABMultiValueGetCount(phoneNumbers);
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: @"[^\\d]" options:0  error:nil];
    
    for(int i = 0; i < count; i++)
    {
        NSString* phone = (__bridge NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
        
        if(phone && phone.length > 0)
        {
            NSMutableString* mut = [phone mutableCopy];
            [regex replaceMatchesInString:mut options:0 range:NSMakeRange(0, phone.length) withTemplate:@""];
            
            while([mut characterAtIndex:0] == '0')
            {
                [mut replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
            }
            
            [ar addObject:mut];
        }
    }
    
    return ar;
}

-(NSArray*) makeEmails
{

    NSMutableArray* ar = [NSMutableArray new];
    
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(self.record, kABPersonEmailProperty);
    CFIndex count = ABMultiValueGetCount(phoneNumbers);
    
    for(int i = 0; i < count; i++)
    {
        NSString* email = (__bridge NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
        
        if(email)
        {
            [ar addObject:email.lowercaseString];
        }
    }
    
    return ar;
    
}


-(UIImage*) getImage
{
    NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(self.record);
    UIImage *img = [UIImage imageWithData:imgData];
    if (!img)
    {
        img = [UIImage imageNamed:@"noimage.png"];
    }
    return img;
}

-(void) updateImage:(UIImage*) newImage
{
    self.profileImage = newImage;
    
    CFErrorRef error;
    ABPersonSetImageData(self.record, (__bridge CFDataRef)UIImagePNGRepresentation(newImage), &error);
    
}


-(BOOL) doesPhoneMatchPerson:(NSString*) phonenumber
{
    @try
    {
        if([phonenumber rangeOfString:@"-"].location != NSNotFound)
        {
            NSInteger index = [phonenumber rangeOfString:@"-"].location;
            phonenumber = [phonenumber substringToIndex:index];
        }
        if([phonenumber rangeOfString:@"."].location != NSNotFound)
        {
            NSInteger index = [phonenumber rangeOfString:@"."].location;
            phonenumber = [phonenumber substringToIndex:index];
        }
        
        for(NSString* ph in self.phoneNumbers)
        {
            if([phonenumber rangeOfString:ph].location != NSNotFound)
            {
                return true;
            }
        }
    }
    @catch (NSException *exception)
    {
        [FileLog log:@"error matching phone number" level:LOGLEVEL_ERROR];
        [FileLog log:exception.description level:LOGLEVEL_ERROR];
    }
    
    
    return false;
}


- (NSString *)description
{
    if(self.company && self.company.length > 0)
    {
        return [NSString stringWithFormat:@"%@ %@ (%@)", self.firstName, self.lastName, self.company];
    }
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}


@end
