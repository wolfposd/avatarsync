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

#import "WhatsAppMultipleMatcher.h"
#import "WAImageFinder.h"
#import "SQLController.h"
#import "PhotoFile.h"
#import "Settings.h"

@interface WhatsAppMultipleMatcher ()

@property (nonatomic,retain) SQLController* sql;

@end


@implementation WhatsAppMultipleMatcher

@synthesize isChecked = _isChecked;

-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        _sql = [SQLController sqlControllerWithFile:[WAImageFinder contactsDBFullPath]];
        _isChecked = false;
    }
    
    return self;
}


-(UIImage*) imageForMatcher
{
    return [UIImage imageNamed:@"whatsapp.png"];
}


-(NSArray *)getPhotosForPerson:(ASPerson *)person
{
    NSMutableArray* ar = [NSMutableArray new];
    
    SQLController* sql = _sql;
    
    UIImage* img = [WAImageFinder getPhotoForPerson:person sql:&sql];
    
    if(img)
    {
        PhotoFile* f = [PhotoFile photoFile:@"WhatsApp" image:img];
        [ar addObject:f];
    }
    
    
    if(ar.count == 0)
    {
        [ar addObjectsFromArray:[self getImagesFromWADB:person]];
    }
    
    
    if(ar.count == 0 && [Settings isWhatsAppMultipleIncludeThumbnail])
    {
        NSArray* imgs = [WAImageFinder thumbimagesFromWAFolder:[WAImageFinder findWhatsappFolder]];
        for(PhotoFile* f in imgs)
        {
            if(f.filename)
            {
                NSString* phone = [f.filename stringByReplacingOccurrencesOfString:@".thumb" withString:@""];
                
                if([person doesPhoneMatchPerson:phone])
                {
                    [ar addObject:f];
                }                
            }
        }
    }
    
    return ar;
}

-(NSArray*) getImagesFromWADB:(ASPerson*) person
{
    NSMutableArray* matchingImages = [NSMutableArray new];
    
    NSString* path = [WAImageFinder findWhatsappFolder];
    NSString* dbpath = [WAImageFinder contactsDBFullPath];
    if(dbpath)
    {
        
        NSMutableArray* picturePaths = [NSMutableArray new];
        
        for (NSString* fone in person.phoneNumbers)
        {
            if(fone.length > 4)
            {
                NSString* where2 = [NSString stringWithFormat:@"ZWHATSAPPID LIKE '%%%@%%'", fone];
                
                NSArray* medias = [self.sql selectAllFrom:@"ZWASTATUS" where:where2];
                
                for(NSDictionary* row in medias)
                {
                    NSString* picpath = row[@"ZPICTUREPATH"];
                    if(picpath)
                    {
                        [picturePaths addObject:picpath];
                    }
                }
            }
        }
        
        
        for(NSString* pp in picturePaths)
        {
            NSString* ff = [NSString stringWithFormat:@"%@/Library/%@.jpg",path, pp];
            UIImage* img = [UIImage imageWithContentsOfFile:ff];
            if(img)
            {
                PhotoFile* pf = [PhotoFile photoFile:@"WhatsApp" image:img];
                [matchingImages addObject:pf];
            }
        }
        
    }
    return matchingImages;
}


-(NSString*) textForMatcher
{
    return @"WhatsApp";
}


-(void)dealloc
{
    [_sql closeDb];
}

@end
