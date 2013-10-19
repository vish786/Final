//
//  SignUPVCViewController.h
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIO.h"

@interface SignUPVC : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
#pragma mark Outlets
    
    IBOutlet UITextField *tfFName;
    IBOutlet UITextField *tfLName;
    IBOutlet UITextField *tfEmailAddress;
    IBOutlet UITextField *tfPassword;
    IBOutlet UIImageView *ivProfileImage;

#pragma mark Variables Declaration
    BOOL isImageSelected;
    NSMutableArray *aLoginData;
    NSString *strQuery;
    BOOL isLoginConstrainCorrect;
    UIAlertView *alertDisplayAlert;
    NSString *stricterFilterString;
    NSString *strLaxString;
    NSString *strEmailRegex;
    NSPredicate *strEmailTest;
    UIImagePickerController *imgPickerController;
    UIActionSheet *asShowImageSource;
    NSData *dataImage;
    
}

#pragma mark Button Click methods
- (IBAction)btnClickEvent:(UIButton *)sender;


@end
