//
//  ThirdViewController.h
//  GDemo
//
//  Created by Wingle Wong on 8/15/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEYRefreshTableViewController.h"
#import "DEYRefreshMutiSectionTableViewController.h"
#import "DistrubiteViewController.h"
#import "EGOImageButton.h"
#import "EGOImageView.h"

@interface ThirdViewController : DEYRefreshMutiSectionTableViewController <DistrubiteDelegate>
@property (retain, nonatomic) IBOutlet UIView *headView;
@property (retain, nonatomic) IBOutlet EGOImageButton *imgBtn;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet EGOImageView *imgView;


@end
