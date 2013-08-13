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

#pragma mark - Actions
- (IBAction)loginClick:(id)sender {
    [APP_DELEGATE loginSuccess];
    
}

- (IBAction)registerClick:(id)sender {
    RegsiterStepFirstViewController *regsiter = [[RegsiterStepFirstViewController alloc] initWithNibName:@"RegsiterStepFirstViewController" bundle:nil];
    [self.navigationController pushViewController:regsiter animated:YES];
    [regsiter release];
    regsiter = nil;
}
@end
