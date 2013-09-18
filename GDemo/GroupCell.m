//
//  GroupCell.m
//  GDemo
//
//  Created by Wingle Wong on 9/18/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "GroupCell.h"

@implementation GroupCell

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
    [_headImgView release];
    [_nameLabel release];
    [_founderLabel release];
    [_memberCountLabel release];
    [super dealloc];
}
@end
