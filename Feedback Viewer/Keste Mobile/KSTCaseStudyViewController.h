//
//  KSTViewController.h
//  Keste Mobile
//
//  Created by Bradley Delaune on 8/25/14.
//  Copyright (c) 2014 Keste. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSTCaseStudyViewController : UIViewController {
    NSDictionary *case_study;
}
@property (weak, nonatomic) IBOutlet UILabel *ui_name;
@property (weak, nonatomic) IBOutlet UITextView *ui_story;
@property (weak, nonatomic) IBOutlet UILabel *ui_fullname;
@property (weak, nonatomic) IBOutlet UILabel *ui_email;

-(void) setCaseStudy:(NSDictionary*)study;

@end
