//
//  KSTIndustryTableViewController.h
//  Keste Mobile
//
//  Created by Bradley Delaune on 8/25/14.
//  Copyright (c) 2014 Keste. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSTIndustryTableViewController : UITableViewController<NSURLConnectionDelegate> {
    NSMutableData *_responseData;
    NSArray *industries;
    UIRefreshControl *refreshControl;
}


@end
