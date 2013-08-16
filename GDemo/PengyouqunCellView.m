//
//  PengyouqunCellView.m
//  GDemo
//
//  Created by Wingle Wong on 8/15/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "PengyouqunCellView.h"

@implementation PengyouqunCellView

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

- (void) awakeFromNib {
    NSLog(@"hymmmmmmmm........");
    
}

- (void)dealloc {
    [_headImgBtn release];
    [_contentTextLabel release];
    [_nameLabel release];
    [_contentImgView release];
    [_newDateLabel release];
    [super dealloc];
}

+ (PengyouqunCellView *) cellView {
    PengyouqunCellView * view = nil;
    NSString * nibName = @"PengyouqunCellView";
    NSArray * viewArray = nil;
    viewArray = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    for (id object in viewArray) {
        if ([object isKindOfClass:[PengyouqunCellView class]]) {
            view = (PengyouqunCellView *)object;
            break;
        }
    }
    return view;
}
@end
