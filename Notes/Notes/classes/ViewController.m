//
//  ViewController.m
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
		//background
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
        //delegate and datasource
    tfEmailAddress.delegate=self;
    tfPassword.delegate=self;
    
        //initialization
    alertDisplayAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    strLaxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    BOOL stricterFilter = YES;
    strEmailRegex = stricterFilter ? stricterFilterString : strLaxString;
    strEmailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strEmailRegex];

}
-(void)viewWillAppear:(BOOL)animated
{
	self.navigationItem.title =@"Sign in";
	tfEmailAddress.text = @"";
	tfPassword.text = @"";
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isRememberMe"]){
			//initialize tabbar
		aTabBarController = [[UITabBarController alloc]init];
		
		[self initTabBar];
		[self.navigationController pushViewController:aTabBarController animated:YES];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tabbar initialization method

-(void)initTabBar{
	allNotesObj =[[AllNotes alloc]initWithNibName:@"AllNotes" bundle:nil];
	UINavigationController *aAllNotesNC = [[UINavigationController alloc]initWithRootViewController:allNotesObj];
	allNotesObj.userId=[[NSUserDefaults standardUserDefaults] integerForKey:@"UserId"];
	
	myNotesObj = [[MyNotes alloc]initWithNibName:@"MyNotes" bundle:nil];
	UINavigationController *aMyNotesNC = [[UINavigationController alloc]initWithRootViewController:myNotesObj];
	myNotesObj.userId =[[NSUserDefaults standardUserDefaults] integerForKey:@"UserId"];
	
	settingsObj = [[Settings alloc]initWithNibName:@"Settings" bundle:nil];
	self.navigationController.navigationBarHidden = YES;
	[aTabBarController setViewControllers:[NSArray arrayWithObjects:aAllNotesNC,aMyNotesNC ,settingsObj, nil]];
	
	UITabBar *aTabBar = aTabBarController.tabBar;
	[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"selectioinBackGround.jpg"]];
	[[UITabBar appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
	UITabBarItem *aAllNotes = [aTabBar.items objectAtIndex:0];
	UITabBarItem *aMyNotes= [aTabBar.items objectAtIndex:1];
	UITabBarItem *aSettings = [aTabBar.items objectAtIndex:2];
	
	[aAllNotes setTitle:@"Public"];
	[aAllNotes setFinishedSelectedImage:[UIImage imageNamed:@"publicIcon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"publicIcon.png"]];
	
	[aMyNotes setTitle:@"My Notes"];
	[aMyNotes setFinishedSelectedImage:[UIImage imageNamed:@"privateIcon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"privateIcon.png"]];
	
	[aSettings setTitle:@"Settings"];
	[aSettings setFinishedSelectedImage:[UIImage imageNamed:@"settingsIcon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"settingsIcon.png"]];
	[aTabBar setBackgroundColor:[UIColor grayColor]];
	
}
#pragma mark button click method
- (IBAction)btnClickEvent:(UIButton *)sender {
    
    if (sender.tag==1) {
        if (![tfEmailAddress.text isEqualToString:@""] & ![tfPassword.text isEqualToString:@""]  & [strEmailTest evaluateWithObject:tfEmailAddress.text]) {
                //login in to system
            isLoginConstrainCorrect=NO;
            strQuery= [NSString stringWithFormat:@"select UserId,FName,LName,Email,Password from UserInfo where Email='%@'",tfEmailAddress.text];
            aLoginData = [[DIO sharedObject]getRecords:strQuery];
            if([aLoginData count]>1){
                NSArray *aTmp = [aLoginData objectAtIndex:1];
                if([[aTmp objectAtIndex:4]isEqualToString:[NSString stringWithFormat:@"%@",tfPassword.text]]){
						//save user info
					
					if (btnRememberMe.selected == YES) {
						if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isRememberMe"]){
							[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRememberMe"];
						}
					}
					[[NSUserDefaults standardUserDefaults] setInteger:[[aTmp objectAtIndex:0] intValue] forKey:@"UserId"];
					[[NSUserDefaults standardUserDefaults] synchronize];
						//initialize tabbar
                    aTabBarController = [[UITabBarController alloc]init];

					[self initTabBar];
                    [self.navigationController pushViewController:aTabBarController animated:YES];
                }else{
                        //alert for invalid login credentials
                    alertDisplayAlert.title=@"Alert";
                    alertDisplayAlert.message=@"Invalid User Email or Password";
                    [alertDisplayAlert show];
                }
            }else{
					//alert for invalid login credentials
				alertDisplayAlert.title=@"Alert";
				alertDisplayAlert.message=@"Invalid User Email or Password";
				[alertDisplayAlert show];
			}
            
        }else if([tfEmailAddress.text isEqualToString:@""] | [tfPassword.text isEqualToString:@""]){
                //alert for email of password empty
            alertDisplayAlert.title=@"Alert";
            alertDisplayAlert.message=@"Please Enter All Fields First";
            [alertDisplayAlert show];
        }else if(![strEmailTest evaluateWithObject:tfEmailAddress.text]){
                //alert for email format wrong
            alertDisplayAlert.title=@"Alert";
            alertDisplayAlert.message=@"Incorrect Email Format";
            [alertDisplayAlert show];
        }
    }else if(sender.tag==2){
        tfEmailAddress.text=@"";
        tfPassword.text=@"";
    }else if(sender.tag == 3){
            //reset password
		resetPasswordObj = [[ResetPasswordVC alloc]initWithNibName:@"ResetPasswordVC" bundle:nil];
		[self.navigationController pushViewController:resetPasswordObj animated:YES];
    }else if(sender.tag==4){
            //registration
        signUPVCObj = [[SignUPVC alloc]initWithNibName:@"SignUPVC" bundle:nil];
        [self.navigationController pushViewController:signUPVCObj animated:YES];
    }else if(sender.tag ==5){
        if(sender.selected==NO){
            sender.selected = YES;
        }else{
            sender.selected = NO;
        }
    }
}

#pragma mark text field Delegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
