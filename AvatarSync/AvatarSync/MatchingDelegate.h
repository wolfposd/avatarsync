//
//  MatchingDelegate.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 03.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
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
