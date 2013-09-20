//
//  V2FirstViewController.h
//  GDemo
//
//  Created by Wingle Wong on 9/18/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface V2FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)creatNewGroup:(id)sender;

@end
