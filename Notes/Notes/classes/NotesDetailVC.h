//
//  NotesDetailVC.h
//  Notes
//
//  Created by IndiaNIC on 21/09/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesDetailVC : UIViewController
{
    
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblDate;
    IBOutlet UITextView *lblDescription;
	IBOutlet UIImageView *ivCaptionImage;
}

#pragma mark Properties
@property (nonatomic,retain)NSDictionary *dictSingleNoteData;
@property (nonatomic ,retain)NSData *dataImageData;

@end
