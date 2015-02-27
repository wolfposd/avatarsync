//
//  FileLog.m
//  FeedbackBeaconContext
//
//  Created by Wolf Posdorfer on 29.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#define FILELOGPATH @"AvatarSync-Log.txt"
#define LOGLEVELPATH @"AvatarSync-Loglevel"

#import "FileLog.h"

@interface FileLog ()

@property (nonatomic,retain) NSFileHandle* fileHandle;
@property (nonatomic) int loglevel;

@end


@implementation FileLog



-(instancetype)init
{
    self = [super init];
    if(self)
    {
        
        NSString* fileName = [FileLog getFilePath];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
            [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
        }
        
        NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
        [file seekToEndOfFile];
        
        NSLog(@"%@", fileName);
        
        _fileHandle = file;
        
        //_isLoggingEnabled = ![[NSFileManager defaultManager] fileExistsAtPath:[FileLog getFilePathForDontLog]];
        
        _loglevel = [self getLogLevel];
    }
    return self;
}

+(FileLog *)instance
{
    static FileLog *myInstance = nil;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        myInstance = [[FileLog alloc] init];
    });
    return myInstance;
}


-(void)dealloc
{
    [_fileHandle closeFile];
}

+(void) clear
{
    NSString* stringtoLog = @"";
    
    NSString* fileName = [self getFilePath];
    
    //create file if it doesn't exist
    if([[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    
    //append text to file (you'll probably want to add a newline every write)
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [file writeData:[stringtoLog dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
}


-(void) log:(NSString*) string
{
    NSString* stringtoLog = [NSString stringWithFormat:@"%@: %@\n", [FileLog currentDate], string];
    [self.fileHandle writeData:[stringtoLog dataUsingEncoding:NSUTF8StringEncoding]];
    
}

-(void) log:(NSString*) string level:(int) loglevel
{
    if(loglevel <= self.loglevel)
    {
        [self log:string];
    }
    
#ifdef DEBUG
    NSLog(@"%@", string);
#endif
}


+(void) log:(NSString*) string level:(int) loglevel
{
    [[FileLog instance] log:string level:loglevel];
}

+(void) log:(NSString*) string
{
    [[FileLog instance] log:string];
}

+(int) getCurrentLogLevel
{
    return [FileLog instance].loglevel;
}

+(NSString*) loglevelasString
{
    switch ([FileLog instance].loglevel) {
        case 0:
            return @"No Logging";
        case 1:
            return @"Error";
        case 2:
            return @"Casual";
        case 3:
            return @"Full Debug";
        default:
            return @"Unknown";

    }
}

+(NSString*) getFilePath
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:FILELOGPATH];
    return fileName;
}

+(NSString*) currentDate
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}


-(int) getLogLevel
{
    @try
    {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fileName = [documentsDirectory stringByAppendingPathComponent:LOGLEVELPATH];
        
        //read the whole file as a single string
        NSString *content = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
        
        if(content)
        {
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: @"[^\\d]" options:0  error:nil];
            NSMutableString* mut = [content mutableCopy];
            [regex replaceMatchesInString:mut options:0 range:NSMakeRange(0, content.length) withTemplate:@""];
            
            return [content intValue];
        }
    }
    @catch(NSException* ex)
    {
        return 1;
    }
}


+(void)printLogToConsole
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:FILELOGPATH];
    
    //read the whole file as a single string
    NSString *content = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@", content);
}

@end
