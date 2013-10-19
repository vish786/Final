//
//  EditImage.h
//  Notes
//
//  Created by Akshay Kuchhadiya on 07/10/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ColorsVC.h"
#import "View.h"
#import "AddEditNote.h"
@class AddEditNote;

@interface EditImage : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>


{
#pragma mark -
#pragma mark Variable Declaration
    
    CGPoint pointLastPoint;
    BOOL isErasing,isColorsVisible,isLayerVisible;
    UIColor *colorLineColor;
    UIImageView *ivImageView;
    UIToolbar *tbToolBar;
    UIScrollView *svToolBarScroller;
    UIBarButtonItem *btnClear,*btnColors,*btnSettings,*btnLayer,*btnLoadImage;
    UIButton *btnNewLayer,*btnDeleteLayer;
    UIView *viewDisplay,*viewLayer;
    ColorsVC *colorsObj;
    NSMutableArray *mutArrayAllLayers;
    UIImagePickerController *ipcSelectImage;
    UIActionSheet *asShowSourceType;
    UILongPressGestureRecognizer *grLongPress;
    int intCallCount;
	
}


#pragma mark -
#pragma mark Properties

@property (nonatomic,retain)NSData *dataImageData;
@property (nonatomic)AddEditNote *delegate;
@end
