//
//  WAImageFinder.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 23.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASPerson.h"
#import "SQLController.h"

@interface WAImageFinder : NSObject


+(NSString*) contactsDB;

+(NSString*) contactsDBFullPath;


// ================================


+(NSString*) findWhatsappFolder;

+(NSArray*) imagesFromWAFolder:(NSString*) baseWAFolder;

+(NSArray*) thumbimagesFromFolder:(NSString*) baseFolder folder:(NSString*) folder;


+(NSArray*) thumbimagesFromWAFolder:(NSString*) baseWAFolder;

+(NSArray*) tempimagesFromWAFolder:(NSString*) baseWAFolder;


// ============


+(NSArray*) matchFotosInArrayToPeople:(NSArray*) photofiles;

+(NSString*) getRealNameFromProfilePicture:(NSString*) profilepicture sql:(SQLController**) sql;

+(NSString*) getWhatsappIDfromZWASTATUS:(NSString*) whereclause sql:(SQLController**) sql;

+(NSString*) getContactIDFROMZWAPHONE:(NSString*) whereclause sql:(SQLController**) sql;

+(NSString*) getFullNamefromZWACONTACT:(NSString*) whereclause sql:(SQLController**) sql;



+(UIImage*) getPhotoForPerson:(ASPerson*) person sql:(SQLController* __autoreleasing*) sql;

@end
