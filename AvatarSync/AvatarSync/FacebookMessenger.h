//
//  FacebookMessenger.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 08.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASPerson.h"

@interface FacebookMessenger : NSObject


+(NSString*) facebookMessengerBasePath;
+(NSString*) facebookBasePath;


// /Library/Caches/_store_2FF78168-FD5B-4F3A-8FE3-A60861208150/8.1_iphone_de_de_DE_messenger_contacts_v1/fbsyncstore.db



+(NSString*) fbIdforUserMessenger:(ASPerson*) person;

+(NSString*) fbIdforUserApp:(ASPerson*) person;

+(NSString*) fbIdforUser:(ASPerson*) person sql:(id*) controller;


+(NSString*) findContactsDBPathMessenger;

+(NSString*) findContactsDBPathApp;

+(UIImage*) downloadImageForUserId:(NSString*) userID;

@end
