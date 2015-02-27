//
//  BigImageCell.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 23.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
@property (weak, nonatomic) IBOutlet UILabel *bigLabel;

@end
