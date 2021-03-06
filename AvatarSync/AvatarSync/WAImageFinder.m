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
#import "WAImageFinder.h"
#import "PhotoFile.h"
#import "FileLog.h"
#import "AbstractFolderFinder.h"
#import "FileUtility.h"
#import "NSString+Base64.h"

@interface WAImageFinder ()
@property (nonatomic,retain) NSString* folderPath;
@end


@implementation WAImageFinder



#pragma mark - private

- (instancetype)init
{
    self = [super init];
    if (self) {
        _folderPath = [WAImageFinder searchFolder];
    }
    return self;
}

+(NSString*) searchFolder
{
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[vComp objectAtIndex:0] intValue] < 8)
    {
        return [AbstractFolderFinder findBaseFolderIOS7:@"whatsapp"];
    }
    else
    {
        NSString* other =  [AbstractFolderFinder findSharedFolderIOS8:@"whatsapp"];
        if(!other)
        {
            return [AbstractFolderFinder findBaseFolderIOS8:@"whatsapp"];
        }
        else
        {
            return other;
        }
    }
}

#pragma mark - public


+(BOOL)isInstalled
{
    return [self instance].folderPath != nil;
}

+(WAImageFinder *)instance
{
    static WAImageFinder *myInstance = nil;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        myInstance = [[WAImageFinder alloc] init];
    });
    return myInstance;
}



+(NSString*) contactsDB
{
    return @"Documents/Contacts.sqlite";
}

+(NSString*) contactsDBShared
{
    return @"Contacts.sqlite";
}


+(NSString*) contactsDBFullPath
{
    NSString* path = [self instance].folderPath;
    if(path)
    {
        if([path rangeOfString:@"Shared"].location != NSNotFound)
        {
            return [NSString stringWithFormat:@"%@/%@", path, [self contactsDBShared]];
        }
        else
        {
            NSString* string = [NSString stringWithFormat:@"%@/%@", path, [self contactsDB]];
            return string;
        }
    }
    return nil;
}


+(NSArray*) imagesFromFolder:(NSString*) baseFolder folder:(NSString*) folder
{
    return [self imagesFromFolder:baseFolder folder:folder extension:@".jpg"];
}

+(NSArray*) thumbimagesFromFolder:(NSString*) baseFolder folder:(NSString*) folder
{
    return [self imagesFromFolder:baseFolder folder:folder extension:@".thumb"];
}

+(NSArray*) imagesFromFolder:(NSString*) baseFolder folder:(NSString*) folder extension:(NSString*) extension
{
    NSString* dir = [baseFolder stringByAppendingString:folder];
    
    NSMutableArray* images = [NSMutableArray new];
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *error;
    NSArray *files = [manager contentsOfDirectoryAtPath:dir error:&error];
    
    for(NSString* imageFile in files)
    {
        // check if extension mathces with given extension
        // check if its not a group-image (they contain 2 x "-" )
        if([imageFile rangeOfString:extension].location != NSNotFound && [imageFile countOccurencesOfString:@"-"] < 2)
        {
            NSString* imagepath = [NSString stringWithFormat:@"%@/%@",dir,imageFile];
            if(imagepath)
            {
                PhotoFile* f = [PhotoFile photoFile:imageFile filepath:imagepath];
                [images addObject:f];
            }
        }
    }
    
    return images;
}


+(BOOL) isSharedFolder:(NSString*) path
{
    return [path rangeOfString:@"Shared"].location != NSNotFound;
}

+(BOOL) isSharedFolder
{
    return [[self instance].folderPath rangeOfString:@"Shared"].location != NSNotFound;
}


+(NSArray*) thumbimagesFromWAFolder
{
    NSString* baseWAFolder = [self instance].folderPath;
    if([self isSharedFolder:baseWAFolder])
        return [self thumbimagesFromFolder:baseWAFolder folder:@"/Media/Profile"];
    else
        return [self thumbimagesFromFolder:baseWAFolder folder:@"/Library/Media/Profile"];
}

+(NSArray*) imagesFromWAFolder
{
    NSString* baseWAFolder = [self instance].folderPath;
    if([self isSharedFolder:baseWAFolder])
        return [self imagesFromFolder:baseWAFolder folder:@"/Media/Profile"];
    else
        return [self imagesFromFolder:baseWAFolder folder:@"/Library/Media/Profile"];
}

+(NSArray*) tempimagesFromWAFolder
{
    NSString* baseWAFolder = [self instance].folderPath;
    return [self imagesFromFolder:baseWAFolder folder:@"/Library/Caches/ProfilePictures"];
}


+(NSArray*) matchFotosInArrayToPeople:(NSArray*) photofiles
{
    SQLController* sql = [SQLController sqlControllerWithFile:[WAImageFinder contactsDBFullPath]];
    
    for(PhotoFile* pf in photofiles)
    {
        NSString* filename = pf.filename;
        NSRange index  = [filename rangeOfString:@".jpg"];
        if(index.location != NSNotFound)
        {
            filename = [filename substringWithRange:NSMakeRange(0,index.location - 1 )];
            NSString* realname = [self getRealNameFromProfilePicture:filename sql:&sql];
            if(realname)
            {
                pf.filename = realname;
            }
        }
    }
    
    [sql closeDb];
    return photofiles;
}


+(NSString*) getRealNameFromProfilePicture:(NSString*) profilepicture sql:(SQLController**) sql
{
    NSString* whatsappidforuser = [self getWhatsappIDfromZWASTATUS:[NSString stringWithFormat:@"ZPICTUREPATH LIKE '%%%@%%'", profilepicture] sql:sql];
    if(whatsappidforuser)
    {
        NSString* contactid = [self getContactIDFROMZWAPHONE:[NSString stringWithFormat:@"ZWHATSAPPID = '%@'", whatsappidforuser] sql:sql];
        if(contactid)
        {
            return [self getFullNamefromZWACONTACT:[NSString stringWithFormat:@"Z_PK = %@", contactid] sql:sql];
        }
    }
    return nil;
}


+(NSString*) getWhatsappIDfromZWASTATUS:(NSString*) whereclause sql:(SQLController**) sql
{
    NSString* whatsappid = nil;
    
    NSLog(@"%@", @"before error?");
    NSArray* results = [*sql selectAllFrom:@"ZWASTATUS" where:whereclause];
    
    if(results.count > 0)
    {
        whatsappid = results[0][@"ZWHATSAPPID"];
    }
    
    return whatsappid;
}

+(NSString*) getContactIDFROMZWAPHONE:(NSString*) whereclause sql:(SQLController**) sql
{
    NSString* contactid = nil;
    
    NSArray* results = [*sql selectAllFrom:@"ZWAPHONE" where:whereclause];
    if(results.count > 0)
    {
        contactid = results[0][@"ZCONTACT"];
    }
    
    return contactid;
}

+(NSString*) getFullNamefromZWACONTACT:(NSString*) whereclause sql:(SQLController**) sql
{
    NSString* realname = nil;
    NSArray* results = [*sql selectAllFrom:@"ZWACONTACT" where:whereclause];
    
    if(results.count > 0 )
    {
        realname = results[0][@"ZFULLNAME"];
    }
    return realname;
}


+(NSString*) getPhotoForPerson:(ASPerson*) person sql:(SQLController*__autoreleasing*) sql
{
    NSString* path = [self getPhotoPathForPerson:person sql:sql];
    if(path)
    {
        if([self isSharedFolder])
        {
            path = [NSString stringWithFormat:@"%@/%@.jpg",[self instance].folderPath, path];
        }
        else
        {
            path = [NSString stringWithFormat:@"%@/Library/%@.jpg",[self instance].folderPath, path];
        }

        if([FileUtility checkIfFileExistsAtPath:path])
            return path;
    }
    return nil;
}


/**
 *  Does a reverse lookup of picture path by user name
 *
 *  @param person person to look for firstname/lastname
 *  @param sql    sql controller reference
 *
 *  @return path or nil
 */
+(NSString*) getPhotoPathForPerson:(ASPerson*) person sql:(SQLController**) sql
{
    NSString* result = nil;
    
    // SELECT * FROM ZWACONTACT WHERE ZFIRSTNAME = 'firstname' AND ZFULLNAME LIKE '%lastname%'
    NSArray* resultquery = [*sql selectAllFrom:@"ZWACONTACT" where:[NSString stringWithFormat:@"ZFIRSTNAME = '%@' AND ZFULLNAME LIKE '%%%@%%'", person.firstName, person.lastName]];
    
    if(resultquery.count == 1)
    {
        NSString* ZPK = resultquery[0][@"Z_PK"];
        if(ZPK)
        {
            NSArray* resultarray2 = [*sql selectAllFrom:@"ZWAPHONE" where:[NSString stringWithFormat:@"ZCONTACT = '%@'",ZPK]];
            if(resultarray2.count == 1)
            {
                NSString* ZWHATSAPPID = resultarray2[0][@"ZWHATSAPPID"];
                if(ZWHATSAPPID)
                {
                    NSArray* pictures = [*sql selectAllFrom:@"ZWASTATUS" where:[NSString stringWithFormat:@"ZWHATSAPPID = '%@'",ZWHATSAPPID]];
                    if(pictures.count == 1)
                    {
                        result = pictures[0][@"ZPICTUREPATH"];
                    }
                }
            }
            
        }
    }
    
    return result;
}


+(NSArray*) getImagesFromWADB:(ASPerson*) person sql:(SQLController**) sql
{
    NSMutableArray* matchingImages = [NSMutableArray new];
    
    NSString* path = [self instance].folderPath;
    NSString* dbpath = [WAImageFinder contactsDBFullPath];
    if(dbpath)
    {
        NSMutableArray* picturePaths = [NSMutableArray new];
        
        for (NSString* fone in person.phoneNumbers)
        {
            if(fone.length > 4)
            {
                NSString* where2 = [NSString stringWithFormat:@"ZWHATSAPPID LIKE '%%%@%%'", fone];
                NSArray* medias = [*sql selectAllFrom:@"ZWASTATUS" where:where2];
                
                for(NSDictionary* row in medias)
                {
                    NSString* picpath = row[@"ZPICTUREPATH"];
                    if(picpath)
                    {
                        [picturePaths addObject:picpath];
                    }
                }
            }
        }

        for(NSString* pp in picturePaths)
        {
            NSString* imagePath = nil;
            if([self isSharedFolder])
            {
                imagePath = [NSString stringWithFormat:@"%@/%@.jpg",path, pp];
            }
            else
            {
                imagePath = [NSString stringWithFormat:@"%@/Library/%@.jpg",path, pp];
            }

            if(imagePath && [FileUtility checkIfFileExistsAtPath:imagePath])
            {
                PhotoFile* pf = [PhotoFile photoFile:@"WhatsApp" filepath:imagePath];
                [matchingImages addObject:pf];
            }
        }
        
        if(matchingImages.count == 0)
        {
            NSString* profileDir = [NSString stringWithFormat:@"%@/Media/Profile",path];
            for(NSString* fone in person.phoneNumbers)
            {
                NSArray* result = [FileUtility getClosestMatchingFiles:profileDir contains:fone notContains:@".thumb"];
                for(NSString* filepath in result)
                {
                    NSUInteger countDashes = [filepath countOccurencesOfString:@"-"];
                    
                    if(countDashes < 6)
                    {
                        PhotoFile* pf = [PhotoFile photoFile:@"WhatsApp" filepath:filepath];
                        [matchingImages addObject:pf];
                    }
                    
                }
            }
        }
        
        
    }
    return matchingImages;
}



@end
