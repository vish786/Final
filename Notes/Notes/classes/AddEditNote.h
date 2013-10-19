//
//  AddEditNote.h
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIO.h"
#import "EditImage.h"
@class EditImage;
@interface AddEditNote : UIViewController <UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
#pragma mark variable declaration
    BOOL isDateVisible;
	BOOL isEditing;
    UIAlertView *alertDisplayAlert,*alertDisplayError;
    UIImagePickerController *imgPickerController;
    UIActionSheet *asShowImageSource;
    BOOL isImageSelected,isImageEdited;
	UITouch *touchLocationInImage;
	EditImage *editImageObj;

#pragma mark outlets
    IBOutlet UIDatePicker *dpDateOfBirth;
    IBOutlet UILabel *lblDate;
    IBOutlet UIButton *aPublic;
    IBOutlet UIButton *aPrivate;
    IBOutlet UITextField *tfField;
    IBOutlet UITextView *tvView;
	IBOutlet UIBarButtonItem *btnDoneButton;
	IBOutlet UIToolbar *toolBar;
    IBOutlet UIImageView *ivCaptionImage;
}

#pragma mark Properties

@property (nonatomic,retain)NSString *strTitle;
@property (nonatomic,retain)NSDictionary *dictSingleNoteData;
@property (nonatomic,retain)NSData *dataImageData;
@property (nonatomic,assign)int UserId;
@property (nonatomic,assign)BOOL isPrivate;

-(IBAction)btnDone:(id)sender;
@end
