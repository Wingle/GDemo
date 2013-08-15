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
    [self.fillTextFiled becomeFirstResponder];
    self.fillTextFiled.tag = self.textTag;
    NSLog(@"self.fill tag = %d",self.fillTextFiled.tag);
}

- (void) viewWillDisappear:(BOOL)animated {
    if ([self.fillTextFiled.text length] == 0) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(fillInBlankFinished:)]) {
        [_delegate fillInBlankFinished:self.fillTextFiled];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_fillTextFiled release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFillTextFiled:nil];
    [super viewDidUnload];
}

#pragma mark - 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
