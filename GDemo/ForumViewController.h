//
//  ForumViewController.h
//  GDemo
//
//  Created by Wingle Wong on 9/20/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)filterForum:(id)sender;

@end
