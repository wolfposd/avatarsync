//
//  SettingsController.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 03.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "SettingsController.h"
#import "AbstractAction.h"
#import "FacebookSettingsAction.h"
#import "FileLog.h"
#import "SelectionCell.h"
#import "Settings.h"


@interface SettingsController ()<SelectionToggled>


@property(nonatomic,retain) NSMutableArray* actions;

@end

@implementation SettingsController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self makeHeaderWithSize:self.view.frame.size text1:NSLocalizedString(@"Settings",nil) text2:NSLocalizedString(@"Configure your stuff",nil)];
    
    _actions = [NSMutableArray new];
    [_actions addObject:[NSMutableArray new]];
    [_actions addObject:[NSMutableArray new]];
    
    [_actions[0] addObject:@[@"placeholder", @"placeholder"]];
    
    [_actions[1] addObject:@[[FileLog getFilePath], @"Logpath"]];
    [_actions[1] addObject:@[[FileLog loglevelasString], @"Loglevel"]];
    
   // [_actions addObject:[FacebookSettingsAction new]];
   // [self.tableView reloadData];
    
   // [self makeFooter];
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void) makeFooter
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    

    self.tableView.tableFooterView = view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 65;
    }
    else
    {
        return 48;
    }
}



#pragma mark - Table view data source


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.actions.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    if(indexPath.section == 0)
    {
        
        SelectionCell* scell = [tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if(!scell)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectionCell" owner:self options:nil];
            scell = [nib objectAtIndex:0];
        }
        scell.selectionLabel.text = NSLocalizedString(@"WhatsApp Thumbnails",nil);
        scell.selectionImage.image = [UIImage imageNamed:@"whatsapp.png"];
        scell.selectiondelegate = self;
        scell.selectionDetailLabel.text = NSLocalizedString(@"Include thumbnails in multiple?",nil);
        scell.selectionSwitch.on = [Settings isWhatsAppMultipleIncludeThumbnail];
        cell = scell;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"standard"];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"standard"];
        }

        
        cell.textLabel.text = self.actions[indexPath.section][indexPath.row][1];
        cell.detailTextLabel.text = self.actions[indexPath.section][indexPath.row][0];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        AbstractAction* action = self.actions[indexPath.section][indexPath.row];
        
        [action actionBeenClickedBy:self];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.actions[section] count];
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Settings";
    }
    else
    {
        return @"Debug-Info";
    }
}


#pragma mark - SelectionToggled

-(void) selectionStateChanged:(BOOL)isSelected forIndex:(NSInteger)index
{
    [Settings setisWhatsAppMultipleIncludeThumbnail:isSelected];
}


@end
