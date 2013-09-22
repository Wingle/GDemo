//
//  FocusViewController.h
//  GDemo
//
//  Created by Wingle Wong on 9/20/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FocusViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UISegmentedControl *segController;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)noticeBtnClicked:(id)sender;

@end
