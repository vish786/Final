//
//  MyNotes.m
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import "MyNotes.h"

@interface MyNotes ()

@end

@implementation MyNotes

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
        //alert view
    alertDisplayAlert.delegate =self;
    alertDisplayAlert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Are You Sure To Delete Entry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:195.0/255.0 green:150.0/255.0 blue:210.0/255.0 alpha:1];
        // Do any additional setup after loading the view from its nib.
		//navigation initialization
    
	UIBarButtonItem *aBtnRightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddEvent:)];
    aBtnRightButton.tag = 1;
    UIBarButtonItem *aBtnLeftButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(btnAddEvent:)];
    aBtnLeftButton.tag =2;
	self.navigationItem.rightBarButtonItem = aBtnRightButton;
    self.navigationItem.leftBarButtonItem = aBtnLeftButton;
	
		//delegates
    tblMyNotes.delegate = self;
    tblMyNotes.dataSource = self;
    
    [mutArrayNotesData removeAllObjects];
    dictSectionViseData = [[NSMutableDictionary alloc]init];
    dictSingleRecord = [[NSDictionary alloc]init];
	mutArrayAllImages = [[NSMutableArray alloc]init];
	addEditNotesObj = [[AddEditNote alloc]initWithNibName:@"AddEditNote" bundle:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
		//initialize tabbar
	self.tabBarController.navigationController.navigationBarHidden=YES;
	self.navigationItem.title=@"My Notes";

	[mutArrAllNotes removeAllObjects];
	[dictSectionViseData removeAllObjects];

    strQuery = [NSString stringWithFormat:@"Select NoteId,Title,Description,UserId,DateTime,Privacy from Notes where UserId = %i",self.userId];
    mutArrAllNotes = [[DIO sharedObject]getRecords:strQuery];
	strQuery = [NSString stringWithFormat: @"select Image from Notes where UserId = %i" ,self.userId];
	mutArrayAllImages = [[DIO sharedObject]getImages:strQuery];
    for (int i=1; i<[mutArrAllNotes count]; i++) {
        aDictData = [NSMutableDictionary dictionaryWithObjects:[mutArrAllNotes objectAtIndex:i]forKeys:[mutArrAllNotes objectAtIndex:0]];
        [aDictData setObject:@"Private Notes" forKey:@"tableId"];
        if ([dictSectionViseData objectForKey:@"My All Notes"]==nil) {
            NSMutableArray *aArray = [[NSMutableArray alloc]init];
            [aArray addObject:aDictData];
            [dictSectionViseData setObject:aArray forKey:@"My All Notes"];
        }else{
            [[dictSectionViseData objectForKey:@"My All Notes"]addObject:aDictData];
        }
    }

    aSectionTitle = [dictSectionViseData allKeys];
;
    [tblMyNotes reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark    Tableview data source methods

    //section for table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[dictSectionViseData allKeys] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [aSectionTitle objectAtIndex:section];
}

    //number of rows
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dictSectionViseData objectForKey:[aSectionTitle objectAtIndex:section]] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	dictSingleRecord = [[dictSectionViseData objectForKey:[aSectionTitle objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
	arrTempData = [mutArrayAllImages objectAtIndex:indexPath.row+1];
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if(aCell==nil)
		{
        aCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
		}
    aCell.textLabel.text = [dictSingleRecord objectForKey:@"Title"];
	aCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	aCell.imageView.image = [UIImage imageWithData:[arrTempData lastObject]];
    return aCell;
}

#pragma mark -
#pragma mark TableView Delegates
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	dictSingleRecord=nil;
	dictSingleRecord=[[dictSectionViseData objectForKey:[aSectionTitle objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    	if ([[dictSingleRecord objectForKey:@"Privacy"] isEqualToString:@"private"]) {
            
            [cell.textLabel setTextColor:[UIColor grayColor]];
            cell.tag=1;
    	}else if([[dictSingleRecord objectForKey:@"Privacy"] isEqualToString:@"public"]){
            [cell.textLabel setTextColor:[UIColor blueColor]];
            cell.tag=2;
        }
    
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);    cell.alpha = 0;
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    cell.layer.transform = rotation;
    
    
    [UIView animateWithDuration:0.8 animations:^{
        cell.alpha=1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        cell.layer.transform=CATransform3DIdentity;
    }];
   
    
//    CATransform3D tranformDefault  = CATransform3DIdentity;
//    [UIView animateWithDuration:0.3 animations:^{
//        cell.layer.transform = tranformDefault;
//    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	dictSingleRecord = nil;
	dictSingleRecord = [[dictSectionViseData objectForKey:[aSectionTitle objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    addEditNotesObj.dictSingleNoteData = dictSingleRecord;
	addEditNotesObj.dataImageData = [[mutArrayAllImages objectAtIndex:indexPath.row+1]lastObject];
    addEditNotesObj.strTitle = @"Edit Note";
	if ([tableView cellForRowAtIndexPath:indexPath].tag==1) {
		addEditNotesObj.isPrivate = YES;
	}else{
		addEditNotesObj.isPrivate = NO;
	}
    [self.navigationController pushViewController:addEditNotesObj animated:YES];
}

    //editing tableview methods

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int total = [tblMyNotes numberOfSections];
    int totalRow = [tblMyNotes numberOfRowsInSection:total];
    if(indexPath.section ==total){
        if (indexPath.row==totalRow) {
            return UITableViewCellEditingStyleInsert;
        }else
        {
            return UITableViewCellEditingStyleDelete;
        }
    }else
    {
        return UITableViewCellEditingStyleDelete;
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	dictSingleRecord = nil;
	dictSingleRecord = [[dictSectionViseData objectForKey:[aSectionTitle objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ipDeleteIndex=indexPath;
        [alertDisplayAlert show];
    }
}

#pragma mark BarButton item click event methods

- (IBAction)btnAddEvent:(UIBarButtonItem *)sender {
    if (sender.tag==1) {
        addEditNotesObj = [[AddEditNote alloc]initWithNibName:@"AddEditNote" bundle:nil];
        addEditNotesObj.strTitle = @"New Note";
        addEditNotesObj.UserId = self.userId;
        [self.navigationController pushViewController:addEditNotesObj animated:YES];
    }else if(sender.tag==2){
        if (!tblMyNotes.editing) {
            
            tblMyNotes.editing=TRUE;
            [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
            
        }else{
            
            tblMyNotes.editing=FALSE;
            [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
            
        }
    }
}


#pragma mark alert view delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ok"]) {
		strQuery = [NSString stringWithFormat:@"delete from Notes where NoteId = %@",[dictSingleRecord objectForKey:@"NoteId"]];
		[[DIO sharedObject]deleteRecord:strQuery];
		[[dictSectionViseData objectForKey:[aSectionTitle objectAtIndex:ipDeleteIndex.section]] removeObjectAtIndex:ipDeleteIndex.row];
		[tblMyNotes deleteRowsAtIndexPaths:[NSArray arrayWithObject:ipDeleteIndex] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
@end
