//
//  RegsiterStepSecondViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/13/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "RegsiterStepSecondViewController.h"
#import "RegsiterStepThirdViewController.h"
#import "AppDelegate.h"

@interface RegsiterStepSecondViewController ()

@end

@implementation RegsiterStepSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) nextStep:(id)sender {
    if (![self.codeTextField.text isEqualToString:@"123456"]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"亲，你输入的验证码不对哦！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alter show];
        [alter release];
        alter = nil;
        return;
    }
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"注册成功"
                                                    message:@"亲，进入软件后请到“设置”里面填写详细的个人信息，以便让更多志同道合的朋友能找到你哦！"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alter show];
    [alter release];
    alter = nil;
    return;
//    RegsiterStepThirdViewController *regsiter = [[RegsiterStepThirdViewController alloc] initWithNibName:@"RegsiterStepThirdViewController" bundle:nil];
//    [self.navigationController pushViewController:regsiter animated:YES];
//    [regsiter release];
//    regsiter = nil;
}

- (void)dealloc {
    [_codeTextField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCodeTextField:nil];
    [super viewDidUnload];
}

#pragma mark - 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [APP_DELEGATE loginSuccess];
}


@end
