//
//  AddEditNote.m
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import "AddEditNote.h"

@interface AddEditNote ()

@end

@implementation AddEditNote

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

    isImageSelected = NO;
    ivCaptionImage.image =[UIImage imageNamed:@"imageBack.png"];
    isImageEdited =NO;
        //init image picker
    
    imgPickerController = [[UIImagePickerController alloc]init];
    imgPickerController.delegate = self;
    
    isDateVisible = false;
	tvView.delegate = self;
	tfField.delegate = self;
	
	UIBarButtonItem *aBtnRightButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(btnDone:)];
	aBtnRightButton.tag=2;
	self.navigationItem.rightBarButtonItem = aBtnRightButton;

	
	alertDisplayAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    alertDisplayError = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    
	self.tabBarController.navigationController.navigationBarHidden=YES;
	toolBar.hidden=YES;
	self.tabBarController.navigationItem.hidesBackButton = NO;
	self.tabBarController.hidesBottomBarWhenPushed=NO;
	if ([self.strTitle isEqualToString:@"Edit Note"]){
        self.navigationItem.title =@"Edit Note";
		lblDate.text= [self.dictSingleNoteData objectForKey:@"DateTime"];
		tfField.text = [self.dictSingleNoteData objectForKey:@"Title"];
		tvView.text = [self.dictSingleNoteData objectForKey:@"Description"];
		ivCaptionImage.image = [UIImage imageWithData:self.dataImageData];
		isEditing = YES;
		isImageSelected = YES;
		if (self.isPrivate) {
			aPrivate.selected = YES;
			aPublic.selected= NO;
		}else{
			aPublic.selected = YES;
			aPrivate.selected = NO;
		}
    }else{
        isEditing =NO;
		aPrivate.selected = YES;
        self.navigationItem.title=@"Add Note";
    }
    if (isImageEdited) {
        ivCaptionImage.image=[UIImage imageWithData:self.dataImageData];
        CGRect aDefauleSize = ivCaptionImage.frame;
        ivCaptionImage.frame = CGRectMake(20, 20, 280, 350);
        [UIView animateWithDuration:0.5 animations:^{
            ivCaptionImage.frame = aDefauleSize;
        }];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Text view delegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	[UIView animateWithDuration:0.5 animations:^{
		[self.view setFrame:CGRectMake(0, -160,self.view.frame.size.width , self.view.frame.size.height)];
	} completion:^(BOOL finished) {
		toolBar.frame = CGRectMake(0, 405, toolBar.frame.size.width, toolBar.frame.size.height);
		toolBar.hidden=NO;
	}];
	return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	[UIView animateWithDuration:0.5 animations:^{
		[self.view setFrame:CGRectMake(0, 0,self.view.frame.size.width , self.view.frame.size.height)];
	} completion:^(BOOL finished) {
		toolBar.frame = CGRectMake(0, -405, toolBar.frame.size.width, toolBar.frame.size.height);
		toolBar.hidden=YES;		
	}];
    return YES;
}

#pragma mark -
#pragma mark Text Field Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	toolBar.hidden=YES;
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark Button Methods


-(IBAction)btnDatePickerEvent:(id)sender
{
	toolBar.hidden=YES;
	[tfField resignFirstResponder];
	[tvView resignFirstResponder];
    if (isDateVisible) {
        dpDateOfBirth.hidden = YES;
        isDateVisible =NO;
        NSDate *aDob = [dpDateOfBirth date];
        NSString *aDateFormat =@"dd-MMM-yyyy hh-mm-ss a";
        NSDateFormatter *aFormatter = [[NSDateFormatter alloc]init];
        [aFormatter setDateFormat:aDateFormat];
        lblDate.text = [NSString stringWithFormat:@"%@", [aFormatter stringFromDate:aDob]];
    }else{
        dpDateOfBirth.hidden=false;
        isDateVisible=YES;
    }
}


-(IBAction)btnPrivacyEvent:(id)sender
{
	[tfField resignFirstResponder];
	[tvView resignFirstResponder];
    toolBar.hidden=YES;
	UIButton *aButton = (UIButton *)sender;
    if(aButton.tag ==5){
        if(aButton.selected==NO){
            aButton.selected = YES;
            aPublic.selected =false;
        }else{
            aButton.selected = NO;
            aPublic.selected = YES;
        }
    }else if(aButton.tag ==6){
        if(aButton.selected==NO){
            aButton.selected = YES;
            aPrivate.selected=NO;
        }else{
            aButton.selected = NO;
            aPrivate.selected = YES;
        }
    }
}

-(IBAction)btnDone:(id)sender
{
    NSString *query;
	UIBarButtonItem *aSender = (UIBarButtonItem *)sender;
	if (aSender.tag==1) {
		[tvView resignFirstResponder];
		toolBar.hidden=YES;
	}else if(aSender.tag == 2){
		[tfField resignFirstResponder];
		[tvView resignFirstResponder];
		NSString *aStrPrivacy;
		if (aPublic.selected==TRUE) {
			aStrPrivacy = @"public";
		}else{
			aStrPrivacy = @"private";
		}
		if (![lblDate.text isEqualToString:@""] & ![tfField.text isEqualToString:@""] & ![tvView.text isEqualToString:@""] & isImageSelected) {
			if (isEditing)
			{
				query= [NSString stringWithFormat:@"update Notes set Title ='%@' ,Description = '%@' ,DateTime = '%@', Privacy= '%@' where NoteId = %i",tfField.text,tvView.text,lblDate.text,aStrPrivacy,[[self.dictSingleNoteData objectForKey:@"NoteId"] intValue]];
                [[DIO sharedObject]storeImage:self.dataImageData secondParameter:[NSString stringWithFormat:@"update Notes set Image = ? where NoteId = %i",[[self.dictSingleNoteData objectForKey:@"NoteId"] intValue]]];
				[[DIO sharedObject]updateRecord:query];
			}
			else{
				query = [NSString stringWithFormat:@"insert into Notes (NoteId,Title,Description,UserId,DateTime,Privacy) values (null,'%@','%@',%i,'%@','%@')",tfField.text,tvView.text,self.UserId,lblDate.text,aStrPrivacy];
				[[DIO sharedObject] insertRecord:query];
                int aNoteId = [[DIO sharedObject]getMaxValue:@"SELECT MAX(NoteId) FROM Notes"];
                [[DIO sharedObject]storeImage:self.dataImageData secondParameter:[NSString stringWithFormat:@"update Notes set Image = ? where NoteId = %i",aNoteId]];
                
			}
			[self.navigationController popViewControllerAnimated:YES];
		}else{
			alertDisplayError.title=@"Alert";
			alertDisplayError.message= @"Enter All Fields";
			[alertDisplayError show];
		}
	}
}

#pragma mark -
#pragma mark Action Sheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Library"]) {
        imgPickerController.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imgPickerController animated:YES completion:Nil];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Camera Rear"]){
        imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPickerController.cameraDevice=UIImagePickerControllerCameraDeviceRear;
        imgPickerController.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:imgPickerController animated:YES completion:Nil];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Camera Front"]){
        imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPickerController.cameraDevice=UIImagePickerControllerCameraDeviceFront;
        imgPickerController.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:imgPickerController animated:YES completion:Nil];
    }
}


#pragma mark -
#pragma mark Image picker delegates

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
        //    NSString *aFileName = [NSString stringByAppendingPathComponent:[NSString stringWithFormat:@"Img_%i.png",[mutArrListOfPhotos count]+1]];
    UIImage *aEditedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *aOrigionalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (aEditedImage) {
        CGRect aDefauleSize = ivCaptionImage.frame;
        ivCaptionImage.image = aEditedImage;
        ivCaptionImage.frame = CGRectMake(20, 20, 280, 350);
        [UIView animateWithDuration:0.7 animations:^{
            ivCaptionImage.frame = aDefauleSize;
        }];
        self.dataImageData = UIImagePNGRepresentation(aEditedImage);
    }else{
        ivCaptionImage.image=aOrigionalImage;
        CGRect aDefauleSize = ivCaptionImage.frame;
        ivCaptionImage.frame = CGRectMake(20, 20, 280, 350);
        [UIView animateWithDuration:0.5 animations:^{
            ivCaptionImage.frame = aDefauleSize;
        }];
        self.dataImageData = UIImagePNGRepresentation(aOrigionalImage);
    }
    
    isImageSelected = YES;
    [imgPickerController dismissViewControllerAnimated:YES completion:Nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    isImageSelected = NO;
    [imgPickerController dismissViewControllerAnimated:YES completion:Nil];
}


#pragma mark -
#pragma mark Alert View Delegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Edit"]) {
			//show view controller for editing image
		if (!editImageObj) {
			editImageObj = [[EditImage alloc]init];
		}
        isImageEdited = YES;
        editImageObj.delegate =self;
		editImageObj.dataImageData = self.dataImageData;
		[self.navigationController pushViewController:editImageObj animated:YES];
	}else if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Retake"]){
			//show image source
		[self checkImageSource];
	}
}



#pragma mark -
#pragma mark View's Touch methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchLocationInImage = [touches anyObject];
    CGRect frame = ivCaptionImage.frame;
    CGPoint touchLocation = [touchLocationInImage locationInView:self.view];
    if (CGRectContainsPoint(frame  ,touchLocation)) {
        if (isImageSelected) {
            alertDisplayAlert = [[UIAlertView alloc]initWithTitle:@"Image Options" message:@"Choose One " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Edit",@"Retake", nil];
            [alertDisplayAlert show];
        }else{
            [self checkImageSource];
        }        
    }
}


#pragma mark -
#pragma mark Handle Image Source Check

-(void)checkImageSource
{
	if (CGRectContainsPoint(ivCaptionImage.frame, [touchLocationInImage locationInView:self.view])) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                asShowImageSource = [[UIActionSheet alloc]initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera Front",@"Camera Rear",@"Library", nil];
                [asShowImageSource showInView:self.view];
            }else{
                asShowImageSource = [[UIActionSheet alloc]initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera Rear",@"Library", nil];
                [asShowImageSource showFromTabBar:self.tabBarController.tabBar];
            }
            
        }else{
            asShowImageSource = [[UIActionSheet alloc]initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Library", nil];
            [asShowImageSource showFromTabBar:self.tabBarController.tabBar];
        }
    }
}

@end
