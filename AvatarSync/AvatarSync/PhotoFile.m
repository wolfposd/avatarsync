//
//  PhotoFile.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 24.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "PhotoFile.h"


@implementation PhotoFile

+(id) photoFile:(NSString*) filename image:(UIImage*) image
{
    
    PhotoFile* f = [PhotoFile new];
    f.image = image;
    f.filename = filename;
    return f;
}


@end
