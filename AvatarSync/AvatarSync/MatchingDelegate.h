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
 *  Array von PhotoFiles
 *
 *  @param person person zum suchen
 *
 *  @return array von PhotoFiles oder empty
 */
-(NSArray*) getPhotosForPerson:(ASPerson*) person;

/**
 *  Das Bild fuer die Uebersicht von Multiple
 *
 *  @return ein bild
 */
-(UIImage*) imageForMatcher;

/**
 *  Der angezeigte text des Matchers
 *
 *  @return zB "WhatsApp"
 */
-(NSString*) textForMatcher;

/**
 *  Soll dieser matcher gleich aktiv werden, beim matchen?
 *
 *  Beim implementieren \@synthesize isChecked = _isChecked;
 */
@property (nonatomic) BOOL isChecked;

@optional

/**
 *  Ein optionaler detailText
 *
 *  @return zb "requires interwebz"
 */
-(NSString*) textDetailForMatcher;

@end
