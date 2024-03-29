//
//  FriendViewController.h
//  GDemo
//
//  Created by Wingle Wong on 8/16/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDUserInfo.h"
#import <CoreLocation/CoreLocation.h>

typedef enum {
    kFriendViewController,
    kNearByViewControoler
}kGDControllerType;

@interface GDNearByUserInfo : GDUserInfo
@property (nonatomic, retain) CLLocation *location;

@end

@interface FriendViewController : UITableViewController
@property (nonatomic, assign) kGDControllerType type;

@end
