//
//  AddressbookManager.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 03.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>




@protocol AddressbookManagerDelegate <NSObject>

-(void) addressbookmanagerError:(NSString*) errorText;

-(void) addressbookmanagerParsingSuccess;

@end



@interface AddressbookManager : NSObject

@property (nonatomic,weak) NSObject<AddressbookManagerDelegate>* currentDelegate;

+(AddressbookManager*) instance;


-(NSArray*) sortedPersonsArray;


-(void) saveAddressbook;


@end
