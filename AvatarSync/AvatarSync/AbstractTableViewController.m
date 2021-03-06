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

#import "AbstractTableViewController.h"

@interface AbstractTableViewController ()

@end

@implementation AbstractTableViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self makeHeader];
}

-(void) makeFooter:(CGSize) size
{
    
}

-(void) makeHeaderWithSize:(CGSize) size
{
    [self makeHeaderWithSize:size text1:nil text2:nil];
}

-(void) makeHeader
{
    [self makeHeaderWithSize:self.view.frame.size];
}

-(void) makeHeaderWithSize:(CGSize) size text1:(NSString*) text1 text2:(NSString*) text2
{
    float width = size.width;
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 60+75)];
    
    UILabel* header = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, width-80, 75)];
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont fontWithName:@"Gill Sans" size:37];
    header.backgroundColor = [UIColor whiteColor];
    
    
    if(self.headerTitleLabel)
    {
        header.text = self.headerTitleLabel.text;
        header.textColor = self.headerTitleLabel.textColor;
    }
    else
    {
        header.textColor = [UIColor blackColor];
        header.text = text1;
    }

    
    UILabel* desc = [[UILabel alloc] initWithFrame:CGRectMake(40, 75, width-80, 60)];
    desc.textAlignment = NSTextAlignmentCenter;
    desc.font = [UIFont fontWithName:@"Helvetica" size:16];
    desc.backgroundColor = [UIColor whiteColor];
    desc.numberOfLines = 4;
    desc.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    if(self.headerDescriptionLabel)
    {
        desc.text = self.headerDescriptionLabel.text;
        desc.textColor = self.headerDescriptionLabel.textColor;
    }
    else
    {
        desc.textColor = [UIColor blackColor];
        desc.text = text2;
    }
    
    
    [view addSubview:header];
    [view addSubview:desc];
    
    self.headerDescriptionLabel = desc;
    self.headerTitleLabel = header;
    
    view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = view;
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if(self.navigationController.topViewController == self)
    {
        [self makeHeaderWithSize:size];
        [self makeFooter:size];
    }
}


-(DeviceOrientation) currentOrientation
{
    if([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height)
    {
        return kDeviceOrientationPortrait;
    }
    else{
        return kDeviceOrientationLandscape;
    }
}


-(DeviceOrientation) getOrientation:(CGSize) size
{
    if(size.width < size.height)
    {
        return kDeviceOrientationPortrait;
    }
    else{
        return kDeviceOrientationLandscape;
    }
}



@end
