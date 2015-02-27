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

#import <UIKit/UIKit.h>
#import "FacebookMessenger.h"
#import "AbstractFolderFinder.h"
#import "SQLController.h"


@implementation FacebookMessenger




+(NSString*) facebookMessengerBasePath
{
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[vComp objectAtIndex:0] intValue] < 8)
    {
        return [AbstractFolderFinder findBaseFolderIOS7:@"messenger.app"];
    }
    else
    {
        return [AbstractFolderFinder findBaseFolderIOS8:@"facebook.messenger"];
    }
}


+(NSString*) facebookBasePath
{
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[vComp objectAtIndex:0] intValue] < 8)
    {
        return [AbstractFolderFinder findBaseFolderIOS7:@"facebook.app"];
    }
    else
    {
        return [AbstractFolderFinder findBaseFolderIOS8:@"facebook.facebook"];
    }
}



// /Library/Caches/_store_2FF78168-FD5B-4F3A-8FE3-A60861208150/8.1_iphone_de_de_DE_messenger_contacts_v1/fbsyncstore.db


+(NSString*) fbIdforUserMessenger:(ASPerson*) person
{
    return [self fbIdforUser:person forPath: [self findContactsDBPathMessenger]];
}
+(NSString*) fbIdforUserApp:(ASPerson*) person
{
    return [self fbIdforUser:person forPath: [self findContactsDBPathApp]];
}


+(NSString*)fbIdforUser:(ASPerson*) person sql:(id*) sql
{
    NSString* whereString = [NSString stringWithFormat:@"first = '%@' AND last = '%@'", person.firstName, person.lastName];
    NSArray* results = [(*sql) selectAllFrom:@"people" where:whereString];
    if(results.count > 0)
    {
        return results[0][@"person_id"];
    }
    
    
    return nil;
}



+(UIImage*) downloadImageForUserId:(NSString*) userID
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",userID]];
    
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    return image;

}

+(NSString*) findContactsDBPathMessenger
{
    return [self findContactsDBPathfor:[self facebookMessengerBasePath]];
}

+(NSString*) findContactsDBPathApp
{
    return [self findContactsDBPathfor:[self facebookBasePath]];
}



#pragma mark - private accessors


+(NSString*) findContactsDBPathfor:(NSString*) FBAPPBASEPATH
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    
    NSString* basePath = [FBAPPBASEPATH stringByAppendingString:@"/Library/Caches"];
    NSError *error;
    NSArray *folders = [manager contentsOfDirectoryAtPath:basePath error:&error];
    
    if (!error)
    {
        for (NSString *folder in folders)
        {
            if([folder rangeOfString:@"_store"].location != NSNotFound )
            {
                NSString* fPath = [[basePath stringByAppendingString:@"/"] stringByAppendingString:folder];
                NSArray* subFolders = [manager contentsOfDirectoryAtPath:fPath error:&error];
                
                for(NSString* subfolder in subFolders)
                {
                    if([subfolder rangeOfString:@"messenger_contacts_v1"].location != NSNotFound)
                    {
                        NSString* fullpath = [NSString stringWithFormat:@"%@/%@/%@/fbsyncstore.db",basePath, folder, subfolder];
                        return fullpath;
                    }
                }
                
            }
        }
    }
    
    return nil;
}


+(NSString*) fbIdforUser:(ASPerson*) person forPath:(NSString*) FBAPPBASEPATH
{
    SQLController* con = [SQLController sqlControllerWithFile:FBAPPBASEPATH];
    
    NSString* result = [self fbIdforUser:person sql:&con];
    
    [con closeDb];
    
    return result;
}

@end
