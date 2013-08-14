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

#define IMAGE_SHEET_TAG         2013081401
#define GENDER_SHEET_TAG        2013081402

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
}

- (IBAction)signBtnClick:(id)sender {
    FillInBlankViewController *fill = [[FillInBlankViewController alloc] initWithNibName:@"FillInBlankViewController" bundle:nil];
    fill.title = @"个性签名";
    fill.delegate = self;
    [self.navigationController pushViewController:fill animated:YES];
    [fill release];
    fill = nil;
}

- (IBAction)areaBtnClick:(id)sender {
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
    UIImage * img = [[info objectForKey:UIImagePickerControllerEditedImage] retain];
    [picker dismissModalViewControllerAnimated:NO];
    [GDUtility saveImage:img imageKey:[NSString stringWithFormat:@"%d",CCRConf.userId]];
    [self performSelectorOnMainThread:@selector(updateHeadImageView:) withObject:img waitUntilDone:YES];

}

#pragma mark - 
- (void) fillInBlankFinished:(NSString *) text {
    [self.signBtn setTitle:text forState:UIControlStateNormal];
}

@end
