//
//  TwitterDownload.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleDownloadProtocol.h"
#import "ASPerson.h"

@interface TwitterDownload : NSObject<SingleDownloadDelegate>


-(id) initWithPerson:(ASPerson*) person;


@end
