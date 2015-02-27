//
//  WAImageFinder.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 23.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAImageFinder.h"
#import "PhotoFile.h"
#import "FileLog.h"
#import "AbstractFolderFinder.h"

@implementation WAImageFinder



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
    NSString* path = [self findWhatsappFolder];
    if(path)
    {
        if([path rangeOfString:@"Shared"].location != NSNotFound)
        {
            return [NSString stringWithFormat:@"%@/%@", path, [self contactsDBShared]];
        }
        else
        {
            return [NSString stringWithFormat:@"%@/%@", path, [self contactsDB]];
        }
    }
    return nil;
}


+(NSString*) findWhatsappFolder
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
        if([imageFile rangeOfString:extension].location != NSNotFound)
        {
            NSString* imagepath = [NSString stringWithFormat:@"%@/%@",dir,imageFile];
            UIImage* image = [UIImage imageWithContentsOfFile:imagepath];
            if(image)
            {
                PhotoFile* f = [PhotoFile photoFile:imageFile image:image];
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


+(NSArray*) thumbimagesFromWAFolder:(NSString*) baseWAFolder
{
    if([self isSharedFolder:baseWAFolder])
        return [self thumbimagesFromFolder:baseWAFolder folder:@"/Media/Profile"];
    else
        return [self thumbimagesFromFolder:baseWAFolder folder:@"/Library/Media/Profile"];
}

+(NSArray*) imagesFromWAFolder:(NSString*) baseWAFolder
{
    if([self isSharedFolder:baseWAFolder])
        return [self imagesFromFolder:baseWAFolder folder:@"/Media/Profile"];
    else
        return [self imagesFromFolder:baseWAFolder folder:@"/Library/Media/Profile"];
}

+(NSArray*) tempimagesFromWAFolder:(NSString*) baseWAFolder
{
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


+(UIImage*) getPhotoForPerson:(ASPerson*) person sql:(SQLController*__autoreleasing*) sql
{
    NSString* path = [self getPhotoPathForPerson:person sql:sql];
    if(path)
    {
        path = [NSString stringWithFormat:@"%@/Library/%@.jpg",[WAImageFinder findWhatsappFolder], path];
        return [UIImage imageWithContentsOfFile:path];
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



@end
