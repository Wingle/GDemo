//
//  DEYChatMessageTableViewCell.h
//  DEyes
//
//  Created by zhang xiang on 8/7/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEYChatMessage.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"

@interface DEYChatMessageTableViewCell : UITableViewCell{
    DEYChatMessage *m_groupChat;
    
    EGOImageView *m_faceImage;
    UILabel *m_userNameLable;
    UILabel *m_messageTimeLable;
    UILabel *m_messagelabel;
    UIImageView *m_messageBubbleImageView;
    UIButton *m_audioButton;
    EGOImageButton *m_imageButton;
    UIImageView *m_imgViewAudio;
    UILabel *m_labelVoiceTime;
    
}

@property (retain, nonatomic) DEYChatMessage *m_groupChat;

@property (retain, nonatomic) IBOutlet EGOImageView *m_faceImage;
@property (retain, nonatomic) IBOutlet UILabel *m_userNameLable;
@property (retain, nonatomic) IBOutlet UILabel *m_messageTimeLable;
@property (retain, nonatomic) IBOutlet UILabel *m_messagelabel;
@property (retain, nonatomic) IBOutlet UIImageView *m_messageBubbleImageView;
@property (retain, nonatomic) IBOutlet UIButton *m_audioButton;
@property (retain, nonatomic) IBOutlet UIButton *m_imageButton;
@property (retain, nonatomic) IBOutlet EGOImageButton *btnFaceImage;

@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewAudio;
@property (retain, nonatomic) IBOutlet UILabel *m_labelVoiceTime;

//根据时间返回
//1，若时间为今天，返回HH:mm
//2，若时间为昨天，返回昨天 HH:mm
//3，若时间为之前，返回yyyy-mm-dd
-(NSString *)convertTimewith:(NSString *) time;

- (void)setChatMessageCellDisplay:(DEYChatMessage *)message Direction:(BOOL)isLeft;

- (CGFloat)getSizeOfVoiceLength:(int)iVoiceLength;

-(void)startPlayAnimation;
-(void)stopPlayAnimation;

+ (int) getMessageTableViewCellHeighrDisplay:(DEYChatMessage *)message;
+ (int) getMessageTableViewCellHeight:(NSString *)strMessage;

@end
