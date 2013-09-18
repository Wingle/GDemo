//
//  V2FirstViewController.h
//  GDemo
//
//  Created by Wingle Wong on 9/18/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDGroupInfo : NSObject
@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) NSString *groupFounder;
@property (nonatomic, assign) NSInteger memberCount;

@end

@interface V2FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
