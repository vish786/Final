//
//  ColorsVC.h
//  Paint
//
//  Created by IndiaNIC on 02/10/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorsVC : UIViewController


{
#pragma mark -
#pragma mark Variables
    
    UILabel *aLblDispRed,*aLblDispBlue,*aLblDispGreen,*aLblAlphaValue;
    UISlider *sldrRed,*sldrBlue,*sldrGreen,*sldrAlpha;
}

#pragma mark -
#pragma mark Properties

@property (nonatomic,retain)UIColor *colorLineColor;
@end
