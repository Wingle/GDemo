//
//  DEYChatMessage.h
//  DEYSocketClientTest
//
//  Created by Wingle Wong on 12/7/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#  define DEBUGLOG(...)				NSLog(__VA_ARGS__)
#else
#  define DEBUGLOG(...)
#endif

typedef enum _eChatType {
    eChatTypeGroup = 0,
    eChatTypeP2P
}eChatType;

typedef enum _eMessageType
{
    eMessageTypeInvalid = 0,
    eMessageTypeMessage,        //文本
    eMessageTypeImage,          //图片
    eMessageTypeSound           //声音
}eMessageType;

typedef enum _eMessageResourceFormat
{
    eMessageResourceFormatInvalid = 0,      //文本等
    eMessageResourceFormatJPG = 1,          //JPG图片
    eMessageResourceFormatPNG = 2,          //PNG图片
    eMessageResourceFormatSPX = 3           //SPX声音
}eMessageResourceFormat;

typedef enum _eMessageState
{
    eMessageStateInvalid = 0,           //无效
    eMessageStateWaitForSend = 1,       //待发送
    eMessageStateSended = 2   ,         //已发送
    eMessageStateSendedTimeOunt = 3,    //超时信息
    eMessageStateReceive = 4,           //下载的
    eMessageStateGroupDismiss = 5,      //群组被解散
    eMessageStateShotOffGroup = 6       //被踢出群组
}eMessageState;

typedef struct {
    int32_t width;
    int32_t height;
}DEYChatMessageImageSize;

@interface DEYUnreadMessageInfo : NSObject

@property (nonatomic, retain) NSString *strChatRoomID;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, assign) int unreadMessageNumber;
@property (nonatomic, assign) eChatType chatType;

- (id) InitUnreadMessageInfoWithRoom:(NSString *) chatRoomID andUserID:(NSString *) userID andTotalMessageNo:(int) msgNo andChatType:(eChatType) chattype;
+ (void) saveUnreadMessage:(DEYUnreadMessageInfo *) unreadMessageInfo UseAddMode:(BOOL) addMode;
+ (int) getAllUnreadMsgNumber:(NSString *) UserID;
+ (int) getGroupAllUnreadMsgNum:(NSString *) UserID;
+ (int) getP2PAllUnreadMsgNum:(NSString *) UserID;
+ (int) getUnreadMsgNumberFromGroup:(NSString *) ChatRoomID UserID:(NSString *) UserID;
+ (int) getUnreadMsgNumberFromP2P:(NSString *) ChatRoomID UserID:(NSString *) UserID;
+ (NSDictionary *) getAllChatRoomUnreadMsgNumber:(NSString *) UserID;
+ (void) deleteUnreadMsgFrom:(NSString *) chatRoomID andUserID:(NSString *) userID;

@end

@interface DEYChatMessage : NSObject {
    NSString * strLocalMsgId;          //聊天ID
    NSString * strServerMsgId;
    NSString * strChatRoomID;               //消息来源或消息发送对象
    NSString * strUserId;               //发言者ID
    NSString * strUserName;
    NSString * strTime;
    NSString * strMessage;
    NSString * strOriginalImageMessage;
    
    eMessageType messageType;                       //资源类型 文本，图片，声音
    eMessageResourceFormat resourceFormat;          //格式
    eMessageState state;                            //聊天数据状态,无需发送和收到的数据为eGroupChatStateInvalid
    eChatType msgChatTpye;                          // 0 为群组聊天，1 为个人点对点聊天
    
    int iImageVersion;
    NSData *messageData;                            //内容信息，文本转为nsstring  图片转为JPG 声音转为spx
    int imageHeight;
    int imageWidth;
    int iVoiceLength;                               //语音时间
    int iLastChatsNum;                              //之前有的未加载数据
}


@property(nonatomic,retain) NSString * strLocalMsgId;       //聊天ID
@property(nonatomic,retain) NSString * strServerMsgId;
@property(nonatomic,retain) NSString * strChatRoomID;
@property(nonatomic,retain) NSString * strUserId;       //发言者ID
@property(nonatomic,retain) NSString * strUserName;
@property(nonatomic,assign) int iImageVersion;
@property(nonatomic,retain) NSString * strTime;
@property(nonatomic,retain) NSString * strMessage;
@property(nonatomic, retain) NSString *strOriginalImageMessage;   //原图片地址
@property(nonatomic,assign) eMessageType messageType;
@property(nonatomic,assign) eMessageResourceFormat resourceFormat;        //格式
@property(nonatomic,assign) eMessageState state;
@property(nonatomic,assign) eChatType msgChatTpye; 

@property(nonatomic,retain) NSData *messageData;
/// 使用下面代替上面两个???
@property(nonatomic,assign,readwrite) DEYChatMessageImageSize imageSize;
@property(nonatomic,assign) int iLastChatsNum;
@property(nonatomic,assign) int iVoiceLength;

@property (nonatomic, assign) BOOL timeToShow;

- (NSString *)originalMediaURL;
- (NSString *)thumbnailMediaURL;

- (NSString *)userThumbnailURL;
- (NSString *)voiceFilePath;

+ (NSString *)chatDataDirectory;

@end
