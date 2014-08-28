//
//  FBKFeedbackViewController.h
//  Feedback
//
//  Created by Bradley Delaune on 8/27/14.
//  Copyright (c) 2014 Keste. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBKFeedbackViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate,NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UILabel *submitLabel;
@property (nonatomic,strong) NSMutableData *responseData;
@end
