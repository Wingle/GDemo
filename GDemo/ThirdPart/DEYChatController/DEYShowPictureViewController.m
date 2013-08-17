//
//  DEYShowPictureViewController.m
//  DEyes
//
//  Created by Jessie Wu on 8/29/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import "DEYShowPictureViewController.h"

@implementation DEYShowPictureViewController

@synthesize imageView;
@synthesize navgationBar;
@synthesize scrollView;
@synthesize isTwiceTouch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize = CGSizeMake(340, 490);
    self.scrollView.maximumZoomScale = 2.0;
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    
    isTwiceTouch = NO;
    UITapGestureRecognizer *tapTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewHandle:)];
    tapTouch.numberOfTapsRequired = 1;
    tapTouch.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:tapTouch];
    [tapTouch release];
}

- (void)viewDidUnload
{
    [self setNavgationBar:nil];
    [super viewDidUnload];
    self.scrollView = nil;
    self.imageView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [navgationBar release];
    [super dealloc];
    [scrollView release];
    [imageView release];
}

#pragma mark - UIScrollView Delegate zoom

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView;
}

#pragma mark - tap

- (IBAction)tapImageViewHandle:(UIGestureRecognizer *)sender{
    isTwiceTouch = !isTwiceTouch;
    if (isTwiceTouch == NO) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self.view bringSubviewToFront:self.navgationBar];
        self.navgationBar.hidden = NO;
    }
    else{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [self.view bringSubviewToFront:self.navgationBar];
        self.navgationBar.hidden = YES;
    }
}

#pragma mark - set image view fram

- (void)imageViewFram:(UIImage *)image{
    [self.imageView setImage:image];    
    [scrollView setContentSize:[imageView frame].size];
    [scrollView setMinimumZoomScale:[scrollView frame].size.width / [imageView frame].size.width];
    [scrollView setZoomScale:[scrollView minimumZoomScale]];
}

#pragma mark - btn clicked action

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnSaveClicked:(id)sender {
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" 
                                                        message:@"保存成功" 
                                                       delegate:self 
                                              cancelButtonTitle:@"确定" 
                                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

@end
