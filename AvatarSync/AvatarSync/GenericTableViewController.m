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

#import "GenericTableViewController.h"
#import "BigImageCell.h"

@interface GenericTableViewController ()<UIAlertViewDelegate>

@property (nonatomic, retain) id<GenericTableDelegate> delegate;

@end

@implementation GenericTableViewController



-(id) initWithDelegate:(id<GenericTableDelegate>) delegate
{
    self = [self initWithStyle:UITableViewStylePlain];
    if(self)
    {
        _delegate = delegate;
        
        if([_delegate respondsToSelector:@selector(setOwner:)])
        {
            [_delegate setOwner:self];
        }
    }
    return self;
}


-(void) reloadTableData
{
    [self makeHeader];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [self.delegate navTitle];
    [self makeHeader];
    
    if([self.delegate respondsToSelector:@selector(controllerWillAppear)])
    {
        [self.delegate controllerWillAppear];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if([self.delegate respondsToSelector:@selector(controllerWillDisapper)])
    {
        [self.delegate controllerWillDisapper];
    }
}

-(void) makeHeader
{
    [self makeHeaderWithSize:self.view.bounds.size];
}

-(void) makeHeaderWithSize:(CGSize) size
{
    float width = size.width;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 120)];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, width, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:22];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.text = [self.delegate titleForHeader];
    
    
    UILabel* desc = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, width, 60)];
    desc.textAlignment = NSTextAlignmentCenter;
    desc.font = [UIFont fontWithName:@"Helvetica" size:16];
    desc.backgroundColor = [UIColor whiteColor];
    desc.textColor = [UIColor blackColor];
    desc.numberOfLines = 4;
    desc.lineBreakMode = NSLineBreakByWordWrapping;
    desc.text = [self.delegate descriptionForHeader];
    
    
    [view addSubview:label];
    [view addSubview:desc];
    
    view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = view;

}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if(self.navigationController.topViewController == self)
    {
        [self makeHeaderWithSize:size];
    }
}


#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.delegate numberOfSections];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.delegate titleForSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.delegate)
    {
        return [self.delegate numberOfRowsInSection:section];
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BigImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BigImageCell"];
    
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BigImageCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(self.delegate)
    {
        [self.delegate updateCell:&cell atIndex:indexPath];
    }

    
    return cell;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate)
    {
        [self.delegate clickedIndexAt:indexPath from:self];
    }
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([self.delegate respondsToSelector:@selector(alertViewClickedButtonAtIndex:controller:)])
    {
        [self.delegate alertViewClickedButtonAtIndex:buttonIndex controller:self];
    }
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
