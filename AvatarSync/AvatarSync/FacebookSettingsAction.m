#//
//  FacebookSettingsAction.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 07.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "FacebookSettingsAction.h"
#import "FacebookLoginViewController.h"

@implementation FacebookSettingsAction



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.text = @"Facebook Login";
    }
    return self;
}




-(void)actionBeenClickedBy:(UIViewController *)con
{
    [con.navigationController pushViewController:[[FacebookLoginViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
}



@end
