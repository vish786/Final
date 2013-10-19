//
//  Settings.m
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import "Settings.h"

@interface Settings ()

@end

@implementation Settings

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

    
}
-(void)viewWillAppear:(BOOL)animated
{
		//initialize tab bar
	self.tabBarController.navigationController.navigationBarHidden=NO;
	self.tabBarController.navigationItem.hidesBackButton = YES;
	UIBarButtonItem *aBtnLogout = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(btnLogout:)];
	self.tabBarController.navigationItem.title=@"Settings";
	self.tabBarController.navigationItem.rightBarButtonItem = aBtnLogout;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark button methods

-(void)btnLogout:(UIBarButtonItem *)sender{
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isRememberMe"]){
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRememberMe"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"UserId"];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
}

@end
