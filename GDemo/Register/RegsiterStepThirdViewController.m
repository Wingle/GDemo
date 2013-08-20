//
//  RegsiterStepThirdViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "RegsiterStepThirdViewController.h"
#import "CCRGlobalConf.h"
#import "GDUtility.h"
#import "FillInBlankViewController.h"
#import "SelectViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "MBProgressHUD.h"

#define IMAGE_SHEET_TAG         2013081401
#define GENDER_SHEET_TAG        2013081402

#define NICKNAME_TAG            2013081510
#define CONTANCT_TAG            2013081520
#define SIGN_TAG                2013081530

@interface RegsiterStepThirdViewController ()

@end

@implementation RegsiterStepThirdViewController

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

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.nickNameTextFiled resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_imageBtn release];
    [_nickNameTextFiled release];
    [_phoneTextField release];
    [_ganderBtn release];
    [_gameBtn release];
    [_signBtn release];
    [_areaBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setImageBtn:nil];
    [self setNickNameTextFiled:nil];
    [self setPhoneTextField:nil];
    [self setGanderBtn:nil];
    [self setGameBtn:nil];
    [self setSignBtn:nil];
    [self setAreaBtn:nil];
    [super viewDidUnload];
}
#pragma mark - 
- (IBAction) nextStep:(id)sender {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud showWhileExecuting:@selector(requestNetWork) onTarget:self withObject:nil animated:YES];
    [self.view addSubview:hud];
    [hud release];
    hud = nil;
   
}

- (void) requestNetWork {
    NSString *strURL = [[NSString stringWithFormat:@"%@/register.do?phone=%@&name=%@&gender=%d&address=%d&signature=%@&password=%@&hobbyId=%d",CR_REQUEST_URL,CCRConf.loginName,CCRConf.nickName,CCRConf.gender,CCRConf.area,CCRConf.userSign,CCRConf.password,CCRConf.game] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:strURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
    NSData *imgData = UIImagePNGRepresentation(self.imageBtn.imageView.image);
    [request setData:imgData forKey:@"img"];
    [request setTimeOutSeconds:5];
    request.delegate = self;
    [request startSynchronous];
}

#pragma mark - IBAction 
- (IBAction)imageBtnClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择"
                                  delegate:self
                                  cancelButtonTitle:@"取 消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"图 库",
                                  @"拍 照",nil];
    actionSheet.tag = IMAGE_SHEET_TAG;
    [actionSheet showInView:self.view];
    [actionSheet release];
    actionSheet = nil;
}

- (IBAction)genderBtnClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择"
                                  delegate:self
                                  cancelButtonTitle:@"取 消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"男",
                                  @"女",nil];
    actionSheet.tag = GENDER_SHEET_TAG;
    [actionSheet showInView:self.view];
    [actionSheet release];
    actionSheet = nil;
}

- (IBAction)gameBtnClick:(id)sender {
    SelectViewController *select = [[SelectViewController alloc] initWithNibName:@"SelectViewController" bundle:nil];
    select.title = @"游戏";
    select.delegate = self;
    select.type = kLoad_game;
    [self.navigationController pushViewController:select animated:YES];
    [select release];
    select = nil;
}

- (IBAction)signBtnClick:(id)sender {
    FillInBlankViewController *fill = [[FillInBlankViewController alloc] initWithNibName:@"FillInBlankViewController" bundle:nil];
    fill.title = @"个性签名";
    fill.delegate = self;
    fill.fillTextFiled.tag = SIGN_TAG;
    [self.navigationController pushViewController:fill animated:YES];
    [fill release];
    fill = nil;
}

- (IBAction)areaBtnClick:(id)sender {
    SelectViewController *select = [[SelectViewController alloc] initWithNibName:@"SelectViewController" bundle:nil];
    select.title = @"地区";
    select.delegate = self;
    select.type = kLoad_area;
    [self.navigationController pushViewController:select animated:YES];
    [select release];
    select = nil;
}

#pragma mark - methods 
- (void) updateHeadImageView:(UIImage *) image {
    [self.imageBtn setImage:image forState:UIControlStateNormal];
}

- (void) updateGender {
    [self.ganderBtn setTitle:CCRConf.strGender forState:UIControlStateNormal];
}

#pragma mark - reseponse
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nickNameTextFiled resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}

#pragma mark ------ UIActionSheet Delegate Methods ------
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex])
    {
        switch (buttonIndex) {
            case 0:
            {
                if (actionSheet.tag == IMAGE_SHEET_TAG) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    picker.allowsEditing = YES;
                    picker.delegate = self;
                    [self.navigationController presentModalViewController:picker animated:YES];
                    [picker release];
                    picker = nil;
                }else if (actionSheet.tag == GENDER_SHEET_TAG) {
                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:gUSER_GENDER];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self performSelectorOnMainThread:@selector(updateGender) withObject:nil waitUntilDone:YES];
                }
                break;
            }
            case 1:
            {
                if (actionSheet.tag == IMAGE_SHEET_TAG) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.allowsEditing = YES;
                    picker.delegate = self;
                    [self.navigationController presentModalViewController:picker animated:YES];
                    [picker release];
                    picker = nil;
                }else if (actionSheet.tag == GENDER_SHEET_TAG) {
                    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:gUSER_GENDER];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self performSelectorOnMainThread:@selector(updateGender) withObject:nil waitUntilDone:YES];
                }
                break;
            }
            default:
                break;
        }
        
    }
    return;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) removePicker:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage * img = [[info objectForKey:UIImagePickerControllerEditedImage] retain];
    [picker dismissModalViewControllerAnimated:NO];
    [self performSelectorOnMainThread:@selector(updateHeadImageView:) withObject:img waitUntilDone:YES];
    [img release];
    img = nil;
    [pool release];
    pool = nil;

}

#pragma mark - fill 
- (void) fillInBlankFinished:(UITextField *) textField {
    [self.signBtn setTitle:textField.text forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:gUSER_SIGN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - select
- (void) didSelectedAreaString:(NSString *) text {
    [self.areaBtn setTitle:text forState:UIControlStateNormal];
}
- (void) didSelectedGameString:(NSString *) text {
    [self.gameBtn setTitle:text forState:UIControlStateNormal];
}

#pragma mark - text 
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 10) {
        [[NSUserDefaults standardUserDefaults] setValue:textField.text forKeyPath:gNICK_NAME];
    }else if (textField.tag == 20) {
        [[NSUserDefaults standardUserDefaults] setValue:textField.text forKeyPath:gUSER_CONTACT];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [textField resignFirstResponder];
}

#pragma mark - ASIHttp---
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *string = [request responseString];
    NSMutableDictionary * dataDict = [string JSONValue];
    NSInteger status = [[dataDict objectForKey:@"status"] integerValue];
    if (status != 0) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"亲，出错了"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alter show];
        [alter release];
        alter = nil;
        return;
    }
    NSString *userid = [dataDict objectForKey:@"userId"];
    if (userid) {
        [[NSUserDefaults standardUserDefaults] setInteger:[userid integerValue] forKey:gUSER_ID];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"10000%@",userid]  forKey:gUSER_CODE];
        [GDUtility saveImage:self.imageBtn.imageView.image imageKey:[NSString stringWithFormat:@"%d",CCRConf.userId]];
    }

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:gHAVE_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
