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
