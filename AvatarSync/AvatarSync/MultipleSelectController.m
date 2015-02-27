//
//  MultipleSelectController.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 03.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "MultipleSelectController.h"
#import "BigImageCell.h"
#import "ASPerson.h"
#import "AddressbookManager.h"
#import "PhotoFile.h"


@implementation UIButtonRememberSection

@end


@interface MultipleSelectController ()

@property (nonatomic,retain) NSArray* personsAndImages;

@end

@implementation MultipleSelectController


-(id) initWithPersonsImages:(NSArray*) personsAndImages
{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self)
    {
        _personsAndImages = personsAndImages;
    }
    return self;
}



-(int) countOfMatchedPersons
{
    int i = 0;
    
    for(NSArray* ar in self.personsAndImages)
    {
        if(ar.count >= 2)
        {
            i++;
        }
    }
    
    
    return i;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Match Results",nil);
    [self makeFooter:self.view.frame.size];
    [self makeHeaderWithSize:self.view.frame.size text1:NSLocalizedString(@"Match Results",nil) text2:NSLocalizedString(@"Swipe left to remove images you don't want to apply",nil)];
    
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(applyAllButtonTouch:)];
    
    self.navigationItem.rightBarButtonItem = item;
    
//    NSString* msg = [NSString stringWithFormat:@"Found: %d / %lu", [self countOfMatchedPersons], (unsigned long) self.personsAndImages.count ];   
//    [[[UIAlertView alloc] initWithTitle:@"Matched" message:msg delegate:self cancelButtonTitle:@"thx" otherButtonTitles: nil] show];
}


-(void) makeFooter:(CGSize) size
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 65)];
    
    BorderButton* button = [[BorderButton alloc] initWithFrame:CGRectMake(40, 20, size.width-80, 40)];
    
    [button setTitle:NSLocalizedString(@"Apply All",nil) forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [button setNeedsDisplay];
    
    [button addTarget:self action:@selector(applyAllButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    
    self.tableView.tableFooterView = view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.personsAndImages.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.personsAndImages[section] count] - 1;
}


-(NSString*) titleForHeaderInSection:(NSInteger) section
{
    NSArray* arr = self.personsAndImages[section];
    if(arr.count != 1)
    {
        ASPerson* p = arr[0];
        return [p.description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return nil;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self titleForHeaderInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BigImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BigImageCell"];
    
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BigImageCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSInteger row = indexPath.row + 1;
    
    PhotoFile* f =self.personsAndImages[indexPath.section][row];
    
    cell.bigImage.image =  f.image;
    cell.bigLabel.text = f.filename;
    
    return cell;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray* arr = self.personsAndImages[indexPath.section];
        
        [arr removeObjectAtIndex:indexPath.row+1];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float width = tableView.frame.size.width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 18)];

    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, width-60, 18)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = [self titleForHeaderInSection:section];
   
    
    UIButtonRememberSection* button = [[UIButtonRememberSection alloc] initWithFrame:CGRectMake(width-35, 5, 30, 18)];
    [button setTitle:@" X " forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    button.section = section;
    button.person = self.personsAndImages[section][0];
    
    
    [button setBackgroundColor:[UIColor colorWithRed:0xf7/255.0 green:0xf7/255.0 blue:0xf7/255.0 alpha:1.0]];
    
    [view addSubview:label];
    [view addSubview:button];
    
    [view setBackgroundColor:[UIColor colorWithRed:0xf7/255.0 green:0xf7/255.0 blue:0xf7/255.0 alpha:1.0]]; //your background color...
    return view;
}


-(void) deleteButtonTouch:(id) sender
{
    UIButtonRememberSection* button = sender;
    NSMutableArray* persons = (NSMutableArray*) self.personsAndImages;
    
    
    
    NSInteger sectionToDelete = -1;
    if(button.section < self.personsAndImages.count && button.person == self.personsAndImages[button.section][0])
    {
        sectionToDelete = button.section;
    }
    else
    {
        for(int cursec = 0; cursec < self.personsAndImages.count; cursec++)
        {
            if(button.person == self.personsAndImages[cursec][0])
            {
                sectionToDelete = cursec;
                break;
            }
        }
    }
    
    if(sectionToDelete != -1)
    {
        [persons removeObjectAtIndex:sectionToDelete];
        
        NSIndexSet* set = [NSIndexSet indexSetWithIndex:sectionToDelete];
        
        [self.tableView beginUpdates];
        [self.tableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
}


-(void) applyAllButtonTouch:(id)sender
{
    
    for(NSInteger i = 0 ; i < self.personsAndImages.count; i++)
    {
        NSArray* array = self.personsAndImages[i];
        if(array.count > 2)
        {
            ASPerson* person = array[0];
            [self showErrorMessageMultiplePictures:person index:i];
            return;
        }
    }
    
    
    for(NSArray* array in self.personsAndImages)
    {
        if(array.count == 2)
        {
            ASPerson* person = array[0];
            PhotoFile* f = array[1];
            [person updateImage:f.image];
        }
    }
    
    [[AddressbookManager instance] saveAddressbook];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) showErrorMessageMultiplePictures:(ASPerson*) pp index:(NSInteger) index
{
    NSString* message = [NSString stringWithFormat:NSLocalizedString(@"%@ still has more than one image, please remove one before proceeding",nil), pp.description];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Gotcha!",nil)otherButtonTitles:nil] show];
    
    
    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:index];
    
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}



@end

