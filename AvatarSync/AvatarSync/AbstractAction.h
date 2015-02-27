//
//  AbstractAction.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 07.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AbstractAction : NSObject


@property (nonatomic, retain) NSString* text;


-(void) actionBeenClickedBy:(UIViewController*) con;

@end
