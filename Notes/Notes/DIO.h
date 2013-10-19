//
//  DIO.h
//  StoryBorardAdvance
//
//  Created by IndiaNIC on 12/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DIO : NSObject
{
    NSString *dataBasePath;
    sqlite3 *dataBaseObject;
}

#pragma mark -
#pragma mark Instance Methdos
-(BOOL)copyDataBaseIfDontExist;
-(int)insertRecord:(NSString *)query;
-(int)deleteRecord:(NSString *)query;
-(NSMutableArray *)getRecords:(NSString *)query;
-(int)getMaxValue:(NSString *)query;
-(int)storeImage:(NSData *)imageData secondParameter:(NSString *)query;
-(NSMutableArray *)getImages:(NSString *)query;
-(int)updateRecord:(NSString *)query;

#pragma mark -
#pragma mark class methods

+(DIO *)sharedObject;
@end
