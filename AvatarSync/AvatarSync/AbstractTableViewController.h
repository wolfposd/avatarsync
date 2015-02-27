//
// AvatarSync
// Copyright (C) 2014-2015  Wolf Posdorfer
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
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
