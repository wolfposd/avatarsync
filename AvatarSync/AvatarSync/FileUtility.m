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

#import "FileUtility.h"

@implementation FileUtility




+(void)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath
{
    NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:directoryName];
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory withIntermediateDirectories:YES attributes:nil error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
}


+(NSString*) downloadContentFrom:(NSURL*) url saveas:(NSString*) filename
{
    NSData* data = [NSData dataWithContentsOfURL:url];
    
    if(!data)
    {
        return nil;
    }
    
    NSString* filePath = [NSString stringWithFormat:@"/tmp/AvatarSync/%@", filename];
    [self createDirectory:@"AvatarSync" atFilePath:@"/tmp/"];
    
    NSLog(@"%@: %@",filename, filePath);
    
    BOOL success = [data writeToFile:filePath atomically:YES];
    
    NSLog(@"save success: %@", success ? @"YES": @"NO");
    
    return filePath;
}



@end
