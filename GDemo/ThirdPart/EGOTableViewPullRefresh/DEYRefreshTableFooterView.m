//
//  DEYRefreshTableFooterView.m
//  DEyes
//
//  Created by zhenhua lu on 7/2/12.
//  Copyright (c) 2012 NeuSoft. All rights reserved.
//

#import "DEYRefreshTableFooterView.h"

@implementation DEYRefreshTableFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, frame.size.height)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = [UIColor colorWithRed:87.0/255.0 
                                          green:108.0/255.0 
                                           blue:137.0/255.0 
                                          alpha:1.0];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
//		label.backgroundColor = [UIColor colorWithRed:224.0/255.0 
//                                                green:224.0/255.0 
//                                                 blue:224.0/255.0 
//                                                alpha:1.0];
        label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_moreLabel=label;
        _moreLabel.text = @"更多...";
        [label release];
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(frame.size.width - 45.0f, (frame.size.height - 20.0f) / 2, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
    }
    return self;
}

- (void)startAnimating {
    [_activityView startAnimating];
}
- (void)stopAnimating {
    [_activityView stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
