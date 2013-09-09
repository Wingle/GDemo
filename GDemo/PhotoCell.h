//
//  PhotoCell.h
//  GDemo
//
//  Created by Wingle Wong on 9/10/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "EGOImageView.h"

@interface PhotoCell : UITableViewCell
@property (retain, nonatomic) IBOutlet EGOImageButton *headImgBtn;
@property (retain, nonatomic) IBOutlet EGOImageView *contentImgView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *newDateLabel;

@end
