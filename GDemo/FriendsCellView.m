//
//  FriendsCellView.m
//  GDemo
//
//  Created by Wingle Wong on 8/16/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "FriendsCellView.h"

@implementation FriendsCellView

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

+ (FriendsCellView *) cellView {
    FriendsCellView * view = nil;
    NSString * nibName = @"FriendsCellView";
    NSArray * viewArray = nil;
    viewArray = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    for (id object in viewArray) {
        if ([object isKindOfClass:[FriendsCellView class]]) {
            view = (FriendsCellView *)object;
            break;
        }
    }
    return view;
}

- (void)dealloc {
    [_imgBtn release];
    [_nameLabel release];
    [_gameLabel release];
    [_areaLabel release];
    [super dealloc];
}
@end
