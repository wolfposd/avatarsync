//
//  AddressbookSQL.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 10.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressbookSQL : NSObject

-(void) printNames;


-(NSArray*) getUsersFromDB;

@end
