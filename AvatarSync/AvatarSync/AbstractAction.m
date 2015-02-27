//
//  AbstractAction.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 07.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "AbstractAction.h"

@implementation AbstractAction


- (instancetype)init
{
    self = [super init];
    if (self) {
        _text = @"";
    }
    return self;
}

-(void) actionBeenClickedBy:(UIViewController*) con
{
    // nothing
}

@end
