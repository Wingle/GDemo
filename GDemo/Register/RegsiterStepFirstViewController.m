//
//  RegsiterStepFirstViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/13/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "RegsiterStepFirstViewController.h"
#import "RegsiterStepSecondViewController.h"
#import "CCRGlobalConf.h"

@interface RegsiterStepFirstViewController ()

@end

@implementation RegsiterStepFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
        self.navigationItem.rightBarButtonItem = barBtnItem;
        [barBtnItem release];
        barBtnItem = nil;
        
        self.navigationItem.leftBarButtonItem.title = @"返回";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.regsiterNameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (IBAction)nextStep:(id)sender {
    if ([self.regsiterNameTextField.text length] == 0) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"亲，请输入你的手机号码或邮箱账号"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alter show];
        [alter release];
        alter = nil;
        return;
    }
    
    RegsiterStepSecondViewController *rsVC = [[RegsiterStepSecondViewController alloc] initWithNibName:@"RegsiterStepSecondViewController" bundle:nil];
    [self.navigationController pushViewController:rsVC animated:YES];
    [rsVC release];
    rsVC = nil;
    
}

- (void)dealloc {
    [_regsiterNameTextField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setRegsiterNameTextField:nil];
    [super viewDidUnload];
}
@end
