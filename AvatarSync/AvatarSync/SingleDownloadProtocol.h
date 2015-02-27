//
//  SingleDownloadProtocol.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//



#import <UIKit/UIKit.h>


@protocol SingleDownloadOwner <NSObject>

-(void) reportDownloadFinishedWithImage:(UIImage*) image;

-(void) errorHappenedDuringDownload:(NSString*) errortext;

-(void) putStringInTextfield:(NSString*) string;

@end


@protocol SingleDownloadDelegate <NSObject>

-(void) startDownloading:(NSString*) filetext;

/**
 *  Called in ViewDidLoad
 *
 *  @param owner the owner
 */
-(void) setOwner:(id<SingleDownloadOwner>) owner;

-(NSString*) titleForLabel;


-(NSString*) titleForNav;

-(UIColor*) backgroundColor;

-(UIColor*) labelColor;

-(NSString*) errorNoText;


@end