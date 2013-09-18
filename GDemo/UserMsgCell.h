//
//  UserMsgCell.h
//  GDemo
//
//  Created by Wingle Wong on 9/18/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface UserMsgCell : UITableViewCell
@property (retain, nonatomic) IBOutlet EGOImageView *headView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *msgLabel;

@end
