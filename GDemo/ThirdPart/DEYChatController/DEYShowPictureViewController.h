//
//  DEYShowPictureViewController.h
//  DEyes
//
//  Created by Jessie Wu on 8/29/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEYShowPictureViewController : UIViewController<UIScrollViewDelegate>{
    BOOL isTwiceTouch;
}

@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UINavigationBar *navgationBar;
@property(nonatomic, assign) BOOL isTwiceTouch;

- (void)imageViewFram:(UIImage *)image;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;

@end
