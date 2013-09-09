//
//  DistrubiteViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/16/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "DistrubiteViewController.h"
#import "PengyouquanDataModel.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "CCRGlobalConf.h"
#import "MBProgressHUD.h"
#import "GDUtility.h"


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
    if ([self.contentTextField.text length] == 0 && self.imgBtn.imageView.image == nil) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请填点东西"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alter show];
        [alter release];
        alter = nil;
        return;
    }
    
    NSString *localMsgID = [GDUtility dateToString:[NSDate date]
                                       ByFormatter:@"yyyyMMddHHmmssSSS"];
    NSInteger type = 0;
    if ([self.contentTextField.text length] != 0 && self.imgBtn.imageView.image != nil) {
        type = 2;
    }else if (self.imgBtn.imageView.image) {
        type = 1;
    }
    
    PengyouquanDataModel *model = [[PengyouquanDataModel alloc] init];
    model.userID = CCRConf.userId;
    model.newsID = [localMsgID longLongValue];
    model.userNickName = CCRConf.nickName;
    model.contentText = self.contentTextField.text;
    model.contentImg = self.imgBtn.imageView.image;
    model.newsDate = [NSDate date];
    model.newsType = type;
    model.stringURLForUser = [GDUtility getHeadImageDownLoadStringUrl:CCRConf.userId];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud showWhileExecuting:@selector(sendWeiboToServer:) onTarget:self withObject:model animated:YES];
    [self.view addSubview:hud];
    [hud release];
    hud = nil;
    
    [model release];
    model = nil;
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void) sendWeiboToServer:(PengyouquanDataModel *) model {
    NSString *strURL = [[NSString stringWithFormat:@"%@/weiboSend.do?userId=%d&type=%d&content=%@&clientId=%ld",
                         CR_REQUEST_URL,CCRConf.userId,model.newsType,model.contentText,model.newsID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:strURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
    NSData *imgData = UIImageJPEGRepresentation(self.imgBtn.imageView.image, 0.3);
    LOG(@"img = %f k",imgData.length/1024.0);
    [request setData:imgData forKey:@"img"];
    [request setTimeOutSeconds:5];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *string = [request responseString];
        NSDictionary *dicData = [string JSONValue];
        NSInteger msgID = [[dicData objectForKey:@"id"] integerValue];
        if (msgID > 0) {
            if (_delegate && [_delegate respondsToSelector:@selector(FinishedDistrubite:)]) {
                [_delegate FinishedDistrubite:model];
            }
        }else {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"没发成功"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alter show];
            [alter release];
            alter = nil;
        }
    }
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
    UIImage *newImg = [GDUtility reproduceImage:img for:kImgReproducePlanFullScreen];
    [self.imgBtn setImage:newImg forState:UIControlStateNormal];

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
                [self presentModalViewController:picker animated:YES];
                [picker release];
                picker = nil;
                break;
            }
            case 1:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                [self presentModalViewController:picker animated:YES];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage * img = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
    [picker dismissModalViewControllerAnimated:NO];
    [self performSelectorOnMainThread:@selector(updateHeadImageView:) withObject:img waitUntilDone:YES];
    [img release];
    img = nil;
    [pool release];
    pool = nil;
    
}
@end
