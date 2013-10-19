//
//  ResetPasswordVC.m
//  Notes
//
//  Created by Akshay Kuchhadiya on 22/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import "ResetPasswordVC.h"

@interface ResetPasswordVC ()

@end

@implementation ResetPasswordVC

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

		//delegates
	tfEamil.delegate = self;
	alertDisplayAlert.delegate = self;
	
	stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    strLaxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    BOOL stricterFilter = YES;
    strEmailRegex = stricterFilter ? stricterFilterString : strLaxString;
    strEmailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strEmailRegex];
	alertDisplayAlert =[[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Re-Enter", nil];
}
-(void)viewWillAppear:(BOOL)animated
{
	self.navigationItem.title=@"Reset";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Button events methods
- (IBAction)btnShowEvent:(UIButton *)sender {
	if (![tfEamil.text isEqualToString:@""] & [strEmailTest evaluateWithObject:tfEamil.text]) {
		strQuery =[NSString stringWithFormat:@"select Password from UserInfo where Email= '%@'",tfEamil.text];
		aLoginData=[[DIO sharedObject]getRecords:strQuery];
		if ([aLoginData count]>1) {
			NSArray *aTmp = [aLoginData objectAtIndex:1];
				//alert for Display Password
			alertDisplayAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Your  Password is %@",[aTmp objectAtIndex:0]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
			[alertDisplayAlert show];
		}else{
			[alertDisplayAlert setMessage:@"You Entered Wrong Email Address"];
			[alertDisplayAlert show];
		}
	}else if([tfEamil.text isEqualToString:@""]){
		[alertDisplayAlert setMessage:@"Please Enter all fields"];
		[alertDisplayAlert show];
	}else if(![strEmailTest evaluateWithObject:tfEamil.text]){
		[alertDisplayAlert setMessage:@"You Enter Wrong Format of Email"];
		[alertDisplayAlert show];
	}
}


#pragma mark textfield delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


#pragma mark Alert view delegate methods 

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ok"]) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}
@end
