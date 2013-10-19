//
//  ResetPasswordVC.h
//  Notes
//
//  Created by Akshay Kuchhadiya on 22/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIO.h"
@interface ResetPasswordVC : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>
{
#pragma mark outlets
	
	IBOutlet UITextField *tfEamil;
	
#pragma mark variables declaration
	
	UIAlertView *alertDisplayAlert;
    NSString *stricterFilterString;
    NSString *strLaxString;
    NSString *strEmailRegex;
    NSPredicate *strEmailTest;
    NSMutableArray *aLoginData;
    NSString *strQuery;

}
- (IBAction)btnShowEvent:(id)sender;
@end
