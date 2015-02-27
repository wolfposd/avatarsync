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

#import "ImageURL.h"


@interface ImageURL ()

@property (nonatomic, weak) id<SingleDownloadOwner> delegate;

@end

@implementation ImageURL


-(void) startDownloading:(NSString*) filetext
{
    if([filetext rangeOfString:@"http://"].location == NSNotFound)
    {
        filetext = [@"http://" stringByAppendingString:filetext];
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^(){
    
        
        NSURL* url = [NSURL URLWithString:filetext];
        
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        [self finishUp:image];
    });
}

-(void) setOwner:(id<SingleDownloadOwner>) owner
{
    self.delegate = owner;
}

-(NSString*) titleForLabel
{
    return NSLocalizedString(@"Enter a URL:",nil);
}

-(UIColor*) backgroundColor
{
    return [UIColor grayColor];
}
-(UIColor*) labelColor
{
    return [UIColor whiteColor];
}

-(NSString*) titleForNav
{
    return NSLocalizedString(@"Image download",nil);
}

-(NSString*) errorNoText
{
    return NSLocalizedString(@"Please enter a URL first.",nil);
}


-(void) finishUp:(UIImage*) image;
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        if(image)
        {
            [self.delegate reportDownloadFinishedWithImage:image];
        }
        else
        {
            [self.delegate errorHappenedDuringDownload:NSLocalizedString(@"Error",nil)];
        }
    });
}


@end
