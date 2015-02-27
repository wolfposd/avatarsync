//
//  GenericTableViewController.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 23.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTableProtocol.h"


@interface GenericTableViewController : UITableViewController<GenericTableOwner>



-(id) initWithDelegate:(id<GenericTableDelegate>) delegate;


@end
