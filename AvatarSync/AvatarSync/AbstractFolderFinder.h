//
//  AbstractFolderFinder.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 08.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractFolderFinder : NSObject


+(NSString*) findSharedFolderIOS8:(NSString*) appName;

+(NSString*) findBaseFolderIOS8:(NSString*) appName;


+(NSString*) findBaseFolderIOS7:(NSString*) appName;


@end
