//
//  FriendsCellView.h
//  GDemo
//
//  Created by Wingle Wong on 8/16/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface FriendsCellView : UIView
@property (retain, nonatomic) IBOutlet EGOImageButton *imgBtn;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *gameLabel;
@property (retain, nonatomic) IBOutlet UILabel *areaLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;

+ (FriendsCellView *) cellView;

@end
