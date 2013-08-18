//
//  ThirdViewController.h
//  GDemo
//
//  Created by Wingle Wong on 8/15/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEYRefreshTableViewController.h"
#import "DistrubiteViewController.h"

@interface ThirdViewController : DEYRefreshTableViewController <DistrubiteDelegate>
@property (retain, nonatomic) IBOutlet UIView *headView;
@property (retain, nonatomic) IBOutlet UIButton *imgBtn;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;


@end
