//
//  SQLController.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLController : NSObject

+(id) sqlControllerWithFile:(NSString*) filepath;

-(void) openDbWithFile:(NSString*) filepath;

-(void) closeDb;


/**
 *  Select Statement returning NSData arguments
 *
 *  @param rows        row selector
 *  @param tablename   from tablename
 *  @param whereclause with where clause or <nil>
 *
 *  @return always an array
 */
-(NSArray*) selectData:(NSString*)rows From:(NSString*) tablename where:(NSString*) whereclause;


/**
 *  Select Statement returning NSString arguments
 *
 *  @param rows        row selector
 *  @param tablename   from tablename
 *  @param whereclause with where clause or <nil>
 *
 *  @return always an array
 */
-(NSArray*) select:(NSString*)rows From:(NSString*) tablename where:(NSString*) whereclause;

/**
 *  Select ALL Statement returning NSString arguments
 *
 *  @param tablename   from tablename
 *  @param whereclause with where clase or <nil>
 *
 *  @return always an array
 */
-(NSArray*) selectAllFrom:(NSString*) tablename where:(NSString*) whereclause;


+(NSString*) escape:(NSString*) string;

@end
