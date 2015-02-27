//
//  SelectionCell.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 03.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectionToggled <NSObject>

-(void) selectionStateChanged:(BOOL) isSelected forIndex:(NSInteger) index;

@end


@interface SelectionCell : UITableViewCell

@property (weak,nonatomic) id<SelectionToggled> selectiondelegate;

@property (weak, nonatomic) IBOutlet UIImageView *selectionImage;
@property (weak, nonatomic) IBOutlet UILabel *selectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectionDetailLabel;
@property (weak, nonatomic) IBOutlet UISwitch *selectionSwitch;

@property (nonatomic) NSInteger currentIndex;

@end
