//
//  LoginViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/13/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "LoginViewController.h"
#import "RegsiterStepFirstViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "CCRGlobalConf.h"
#import "MBProgressHUD.h"

#define LOGIN_REQUEST       10000
#define INFO_REQUEST        20000

@interface LoginViewController ()

@end

@implementation LoginViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_loginNameTextField release];
    [_passwdTextField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLoginNameTextField:nil];
    [self setPasswdTextField:nil];
    [super viewDidUnload];
}

#pragma mark -- Touch Events

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.loginNameTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
}

#pragma mark - 
- (void)requestNetWork {
    NSString *strURL = [NSString stringWithFormat:@"%@/login.do?phone=%@&password=%@",CR_REQUEST_URL,self.loginNameTextField.text,self.passwdTextField.text];
    NSURL *URL = [NSURL URLWithString:strURL];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    request.tag = LOGIN_REQUEST;
    [request setTimeOutSeconds:5];
    request.delegate = self;
    [request startSynchronous];
}

#pragma mark - Actions
- (IBAction)loginClick:(id)sender {
    if ([self.loginNameTextField.text length] == 0 || [self.passwdTextField.text length] == 0) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"亲，请输入账号和密码"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alter show];
        [alter release];
        alter = nil;
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud showWhileExecuting:@selector(requestNetWork) onTarget:self withObject:nil animated:YES];
    [self.view addSubview:hud];
    [hud release];
    hud = nil;
    
}

- (IBAction)registerClick:(id)sender {
    RegsiterStepFirstViewController *regsiter = [[RegsiterStepFirstViewController alloc] initWithNibName:@"RegsiterStepFirstViewController" bundle:nil];
    [self.navigationController pushViewController:regsiter animated:YES];
    [regsiter release];
    regsiter = nil;
}

#pragma mark - ASIHttp---
- (void)requestFinished:(ASIHTTPRequest *)request {
    if (request.tag == LOGIN_REQUEST) {
        NSString *string = [request responseString];
        NSMutableDictionary * dataDict = [string JSONValue];
        NSInteger status = [[dataDict objectForKey:@"status"] integerValue];
        if (status != 0) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"亲，账号密码错误啊"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alter show];
            [alter release];
            alter = nil;
            return;
        }
        NSInteger userid = [[dataDict objectForKey:@"userId"] integerValue];
        [[NSUserDefaults standardUserDefaults] setInteger:userid forKey:gUSER_ID];
        [[NSUserDefaults standardUserDefaults] setObject:[dataDict objectForKey:@"name"] forKey:gNICK_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:self.loginNameTextField.text forKey:gLOGIN_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:self.passwdTextField.text forKey:gPASSWORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *strURL = [NSString stringWithFormat:@"%@/userInfo.do?userId=%d",CR_REQUEST_URL,userid];
        NSURL *URL = [NSURL URLWithString:strURL];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
        request.tag = INFO_REQUEST;
        [request setTimeOutSeconds:5];
        request.delegate = self;
        [request startSynchronous];
    }else {
        
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:gHAVE_LOGIN];
    
    [APP_DELEGATE loginSuccess];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"亲，网络不通哦"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alter show];
    [alter release];
    alter = nil;
    return;
    
}
@end
