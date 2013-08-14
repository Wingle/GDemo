//
//  HeadImageCellView.m
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "HeadImageCellView.h"

@implementation HeadImageCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib {
    
}

- (void)dealloc {
    [_imageBtn release];
    [super dealloc];
}
- (IBAction)imageBtnClick:(id)sender {
}
@end
