//
//  ViewController.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 23.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
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
