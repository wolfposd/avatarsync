//
//  Settings.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 28.01.15.
//  Copyright (c) 2015 Wolf Posdorfer. All rights reserved.
//

#import "Settings.h"

#define KEY_WHATSAPPMULTIPLETHUMBNAIL @"WhatsAppMultipleIncludeThumbnail"

@implementation Settings




+(BOOL) isWhatsAppMultipleIncludeThumbnail
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:KEY_WHATSAPPMULTIPLETHUMBNAIL];
}


+(void) setisWhatsAppMultipleIncludeThumbnail:(BOOL) include
{
    [[NSUserDefaults standardUserDefaults] setBool:include forKey:KEY_WHATSAPPMULTIPLETHUMBNAIL];
}



@end
