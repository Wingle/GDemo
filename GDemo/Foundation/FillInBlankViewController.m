//
//  FillInBlankViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "FillInBlankViewController.h"

@interface FillInBlankViewController ()

@end

@implementation FillInBlankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillDisappear:(BOOL)animated {
    if (_delegate && [_delegate respondsToSelector:@selector(fillInBlankFinished:)]) {
        [_delegate fillInBlankFinished:self.fillTextView.text];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_fillTextView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFillTextView:nil];
    [super viewDidUnload];
}
@end
