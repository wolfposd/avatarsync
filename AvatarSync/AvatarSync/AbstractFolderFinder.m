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

#import "AbstractFolderFinder.h"
#import "FileLog.h"

@implementation AbstractFolderFinder



+(NSString*) findSharedFolderIOS8:(NSString*) appName
{
    NSString *dir = @"/var/mobile/Containers/Shared/AppGroup/";
    
    return [self findFolderIOS8:appName folder:dir];
}

+(NSString*) findBaseFolderIOS8:(NSString*) appName
{
    NSString *dir = @"/var/mobile/Containers/Data/Application/";
   
    NSString* result =[self findFolderIOS8:appName folder:dir];
    return result;
}


+(NSString*) findFolderIOS8:(NSString*) appName folder:(NSString*) dir
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *folders = [manager contentsOfDirectoryAtPath:dir error:&error];
    
    if (!error)
    {
        for (NSString *folder in folders)
        {
            NSString *folderPath = [dir stringByAppendingString:folder];
            NSArray *items = [manager contentsOfDirectoryAtPath:folderPath error:&error];
            
            for(NSString* itemPath in items)
            {
                
                if([itemPath rangeOfString:@".com.apple.mobile_container_manager.metadata.plist"].location != NSNotFound)
                {
                    NSString* fullpath = [NSString stringWithFormat:@"%@/%@",folderPath, itemPath];
                    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:fullpath];
                    
                    NSString* mcmmetadata = dict[@"MCMMetadataIdentifier"];
                    if(mcmmetadata && [mcmmetadata.lowercaseString rangeOfString:appName].location != NSNotFound)
                    {
                        [FileLog log:[NSString stringWithFormat:@"found folder ios8: %@",folderPath] level:LOGLEVEL_DEBUG];
                        return folderPath;
                    }
                }
            }
            
        }
        
    }
    
    [FileLog log:[NSString stringWithFormat:@"[AbstractFolderFinder]: iOS8, couldnt find %@ folder, possibly not installed, looking for %@" ,appName, dir]level:LOGLEVEL_DEBUG];
    return nil;
}


+(NSString*) findBaseFolderIOS7:(NSString*) appName
{
    NSString* dir = @"/var/mobile/Applications/";
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *error;
    NSArray *folders = [manager contentsOfDirectoryAtPath:dir error:&error];
    
    
    for(NSString* appFolder in folders)
    {
        NSString* appFolderPath = [dir stringByAppendingString:appFolder];
        NSArray* items = [manager contentsOfDirectoryAtPath:appFolderPath error:&error];
        
        for(NSString* insideApp in items)
        {
            if([insideApp.lowercaseString rangeOfString:appName].location != NSNotFound)
            {
                [FileLog log:[NSString stringWithFormat:@"found folder ios7: %@",appFolderPath] level:LOGLEVEL_DEBUG];
                return appFolderPath;
            }
        }
    }
    
    
    [FileLog log:[NSString stringWithFormat:@"[AbstractFolderFinder]: iOS7, couldnt find %@ folder, possibly not installed" ,appName]level:LOGLEVEL_DEBUG];
    return nil;
}



@end
