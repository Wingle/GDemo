//
//  GDUserInfoViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/17/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "GDUserInfoViewController.h"
#import "DEYChatViewController.h"
#import "CCRGlobalConf.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "SBJson.h"

@interface GDUserInfoViewController ()
@property (nonatomic, assign) GDRelationShip ship;

- (void) requestNetworkToApply;

@end

@implementation GDUserInfoViewController

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
    if (self.userInfo == nil) {
        return;
    }
    self.ship = kRelationshipFriends;
    if (self.userInfo.relationship == kRelationshipStranger) {
        [self.sendMsgBtn setTitle:@"加为好友" forState:UIControlStateNormal];
        self.ship = kRelationshipStranger;
    }
    [self.imgView setImageURL:[NSURL URLWithString:self.userInfo.imagestringURL]];
    [self.nameLabel setText:self.userInfo.nickName];
    [self.genderLabel setText:self.userInfo.strGender];
    [self.areaLabel setText:self.userInfo.stringArea];
    [self.gameLabel setText:self.userInfo.stringgameServer];
    
    UILabel *label = self.signLabel;
    label.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
    label.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
    [label setBackgroundColor:[UIColor clearColor]];
    
    //宽度不变，根据字的多少计算label的高度
    CGSize size = [self.userInfo.userSign sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //根据计算结果重新设置UILabel的尺寸
    CGFloat apal = size.height - label.frame.size.height;
    [self.signLabel setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, size.height)];
    [self.signLabel setText:self.userInfo.userSign];
    [self.contactView setFrame:CGRectMake(self.contactView.frame.origin.x, self.contactView.frame.origin.y, self.contactView.frame.size.width, self.contactView.frame.size.height+apal)];
    
    [self.mainScrollView addSubview:self.contactView];
    self.mainScrollView.contentSize = CGSizeMake(320.0, self.contactView.frame.size.height+10);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainScrollView release];
    [_contactView release];
    [_imgView release];
    [_nameLabel release];
    [_genderLabel release];
    [_areaLabel release];
    [_gameLabel release];
    [_signLabel release];
    [_userInfo release];
    [_sendMsgBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainScrollView:nil];
    [self setContactView:nil];
    [self setImgView:nil];
    [self setNameLabel:nil];
    [self setGenderLabel:nil];
    [self setAreaLabel:nil];
    [self setGameLabel:nil];
    [self setSignLabel:nil];
    [self setSendMsgBtn:nil];
    [super viewDidUnload];
}
- (IBAction)sendMsgBtnClick:(id)sender {
    switch (self.ship) {
        case kRelationshipFriends:
        {
            DEYChatViewController *vc = [[DEYChatViewController alloc] initWithNibName:@"DEYChatViewController" bundle:nil UserID:[NSString stringWithFormat:@"%d",CCRConf.userId] RoomID:[NSString stringWithFormat:@"%d",self.userInfo.userID] ChatType:eChatTypeP2P];
            vc.title = self.userInfo.nickName;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
            vc = nil;
            break;
        }
        case kRelationshipStranger:
        {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            self.userInfo.relationship = kRelationshipFriends;
            [hud showWhileExecuting:@selector(requestNetworkToApply) onTarget:self withObject:nil animated:YES];
            [self.view addSubview:hud];
            [hud release];
            hud = nil;
            break;
        }
            
        default:
            break;
    }
}

#pragma mark -
- (void) requestNetworkToApply {
    NSString *strURL = [NSString stringWithFormat:@"%@/concern.do?userId=%d&friendId=%d&type=1",CR_REQUEST_URL,CCRConf.userId,self.userInfo.userID];
    NSURL *URL = [NSURL URLWithString:strURL];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setTimeOutSeconds:5];
    request.delegate = self;
    [request startSynchronous];
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
    [self.navigationController popViewControllerAnimated:YES];
    

    
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
