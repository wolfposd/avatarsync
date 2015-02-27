//
//  AbstractTableViewController.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 03.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum : NSUInteger {
    kDeviceOrientationPortrait,
    kDeviceOrientationLandscape,
} DeviceOrientation;


@interface AbstractTableViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UILabel* headerTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel* headerDescriptionLabel;


-(void) makeFooter:(CGSize) size;
-(void) makeHeader;
-(void) makeHeaderWithSize:(CGSize) size;
-(void) makeHeaderWithSize:(CGSize) size text1:(NSString*) text1 text2:(NSString*) text2;

-(DeviceOrientation) currentOrientation;
-(DeviceOrientation) getOrientation:(CGSize) size;

@end
