//
//  DistrubiteViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/16/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "DistrubiteViewController.h"

@interface DistrubiteViewController ()

@end

@implementation DistrubiteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString *str = @"发布信息";
        self.title = str;
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
        self.navigationItem.rightBarButtonItem = barBtnItem;
        [barBtnItem release];
        barBtnItem = nil;
        
//        self.navigationItem.leftBarButtonItem.title = @"返回";
//        
//        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"发布"
//                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
//        self.navigationItem.le = barBtnItem;
//        [barBtnItem release];
//        barBtnItem = nil;
        self.navigationItem.leftItemsSupplementBackButton = YES;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(leftBtnClick:)];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainScollView release];
    [_contentTextField release];
    [_imgBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainScollView:nil];
    [self setContentTextField:nil];
    [self setImgBtn:nil];
    [super viewDidUnload];
}

- (IBAction) nextStep:(id)sender {
    
}

- (IBAction)leftBtnClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)imgBtnClick:(id)sender {
    
}
@end
