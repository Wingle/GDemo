//
//  TextCell.m
//  GDemo
//
//  Created by Wingle Wong on 9/9/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "TextCell.h"

@implementation TextCell

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
    [_nameLabel release];
    [_contentTextLabel release];
    [_newDateLabel release];
    [super dealloc];
}
@end
