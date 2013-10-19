//
//  AllNotes.h
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIO.h"
#import "NotesDetailVC.h"
@interface AllNotes : UIViewController <UITableViewDataSource,UITableViewDelegate>

{
#pragma mark outlets
    IBOutlet UITableView *tblAllNotes;
    
#pragma mark variables declaration
    NSMutableArray *mutArrAllNotes,*mutArrayAllImages;
    NSString *strQuery;
    NSArray *aSectionTitle,*arrTempData;
    NSMutableDictionary *dictSectionViseData;
    NSString *identifire;
    NSMutableArray *names;
    NSMutableArray *mutArrayNotesData;
    NSDictionary *dictSingleRecord;
    NotesDetailVC *notesDetailObj;
	
	NSDictionary *aDictData;
	NSArray *aArrTmp;
	NSString *aStrTmp;
	NSArray *arrAllUserInfo;

    
}

#pragma mark Properties Declaration

@property (nonatomic,assign)int userId;

@end
