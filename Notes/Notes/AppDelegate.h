//
//  AppDelegate.h
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIO.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
        //Application Level Variables
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController    *navigationController;

@end
