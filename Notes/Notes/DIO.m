//
//  DIO.m
//  StoryBorardAdvance
//
//  Created by IndiaNIC on 12/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import "DIO.h"

static DIO *dioObj= nil;

//Your Database Name
static NSString *dataBaseName = @"NotesDB.db";

@implementation DIO

#pragma mark -
#pragma mark ShardManager
+(DIO *)sharedObject
{
    if(!dioObj){
        dioObj = [[DIO alloc]init];
    }
    return dioObj;
}

#pragma mark -
#pragma mark CopyDatabase

-(BOOL)copyDataBaseIfDontExist
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"dataBase"];
    [fileManager createDirectoryAtPath:writableDBPath withIntermediateDirectories:NO attributes:nil error:nil];
	writableDBPath = [writableDBPath stringByAppendingPathComponent:dataBaseName];
    dataBasePath=writableDBPath;
    
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return success;
    [[NSBundle mainBundle]resourcePath];
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dataBaseName];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
	if (!success) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!!!" message:[NSString stringWithFormat:@"Failed to create writable database... %i" ,error.code] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil] ;
		[alert show];
	}
	return success;
}

#pragma mark -
#pragma mark Insert Record

-(int)insertRecord:(NSString *)query{
    sqlite3_stmt *statement=nil;
    int result = 0;
    if(sqlite3_open([dataBasePath UTF8String], &dataBaseObject)==SQLITE_OK){
        if ((result = sqlite3_prepare(dataBaseObject, [query UTF8String], -1, &statement, NULL))==SQLITE_OK) {
            sqlite3_step(statement);
        }
    }
    sqlite3_finalize(statement);
    if(sqlite3_close(dataBaseObject)==SQLITE_OK){
        
    }else{
        NSAssert1(0, @"Error: failed to close database on mem warning with message '%s'.", sqlite3_errmsg(dataBaseObject));
    }
    return result;
}
#pragma mark -
#pragma mark Delete Record

-(int)deleteRecord:(NSString *)query
{
    return [self insertRecord:query];
}

#pragma mark -
#pragma mark Get Record
-(NSMutableArray *)getRecords:(NSString *)query
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    int resultRowCount=0;
    sqlite3_stmt *statement=nil;
    if(sqlite3_open([dataBasePath UTF8String], &dataBaseObject)==SQLITE_OK){
        if (sqlite3_prepare(dataBaseObject, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
			NSMutableArray *tableHeader=[[NSMutableArray alloc]init];
            while (sqlite3_step(statement)==SQLITE_ROW) {
                int cout = sqlite3_column_count(statement);
                NSMutableArray *tempData = [[NSMutableArray alloc]init];
                for (int i = 0; i<cout; i++) {
                    if(resultRowCount==0){
                        char *name = (char*) sqlite3_column_name(statement, i);
                        NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                        [tableHeader addObject:columnName];
                    }
					char *data = (char*) sqlite3_column_text(statement, i);
                    
                    NSString *columnData = @"";
                    if(data){
                        columnData = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
				}
                [tempData addObject:columnData];
                }
                if (resultRowCount == 0) {
                    [result addObject:tableHeader];
                    resultRowCount++;
                    [result addObject:tempData];
                    resultRowCount++;
                }else{
                    [result addObject:tempData];
                    resultRowCount++;                    
                }
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBaseObject);
    return result;
}

#pragma mark -
#pragma mark Update Record
-(int)updateRecord:(NSString *)query
{
	return [self insertRecord:query];
}


#pragma mark -
#pragma mark Get Max Value

-(int)getMaxValue:(NSString *)query
{
    int aResult=0;
    sqlite3_stmt *statement = nil;
    if(sqlite3_open([dataBasePath UTF8String],&dataBaseObject)==SQLITE_OK){
        if (sqlite3_prepare(dataBaseObject, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                int aCount = sqlite3_column_count(statement);
                if (aCount ==1) {
                    char *aChar = (char*)sqlite3_column_text(statement, 0);
                    if (aChar!=nil) {
                        aResult = [[NSString stringWithUTF8String:aChar]intValue];                        
                    }
                }
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBaseObject);
    return aResult;
}

#pragma mark -
#pragma mark Store Image

-(int)storeImage:(NSData *)imageData secondParameter:(NSString *)query{
    sqlite3_stmt *statement=nil;
    int result = 0;
    if(sqlite3_open([dataBasePath UTF8String], &dataBaseObject)==SQLITE_OK){
        if ((result = sqlite3_prepare(dataBaseObject, [query UTF8String], -1, &statement, NULL))==SQLITE_OK) {
            sqlite3_bind_blob(statement, 1, [imageData bytes], [imageData length], NULL);
            result = sqlite3_step(statement);
        }
    }
    sqlite3_finalize(statement);
    if(sqlite3_close(dataBaseObject)==SQLITE_OK){
        
    }else{
        NSAssert1(0, @"Error: failed to close database on mem warning with message '%s'.", sqlite3_errmsg(dataBaseObject));
    }
    return result;
}

#pragma mark -
#pragma mark Get Images

-(NSMutableArray *)getImages:(NSString *)query
{
	sqlite3_stmt *statement = nil;
	NSMutableArray *aResult = [[NSMutableArray alloc]init];
	int resultRowCount =0;
	
	if (sqlite3_open([dataBasePath UTF8String],&dataBaseObject) == SQLITE_OK) {
		
		if (sqlite3_prepare(dataBaseObject, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
			while (sqlite3_step(statement)==SQLITE_ROW) {
				int aColumnCount = sqlite3_column_count(statement);
				NSMutableArray *tableHeader=[[NSMutableArray alloc]init];
				NSMutableArray *tempData = [[NSMutableArray alloc]init];
				for (int i = 0; i<aColumnCount; i++) {
					if(resultRowCount==0){
						char *name = (char*) sqlite3_column_name(statement, i);
						NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
						[tableHeader addObject:columnName];
					}
					const void *aBytes = (sqlite3_column_blob(statement, i));
					int aLength = (sqlite3_column_bytes(statement, i));
					NSData *aData  = [NSData dataWithBytes:aBytes length:aLength];
					if (aData) {
						[tempData addObject:aData];
					}
				}
				if (resultRowCount ==0) {
					[aResult addObject:tableHeader];
					resultRowCount ++;
				}
				[aResult addObject:tempData];
			}
		}
	}
	sqlite3_finalize(statement);
	sqlite3_close(dataBaseObject);
	return aResult;
}

@end
