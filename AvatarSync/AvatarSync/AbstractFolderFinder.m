//
//  AbstractFolderFinder.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 08.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
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
   
    return [self findFolderIOS8:appName folder:dir];
}


+(NSString*) findFolderIOS8:(NSString*) appName folder:(NSString*) dir
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *error;
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
