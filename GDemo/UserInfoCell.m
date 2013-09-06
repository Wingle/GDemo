//
//  UserInfoCell.m
//  GDemo
//
//  Created by Wingle Wong on 9/5/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

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
    [_imgView release];
    [_nameLabel release];
    [_gameLabel release];
    [_areaLabel release];
    [super dealloc];
}
@end
