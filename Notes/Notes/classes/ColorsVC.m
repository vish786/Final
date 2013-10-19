//
//  ColorsVC.m
//  Paint
//
//  Created by IndiaNIC on 02/10/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import "ColorsVC.h"
#import "View.h"
#import <QuartzCore/QuartzCore.h>

@interface ColorsVC ()

@end

@implementation ColorsVC


#pragma mark -
#pragma mark Viewcontroller LifeCycle Methods
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
	// Do any additional setup after loading the view.
    UILabel *aLblRed = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 30)];
    aLblRed.text=@"Red Color";
    aLblRed.backgroundColor = [UIColor clearColor];
    sldrRed = [[UISlider alloc]initWithFrame:CGRectMake(120, 20, 70, 30)];
    sldrRed.minimumValue=0;
    sldrRed.maximumValue=1;
    [sldrRed addTarget:self action:@selector(sldrValueChanged:) forControlEvents:UIControlEventValueChanged];
    sldrRed.tag=1;
    aLblDispRed = [[UILabel alloc]initWithFrame:CGRectMake(190, 20, 60, 30)];
    aLblDispRed.backgroundColor = [UIColor clearColor];
    
    UILabel *aLblBlue = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 100, 30)];
    aLblBlue.text=@"Blue Color";
    aLblBlue.backgroundColor = [UIColor clearColor];
    sldrBlue = [[UISlider alloc]initWithFrame:CGRectMake(120, 60, 70, 30)];
    sldrBlue.minimumValue=0;
    sldrBlue.maximumValue=1;
    sldrBlue.tag=2;
    [sldrBlue addTarget:self action:@selector(sldrValueChanged:) forControlEvents:UIControlEventValueChanged];
    aLblDispBlue = [[UILabel alloc]initWithFrame:CGRectMake(190, 60, 60, 30)];
    aLblDispBlue.backgroundColor =[UIColor clearColor];

    UILabel *aLblGreen = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 100, 30)];
    aLblGreen.text=@"Green Color";
    aLblGreen.backgroundColor=[UIColor clearColor];
    sldrGreen = [[UISlider alloc]initWithFrame:CGRectMake(120, 100, 70, 30)];
    sldrGreen.minimumValue=0;
    sldrGreen.maximumValue=1;
    sldrGreen.tag=3;
    [sldrGreen addTarget:self action:@selector(sldrValueChanged:) forControlEvents:UIControlEventValueChanged];
    aLblDispGreen = [[UILabel alloc]initWithFrame:CGRectMake(190, 100, 60, 30)];
    aLblDispGreen.backgroundColor=[UIColor clearColor];

    UILabel *aLblAlpha = [[UILabel alloc]initWithFrame:CGRectMake(20, 140, 100, 30)];
    aLblAlpha.text=@"Alpha";
    aLblAlpha.backgroundColor=[UIColor clearColor];
    sldrAlpha = [[UISlider alloc]initWithFrame:CGRectMake(120, 140, 70, 30)];
    sldrAlpha.minimumValue=0;
    sldrAlpha.maximumValue=1;
    sldrAlpha.value=1;
    sldrAlpha.tag=4;
    [sldrAlpha addTarget:self action:@selector(sldrValueChanged:) forControlEvents:UIControlEventValueChanged];
    aLblAlphaValue = [[UILabel alloc]initWithFrame:CGRectMake(190, 140, 60, 30)];
    aLblAlphaValue.backgroundColor=[UIColor clearColor];
    
    
    [self.view addSubview:aLblRed];
    [self.view addSubview:sldrRed];
    [self.view addSubview:aLblDispRed];
    
    [self.view addSubview:aLblBlue];
    [self.view addSubview:sldrBlue];
    [self.view addSubview:aLblDispBlue];

    [self.view addSubview:aLblGreen];
    [self.view addSubview:sldrGreen];
    [self.view addSubview:aLblDispGreen];

    [self.view addSubview:aLblAlpha];
    [self.view addSubview:sldrAlpha];
    [self.view addSubview:aLblAlphaValue];

}


-(void)loadView
{
    [super loadView];
    
    View *aView = [[View alloc]initWithFrame:CGRectMake(0, 0, 290, 330)];
    aView.layer.cornerRadius=10;
    [aView setBackgroundColor:[UIColor lightGrayColor]];
    [aView setAlpha:1];
    self.view =aView;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Slider Value changed Method


-(void)sldrValueChanged:(UISlider *)sender
{
    if (sender.tag==1) {
        aLblDispRed.text=[NSString stringWithFormat:@"%f",sender.value];
    }else if(sender.tag ==2){
        aLblDispBlue.text=[NSString stringWithFormat:@"%f",sender.value];
    }else if (sender.tag == 3){
        aLblDispGreen.text=[NSString stringWithFormat:@"%f",sender.value];
    }else if(sender.tag ==4){
        aLblAlphaValue.text = [NSString stringWithFormat:@"%f",sender.value];
    }
    self.colorLineColor = [UIColor colorWithRed:sldrRed.value green:sldrGreen.value blue:sldrBlue.value alpha:sldrAlpha.value];
    [self.view setBackgroundColor:self.colorLineColor];
}

#pragma mark -
#pragma mark View's Touch Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
