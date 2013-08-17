//
//  DEYChatMessageTableViewCell.m
//  DEyes
//
//  Created by zhang xiang on 8/7/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import "DEYChatMessageTableViewCell.h"
#import <AVFoundation/AvFoundation.h>

#define Font_Heit_SC @"STHeitiSC-Light"
#define Message_Height_One 37
#define Message_Width 215
#define MessageBGKImgRightBadge  264
#define FontSize 16
#define ImageMaxSize  137
#define ImageMinSize  35
#define ImageDownloadHighParam @"%@/downloadImage.do?appId=%@&type=0&size=1&imgVersion=%@&id=%@"
#define ImageDownloadLowParam @"%@/downloadImage.do?appId=%@&type=0&size=0&imgVersion=%@&id=%@"
#define MESSAGE_CELL_HEIGHT     90

@interface  DEYChatMessageTableViewCell (private)

- (void)setChatMessageCell:(DEYChatMessage *)message Direction:(BOOL)isLeft;

- (void)setChatImageCell:(DEYChatMessage *)message Direction:(BOOL)isLef;

- (void)setChatVoiceCell:(DEYChatMessage *)message Direction:(BOOL)isLeft;
@end


@implementation DEYChatMessageTableViewCell

@synthesize m_faceImage;
@synthesize btnFaceImage;
@synthesize m_userNameLable;
@synthesize m_messageTimeLable;
@synthesize m_audioButton;
@synthesize m_imageButton;
@synthesize m_messagelabel;
@synthesize m_messageBubbleImageView;
@synthesize m_imgViewAudio;
@synthesize m_labelVoiceTime;

@synthesize m_groupChat;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc{
    [m_groupChat release];
    
    [m_messagelabel release];
    [m_messageBubbleImageView release];
    [m_faceImage release];
    [m_userNameLable release];
    [m_messageTimeLable release];
    [m_audioButton release];
    [m_imageButton release];
    [btnFaceImage release];
    [super dealloc];
}

#pragma mark - utility

- (NSString *)convertTimewith:(NSString *) time{
	NSString * return_Time;
    
    //取得今天时间
	NSDate *todayData = [NSDate date];
    //取得昨天时间
    NSDate *yesterdayData = [todayData dateByAddingTimeInterval:-86400];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date_Time = [dateFormatter dateFromString:time];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    if ([[dateFormatter stringFromDate:todayData] isEqualToString:[dateFormatter stringFromDate:date_Time]]) {
        //发送时间为今天，则信息发送时间Label仅显示时间：HH:mm
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        return_Time = [dateFormatter stringFromDate:date_Time];
    }else if([[dateFormatter stringFromDate:yesterdayData] isEqualToString:[dateFormatter stringFromDate:date_Time]])
    {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        return_Time = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date_Time]];
    }else
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return_Time = [dateFormatter stringFromDate:date_Time];
    }
	[dateFormatter release];
	return return_Time;
}


//针对message的内容对控件进行赋值并调整其控件大小
- (void) setChatMessageCellDisplay:(DEYChatMessage *)message Direction:(BOOL)isLeft{
    
    self.m_groupChat = message;

    if (message == nil) {
        return ;
    }    
    btnFaceImage.layer.masksToBounds = YES;
    btnFaceImage.layer.cornerRadius = 5.0;
    btnFaceImage.layer.borderWidth = 0.5f;
    btnFaceImage.layer.borderColor = [[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1.0f] CGColor];
    
    [btnFaceImage setPlaceholderImage:[UIImage imageNamed:@"user_head.png"]];
    NSString *imgURL = [NSString stringWithFormat:ImageDownloadLowParam,CR_REQUEST_URL,APPID,[NSString stringWithFormat:@"%d",message.iImageVersion],message.strUserId];
    [btnFaceImage setImageURL:[NSURL URLWithString:imgURL]];
    
    m_userNameLable.text = message.strUserName;
    
    if (message.strTime != nil && ![message.strTime isEqualToString:@""]) {
        NSString *time = @"";
        if (message.strTime != nil) {
            time = [self convertTimewith:message.strTime];
        }
        
        if (time != nil) {
            CGSize size = [time sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 200)];
            CGRect rect = CGRectMake((320-size.width)/2.0, m_messageTimeLable.frame.origin.y, size.width + 16, size.height + 4);
            m_messageTimeLable.frame = rect;
            
            m_messageTimeLable.layer.cornerRadius = 6.0;
            m_messageTimeLable.layer.masksToBounds = YES;
            [m_messageTimeLable setBackgroundColor:[UIColor blackColor]];
            [m_messageTimeLable setAlpha:0.2];
            [m_messageTimeLable setTextColor:[UIColor whiteColor]];
            [m_messageTimeLable setHidden:NO];
            self.m_messageTimeLable.text = time;
        }
       
    }else{
        [m_messageTimeLable setHidden:YES];
    }
    
    if (message.messageType == eMessageTypeMessage) {
        [self setChatMessageCell:message Direction:isLeft];   
    }
    else if(message.messageType == eMessageTypeSound){
        [self setChatVoiceCell:message Direction:isLeft];
    }
    else if(message.messageType == eMessageTypeImage){
        [self setChatImageCell:message Direction:isLeft];
    }
    
}

- (void)setChatMessageCell:(DEYChatMessage *)message Direction:(BOOL)isLeft{
   
    m_messagelabel.text = message.strMessage;
    
    CGSize labelSize = [self.m_messagelabel.text sizeWithFont:[UIFont systemFontOfSize:FontSize] constrainedToSize:CGSizeMake(Message_Width-30,2000)];// lineBreakMode:UILineBreakModeWordWrap];
    
    int width = labelSize.width < Message_Width ?labelSize.width:Message_Width;
    width = width < 16 ? 16 :width;
    int height = labelSize.height<20?20:labelSize.height;
    
    UIImage *img= nil;
    if (isLeft) {
        img = [UIImage imageNamed:@"text_background_left.png"];
        
        //重新设置各控件的大小及位置
        CGRect labelRect = self.m_messagelabel.frame;
        if (width == 16) {
            labelRect.origin.x = m_messageBubbleImageView.frame.origin.x + 16;
        }else{
            labelRect.origin.x = m_messageBubbleImageView.frame.origin.x + 20;
        }
        
        labelRect.size.width = width;
        labelRect.size.height = height;
        self.m_messagelabel.frame = labelRect;
        
        
        CGRect bubbleImageRect = self.m_messageBubbleImageView.frame;
        bubbleImageRect.size.width = width + 28;
        bubbleImageRect.size.height = (height + 20)>45 ? (height + 20) : 45;
        self.m_messageBubbleImageView.frame = bubbleImageRect;
        self.m_messageBubbleImageView.image = [img stretchableImageWithLeftCapWidth:25 topCapHeight:30];
        
        [self setFrame:CGRectMake(0, 0, 320, 50+height)];
        
        
    }else{
        img = [UIImage imageNamed:@"text_background_right.png"];
        
        //重新设置各控件的大小及位置
        CGRect labelRect = self.m_messagelabel.frame;
        if (width < Message_Width - 30) {
            labelRect.origin.x = MessageBGKImgRightBadge - width - 15;
        }else{
            labelRect.origin.x = MessageBGKImgRightBadge - width - 12;
        }
        
        labelRect.size.width = width;
        labelRect.size.height = height;
        self.m_messagelabel.frame = labelRect;
        
        
        CGRect bubbleImageRect = self.m_messageBubbleImageView.frame;
        bubbleImageRect.origin.x = MessageBGKImgRightBadge - width - 28;
        bubbleImageRect.size.width = width + 28;
        bubbleImageRect.size.height = (height + 20)>45 ? (height + 20) : 45;
        self.m_messageBubbleImageView.frame = bubbleImageRect;
        self.m_messageBubbleImageView.image = [img stretchableImageWithLeftCapWidth:25 topCapHeight:30];
        
        [self setFrame:CGRectMake(0, 0, 320, 50+height)];
    }
}

- (void)setChatImageCell:(DEYChatMessage *)message Direction:(BOOL)isLeft{

    CGSize imageSize;
    imageSize.height = message.imageSize.height < ImageMaxSize ? message.imageSize.height : ImageMaxSize;
    imageSize.height = imageSize.height < ImageMinSize ? ImageMinSize : imageSize.height;
    
    imageSize.width = message.imageSize.width < ImageMaxSize ? message.imageSize.width : ImageMaxSize;
    imageSize.width = imageSize.width < ImageMinSize ? ImageMinSize : imageSize.width;
    
    m_imageButton.layer.cornerRadius = 8.0;
    m_imageButton.layer.masksToBounds = YES;
    
    if (isLeft) {
        [m_imageButton setImageURL:[NSURL URLWithString:message.thumbnailMediaURL]];
    } else{
        NSString *string = [NSString stringWithString:message.strMessage];
        BOOL isImageLink = [string hasPrefix:@"chatMedia.do?receiveId"];

        if (isImageLink) {
            [m_imageButton setImageURL:[NSURL URLWithString:message.thumbnailMediaURL]];
        } else{
            NSData *imageData = [NSData dataWithContentsOfFile:message.strMessage];
            UIImage *image = [UIImage imageWithData:imageData];
            
            [m_imageButton setImage:image forState:UIControlStateNormal];
        }
        
    }
    
    
    if (isLeft) {

        UIImage *leftBackImage = [UIImage imageNamed:@"text_background_left.png"];
        CGRect bubbleRect = m_messageBubbleImageView.frame;
        bubbleRect.size.height = imageSize.height + 14;
        bubbleRect.size.width = imageSize.width + 20;
        m_messageBubbleImageView.frame = bubbleRect;
        
        self.m_messageBubbleImageView.image = [leftBackImage stretchableImageWithLeftCapWidth:25 topCapHeight:30];
        
        //对图片尺寸及按钮的大小进行进行设定
        CGRect buttonRect = m_imageButton.frame;
        buttonRect.origin.x = m_messageBubbleImageView.frame.origin.x + 14;
        buttonRect.origin.y = m_messageBubbleImageView.frame.origin.y + 6;
        buttonRect.size.height = imageSize.height;
        buttonRect.size.width = imageSize.width;
        m_imageButton.frame = buttonRect;
        
        CGRect viewRect = self.frame;
        viewRect.size.height = imageSize.height + 32;
        self.frame= viewRect;

    }else{
    
        UIImage *rightBackImage = [UIImage imageNamed:@"text_background_right.png"];
        CGRect bubbleRect = m_messageBubbleImageView.frame;
        bubbleRect.origin.x = 245 - imageSize.width;
        bubbleRect.size.height = imageSize.height + 14;
        bubbleRect.size.width = imageSize.width + 20;
        m_messageBubbleImageView.frame = bubbleRect;
        
        self.m_messageBubbleImageView.image = [rightBackImage stretchableImageWithLeftCapWidth:25 topCapHeight:30];
        
        CGRect buttonRect = m_imageButton.frame;
        buttonRect.origin.x = m_messageBubbleImageView.frame.origin.x + 6;
        buttonRect.origin.y = m_messageBubbleImageView.frame.origin.y + 6;
        buttonRect.size.height = imageSize.height;
        buttonRect.size.width = imageSize.width;
        m_imageButton.frame = buttonRect;
        
        CGRect viewRect = self.frame;
        viewRect.size.height = imageSize.height + 32;
        self.frame = viewRect;
        
    }
        
}

- (void)setChatVoiceCell:(DEYChatMessage *)message Direction:(BOOL)isLeft{
    
    m_labelVoiceTime.text = [NSString stringWithFormat:@"%d\"",message.iVoiceLength];
    
    //播放音频显示动画
    m_imgViewAudio.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:isLeft?@"GobiOribit_voice3.png":@"messageVoiceRight3.png"],
                                      [UIImage imageNamed:isLeft?@"GobiOribit_voice1.png":@"messageVoiceRight1.png"],
                                      [UIImage imageNamed:isLeft?@"GobiOribit_voice2.png":@"messageVoiceRight2.png"],
                                      [UIImage imageNamed:isLeft?@"GobiOribit_voice0.png":@"messageVoiceRight0.png"],
                                      nil];
    m_imgViewAudio.image = [UIImage imageNamed:isLeft?@"GobiOribit_voice0.png":@"messageVoiceRight0.png"];
    m_imgViewAudio.animationDuration = 1.2f;
    m_imgViewAudio.animationRepeatCount = 0;
    
    //计算显示背景长度
    CGFloat size = [self getSizeOfVoiceLength:message.iVoiceLength];
    
    UIImage *img = nil;
    if (isLeft) {
        img = [UIImage imageNamed:@"text_background_left.png"];
        CGRect bubbleRect = m_messageBubbleImageView.frame;
        bubbleRect.size.width = 55 + size;
        m_messageBubbleImageView.frame = bubbleRect;
        m_messageBubbleImageView.image = [img stretchableImageWithLeftCapWidth:25 topCapHeight:30];
        
        CGRect buttonRect = m_audioButton.frame;
        buttonRect.size.width = 35 + size;
        m_audioButton.frame =  buttonRect;
        
        CGRect labelRect = m_labelVoiceTime.frame;
        labelRect.origin.x = 121 + size;
        m_labelVoiceTime.frame = labelRect;
    }else{
        img = [UIImage imageNamed:@"text_background_right.png"];
        CGRect bubbleRect = m_messageBubbleImageView.frame;
        bubbleRect.origin.x = 211 - size;
        bubbleRect.size.width = 55 + size;
        m_messageBubbleImageView.frame = bubbleRect;
        m_messageBubbleImageView.image = [img stretchableImageWithLeftCapWidth:25 topCapHeight:30];
        
        CGRect buttonRect = m_audioButton.frame;
        buttonRect.origin.x = 215 - size;
        buttonRect.size.width = 35 + size;
        m_audioButton.frame =  buttonRect;
        
        CGRect labelRect = m_labelVoiceTime.frame;
        labelRect.origin.x = 182 - size;
        m_labelVoiceTime.frame = labelRect;
    }
    
}


-(void)startPlayAnimation{
    [m_imgViewAudio startAnimating];
}

-(void)stopPlayAnimation{
    [m_imgViewAudio stopAnimating];
}

#pragma mark -
- (CGFloat)getSizeOfVoiceLength:(int)iVoiceLength{
    CGFloat size;
    if (iVoiceLength <=1) {
        size = 0;
    }else if (iVoiceLength < 8) {
        size = (iVoiceLength - 1) * 10;
    }else if(iVoiceLength < 17){
        size = 60 + (iVoiceLength - 7) * 5;
    }else{
        size = 100;
    }
    
    return size;
}

+ (int) getMessageTableViewCellHeighrDisplay:(DEYChatMessage *)message{
    
    int height = 0;
    
    if (message.messageType == eMessageTypeMessage) {
        CGSize labelSize = [message.strMessage sizeWithFont:[UIFont systemFontOfSize:FontSize] constrainedToSize:CGSizeMake(Message_Width-30,2000) lineBreakMode:UILineBreakModeWordWrap];
   
        height =  labelSize.height<20 ? MESSAGE_CELL_HEIGHT : labelSize.height + 70;
    }
    else if(message.messageType == eMessageTypeSound){
        height = MESSAGE_CELL_HEIGHT;
    }
    else if(message.messageType == eMessageTypeImage){
        CGSize imageSize;
        imageSize.height = message.imageSize.height < ImageMaxSize ? message.imageSize.height : ImageMaxSize;
        imageSize.width = message.imageSize.width < ImageMaxSize ? message.imageSize.width : ImageMaxSize;

        height = imageSize.height + 60;
        if (height < MESSAGE_CELL_HEIGHT) {
            height = MESSAGE_CELL_HEIGHT;
        }
    }
    
    return height;
}

+ (int) getMessageTableViewCellHeight:(NSString *)strMessage{
    
    return 0;
}

@end
