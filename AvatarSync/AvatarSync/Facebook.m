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

#import "Facebook.h"



@interface Facebook ()

@property (nonatomic,weak) id<SingleDownloadOwner> ownerDownloader;
@property (nonatomic,retain) ASPerson* person;

@end

@implementation Facebook



-(id)initWithPerson:(ASPerson *)person
{
    self = [super init];
    if(self)
    {
        _person = person;
    }
    return self;
}

-(void) setOwner:(id<SingleDownloadOwner>) owner
{
    self.ownerDownloader = owner;
    
    NSString* facebook = self.person.socialNetworks[@"facebook"];
    if(facebook)
    {
        [self.ownerDownloader putStringInTextfield:facebook];
    }
}

-(NSString*) titleForNav
{
    return @"Facebook";
}

-(NSString*) titleForLabel
{
    return NSLocalizedString(@"Enter Facebook Name:",nil);
}
-(UIColor*) backgroundColor
{
    
    // color="#3c5a98"
    
    return [UIColor colorWithRed:0.23 green:0.35 blue:0.59 alpha:1.0];
}
-(UIColor*) labelColor
{
    return [UIColor whiteColor];
}

-(NSString*) errorNoText
{
    return NSLocalizedString(@"Please enter a Facebook-Username first.",nil);
}

-(void)startDownloading:(NSString *)filetext
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^(){
        
        UIImage* image = nil;
        if(filetext){
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",filetext]];
            
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            if(image)
            {
                [self.ownerDownloader reportDownloadFinishedWithImage:image];
            }
            else
            {
                [self.ownerDownloader errorHappenedDuringDownload:NSLocalizedString(@"Error", nil)];
            }
        });
        
    });
}


@end
