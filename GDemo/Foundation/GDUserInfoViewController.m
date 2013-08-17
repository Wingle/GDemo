//
//  GDUserInfoViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/17/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "GDUserInfoViewController.h"

@interface GDUserInfoViewController ()
@property (nonatomic, assign) GDRelationShip ship;

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
            
            break;
        }
        case kRelationshipStranger:
        {
            break;
        }
            
        default:
            break;
    }
}
@end
