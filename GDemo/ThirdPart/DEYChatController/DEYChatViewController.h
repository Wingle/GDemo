//
//  DEYChatViewController.h
//  DEyes
//
//  Created by zhang xiang on 8/7/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HPGrowingTextView.h"
#import "DEYChatMessageTableViewCell.h"
#import "DEYChatManager.h"
#import "EGORefreshTableHeaderView.h"
#import "DEYAudioController.h"

@protocol DEYChatMessageTableViewDelegate; 

@interface DEYChatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,HPGrowingTextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,DEYAVAudioPlayerDelegate,DEYChatManagerDelegate,EGORefreshTableHeaderDelegate,UIAlertViewDelegate>{
    NSString *userName;             //用户名
    NSMutableArray *groupMessagesArray;          //群组聊天记录
    NSString *messageInfo;                  //暂时保存聊天信息
    
    NSMutableArray *m_arrAudioAnimationView;        //保存语音聊天的显示
    NSTimer *m_recordingTimer;                      //语音定时器
    
    BOOL m_bReloadingMessage;
    EGORefreshTableHeaderView *m_refreshChatListHeaderView;     //下拉更新view
    UIViewController *imageViewController;  
    
    DEYAudioController * audiocontroller;
    DEYChatMessageTableViewCell *audioPlayCell;
    
    // up&down delegate by duanjsh
    id<DEYChatMessageTableViewDelegate> chatTableViewDelegate;
    float m_prevoffset; //保存拖动时offset
    BOOL m_isFingerAction;
    int historyMessageNumber;
    
    IBOutlet DEYChatMessageTableViewCell *m_leftImageTableViewCell;
    IBOutlet DEYChatMessageTableViewCell *m_rightImageTableViewCell;
    IBOutlet DEYChatMessageTableViewCell *m_rightVoiceTableViewCell;
    IBOutlet DEYChatMessageTableViewCell *m_leftVoiceTableViewCell;
    IBOutlet DEYChatMessageTableViewCell *m_leftMessageTableViewCell;
    IBOutlet DEYChatMessageTableViewCell *m_rightMessageTableViewCell;
}

@property (nonatomic, retain) NSString *strUserId;
@property (nonatomic, retain) NSString *strChatRoomID;
@property (nonatomic, assign) eChatType chatType;

@property (assign, nonatomic) id<DEYChatMessageTableViewDelegate> chatTableViewDelegate;

@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSMutableArray *groupMessagesArray;  

@property (retain, nonatomic) IBOutlet UITableView *chatMessagetableView;

@property (retain, nonatomic) IBOutlet UIView *chatMessageView;
@property (retain, nonatomic) IBOutlet HPGrowingTextView *messageTextView;
@property (retain, nonatomic) IBOutlet UIImageView *messageViewbackImageView;
@property (retain, nonatomic) IBOutlet UIButton *messageSelectPictureButton;
@property (retain, nonatomic) IBOutlet UIButton *messageTypeButton;
@property (retain, nonatomic) IBOutlet UIButton *voiceMessageButton;

@property (retain, nonatomic) IBOutlet UIImageView *m_recordVoiceView;
@property (retain, nonatomic) EGORefreshTableHeaderView *m_refreshChatListHeaderView;

- (IBAction)messageSelectPictureClick:(id)sender;
- (IBAction)messageTypeClick:(id)sender;
- (IBAction)startRecord:(id)sender;
- (IBAction)stopRecord:(id)sender;

- (void)scrollTableToFoot:(BOOL)animated;

- (IBAction)navigationReturn:(id)sender;

- (void) takePhotoWithCamera;
- (void) selectPhotoFromLibrary;
- (BOOL)startCameraPickerFromViewController:(UIViewController*)controller usingDelegate:(id<UIImagePickerControllerDelegate>)delegateObject;
- (BOOL)startLibraryPickerFromViewController:(UIViewController*)controller usingDelegate:(id<UIImagePickerControllerDelegate>)delegateObject;
- (void)startPickerFromViewController:(UIViewController *)controller usingDelegate:(id<UIImagePickerControllerDelegate>)delegateObject sourceType:(UIImagePickerControllerSourceType)sourceType;

-(UIImage *)scaleImage:(UIImage *)sourceImage;

- (UIImage *)thumbImage:(UIImage *)image toPath:(NSString *)thumbPath;   //压缩图片

- (void) useImage:(UIImage *)thumbImage thumbPath:(NSString *)thumbPath imagePath:(NSString *)imagePath;

- (void) chatMessagePostion:(int)originY tableViewHeight:(int)tableViewHeight animationDuration:(NSNumber*)duration animationCure:(NSNumber *)curve;

- (void)setMessageControlPosition:(float)changHeight;
- (void)addChatMessageToShow:(DEYChatMessage *)groupChat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil UserID:(NSString *) userID RoomID:(NSString *) strRoomID ChatType:(eChatType) type;

//第一个比第二个的时间差值比给定值大，返回ture
- (BOOL)equalsWithAccuracy:(NSString *)firstTime secondTime:(NSString *)secondTime accuracy:(int)accuray;
- (NSDate *)getDateFromString:(NSString *)stringTime;
- (NSString *)getStringFromDate:(NSDate *)data;
- (NSMutableArray *)setMessageTimeToShow:(NSMutableArray *)messageArray;

-(NSString *)reciveFilePath;
-(void)initDocument:(NSString *)temPath;

@end

typedef enum{
    kDEYChatTableViewScrollDirectory_up,
    kDEYChatTableViewScrollDirectory_down,
    kDEYChatTableViewScrollDirectory_no
}DEYChatTableViewScrollDirectory;

@protocol DEYChatMessageTableViewDelegate <NSObject>
@optional
- (void)chatTableViewFingerScrollingDirectory:(DEYChatTableViewScrollDirectory)dir;
- (void)chatMessageDidSendFailedProcessing;
@end
