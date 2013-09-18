//
//  GroupCell.h
//  GDemo
//
//  Created by Wingle Wong on 9/18/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *headImgView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *founderLabel;
@property (retain, nonatomic) IBOutlet UILabel *memberCountLabel;

@end
