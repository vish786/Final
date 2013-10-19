//
//  ViewController.h
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIO.h"
#import "AllNotes.h"
#import "MyNotes.h"
#import "Settings.h"
#import "SignUPVC.h"
#import "ResetPasswordVC.h"

@interface ViewController : UIViewController <UITextFieldDelegate>
{
#pragma mark Outlets
    
    IBOutlet UITextField *tfEmailAddress;
    IBOutlet UITextField *tfPassword;
    IBOutlet UIButton *btnRememberMe;
#pragma mark Variables Declaration
    NSMutableArray *aLoginData;
    NSString *strQuery;
    BOOL isLoginConstrainCorrect;
    NSString *stricterFilterString;
    NSString *strLaxString;
    NSString *strEmailRegex;
    NSPredicate *strEmailTest;
	
	
	AllNotes *allNotesObj;
    MyNotes *myNotesObj;
    Settings *settingsObj;
    SignUPVC *signUPVCObj;
	ResetPasswordVC *resetPasswordObj;
    UIAlertView *alertDisplayAlert;
	UITabBarController *aTabBarController;

}

-(void)initTabBar;

#pragma mark Button Click methods
- (IBAction)btnClickEvent:(UIButton *)sender;
@end
