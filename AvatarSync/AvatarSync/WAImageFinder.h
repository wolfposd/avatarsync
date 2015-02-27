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
