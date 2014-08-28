//
//  FBKFeedbackViewController.m
//  Feedback
//
//  Created by Bradley Delaune on 8/27/14.
//  Copyright (c) 2014 Keste. All rights reserved.
//

#import "FBKFeedbackViewController.h"

@interface FBKFeedbackViewController ()

@property (strong, nonatomic) IBOutlet UIView *panel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *commentField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *successBox;
- (IBAction)didSelectSubmitFeedback:(id)sender;
@property NSInteger keyboard_h;
@property BOOL didEditComments;

@end

@implementation FBKFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.didEditComments = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameField.delegate = self;
    self.emailField.delegate = self;
    self.titleField.delegate = self;
    self.nameField.delegate = self;
    self.commentField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _submitButton.frame.origin.y + _submitButton.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height-220);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height+220);
}

- (IBAction)didSelectSubmitFeedback:(id)sender {
    if(sender == self.submitButton) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://dug-presentation.herokuapp.com/services/rest/feedback/"]];
        [request setHTTPMethod:@"POST"];
        NSDictionary *data = [[NSDictionary alloc] initWithObjects:@[self.nameField.text,
                                                                     self.emailField.text,
                                                                     self.titleField.text,
                                                                     self.commentField.text]
                                                           forKeys:@[@"full_name",
                                                                     @"email",
                                                                     @"name",
                                                                     @"comments"]];
        
        NSData *data2 = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
        
        NSLog(@"%@",[NSString stringWithUTF8String:[data2 bytes]]);
        [request setHTTPBody:data2];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.nameField) {
        [self.emailField becomeFirstResponder];
    } else if(textField == self.emailField) {
        [self.titleField becomeFirstResponder];
    } else if(textField == self.titleField) {
        [self.commentField becomeFirstResponder];
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView == self.commentField && !self.didEditComments) {
        textView.text = @"";
        self.didEditComments = YES;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView == self.commentField && [textView.text isEqualToString:@""]) {
        textView.text = @"Comments";
        self.didEditComments = NO;
    }
}

- (void)clearFields {
    self.nameField.text = @"";
    self.emailField.text = @"";
    self.titleField.text = @"";
    self.commentField.text = @"";
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
    if([(NSHTTPURLResponse *)response statusCode] != 201) {
        self.submitLabel.text = @"Error. Try Again.";
        [self.submitLabel performSelector:@selector(setText:) withObject:@"Submit Your Feedback" afterDelay:2.0];
    } else {
        [self clearFields];
        self.submitLabel.text = @"Success!";
        [self.submitLabel performSelector:@selector(setText:) withObject:@"Submit Your Feedback" afterDelay:2.0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"done making callout");
    NSLog(@"%@",[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    NSLog(@"callout error received");
}
@end
