//
//  EditImage.m
//  Notes
//
//  Created by Akshay Kuchhadiya on 07/10/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import "EditImage.h"

@interface EditImage ()

@end

@implementation EditImage
#pragma mark -
#pragma mark ViewController Life Cycle methods

-(EditImage *)init
{
    self =[super init];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self setHidesBottomBarWhenPushed:YES];
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    intCallCount = 0;
		// Do any additional setup after loading the view, typically from a nib.
    
        //BarButton
    
    UIBarButtonItem *barBtnSave = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(barBtnSave:)];
    self.navigationItem.rightBarButtonItem = barBtnSave;
    
    ipcSelectImage = [[UIImagePickerController alloc]init];
    ipcSelectImage.delegate = self;
    
        //colors pallet
    
    viewDisplay.hidden=YES;
    viewDisplay = [[UIView alloc]initWithFrame:CGRectMake(20, 80, 290, 330)];
    viewDisplay.layer.cornerRadius=20;
    colorsObj = [[ColorsVC alloc]init];
    [viewDisplay addSubview:colorsObj.view];
    viewDisplay.hidden = YES;
    [self addChildViewController:colorsObj];
    
    mutArrayAllLayers = [[NSMutableArray alloc]init];

        //new layer pallet
    btnNewLayer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnNewLayer.frame=CGRectMake(0, 0, 80, 30);
    [btnNewLayer setTitle:@"New" forState:UIControlStateNormal];
    [btnNewLayer addTarget:self action:@selector(btnNewLayerEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    btnDeleteLayer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnDeleteLayer.frame=CGRectMake(0, 35, 80, 30);
    [btnDeleteLayer setTitle:@"Delete" forState:UIControlStateNormal];
    [btnDeleteLayer addTarget:self action:@selector(btnDeleteLayerEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    viewLayer = [[UIView alloc]initWithFrame:CGRectMake(210, 380, 80, 60)];
    [viewLayer addSubview:btnNewLayer];
    [viewLayer addSubview:btnDeleteLayer];
    [self.view addSubview:viewDisplay];
    viewLayer.hidden=YES;
    
        //gesture for toolbar
    
    grLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(grLongPressDetected:)];
    [self.view addGestureRecognizer:grLongPress];
        
        //initialize toolbar
    
    tbToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 450, 400, 55)];
    tbToolBar.barStyle = UIBarStyleBlackTranslucent;
    btnClear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	btnClear = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClearEvent:)];
    
    btnColors=[[UIBarButtonItem alloc]initWithTitle:@"Colors" style:UIBarButtonItemStyleBordered target:self action:@selector(btnColorsEvent:)];
    
    btnSettings = [[UIBarButtonItem alloc]initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(btnSettgins:)];
    btnLayer = [[UIBarButtonItem alloc]initWithTitle:@"Layer" style:UIBarButtonItemStyleBordered target:self action:@selector(btnLayer:)];
    
    btnLoadImage = [[UIBarButtonItem alloc]initWithTitle:@"Load Image" style:UIBarButtonItemStyleBordered target:self action:@selector(btnLoadImage:)];
	tbToolBar.items = @[btnClear,btnColors,btnLoadImage,btnLayer,btnSettings];
	[self.view addSubview:tbToolBar];
	
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setHidesBottomBarWhenPushed:YES];
        //initialize new layer
    
    ivImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    ivImageView.image = [UIImage imageWithData:self.dataImageData];
    [ivImageView setUserInteractionEnabled:YES];
    [self.view addSubview:ivImageView];
    [self.view bringSubviewToFront:tbToolBar];
    isErasing = false;
    [mutArrayAllLayers addObject:ivImageView];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self btnNewLayerEvent:btnNewLayer];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
		// Dispose of any resources that can be recreated.
}

-(void)loadView
{
    [super loadView];
    self.view= [[View alloc]initWithFrame:self.view.frame];
    self.view.backgroundColor =[UIColor whiteColor];
}

#pragma mark -
#pragma mark Touch Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideColors];
    [self hideLaye];
    UITouch *aTouch = [touches anyObject];
    pointLastPoint = [aTouch locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([mutArrayAllLayers count] >=1) {
        CGPoint movedPoint = [[touches anyObject] locationInView:self.view];
        UIGraphicsBeginImageContext(self.view.frame.size);
        ivImageView =[mutArrayAllLayers lastObject];
        [ivImageView drawRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, colorLineColor.CGColor);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextMoveToPoint(context, pointLastPoint.x, pointLastPoint.y);
        CGContextAddLineToPoint(context, movedPoint.x, movedPoint.y);
        if (isErasing) {
            CGContextSetLineWidth(context, 30);
            CGContextSetBlendMode(context, kCGBlendModeClear);
        }else{
            CGContextSetLineWidth(context, 5);
            CGContextSetBlendMode(context, kCGBlendModeNormal);
        }
        CGContextStrokePath(context);
        ivImageView.image= UIGraphicsGetImageFromCurrentImageContext();
            //    CGContextSaveGState(context);
        pointLastPoint = movedPoint;
        UIGraphicsEndImageContext();
    }
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    pointLastPoint = [[touches anyObject] locationInView:self.view];
}


#pragma mark -
#pragma mark Button Click Event Methods


#pragma mark -
#pragma mark Bar Button methdos

-(void)barBtnSave:(UIBarButtonItem *)sender
{
    tbToolBar.hidden = YES;
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    ivImageView.image= UIGraphicsGetImageFromCurrentImageContext();
    NSData *aDataImageData = [NSData dataWithData:UIImagePNGRepresentation(viewImage)];
    self.delegate.dataImageData = aDataImageData;
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -
#pragma mark Choose Color Methods

-(void)btnClearEvent:(UIBarButtonItem *)sender
{
    if(isErasing) isErasing=false;
	else isErasing = true;
}

-(void)btnColorsEvent:(UIBarButtonItem *)sender
{
    [self hideLaye];
    if (viewDisplay.hidden) {
        [self displayColorsView];
    }else{
        [self hideColors];
    }
}
#pragma mark -
#pragma mark Settings

-(void)btnSettgins:(UIBarButtonItem *)sender
{
    
}

#pragma mark -
#pragma mark Layer Pallet Methods

-(void)btnLayer:(UIBarButtonItem *)sender
{
    [self hideColors];
    if (viewLayer.hidden) {
        [self displayLayerView];
    }else{
        [self hideLaye];
    }
}

-(void)btnNewLayerEvent:(UIButton *)sender
{
    ivImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [ivImageView setUserInteractionEnabled:YES];
    [self.view addSubview:ivImageView];
    [self.view bringSubviewToFront:tbToolBar];
    isErasing = false;
    [mutArrayAllLayers addObject:ivImageView];
    [self hideLaye];
}
-(void)btnDeleteLayerEvent:(UIButton *)sender
{
    [ivImageView removeFromSuperview];
    [mutArrayAllLayers removeLastObject];
    ivImageView = [mutArrayAllLayers lastObject];
    [self hideLaye];
}

-(void)btnLoadImage:(UIBarButtonItem *)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        asShowSourceType = [[UIActionSheet alloc]initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil];
        [asShowSourceType showInView:self.view];
    }else{
        asShowSourceType = [[UIActionSheet alloc]initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Library", nil];
        [asShowSourceType showInView:self.view];
    }
}

#pragma mark -
#pragma mark Other Methods

-(void)displayLayerView
{
    viewLayer.hidden=NO;
    [self.view bringSubviewToFront:viewLayer];
    [viewLayer addSubview:btnNewLayer];
    [viewLayer addSubview:btnDeleteLayer];
    viewLayer.alpha=0;
    [self.view addSubview:viewLayer];
    [UIView animateWithDuration:0.4 animations:^{
        viewLayer.alpha=1;
    }];
}

-(void)hideLaye
{
    [UIView animateWithDuration:0.2 animations:^{
        viewLayer.alpha=0;
    } completion:^(BOOL finished) {
        viewLayer.hidden=YES;
    }];
}
-(void)displayColorsView
{
    [self.view bringSubviewToFront:viewDisplay];
    viewDisplay.hidden=NO;
    viewDisplay.alpha =0;
    [UIView animateWithDuration:0.4 animations:^{
        viewDisplay.alpha =1;
    }];
    isColorsVisible = YES;
}
-(void)hideColors
{
    [UIView animateWithDuration:0.3 animations:^{
        viewDisplay.alpha =0;
    } completion:^(BOOL finished) {
        viewDisplay.hidden=YES;
        colorLineColor = colorsObj.colorLineColor;
    }];
}

#pragma mark -
#pragma mark Action Sheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Camera"]) {
        ipcSelectImage.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:ipcSelectImage animated:YES completion:nil];
    }else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Library"]){
        ipcSelectImage.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:ipcSelectImage animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark Image Pickercontroller Delegate Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *aImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    ivImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    ivImageView.image = aImage;
    [ivImageView setUserInteractionEnabled:YES];
    [self.view addSubview:ivImageView];
    [self.view bringSubviewToFront:tbToolBar];
    isErasing = false;
    [mutArrayAllLayers addObject:ivImageView];
    [ipcSelectImage dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark Gesture Recognizer methods

#pragma mark Long Press detected 

-(void)grLongPressDetected:(id)sender
{
    [self hideColors];
    [self hideLaye];
    intCallCount++;
    if (intCallCount==2) {
        intCallCount =0;
    }
    if (tbToolBar.hidden==YES && intCallCount ==1) {
        tbToolBar.hidden=NO;
    }else if(tbToolBar.hidden==NO && intCallCount ==1){
        tbToolBar.hidden=YES;
    }
}

@end
