//
//  AllNotes.m
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import "AllNotes.h"
#import <QuartzCore/QuartzCore.h>
@interface AllNotes ()

@end

@implementation AllNotes

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

    // Do any additional setup after loading the view from its nib.
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:195.0/255.0 green:150.0/255.0 blue:210.0/255.0 alpha:1];
    
    tblAllNotes.delegate = self;
    tblAllNotes.dataSource = self;
    
    [mutArrayNotesData removeAllObjects];
    dictSectionViseData = [[NSMutableDictionary alloc]init];
    dictSingleRecord = [[NSDictionary alloc]init];
	
		//get user data
	strQuery  = [NSString stringWithFormat:@"select UserId,FName,LName from UserInfo"];
	arrAllUserInfo = [[DIO sharedObject]getRecords:strQuery];
    notesDetailObj = [[NotesDetailVC alloc]initWithNibName:@"NotesDetailVC" bundle:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
		//initialize tabbar
	[mutArrAllNotes removeAllObjects];
	[dictSectionViseData removeAllObjects];
	self.tabBarController.navigationController.navigationBarHidden=YES;
	self.navigationItem.title=@"All Notes";

		//initialize data
    strQuery = [NSString stringWithFormat:@"Select NoteId,Title,Description,UserId,DateTime,Privacy from Notes where UserId != %i and Privacy='public'",self.userId];
    mutArrAllNotes = [[DIO sharedObject]getRecords:strQuery];
	strQuery = [NSString stringWithFormat: @"select Image from Notes where UserId != %i and Privacy='public'" ,self.userId];
	mutArrayAllImages = [[DIO sharedObject]getImages:strQuery];
    for (int i=1; i<[mutArrAllNotes count]; i++) {
        aDictData = [NSDictionary dictionaryWithObjects:[mutArrAllNotes objectAtIndex:i]forKeys:[mutArrAllNotes objectAtIndex:0]];
		for (int j=1; j<[arrAllUserInfo count]; j++) {
			if ([[[arrAllUserInfo objectAtIndex:j] objectAtIndex:0] intValue ]==[[aDictData objectForKey:@"UserId"] intValue]) {
				aArrTmp = [arrAllUserInfo objectAtIndex:j];
				break;
			}
		}
		aStrTmp = [NSString stringWithFormat:@"%@ %@",[aArrTmp objectAtIndex:1],[aArrTmp objectAtIndex:2]];
        if ([dictSectionViseData objectForKey:aStrTmp]==nil) {
            NSMutableArray *aArray = [[NSMutableArray alloc]init];
            [aArray addObject:aDictData];
            [dictSectionViseData setObject:aArray forKey:aStrTmp];
        }else{
            [[dictSectionViseData objectForKey:aStrTmp]addObject:aDictData];
        }
    }
    aSectionTitle = [[dictSectionViseData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [tblAllNotes reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    Tableview delegate and data source methods

    //section for table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [aSectionTitle count];
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
	arrTempData = [mutArrayAllImages objectAtIndex:indexPath.row +1];
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if(aCell==nil)
    {
		aCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }else{
//		aCell.textLabel.text= @"";
//		aCell.imageView.image = nil;
	}
	aCell.textLabel.text = [dictSingleRecord objectForKey:@"Title"];
	aCell.imageView.image =[UIImage imageWithData:[arrTempData lastObject]];
	aCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return aCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	dictSingleRecord = [[dictSectionViseData objectForKey:[aSectionTitle objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    notesDetailObj.dictSingleNoteData = dictSingleRecord;
	notesDetailObj.dataImageData = [[mutArrayAllImages objectAtIndex:indexPath.row+1]lastObject];
    [self.navigationController pushViewController:notesDetailObj animated:YES];
}
#pragma mark tableview delgate methods
    //editing tableview methods

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

}
@end
