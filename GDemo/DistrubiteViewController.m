//
//  DistrubiteViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/16/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "DistrubiteViewController.h"


#define IMAGE_SHEET_TAG         2013081701

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
    self.imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
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

- (IBAction)updateHeadImageView:(id)sender {
    UIImage *img = (UIImage *) sender;
    [self.imgBtn setImage:img forState:UIControlStateNormal];

}
#pragma mark ------ UIActionSheet Delegate Methods ------
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex])
    {
        switch (buttonIndex) {
            case 0:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                [self.navigationController presentModalViewController:picker animated:YES];
                [picker release];
                picker = nil;
                break;
            }
            case 1:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                [self.navigationController presentModalViewController:picker animated:YES];
                [picker release];
                picker = nil;
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
    UIImage * img = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
    [picker dismissModalViewControllerAnimated:NO];
    [self performSelectorOnMainThread:@selector(updateHeadImageView:) withObject:img waitUntilDone:YES];
    
}
@end
