//
//  DEYRefreshMutiSectionTableViewController.h
//  DEyes
//
//  Created by zhenhua lu on 7/5/12.
//  Copyright (c) 2012 NeuSoft. All rights reserved.
//

#import "DEYRefreshTableViewController.h"

@interface DEYRefreshMutiSectionTableViewController : DEYRefreshTableViewController {
    NSMutableDictionary *dataDict;
}

@property (nonatomic, retain) NSMutableDictionary *dataDict;

@end
