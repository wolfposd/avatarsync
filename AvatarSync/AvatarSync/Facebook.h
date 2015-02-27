//
//  Facebook.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 26.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASPerson.h"
#import "SingleDownloadProtocol.h"

@interface Facebook : NSObject<SingleDownloadDelegate>


-(id) initWithPerson:(ASPerson*) person;

@end
