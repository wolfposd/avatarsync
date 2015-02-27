//
//  ContactsTableViewController.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 23.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ASPerson.h"
#import "GenericTableViewController.h"
#import "WATableFeed.h"
#import "WAImageFinder.h"
#import "ImageApplyOptions.h"
#import "FileLog.h"
#import "AddressbookManager.h"
#import "AddressbookSQL.h"

@interface ContactsTableViewController ()<AddressbookManagerDelegate>

@property(nonatomic,retain) AddressbookManager* addressbookManager;

@property (nonatomic, retain) NSArray* sections;
@property (nonatomic, retain) NSDictionary* rows;

@property (nonatomic, weak) IBOutlet UILabel* headerTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel* headerDescriptionLabel;


@property (nonatomic,retain) AddressbookSQL* addressbookSQL;

@end

@implementation ContactsTableViewController



- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.addressbookManager = [AddressbookManager instance];
    
    //self.addressbookSQL = [AddressbookSQL new];
    
    
    [FileLog log:@"Starting ContactsTableViewController" level:LOGLEVEL_DEBUG];
    
    [self makeHeader];

    
    _sections = @[@"0",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I",
                  @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S",
                  @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    
    
    [FileLog log:@"ContactsTableViewController- viewDidLoad:starting to assign persons" level:LOGLEVEL_DEBUG];
    [self assignAddressbook];
    
    //[self assignAddressbookWithPersons:[self.addressbookSQL getUsersFromDB]];
    
    [FileLog log:@"ContactsTableViewController- finished to assign persons" level:LOGLEVEL_DEBUG];
    
    
    [FileLog log:@"ContactsTableViewController- Finished ContactsTableViewController" level:LOGLEVEL_DEBUG];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self makeHeader];
    [self.tableView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.view layoutSubviews];
}

-(void) makeHeaderWithSize:(CGSize) size
{
    float width = size.width;
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 120)];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, width-80, 75)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Gill Sans" size:37];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    
    label.text = @"AvatarSync";
    
    
    UILabel* desc = [[UILabel alloc] initWithFrame:CGRectMake(40, 65, width-80, 60)];
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
        desc.text = @"";
    }
    
    
    [view addSubview:label];
    [view addSubview:desc];
    
    self.headerDescriptionLabel = desc;
    self.headerTitleLabel = label;
    
    view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = view;
}

-(void) makeHeader
{
    [self makeHeaderWithSize:self.view.frame.size];
}

#pragma mark - Addressbook

-(void)saveAddressbook
{
    [self.addressbookManager saveAddressbook];
}


-(void) assignAddressbookWithPersons:(NSArray*) asPersonArray
{
    [FileLog log:@"ContactsTableViewController- assignAddressbook:START" level:LOGLEVEL_DEBUG];
    
    self.addressbookManager.currentDelegate = self;
    
    NSMutableArray* allPersons  = [asPersonArray mutableCopy];
    
    [FileLog log:@"ContactsTableViewController- setting up variables with sorted persons" level:LOGLEVEL_DEBUG];
    
    NSMutableDictionary* dictionary = [NSMutableDictionary new];
    for(NSString* letter in self.sections)
    {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        [dictionary setObject:array forKey:letter];
    }
    
    [FileLog log:@"ContactsTableViewController- Dictionary setup complete" level:LOGLEVEL_DEBUG];
    
    
    [FileLog log:@"ContactsTableViewController- Starting to place persons in array" level:LOGLEVEL_DEBUG];
    for(ASPerson* p in allPersons)
    {
        [FileLog log:@"ContactsTableViewController- placing person in array:" level:LOGLEVEL_DEBUG];
        if(p.firstName && p.firstName.length > 0)
        {
            NSString* firstChar = [p.firstName substringToIndex:1].uppercaseString;
            NSMutableArray* val = dictionary[firstChar];
            if(val)
            {
                [val addObject:p];
                [FileLog log:[NSString stringWithFormat:@"ContactsTableViewController-   > placed person into %@", firstChar] level:LOGLEVEL_DEBUG];
            }
            else
            {
                [dictionary[@"0"] addObject:p];
                [FileLog log:[NSString stringWithFormat:@"ContactsTableViewController-   > placed person into 0,1"] level:LOGLEVEL_DEBUG];
            }
        }
        else
        {
            [dictionary[@"0"] addObject:p];
            [FileLog log:[NSString stringWithFormat:@"ContactsTableViewController-   > placed person into 0,2"] level:LOGLEVEL_DEBUG];
        }
    }
    
    [FileLog log:@"ContactsTableViewController- Assigning dictionary to rows variable" level:LOGLEVEL_DEBUG];
    self.rows = dictionary;
    
    
    [FileLog log:@"ContactsTableViewController- Done with sorting and stuff, now reloading table on mainThread" level:LOGLEVEL_DEBUG];
    
    [self performSelectorOnMainThread:@selector(reloadOnMain) withObject:nil waitUntilDone:NO];
    
    [FileLog log:@"ContactsTableViewController- assingAddressbook:END" level:LOGLEVEL_DEBUG];
    
    self.headerDescriptionLabel.text = NSLocalizedString(@"Select a Contact and Sync away!", nil);
}


-(void) assignAddressbook
{
    [self assignAddressbookWithPersons:[[self.addressbookManager sortedPersonsArray] mutableCopy]];
}

-(void) reloadOnMain
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* dicsec = self.sections[section];
    return [self.rows[dicsec] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if( [self.rows[self.sections[section]] count] == 0)
    {
        return nil;
    }
    return self.sections[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sections;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.sections indexOfObject:title];
}

-(ASPerson*) personAt:(NSIndexPath*) indexpath
{
    NSString* dicsec = self.sections[indexpath.section];
    return self.rows[dicsec][indexpath.row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ASPerson* person = [self personAt:indexPath];
    
    //[FileLog log:[NSString stringWithFormat:@"ContactsTableViewController-  Creating Cell for Person:%@",person] level:LOGLEVEL_DEBUG];
    
 
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName];
    cell.imageView.image = person.profileImage;
    if(person.company && person.company.length > 0)
    {
        cell.detailTextLabel.text = person.company;
    }
    else
    {
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageApplyOptions* imageOption = [[ImageApplyOptions alloc] initWithContact:[self personAt:indexPath]];
    GenericTableViewController* gen = [[GenericTableViewController alloc] initWithDelegate:imageOption];
    
    [self.navigationController pushViewController:gen animated:YES];
}

#pragma mark - Description Messages

-(void) showErrorMessageAccess
{
    self.headerDescriptionLabel.text = NSLocalizedString(@"AvatarSync needs access to the Addressbook",nil);
    self.headerDescriptionLabel.textColor = [UIColor redColor];
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if(self.navigationController.topViewController == self)
    {
        [self makeHeaderWithSize:size];
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

-(void)addressbookmanagerError:(NSString *)errorText
{
    self.headerDescriptionLabel.text = errorText;
    self.headerDescriptionLabel.textColor = [UIColor redColor];
}

-(void)addressbookmanagerParsingSuccess
{
    [self assignAddressbook];
}


@end
