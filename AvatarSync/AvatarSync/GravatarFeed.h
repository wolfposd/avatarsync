//
//  GravatarFeed.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractGenericTableDelegate.h"
#import "GenericTableProtocol.h"
#import "PhotoFile.h"

@interface GravatarFeed : AbstractGenericTableDelegate

+(PhotoFile*) loadImageForEmail:(NSString*) email;

@end
