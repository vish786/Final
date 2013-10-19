//
//  MyNotes.h
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesDetailVC.h"
#import "AddEditNote.h"
#import "DIO.h"

@interface MyNotes : UIViewController <UITableViewDelegate,UITableViewDataSource>

{
#pragma mark outlets
    IBOutlet UITableView *tblMyNotes;
    
#pragma mark variables declaration
    NSMutableArray *mutArrAllNotes;
    NSString *strQuery;
    NSArray *aSectionTitle,*arrTempData;
    NSMutableDictionary *dictSectionViseData;
    NSString *identifire;
    NSMutableArray *mutArrayNotesData,*mutArrayAllImages;
    NSDictionary *dictSingleRecord;
    NotesDetailVC *notesDetailObj;
    AddEditNote *addEditNotesObj;
	UIAlertView *alertDisplayAlert;
    NSIndexPath *ipDeleteIndex;
	NSMutableDictionary *aDictData;
	NSArray *aArrTmp;
	NSString *aStrTmp;
}

#pragma mark Properties Declaration

@property (nonatomic,assign)int userId;

#pragma mark BarButton item click event methods
- (IBAction)btnAddEvent:(UIBarButtonItem *)sender;

@end
