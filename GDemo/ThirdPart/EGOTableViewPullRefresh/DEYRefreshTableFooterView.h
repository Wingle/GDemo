//
//  DEYRefreshTableFooterView.h
//  DEyes
//
//  Created by zhenhua lu on 7/2/12.
//  Copyright (c) 2012 NeuSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEYRefreshTableFooterView : UIView {
    UILabel *_moreLabel;
    UIActivityIndicatorView *_activityView;
}

- (void)startAnimating;
- (void)stopAnimating;

@end
