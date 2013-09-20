//
//  GoupDetailViewController.h
//  GDemo
//
//  Created by Wingle Wong on 9/20/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kMyGroup = 0,
    kHotGroup
} GoupDetailType;

@interface GoupDetailViewController : UITableViewController
@property (nonatomic, assign) GoupDetailType type;

@end
