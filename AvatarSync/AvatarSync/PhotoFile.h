//
//  PhotoFile.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 24.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface PhotoFile : NSObject


@property (nonatomic,retain) UIImage* image;
@property (nonatomic,retain) NSString* filename;

+(id) photoFile:(NSString*) filename image:(UIImage*) image;

@end
