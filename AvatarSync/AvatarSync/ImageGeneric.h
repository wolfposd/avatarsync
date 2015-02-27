//
//  ImageGeneric.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericTableProtocol.h"
#import "AbstractGenericTableDelegate.h"

@interface ImageGeneric : AbstractGenericTableDelegate <GenericTableDelegate>

-(id) initWithContact:(ASPerson *)person andPhotofiles:(NSArray*) photofiles;

@end
