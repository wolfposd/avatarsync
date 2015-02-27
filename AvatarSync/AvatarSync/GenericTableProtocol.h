//
//  GenericTableProtocol.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 23.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
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


