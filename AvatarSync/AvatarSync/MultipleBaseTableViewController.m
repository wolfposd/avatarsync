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

#import "MultipleBaseTableViewController.h"
#import "WhatsAppMultipleMatcher.h"
#import "SelectionCell.h"
#import "BorderButton.h"
#import "AddressbookManager.h"
#import "MultipleSelectController.h"

#import "FileLog.h"

#import "FacebookMultipleMatcher.h"
#import "FacebookMessengerMultipleMatcher.h"
#import "GravatarMultipleMatcher.h"
#import "DickButtMultipleMatcher.h"


@interface MultipleBaseTableViewController ()<SelectionToggled, AddressbookManagerDelegate>

@property (nonatomic, retain) NSMutableArray* matchers;
@property (nonatomic, retain) AddressbookManager* addressbookManager;


@property (nonatomic, weak) IBOutlet UILabel* statusLabel;

@end

@implementation MultipleBaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.addressbookManager = [AddressbookManager instance];
    
    _matchers = [NSMutableArray new];
    
    [self.matchers addObject:[WhatsAppMultipleMatcher new]];
    [self.matchers addObject:[FacebookMultipleMatcher new]];
    [self.matchers addObject:[FacebookMessengerMultipleMatcher new]];
    [self.matchers addObject:[GravatarMultipleMatcher new]];
    [self.matchers addObject:[DickButtMultipleMatcher new]];
   
    
    [self makeHeaderWithSize:self.view.frame.size text1:@"AvatarSync" text2:NSLocalizedString(@"Select sources to look for images\n\nAfterwards select images to apply",nil)];
    
    [self makeFooter:self.view.frame.size];
}


-(void) makeFooter:(CGSize) size
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 150)];
    
    BorderButton* button = [[BorderButton alloc] initWithFrame:CGRectMake(40, 20, size.width-80, 40)];

    [button setTitle:NSLocalizedString(@"Start matching",nil) forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [button setNeedsDisplay];
    
    [button addTarget:self action:@selector(startButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, size.width-20, 60)];
    
    label.numberOfLines = 3;
    label.textAlignment = NSTextAlignmentCenter;
    
    
    [view addSubview:button];
    [view addSubview:label];
    
    
    self.statusLabel = label;
    self.tableView.tableFooterView = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.statusLabel)
    {
        self.statusLabel.text = @"";
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.matchers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
    
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectiondelegate = self;
    cell.currentIndex = indexPath.row;
    
    
    NSObject<MatchingDelegate>* del = self.matchers[indexPath.row];
    
    cell.selectionImage.image = [del imageForMatcher];
    cell.selectionLabel.text = [del textForMatcher];
    cell.selectionSwitch.on = del.isChecked;
    
    
    if([del respondsToSelector:@selector(textDetailForMatcher)])
    {
        cell.selectionDetailLabel.text = [del textDetailForMatcher];
    }
    else{
        cell.selectionDetailLabel.text = @"";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)didReceiveMemoryWarning
{
    [FileLog log:@"MultipleBase has received Memory Warning" level:LOGLEVEL_ERROR];
}

-(void)selectionStateChanged:(BOOL)isSelected forIndex:(NSInteger)index
{
    NSObject<MatchingDelegate>* del = self.matchers[index];
    del.isChecked = isSelected;
}


-(void) startButtonTouched:(id) sender
{
    
    [sender setEnabled:false];
    
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.matchers.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^()
    {
        NSMutableArray* personsAndImages = [NSMutableArray new];
        
        NSInteger countImages = 0;
        for(ASPerson* p in [self.addressbookManager sortedPersonsArray])
        {
            NSMutableArray* par = [NSMutableArray new];
            [par addObject:p];
            
            [personsAndImages addObject:par];
        }
        
        
        NSUInteger endCount = personsAndImages.count;
        
        for(NSObject<MatchingDelegate>* matcher in self.matchers)
        {
            if(matcher.isChecked)
            {
                for(NSUInteger i = 0; i < personsAndImages.count; i++)
                {
                    
                    [self updateLabel:matcher.textForMatcher start:i end:endCount];
                    NSMutableArray* pAr = personsAndImages[i];
                    ASPerson* person = pAr[0];
                    NSArray* resultImages = [matcher getPhotosForPerson:person];
                    [pAr addObjectsFromArray:resultImages];
                    countImages += resultImages.count;
                }
                
            }
        }
 
        dispatch_async(dispatch_get_main_queue(), ^() {
            [sender setEnabled:true];
            if(countImages !=0)
            {
                MultipleSelectController* msc = [[MultipleSelectController alloc] initWithPersonsImages:personsAndImages];
                
                [self.navigationController pushViewController:msc animated:YES];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil) message:NSLocalizedString(@"No Matching entries found",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Gotcha!",nil) otherButtonTitles:nil] show];
            }
        });
    
    
    }); // end of dispatch block
}

-(void) updateLabel:(NSString*) matcher start:(NSUInteger) start end:(NSUInteger) end
{
    dispatch_async(dispatch_get_main_queue(), ^()
    {
        NSString* dots = nil;
        switch (start % 3) {
            case 0:
                dots = @"..";
                break;
            case 1:
                dots = @"....";
                break;
            default:
                dots = @"......";
                break;
        }
        self.statusLabel.text = [NSString stringWithFormat:@"%@: %lu/%lu\n%@", matcher,(unsigned long)start+1,(unsigned long)end,dots];
    });
}

#pragma mark - AddressbookManagerDelegate

-(void)addressbookmanagerError:(NSString *)errorText
{
    
}

-(void)addressbookmanagerParsingSuccess
{
    
}




@end
