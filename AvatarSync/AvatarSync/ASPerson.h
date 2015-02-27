//
//  ASPerson.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 23.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <UIKit/UIImage.h>

@interface ASPerson : NSObject

@property (nonatomic) ABRecordRef record;

@property (nonatomic,retain) NSString* firstName;
@property (nonatomic,retain) NSString* lastName;
@property (nonatomic,retain) NSString* company;

@property (nonatomic,retain) NSDictionary* socialNetworks;

@property (nonatomic,retain) UIImage* profileImage;
@property (nonatomic,retain) NSArray* phoneNumbers;
@property (nonatomic,retain) NSArray* emails;



+(id) personWith:(ABRecordRef) record;


-(void) refetchInfos;

-(void) updateImage:(UIImage*) newImage;


-(BOOL) doesPhoneMatchPerson:(NSString*) phonenumber;


@end
