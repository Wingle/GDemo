//
//  LoginViewController.h
//  GDemo
//
//  Created by Wingle Wong on 8/13/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *loginNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwdTextField;

- (IBAction)loginClick:(id)sender;
- (IBAction)registerClick:(id)sender;


@end
