//
//  FacebookMessengerTableFeed.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 08.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericTableProtocol.h"
#import "AbstractGenericTableDelegate.h"

@interface FacebookMessengerTableFeed : AbstractGenericTableDelegate <GenericTableDelegate>

-(id) initWithContact:(ASPerson *)person isFacebookApp:(BOOL) isFacebook;


@end
