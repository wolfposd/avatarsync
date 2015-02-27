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
#import "BigImageCell.h"
#import "ASPerson.h"





@protocol GenericTableOwner <NSObject>

/**
 *  Tells the controller to reload the table and refresh the Header View
 */
-(void) reloadTableData;

@end




@protocol GenericTableDelegate <NSObject>

/**
 *  Init this Delegate with a person
 *
 *  @param person the person for which to update images
 *
 *  @return initialized object
 */
-(id) initWithContact:(ASPerson*) person;

/**
 *  @return Title for the Navigation Controller
 */
-(NSString*) navTitle;

/**
 *  @return Title for the Header view
 */
-(NSString*) titleForHeader;

/**
 *  @return Description for the Header view
 */
-(NSString*) descriptionForHeader;

/**
 *  number of rows in section
 *
 *  @param section section index
 *
 *  @return number of rows
 */
-(NSInteger) numberOfRowsInSection:(NSInteger) section;

/**
 *  Number of Sections
 *
 *  @return num_sec
 */
-(NSInteger) numberOfSections;

/**
 *  Apply stuff to the cell
 */
-(void) updateCell:(BigImageCell**) cell atIndex:(NSIndexPath*) indexpath;
/**
 *  Table was clicked at index from controller
 *
 *  @param indexpath  clicked index
 *  @param controller owning controller
 */
-(void) clickedIndexAt:(NSIndexPath*) indexpath from:(UIViewController*) controller;
/**
 *  Title for table section
 *
 *  @param section section index
 *
 *  @return title
 */
-(NSString*) titleForSection:(NSInteger) section;

@optional

/**
 *  The alertview was clicked
 *
 *  @param buttonIndex clicked button
 *  @param controller  the owning controller
 */
-(void)alertViewClickedButtonAtIndex:(NSInteger)buttonIndex controller:(UIViewController*) controller;

/**
 *  Sets the delegate owner protocol stuff, useful for callbacks
 *
 *  @param owner the GenericTable
 */
-(void) setOwner:(id<GenericTableOwner>) owner;

/**
 *  Called when the controller will disapper
 */
-(void) controllerWillDisapper;

/**
 *  Called when the controller will appear
 */
-(void) controllerWillAppear;

@end


