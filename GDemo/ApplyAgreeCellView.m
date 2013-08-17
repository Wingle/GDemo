//
//  ApplyAgreeCellView.m
//  GDemo
//
//  Created by Wingle Wong on 8/17/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "ApplyAgreeCellView.h"

@implementation ApplyAgreeCellView

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

- (void)dealloc {
    [_imgBtn release];
    [_nameLabel release];
    [_userInfo release];
    [super dealloc];
}

+ (ApplyAgreeCellView *) cellView {
    ApplyAgreeCellView * view = nil;
    NSString * nibName = @"ApplyAgreeCellView";
    NSArray * viewArray = nil;
    viewArray = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    for (id object in viewArray) {
        if ([object isKindOfClass:[ApplyAgreeCellView class]]) {
            view = (ApplyAgreeCellView *)object;
            break;
        }
    }
    return view;
}

- (void) setUserInfo:(GDUserInfo *)user withIndexPath:(NSIndexPath *) indexPath {
    self.userInfo = user;
    [self.nameLabel setText:self.userInfo.nickName];
    [self.imgBtn setImageURL:[NSURL URLWithString:self.userInfo.imagestringURL]];
}


- (IBAction)agreeBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(agreeUser:)]) {
        [_delegate agreeUser:self.userInfo];
    }
}

- (IBAction)disAgreeBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(disagreeUser:)]) {
        [_delegate disagreeUser:self.userInfo];
    }
}
@end
