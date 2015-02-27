//
//  MultipleSelectController.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 03.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"
#import "BorderButton.h"

/**
 *  only for this class to remember the clicked section
 */
@interface UIButtonRememberSection : BorderButton

@property (nonatomic) NSInteger section;
@property (nonatomic,retain) id person;

@end


@interface MultipleSelectController : AbstractTableViewController

-(id) initWithPersonsImages:(NSArray*) personsAndImages;

@end
