//
//  NotesDetailVC.m
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import "NotesDetailVC.h"

@interface NotesDetailVC ()

@end

@implementation NotesDetailVC

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
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.navigationItem.title=@"Details";
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
	lblTitle.text = [self.dictSingleNoteData objectForKey:@"Title"];
    lblDate.text= [self.dictSingleNoteData objectForKey:@"DateTime"];
    lblDescription.text = [self.dictSingleNoteData objectForKey:@"Description"];
    ivCaptionImage.image = [UIImage imageWithData:self.dataImageData];
	self.navigationController.title = @"Note Detail";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClickedEvent:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
