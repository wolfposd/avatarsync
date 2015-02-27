//
//  SQLController.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "SQLController.h"
#import "sqlite3.h"

@implementation SQLController
{
    sqlite3 *database;
    NSString *dbPath;
    sqlite3_stmt *statement;
}


+(id) sqlControllerWithFile:(NSString*) filepath
{
    SQLController* c = [SQLController new];
    [c openDbWithFile:filepath];
    return c;
}

-(void) openDbWithFile:(NSString*) filepath
{
    dbPath = filepath;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK)
    {
        NSLog(@"%@", @"error with db");
        sqlite3_close(database);
    }
    //    else
    //    {
    //     NSLog(@"%@", @"no error");
    //     [self printSQL:@"SELECT * FROM main.sqlite_master WHERE type='table';"];
    //    }
}

-(void) closeDb
{
    sqlite3_close(database);
}


-(void) printSQL:(NSString*) sql
{
    if( sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        NSLog(@"%@", @"start printing");
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            int colCount = sqlite3_column_count(statement);
            for(int i = 0; i < colCount; i++)
            {
                NSString* fieldname = [NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)];
                NSString* curfield = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                NSLog(@"field: %@, value: %@", fieldname, curfield);
            }
        }
        NSLog(@"%@", @"end printing");
    }
    else
    {
         [self printError];
    }
}

-(NSArray*) select:(NSString*)tables From:(NSString*) tablename where:(NSString*) whereclause
{
    NSMutableArray* results =  [NSMutableArray new];
    
    NSString* query = nil;
    if(!whereclause)
    {
        query = [NSString stringWithFormat:@"SELECT %@ FROM %@ ;",tables, tablename];
    }
    else
    {
        query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ ;",tables, tablename, whereclause];
    }
    
    if( sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        int colCount = sqlite3_column_count(statement);
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary* dic = [NSMutableDictionary new];
            
            for(int i = 0; i < colCount; i++)
            {
                NSString* fieldname = [NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)];
                char* p = (char *) sqlite3_column_text(statement, i);
                
                if( p != NULL)
                {
                    NSString* curfield = [NSString stringWithUTF8String:p];
                    
                    if(curfield)
                    {
                        [dic setObject:curfield forKey:fieldname];
                    }
                }
            }
            
            [results addObject:dic];
        }
        sqlite3_finalize(statement);
    }
    else
    {
        [self printError];
    }
    
    return results;
}


-(NSArray*) selectData:(NSString*)tables From:(NSString*) tablename where:(NSString*) whereclause
{
    NSMutableArray* results =  [NSMutableArray new];
    
    NSString* query = nil;
    if(!whereclause)
    {
        query = [NSString stringWithFormat:@"SELECT %@ FROM %@ ;",tables, tablename];
    }
    else
    {
        query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ ;",tables, tablename, whereclause];
    }
    
    if( sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        int colCount = sqlite3_column_count(statement);
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary* dic = [NSMutableDictionary new];
            
            for(int i = 0; i < colCount; i++)
            {
                NSString* fieldname = [NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)];
                NSData* data = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, i) length:sqlite3_column_bytes(statement, i)];
                
                if( data != NULL && data != nil)
                {
                    [dic setObject:data forKey:fieldname];
                }
            }
            
            [results addObject:dic];
        }
        sqlite3_finalize(statement);
    }
    else
    {
        [self printError];
    }
    
    return results;
}



-(NSArray*) selectAllFrom:(NSString*) tablename where:(NSString*) whereclause
{
    return [self select:@"*" From:tablename where:whereclause];
}


+(NSString*) escape:(NSString*) string
{
    char* escaped = sqlite3_mprintf("%Q", string);
    return [NSString stringWithUTF8String:escaped];
}


-(void) printError
{
    NSLog(@"%@: %@", @"SQL ERROR", [NSString stringWithUTF8String:(char *)sqlite3_errmsg(database)]);
}

@end
