//
//  PhotoCell.m
//  GDemo
//
//  Created by Wingle Wong on 9/10/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headImgBtn release];
    [_contentImgView release];
    [_nameLabel release];
    [_newDateLabel release];
    [super dealloc];
}
@end
