//
//  KSTViewController.m
//  Keste Mobile
//
//  Created by Bradley Delaune on 8/25/14.
//  Copyright (c) 2014 Keste. All rights reserved.
//

#import "KSTCaseStudyViewController.h"

@interface KSTCaseStudyViewController ()

@end

@implementation KSTCaseStudyViewController

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
    
    if([[case_study objectForKey:@"comments__c"] isKindOfClass:[NSString class]])
        self.ui_story.text = (NSString*)[case_study valueForKey:@"comments__c"];;
    if([[case_study objectForKey:@"full_name__c"] isKindOfClass:[NSString class]])
        self.ui_fullname.text = (NSString*)[case_study valueForKey:@"full_name__c"];;
    if([[case_study objectForKey:@"email__c"] isKindOfClass:[NSString class]])
        self.ui_email.text = (NSString*)[case_study valueForKey:@"email__c"];;
    if([[case_study objectForKey:@"name"] isKindOfClass:[NSString class]]) {
        self.ui_name.text = (NSString*)[case_study valueForKey:@"name"];
        self.navigationItem.title = [case_study valueForKey:@"name"];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setCaseStudy:(NSDictionary*)study
{
    case_study = study;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
