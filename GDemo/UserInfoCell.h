//
//  UserInfoCell.h
//  GDemo
//
//  Created by Wingle Wong on 9/5/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface UserInfoCell : UITableViewCell
@property (retain, nonatomic) IBOutlet EGOImageView *imgView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *gameLabel;
@property (retain, nonatomic) IBOutlet UILabel *areaLabel;

@end
