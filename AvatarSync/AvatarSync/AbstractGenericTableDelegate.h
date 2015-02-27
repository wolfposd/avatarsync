//
//  AbstractGenericTableDelegate.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericTableProtocol.h"
#import "ASPerson.h"

@interface AbstractGenericTableDelegate : NSObject <GenericTableDelegate>

@property (nonatomic, retain) ASPerson* person;
@property (nonatomic,retain) NSIndexPath* lastClickedIndex;


-(void) showAskAlert:(UIViewController*) controller;

@end
