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
