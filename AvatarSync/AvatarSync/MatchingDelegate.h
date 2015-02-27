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
#import <UIKit/UIImage.h>
#import "ASPerson.h"


@protocol MatchingDelegate <NSObject>

/**
 *  Array of PhotoFiles
 *
 *  @param person person to search for
 *
 *  @return array of PhotoFiles or empty-array
 */
-(NSArray*) getPhotosForPerson:(ASPerson*) person;

/**
 *  Preview image for this matcher
 *
 *  @return an image
 */
-(UIImage*) imageForMatcher;

/**
 *  Text of this matcher
 *
 *  @return e.g. "WhatsApp"
 */
-(NSString*) textForMatcher;

/**
 *  Is this matcher currently active?
 *
 *  When implementing do: \@synthesize isChecked = _isChecked;
 */
@property (nonatomic) BOOL isChecked;

@optional

/**
 *  optional detail text for matcher
 *
 *  @return e.g. "requires interwebz"
 */
-(NSString*) textDetailForMatcher;

@end
