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

#import "ViewController.h"
#import "ContactsTableViewController.h"
#import "FileLog.h"
#import "MultipleBaseTableViewController.h"
#import "SettingsController.h"


@implementation ViewController


-(void) viewDidAppear:(BOOL)animated
{
    [FileLog log:@"starting app with ViewController" level:LOGLEVEL_DEBUG];

    [self startup];
    
}

-(void) startup
{    
    ContactsTableViewController* t = [[ContactsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:t];
    nav1.tabBarItem.image = [UIImage imageNamed:@"single"];
    t.title = NSLocalizedString(@"Single",nil);
    
    MultipleBaseTableViewController* m = [[MultipleBaseTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:m];
    nav2.tabBarItem.image = [UIImage imageNamed:@"multiple"];
    m.title  = NSLocalizedString(@"Multiple",nil);
    
    
    SettingsController* s = [[SettingsController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:s];
    nav3.tabBarItem.image = [UIImage imageNamed:@"cog"];
    s.title = NSLocalizedString(@"Settings",nil);
    

    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:1.0 green:0.0 blue:0 alpha:1]];
    UITabBarController* tabbar = [[UITabBarController alloc] init];
    [tabbar addChildViewController:nav1];
    [tabbar addChildViewController:nav2];
    [tabbar addChildViewController:nav3];
    
    
    [self presentViewController:tabbar animated:NO completion:^(){}];
}





@end
