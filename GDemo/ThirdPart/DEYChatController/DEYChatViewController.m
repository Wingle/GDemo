//
//  DEYChatViewController.m
//  DEyes
//
//  Created by zhang xiang on 8/7/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "DEYChatViewController.h"
#import "DEYChatMessage.h"
#import "DEYShowPictureViewController.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import "ASIHTTPRequest.h"
#import "CCRGlobalConf.h"
#import "SBJson.h"
#import "AppDelegate.h"

#define ImageViewTag 20120813
#define kMessageFontSize    14.0f 
#define UI_ImageName_RecBlackAnimation @"GobiOribit_RecAnimation1.png"
#define UI_ImageName_RecWhiteAnimation @"GobiOribit_RecAnimation2.png"

#ifndef LOG
#define LOG NSLog
#endif

#define SEND_REQUEST_TAG    2013081901
#define GET_REQUEST_TAG     2013081902


typedef enum{
    kDEYFingerDragActionType_begin,
    kDEYFingerDragActionType_end,
    kDEYFingerDragActionType_dragging
}DEYFingerDragActionType;

@interface DEYChatViewController ()
@property (nonatomic, retain) NSTimer * timer;
@property (nonatomic, assign) NSInteger maxcharID;

- (DEYChatMessage *)createNewChatMessage;
- (void) addLatestMessageToChatViewList:(NSArray *) dataArr;
@end

@implementation DEYChatViewController

@synthesize strUserId = _strUserId;
@synthesize strChatRoomID = _strChatRoomID;
@synthesize chatType = _chatType;

@synthesize chatTableViewDelegate;
@synthesize userName;
@synthesize groupMessagesArray;

@synthesize chatMessagetableView;
@synthesize chatMessageView;
@synthesize messageTextView;
@synthesize messageViewbackImageView;
@synthesize messageSelectPictureButton;
@synthesize messageTypeButton;
@synthesize voiceMessageButton;
@synthesize m_recordVoiceView;

@synthesize m_refreshChatListHeaderView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        historyMessageNumber = 0;
        groupMessagesArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        if (!m_arrAudioAnimationView) {
            m_arrAudioAnimationView = [[NSMutableArray alloc] initWithCapacity:0];
        }
    
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"消息"
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(beBack:)];
        self.navigationItem.leftBarButtonItem = barBtnItem;
        [barBtnItem release];
        barBtnItem = nil;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil UserID:(NSString *) userID RoomID:(NSString *) strRoomID ChatType:(eChatType) type {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.strUserId = userID;
        self.strChatRoomID = strRoomID;
        self.chatType = type;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (IBAction)beBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.chatMessagetableView reloadData];
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    NSArray *latestMessages = nil;
    // --- request network;
    
    // ----
    
//    [self addLatestMessageToChatViewList:latestMessages];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super viewDidDisappear:animated];
    self.tabBarController.selectedIndex = 0;
    
}


- (void)viewDidLoad
{
    
    ////聊天消息
//http://localhost:8080/demo/chatList.do?userId=1&id=0
    //增量获取，id为最后的chat id

    NSString *strURL = [NSString stringWithFormat:@"%@/chatList.do?userId=%d&id=0",CR_REQUEST_URL,CCRConf.userId];
    NSURL *URL = [NSURL URLWithString:strURL];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setTimeOutSeconds:5];
    request.tag = GET_REQUEST_TAG;
    request.delegate = self;
    [request startSynchronous];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.messageTextView setMinNumberOfLines:1];
    [self.messageTextView setMaxNumberOfLines:3];
    [self.messageTextView setReturnKeyType:UIReturnKeySend];
    [self.messageTextView setFont:[UIFont systemFontOfSize:kMessageFontSize]];
    [self.messageTextView setDelegate:self];
    self.messageTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 3, 0);
    [self.messageTextView setBackgroundColor:[UIColor clearColor]];
    [self.messageTextView.internalTextView setBackgroundColor:[UIColor clearColor]];
    [self.messageTextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[self.messageTextView bounds]];
    imageView.tag = ImageViewTag;
    imageView.image = [UIImage imageNamed:@"messageBackground.png"];
    [messageTextView addSubview:imageView];
    [messageTextView setBackgroundColor:[UIColor clearColor]];
    [messageTextView sendSubviewToBack:imageView];
    [imageView release];

    
    //添加聊天页面的手势处理
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.chatMessagetableView addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
    
    //下拉刷新处理
    if (self.m_refreshChatListHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.chatMessagetableView.bounds.size.height, self.view.frame.size.width, self.chatMessagetableView.bounds.size.height)];
        view.delegate = self;
        [self.chatMessagetableView addSubview:view];
        self.m_refreshChatListHeaderView = view;
        [view release];
        view = nil;
    }
    m_bReloadingMessage = NO;
    [self.m_refreshChatListHeaderView refreshLastUpdatedDate];
    
    //增加tableview的headerview显示
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    [headerView setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1]];
    self.chatMessagetableView.tableHeaderView = headerView;
    [headerView release];
    
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5
                                                      target:self
                                                    selector:@selector(detectMsgCome)
                                                    userInfo:nil
                                                     repeats:YES];
        [self.timer setFireDate:[NSDate date]];
    }
    
}

- (void)viewDidUnload
{
    [self setChatMessagetableView:nil];
    [self setChatMessageView:nil];
    [self setMessageTextView:nil];
    [self setMessageSelectPictureButton:nil];
    [m_leftMessageTableViewCell release];
    m_leftMessageTableViewCell = nil;
    [m_rightMessageTableViewCell release];
    m_rightMessageTableViewCell = nil;
    [self setMessageTypeButton:nil];
    [self setVoiceMessageButton:nil];
    [self setMessageViewbackImageView:nil];
    [m_leftImageTableViewCell release];
    m_leftImageTableViewCell = nil;
    [m_rightImageTableViewCell release];
    m_rightImageTableViewCell = nil;
    [self setM_recordVoiceView:nil];
    
    [m_arrAudioAnimationView removeAllObjects];
    
//    [audiocontroller release];
    [m_leftVoiceTableViewCell release];
    m_leftVoiceTableViewCell = nil;
    [m_rightVoiceTableViewCell release];
    m_rightVoiceTableViewCell = nil;
    m_refreshChatListHeaderView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    self.strUserId = nil;
    self.strChatRoomID = nil;
    
    [_timer invalidate];
    _timer = nil;

    
    [groupMessagesArray release];
    
    [m_arrAudioAnimationView release];
    chatMessagetableView.delegate = nil;
    [chatMessagetableView release];
    [chatMessageView release];
    [messageTextView release];
    [messageSelectPictureButton release];
    [m_leftMessageTableViewCell release];
    [m_rightMessageTableViewCell release];
    [messageTypeButton release];
    [voiceMessageButton release];
    [messageViewbackImageView release];
    [m_leftImageTableViewCell release];
    [m_rightImageTableViewCell release];
    [m_leftVoiceTableViewCell release];
    [m_rightVoiceTableViewCell release];
    [m_recordVoiceView release];
    [messageInfo release];
    [_userInfo release];

    m_refreshChatListHeaderView.delegate = nil;
    [m_refreshChatListHeaderView release];
    [super dealloc];
}

- (void) detectMsgCome {
    NSString *strURL = [NSString stringWithFormat:@"%@/chatList.do?userId=%d&id=%d",CR_REQUEST_URL,CCRConf.userId,self.maxcharID];
    NSLog(@"chatList.do = %@",strURL);
    NSURL *URL = [NSURL URLWithString:strURL];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setTimeOutSeconds:3];
    request.delegate = self;
    request.tag = GET_REQUEST_TAG;
    [request startAsynchronous];
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.groupMessagesArray == nil || self.groupMessagesArray.count == 0) {
        return 0;
    }
    
    return [groupMessagesArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    
    if (self.groupMessagesArray == nil || self.groupMessagesArray.count == 0) {
       //无内容时显示
        return 0;
    }
    NSUInteger realRow = row;
    
    if (realRow <[groupMessagesArray count]) {
        DEYChatMessage *groupChat = (DEYChatMessage *)[groupMessagesArray objectAtIndex:realRow];
        
        if (groupChat) {
            int height = [DEYChatMessageTableViewCell getMessageTableViewCellHeighrDisplay:groupChat];
            if (realRow == [groupMessagesArray count]-1) {
                height += 10;
            }
            
            return height;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    
    DEYChatMessageTableViewCell *cell = nil;
    
    if (self.groupMessagesArray == nil || self.groupMessagesArray.count == 0) {
        UITableViewCell *cell = [[[UITableViewCell alloc] init] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    static NSString *leftMessageIdentifier = @"leftChatMessageIdentifier";
    static NSString *rightMessageIdentifier = @"rightChatMessageIdentifier";
    static NSString *leftChatImageIdentifier = @"leftChatImageIdentifier";
    static NSString *rightChatImageIdentifier = @"rightChatImageIdentifier";
    static NSString *leftChatVoiceIdentifier =  @"leftChatVoiceIdentifier";
    static NSString *rightChatVoiceIdentifier =  @"rightChatVoiceIdentifier";
    
            
    NSUInteger realRow = row;
    
    DEYChatMessage *groupChat = (DEYChatMessage *)[groupMessagesArray objectAtIndex:realRow];
    
    //为False是自己发出的，为true不是自己发出的
    BOOL isLeft = ![groupChat.strUserId isEqualToString:self.strUserId];
    //根据聊天页面的的左右分配来进行页面设置
    
    if (isLeft) {
        if (groupChat.messageType == eMessageTypeMessage) {
            cell = (DEYChatMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:leftMessageIdentifier];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"DEYChatMessageTableViewCell" owner:self options:nil];
                cell = m_leftMessageTableViewCell;
                m_leftMessageTableViewCell = nil;
            }
        }else if (groupChat.messageType == eMessageTypeSound) {
            cell = (DEYChatMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:leftChatVoiceIdentifier];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"DEYChatMessageTableViewCell" owner:self options:nil];
                cell = m_leftVoiceTableViewCell;
                m_leftVoiceTableViewCell = nil;
            }
            
        }else if (groupChat.messageType == eMessageTypeImage){
            cell = (DEYChatMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:leftChatImageIdentifier];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"DEYChatMessageTableViewCell" owner:self options:nil];
                cell = m_leftImageTableViewCell;
                m_leftImageTableViewCell = nil;
            }
        }
        
        [cell setChatMessageCellDisplay:groupChat Direction:isLeft];
    }else{
        if (groupChat.messageType == eMessageTypeMessage) {
            cell = (DEYChatMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:rightMessageIdentifier];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"DEYChatMessageTableViewCell" owner:self options:nil];
                cell = m_rightMessageTableViewCell;
                m_rightMessageTableViewCell = nil;
            }
        }else if (groupChat.messageType == eMessageTypeSound) {
           cell = (DEYChatMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:rightChatVoiceIdentifier];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"DEYChatMessageTableViewCell" owner:self options:nil];
                cell = m_rightVoiceTableViewCell;
                m_rightVoiceTableViewCell = nil;
                
            }
            
        }else if (groupChat.messageType == eMessageTypeImage){
            cell = (DEYChatMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:rightChatImageIdentifier];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"DEYChatMessageTableViewCell" owner:self options:nil];
                cell = m_rightImageTableViewCell;
                m_rightImageTableViewCell = nil;
            }
        }
        
        [cell setChatMessageCellDisplay:groupChat Direction:isLeft];

    }
    
    //对cell添加点击事件处理
//    [cell.btnFaceImage addTarget:self action:@selector(showPersonalInfo:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.m_audioButton addTarget:self action:@selector(audioPlayClick:) forControlEvents:UIControlEventTouchDown];
//    [cell.m_imageButton addTarget:self action:@selector(messageOfArtworkClick:) forControlEvents:UIControlEventTouchUpInside];  
    
    return cell;
}

#pragma mark show hide bookmark
// 上推下拉事件代理
- (void)performChatTableViewFingerScrollingDirectory:(DEYChatTableViewScrollDirectory)dir {
    if (chatTableViewDelegate && 
        [chatTableViewDelegate respondsToSelector:@selector(chatTableViewFingerScrollingDirectory:)]) {
        [chatTableViewDelegate chatTableViewFingerScrollingDirectory:dir];
    }
}
// 若隐若现的红色书签 by duanjsh 10-23
- (void)performDragDirectoryTableScrollView:(UIScrollView *)scrollView 
                             fingerDragType:(DEYFingerDragActionType)dragType
{
    
//    LOG(@"若隐若现之红色书签");
    if (dragType == kDEYFingerDragActionType_begin) {
        m_prevoffset = scrollView.contentOffset.y;
        m_isFingerAction = YES;
//        LOG(@"scrol begin: %f",m_prevoffset);
    }
    else if (dragType == kDEYFingerDragActionType_end) {
        m_prevoffset = scrollView.contentOffset.y;
        m_isFingerAction = NO;
    }
    else if (dragType == kDEYFingerDragActionType_dragging && m_isFingerAction) {
        LOG(@"scrol drag:  %f",scrollView.contentOffset.y);
        if (m_prevoffset < scrollView.contentOffset.y - 5) {
            [self performChatTableViewFingerScrollingDirectory:kDEYChatTableViewScrollDirectory_up];
//            LOG(@"up");
        }
        else if (m_prevoffset > scrollView.contentOffset.y + 5) {
            [self performChatTableViewFingerScrollingDirectory:kDEYChatTableViewScrollDirectory_down];
//            LOG(@"down");
        }
        else {
            [self performChatTableViewFingerScrollingDirectory:kDEYChatTableViewScrollDirectory_no];
//            LOG(@"none");
        }
    }
}

#pragma mark - button of cell was click
//btn click show Personal information
- (IBAction)showPersonalInfo:(id)sender{
//    UIButton *btn = (UIButton *)sender;
//    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview;
//    NSIndexPath *indexPath = [chatMessagetableView indexPathForCell:cell];
//    DEYChatMessage *groupChat = (DEYChatMessage *)[groupMessagesArray objectAtIndex:indexPath.row];
}

//get the artwork Image for message
- (IBAction)messageOfArtworkClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview;
    NSIndexPath *indexPath = [chatMessagetableView indexPathForCell:cell];
    DEYChatMessage *groupChat = (DEYChatMessage *)[groupMessagesArray objectAtIndex:indexPath.row];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    //组装文件保存的路径
    if([fm fileExistsAtPath:groupChat.strOriginalImageMessage]){
        
        LOG(@"the original image path:%@",groupChat.strOriginalImageMessage);
        //显示未压缩图片
        
        NSData *imageData = [NSData dataWithContentsOfFile:groupChat.strOriginalImageMessage];
        UIImage *image = [UIImage imageWithData:imageData];
        
        DEYShowPictureViewController *showPictureView = [[DEYShowPictureViewController alloc] initWithNibName:@"DEYShowPictureViewController" bundle:nil];
        
        [self.navigationController pushViewController:showPictureView animated:YES];
        //        showPictureView.imageView.image = [UIImage imageWithData:imageData];
        [showPictureView imageViewFram:image];
        LOG(@"size x:%f,y:%f",image.size.width,image.size.height);
        
        [showPictureView release];
        
    }else if ([fm fileExistsAtPath:groupChat.strMessage]) {
        
        NSMutableString *strTest = [NSMutableString stringWithString:groupChat.strMessage];
        int strLength = [groupChat.strMessage length];
        LOG(@"%d",strLength);
        [strTest insertString:@"_" atIndex:strLength - 4];
        LOG(@"%@",strTest);
        
        groupChat.strOriginalImageMessage = [NSString stringWithString:strTest];
        LOG(@"the original image path:%@",groupChat.strOriginalImageMessage);
        //显示未压缩图片
        
        NSData *imageData = [NSData dataWithContentsOfFile:groupChat.strOriginalImageMessage];
        UIImage *image = [UIImage imageWithData:imageData];
        
        DEYShowPictureViewController *showPictureView = [[DEYShowPictureViewController alloc] initWithNibName:@"DEYShowPictureViewController" bundle:nil];
        
        [self.navigationController pushViewController:showPictureView animated:YES];
        //        showPictureView.imageView.image = [UIImage imageWithData:imageData];
        [showPictureView imageViewFram:image];
        LOG(@"size x:%f,y:%f",image.size.width,image.size.height);
        
        [showPictureView release];
    }
    else if(![fm fileExistsAtPath:groupChat.strMessage] && ![fm fileExistsAtPath:groupChat.strOriginalImageMessage]){
        
        NSString *tempThumbImageHome = [self reciveFilePath];
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@.png",tempThumbImageHome,groupChat.strServerMsgId];
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:imagePath]) {
            NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
            UIImage *image = [UIImage imageWithData:imageData];
            
            DEYShowPictureViewController *showPictureView = [[DEYShowPictureViewController alloc] initWithNibName:@"DEYShowPictureViewController" bundle:nil];
            
            [self.navigationController pushViewController:showPictureView animated:YES];
            //        showPictureView.imageView.image = [UIImage imageWithData:imageData];
            [showPictureView imageViewFram:image];
            LOG(@"size x:%f,y:%f",image.size.width,image.size.height);
            
            [showPictureView release];
        }
        else{    //对于本地不存在的则从网络上获取
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        
        [self.view addSubview:hud];
        NSMutableDictionary *object = [[NSMutableDictionary alloc] initWithCapacity:0];
        [object setValue:groupChat forKey:@"groupChat"];
        [object setValue:cell forKey:@"cell"];
        
        [hud showWhileExecuting:@selector(loadImage:) onTarget:self withObject:object animated:YES];
        
        [object release];
        [hud release];
        }
    }
}

-(void)loadImage:(NSMutableDictionary *)object{
    if (object == nil) {
        return ;
    }
    DEYChatMessage *groupChat = [object objectForKey:@"groupChat"];
    
    NSData *OriginalImageData = nil;
    OriginalImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:groupChat.originalMediaURL]];
    NSString *tempThumbImageHome = [self reciveFilePath];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@.png",tempThumbImageHome,groupChat.strServerMsgId];
    
    [OriginalImageData writeToFile:imagePath atomically:NO];
    [groupChat setStrOriginalImageMessage:imagePath];
    
    //    [self performSelectorOnMainThread:@selector(messageOfArtworkClick:) withObject:object waitUntilDone:YES];
    
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [UIImage imageWithData:imageData];
    //显示大图
    
    DEYShowPictureViewController *showPictureView = [[DEYShowPictureViewController alloc] initWithNibName:@"DEYShowPictureViewController" bundle:nil];
    LOG(@"size x:%f,y:%f",image.size.width,image.size.height);
    
    [self.navigationController pushViewController:showPictureView animated:YES];
    
    [showPictureView imageViewFram:image];
    [showPictureView release];
}

#pragma mark - 
#pragma mark creat filePath

-(void)initDocument:(NSString *)temPath{
    NSFileManager *fm = [NSFileManager defaultManager];
    //LOG(@"%@",directoryName);
    if ([fm fileExistsAtPath:temPath]){
        return;
    }
    [fm createDirectoryAtPath:temPath withIntermediateDirectories:NO attributes:nil error:nil];
}

-(NSString *)reciveFilePath{
    NSString *tmp_forumHome = [NSString stringWithFormat:@"%@/tmp/thumbImage",NSHomeDirectory()];
    [self initDocument:tmp_forumHome];
    return tmp_forumHome;
}

#pragma mark - audio manager the record and play and so on
//start Record when the button of voice click
- (IBAction)startRecord:(id)sender {
    //对按钮进行图片替换
}

- (IBAction)stopRecord:(id)sender {
 
}


//play audio when the message audio been click
- (IBAction)audioPlayClick:(id)sender{
}


#pragma mark - growingTextView Delegate and text Message
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView{
    
    return YES;
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        NSMutableString *text = [NSMutableString stringWithString:growingTextView.text];
        
        text = [NSMutableString stringWithString:[text stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        text = [NSMutableString stringWithString:[text stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        
        NSString *messageText = [NSString stringWithString:text];
        
        growingTextView.text = @"";
        
        if ([messageText isEqualToString:@""] || messageText == nil) {
            return NO;
        }

        //对数据进行封装
        DEYChatMessage *groupChat = [self createNewChatMessage];
        [groupChat setMessageType:eMessageTypeMessage];
        [groupChat setStrMessage:messageText];
        [groupChat setMessageData:[messageText dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        //发送数据 ---zhongyao
//        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//        [hud showWhileExecuting:@selector(sendMsgToServer:) onTarget:self withObject:groupChat animated:YES];
//        [APP_DELEGATE.window addSubview:hud];
//        [hud release];
//        hud = nil;
        [self sendMsgToServer:groupChat];
    
        [groupChat release];
        groupChat = nil;
    
        return NO;
    }
    
    return YES;
}

- (void)scrollTableToFoot:(BOOL)animated {
    NSLog(@"scrollTableToFoot;");
    NSInteger s = [self.chatMessagetableView numberOfSections];  
    if (s<1) return;  
    NSInteger r = [self.chatMessagetableView numberOfRowsInSection:s-1];  
    if (r<1) return;  
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  
    
    [self.chatMessagetableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    NSLog(@"scrollTableToFoot crollToRowAtIndexPath;");
}  

- (IBAction)navigationReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    float changHeight = growingTextView.frame.size.height - height;

    [self setMessageControlPosition:changHeight];
}

#pragma mark - the button was click
- (IBAction)messageTypeClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 2012080901) {         //文字转换为语音时需要对页面进行重新布局
        [messageInfo release];
        messageInfo = [[NSString stringWithString:self.messageTextView.text] retain];
        self.messageTextView.text = @"";
        [self.view endEditing:YES];
        button.tag = 2012080902;
        
        [button setImage:[UIImage imageNamed:@"messageText.png"] forState:UIControlStateNormal];
        [self.voiceMessageButton setHidden:NO];
        [self.messageTextView setHidden:YES];
    }else if(button.tag == 2012080902)      //语音转换为文字，也需要掏对页面进行重新并布局
    {
        if (messageInfo != nil) {
            self.messageTextView.text = messageInfo;
        }
        
        [self.messageTextView.internalTextView becomeFirstResponder];
        button.tag = 2012080901;
        [button setImage:[UIImage imageNamed:@"messageVoice.png"] forState:UIControlStateNormal];
       
        [self.voiceMessageButton setHidden:YES];
        [self.messageTextView setHidden:NO];
    }
    
}

- (IBAction)messageSelectPictureClick:(id)sender {
}


#pragma mark - DEYChatManagerDelegate
#pragma mark - about receive Data 
- (void) addLatestMessageToChatViewList:(NSArray *) dataArr {
    NSMutableArray *timeToShowArr = [NSMutableArray arrayWithArray:dataArr];
    [self.groupMessagesArray removeAllObjects];
    [self.groupMessagesArray addObjectsFromArray:[self setMessageTimeToShow:timeToShowArr]];
    
    [self.chatMessagetableView reloadData];
    
    [self scrollTableToFoot:NO];
    
    [self performSelector:@selector(scrollTableToFoot:) withObject:NO afterDelay:0];
}

#pragma mark - UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        if (chatTableViewDelegate && 
            [chatTableViewDelegate respondsToSelector:@selector(chatMessageDidSendFailedProcessing)]) {
            [chatTableViewDelegate chatMessageDidSendFailedProcessing];
        }
    }
}

#pragma mark - UISCrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self performDragDirectoryTableScrollView:scrollView fingerDragType:kDEYFingerDragActionType_begin];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [m_refreshChatListHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    [self performDragDirectoryTableScrollView:scrollView fingerDragType:kDEYFingerDragActionType_dragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [m_refreshChatListHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    // 先调用则弹回效果不算在fingerdrag内，后调用则弹回时把弹回的初始点计入下一次卷动
    [self performDragDirectoryTableScrollView:scrollView fingerDragType:kDEYFingerDragActionType_end];
}

#pragma mark - CCRefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    m_bReloadingMessage = YES;
    [self performSelector:@selector(getHistoryChatMessage) withObject:nil];
    
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return m_bReloadingMessage;
}

- (NSDate *)refreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    return [NSDate date];
}

- (void)getHistoryChatMessage{
    //查询数据从后台

    
    [self performSelectorOnMainThread:@selector(endGetHistoryChatMessage) withObject:nil waitUntilDone:YES];
}

- (void)endGetHistoryChatMessage{
    if (m_bReloadingMessage) {
        [self performSelector:@selector(doneLoadingTableViewData:) withObject:self.m_refreshChatListHeaderView afterDelay:0.0f];
    }
}

- (void)doneLoadingTableViewData:(EGORefreshTableHeaderView *)view{
    [self.chatMessagetableView reloadData];
    if (historyMessageNumber > 0) {
        [self.chatMessagetableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:historyMessageNumber inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        historyMessageNumber = 0;
    }
    
    m_bReloadingMessage = NO;
    [m_refreshChatListHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.chatMessagetableView];
}

- (NSString *)egoRefreshHintForState:(EGOPullRefreshState)state {
    return @"";
}


#pragma mark - Utilities function
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    int originY =self.view.frame.size.height - self.chatMessageView.frame.size.height - keyboardBounds.size.height;
    int tableHeight = self.view.frame.size.height - keyboardBounds.size.height - self.chatMessageView.frame.size.height;
    [self chatMessagePostion:originY tableViewHeight:tableHeight animationDuration:duration animationCure:curve];
    [self scrollTableToFoot:NO];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
    int originY = self.view.frame.size.height - self.chatMessageView.frame.size.height;
    int tableHeight = self.view.frame.size.height - self.chatMessageView.frame.size.height;
    
    [self chatMessagePostion:originY tableViewHeight:tableHeight animationDuration:duration animationCure:curve];
}

- (void) chatMessagePostion:(int)originY tableViewHeight:(int)tableViewHeight animationDuration:(NSNumber*)duration animationCure:(NSNumber *)curve{
    CGRect messageFrame = self.chatMessageView.frame;
    messageFrame.origin.y = originY;
	
    CGRect tableFrame = self.chatMessagetableView.frame;
    tableFrame.size.height = tableViewHeight;

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	self.chatMessageView.frame = messageFrame;
	self.chatMessagetableView.frame = tableFrame;
	// commit animations
	[UIView commitAnimations];

}

//对聊天信息中的时间是否进行显示
- (NSMutableArray *)setMessageTimeToShow:(NSMutableArray *)messageArray{
    DEYChatMessage *groupChatFront,*groupChatBack;
    
    for (int i=0; i<[messageArray count]; i++) {
        if (i==0) {
            groupChatFront = [messageArray objectAtIndex:i];
            [groupChatFront setTimeToShow:YES];
        }else{
            groupChatFront = [messageArray objectAtIndex:i-1];
            groupChatBack = [messageArray objectAtIndex:i];
            [groupChatBack setTimeToShow:[self equalsWithAccuracy:groupChatFront.strTime secondTime:groupChatBack.strTime accuracy:5]];
        }
    }
    
    return messageArray;
}

- (BOOL)equalsWithAccuracy:(NSString *)firstTime secondTime:(NSString *)secondTime accuracy:(int)accuray{
    BOOL greater = FALSE;
    if (firstTime == nil || [firstTime isEqualToString:@""] || secondTime == nil || [secondTime isEqualToString:@""]) {
        return greater;
    }
    
    NSDate *firstDate = [self getDateFromString:firstTime];
    NSDate *secondDate = [self getDateFromString:secondTime];
    
    NSTimeInterval first = [firstDate timeIntervalSince1970]*1;
    NSTimeInterval second = [secondDate timeIntervalSince1970]*1;
    NSTimeInterval less = (first < second)?(second - first):(first - second);
    if (less/60 > accuray) {
        greater = TRUE;
    }
    
    return greater;
}

- (NSDate *)getDateFromString:(NSString *)stringTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:stringTime];
    [dateFormatter release];
    
    return date;
}

- (NSString *)getStringFromDate:(NSDate *)data{
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringTime = [dataFormatter stringFromDate:data];
    [dataFormatter release];
    
    return stringTime;
}

- (void)addChatMessageToShow:(DEYChatMessage *)groupChat{
    NSLog(@"addChatMessageToShow");
    if ([groupMessagesArray count]==0) {
        [groupChat setTimeToShow:TRUE];
    }else{
        DEYChatMessage *timeTemp = [groupMessagesArray objectAtIndex:[groupMessagesArray count]-1];
        [groupChat setTimeToShow:[self equalsWithAccuracy:timeTemp.strTime secondTime:groupChat.strTime accuracy:5]];
    }
    NSLog(@"addChatMessageToShow setTime;");
    [self.groupMessagesArray addObject:groupChat];
    NSLog(@"addChatMessageToShow addObject;");
    [self.chatMessagetableView beginUpdates];
    [chatMessagetableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[groupMessagesArray count]-1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.chatMessagetableView endUpdates];
    NSLog(@"addChatMessageToShow update;");
    
    [self scrollTableToFoot:YES];
    //*********************************************//

}

#pragma mark - Text Change controller
//when the text height was change the controller frame was been change too
- (void)setMessageControlPosition:(float)changHeight{
    //重新设置各控件的位置
    CGRect primaryRect = self.chatMessageView.frame;
    primaryRect.size.height -= changHeight;
    primaryRect.origin.y += changHeight;
    self.chatMessageView.frame = primaryRect;
    
    //重新设置输入页面的背景
    CGRect imageRect = self.messageViewbackImageView.frame;
    imageRect.origin.y += changHeight;
    imageRect.size.height -= changHeight;
    UIImage *image = [self.messageViewbackImageView.image stretchableImageWithLeftCapWidth:160 topCapHeight:20];
    self.messageViewbackImageView.image = image;
    self.messageViewbackImageView.frame = imageRect;
    
    //设置输入框的背景
    NSArray *subViewArray = [messageTextView subviews];
    
    for (int i = 0; i<[subViewArray count]; i++) {
        UIView *subview = [subViewArray objectAtIndex:i];
        if (subview.tag == ImageViewTag) {
            UIImageView *imageView = (UIImageView *)subview;
            CGRect textImageRect = imageView.frame;
            textImageRect.size.height -= changHeight;
            imageView.image = [imageView.image stretchableImageWithLeftCapWidth:110 topCapHeight:10];
            imageView.frame = textImageRect;
        }
    }
 
}

#pragma mark - Helper Methods
- (DEYChatMessage *)createNewChatMessage {
    DEYChatMessage *groupChat = [[DEYChatMessage alloc] init];
    [groupChat setStrUserId:self.strUserId];
    [groupChat setStrChatRoomID:self.strChatRoomID];
    [groupChat setMsgChatTpye:self.chatType];
    
    [groupChat setStrUserName:userName];
    [groupChat setIImageVersion:-1];
    
    NSDate *nowTime = [NSDate date];
    
    NSString *localMsgID = [[self class] dateToString:nowTime
                                          ByFormatter:@"yyyyMMddHHmmssSSS"];
    
    groupChat.strLocalMsgId = localMsgID;
    
//    [groupChat setStrTime:[self getStringFromDate:nowTime]];
    [groupChat setState:eMessageStateWaitForSend];
    
    return groupChat;
}

+ (NSString *)dateToString:(NSDate *) date ByFormatter:(NSString*)strTimeFormatter {
    NSDateFormatter	* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:strTimeFormatter];
    return [formatter stringFromDate:date];
}

#pragma mark - hym
-(void)sendMsgToServer:(DEYChatMessage *) message {
    NSLog(@"sendMsgToServer");
    DEYChatMessage *message_ = [message retain];
    NSString *strURL = [[NSString stringWithFormat:@"%@/chatSend.do?userId=%d&toId=%d&type=0&content=%@&clientId=%@",CR_REQUEST_URL,CCRConf.userId,self.userInfo.userID,message_.strMessage,message_.strLocalMsgId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:strURL];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setTimeOutSeconds:5];
    request.tag = SEND_REQUEST_TAG;
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *string = [request responseString];
        NSMutableDictionary * dataDict = [string JSONValue];
        NSInteger status = [[dataDict objectForKey:@"status"] integerValue];
        if (status != 0) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"亲，没发送成功。请重发。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alter show];
            [alter release];
            alter = nil;
            return;
        }
        [self addChatMessageToShow:message_];
        return;
    }
    NSLog(@"error = %@",[error localizedDescription]);
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"亲，网络不通哦"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alter show];
    [alter release];
    alter = nil;
    
    [message_ release];
    message_ = nil;
    return;
    
}

/*
 @synthesize strLocalMsgId;
 @synthesize strServerMsgId;
 @synthesize strChatRoomID;
 @synthesize strUserId;
 
 @synthesize strUserName;
 @synthesize strTime;
 @synthesize strMessage;
 @synthesize strOriginalImageMessage;
 @synthesize messageType;
 @synthesize resourceFormat;
 @synthesize state;
 @synthesize msgChatTpye;
 @synthesize messageData;
 */

#pragma mark - ASIHttp---
- (void)requestFinished:(ASIHTTPRequest *)request {
    if (request.tag == GET_REQUEST_TAG) {
        NSString *string = [request responseString];
        NSMutableDictionary * dataDict = [string JSONValue];
        NSArray *chatMsgs = [dataDict objectForKey:@"chats"];
        NSInteger iCount = [chatMsgs count];
        for (int i = 0; i < iCount; i ++) {
            NSDictionary *msg = [chatMsgs objectAtIndex:i];
            DEYChatMessage *message = [[DEYChatMessage alloc] init];
            message.strServerMsgId = [msg objectForKey:@"id"];
            message.strUserId = [msg objectForKey:@"userId"];
            message.strChatRoomID = [msg objectForKey:@"toId"];
            message.messageType = eMessageTypeMessage;
            message.strMessage = [msg objectForKey:@"content"];
            message.strLocalMsgId = [msg objectForKey:@"clientId"];
            long long timeInterval = [[msg objectForKey:@"time"] longLongValue];
            message.messageTimeStamp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            self.maxcharID = [message.strServerMsgId integerValue];
            [self performSelectorOnMainThread:@selector(updateChatTableview:) withObject:message waitUntilDone:YES];
            [message release];
            message = nil;
            
        }
        
    }
    
    
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

#pragma mark - -
- (void) updateChatTableview:(DEYChatMessage *) message {
    [self addChatMessageToShow:message];
}


@end
