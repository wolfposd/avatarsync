//
//  SingleDownloadViewController.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASPerson.h"
#import "SingleDownloadProtocol.h"

@interface SingleDownloadViewController : UIViewController<SingleDownloadOwner>


-(id) initWithPerson:(ASPerson*) person andDelegate:(id<SingleDownloadDelegate>) delegate;

@end
