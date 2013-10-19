//
//  SignUPVCViewController.m
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import "SignUPVC.h"

@interface SignUPVC ()

@end

@implementation SignUPVC

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

        //prifle image
    isImageSelected = NO;
    ivProfileImage.image =[UIImage imageNamed:@"imageBack.png"];
        //init image picker
    
    imgPickerController = [[UIImagePickerController alloc]init];
    imgPickerController.delegate = self;
    
        //delegate and datasource
    tfFName.delegate = self;
    tfLName.delegate = self;
    tfEmailAddress.delegate=self;
    tfPassword.delegate=self;
    alertDisplayAlert.delegate =self;
	
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
		//nav setup
    self.navigationItem.title=@"Sign Up";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Button Click methods
- (IBAction)btnBackEvent:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnClickEvent:(id)sender
{
    UIButton *aBtnTmp = (UIButton *)sender;
    if (aBtnTmp.tag ==1) {
        
            //Check For All Fields
        if (![tfFName.text isEqualToString:@""] & ![tfLName.text isEqualToString:@""] &![tfEmailAddress.text isEqualToString:@""] & ![tfPassword.text isEqualToString:@""]  & [strEmailTest evaluateWithObject:tfEmailAddress.text]& isImageSelected)
        {
                //check for login credentials
            strQuery =[NSString stringWithFormat:@"select * from UserInfo where Email= '%@'",tfEmailAddress.text];
            aLoginData=[[DIO sharedObject]getRecords:strQuery];
                //check for Existing Email
            if([aLoginData count]>1)
            {
                NSArray *aTmp = [aLoginData lastObject];
                if([[aTmp objectAtIndex:3]isEqualToString:[NSString stringWithFormat:@"%@",tfEmailAddress.text]]){
                        //alert for email exist
                    alertDisplayAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"InvalidEamil", nil];
                    alertDisplayAlert.message=@"Please Enter Diffrent Email this email is Registerd";
                    [alertDisplayAlert show];
                }
            }else
            {
                strQuery =[NSString stringWithFormat:@"insert into UserInfo(UserId,FName,LName,Email,Password) values (null,'%@','%@','%@','%@')",tfFName.text,tfLName.text,tfEmailAddress.text,tfPassword.text];
                int aResult = [[DIO sharedObject]insertRecord:strQuery];
                
                int aUserId = [[DIO sharedObject]getMaxValue:@"SELECT MAX(UserId) FROM UserInfo"];
                int aImgResult = [[DIO sharedObject]storeImage:dataImage secondParameter:[NSString stringWithFormat:@"update UserInfo set Image = ? where UserId = %i",aUserId]];
                if (aResult == 0 && aImgResult ==101) {
                        //present popup for success
                    alertDisplayAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    alertDisplayAlert.message=@"Congratulation You Registerd Success fully Login with you email and password";
                    [alertDisplayAlert show];
                }else{
						//present popup for error
                    alertDisplayAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Retry", nil];
                    alertDisplayAlert.message=@"Registration Erro Cant complete right now";
                    [alertDisplayAlert show];
                }
            }
        }
        else if([tfFName.text isEqualToString:@""] | [tfLName.text isEqualToString:@""] |[tfEmailAddress.text isEqualToString:@""] |[tfPassword.text isEqualToString:@""] | !isImageSelected){
                //alert for enter all fields
            alertDisplayAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ReEnter", nil];
            alertDisplayAlert.message=@"Please Enter All Fields First";
            [alertDisplayAlert show];
        }else if(![strEmailTest evaluateWithObject:tfEmailAddress.text]){
                //alert for wrong email address
            alertDisplayAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ReEnter", nil];
            alertDisplayAlert.message=@"Incorrect Email Format";
            [alertDisplayAlert show];
        }
    }else if(aBtnTmp.tag==2){
        tfFName.text=@"";
        tfLName.text=@"";
        tfEmailAddress.text=@"";
        tfPassword.text=@"";
    }}

#pragma mark text field Delegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag ==1 | textField.tag ==2) {
        if ([textField.text length]==0) {
            textField.text=[string uppercaseString];
            return NO;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	NSLog(@"%i",textField.tag);
    if (textField.tag ==3) {
		[UIView animateWithDuration:0.5 animations:^{
			[self.view setFrame:CGRectMake(0, -150,self.view.frame.size.width , self.view.frame.size.height)];
		}];
    }else if(textField.tag ==4){
		[UIView animateWithDuration:0.5 animations:^{
			[self.view setFrame:CGRectMake(0, -160,self.view.frame.size.width , self.view.frame.size.height)];
		}];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	if (textField.tag==3 | textField.tag==4) {
		[UIView animateWithDuration:0.5 animations:^{
			[self.view setFrame:CGRectMake(0, 0,self.view.frame.size.width , self.view.frame.size.height)];
		}];		
	}
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark alert view delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ok"]) {
        [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark Image Picker Delegate 

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
//    NSString *aFileName = [NSString stringByAppendingPathComponent:[NSString stringWithFormat:@"Img_%i.png",[mutArrListOfPhotos count]+1]];
    UIImage *aEditedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *aOrigionalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (aEditedImage) {
        CGRect aDefauleSize = ivProfileImage.frame;
        ivProfileImage.image = aEditedImage;
        ivProfileImage.frame = CGRectMake(20, 20, 280, 350);
        [UIView animateWithDuration:0.7 animations:^{
            ivProfileImage.frame = aDefauleSize;
        }];
        dataImage = UIImagePNGRepresentation(aEditedImage);
    }else{
        ivProfileImage.image=aOrigionalImage;
        CGRect aDefauleSize = ivProfileImage.frame;
        ivProfileImage.frame = CGRectMake(20, 20, 280, 350);
        [UIView animateWithDuration:0.5 animations:^{
            ivProfileImage.frame = aDefauleSize;
        }];
        dataImage = UIImagePNGRepresentation(aOrigionalImage);
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
#pragma mark Touch Methods


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    if (CGRectContainsPoint(ivProfileImage.frame, [aTouch locationInView:self.view])) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                asShowImageSource = [[UIActionSheet alloc]initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera Front",@"Camera Rear",@"Library", nil];
                [asShowImageSource showInView:self.view];
            }else{
                asShowImageSource = [[UIActionSheet alloc]initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera Rear",@"Library", nil];
                [asShowImageSource showInView:self.view];
            }
            
        }else{
            asShowImageSource = [[UIActionSheet alloc]initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Library", nil];
            [asShowImageSource showInView:self.view];
        }
    }
}

@end
