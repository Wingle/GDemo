//
//  FirstViewController.h
//  GDemo
//
//  Created by Wingle Wong on 8/17/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEYRefreshTableViewController.h"
#import "GDUserInfo.h"

@interface UserMsgInfo : GDUserInfo
@property (nonatomic, retain) NSString *latestMsg;
@end

@interface FirstViewController : DEYRefreshTableViewController

@end
