//
//  DEYChatMessage.m
//  DEYSocketClientTest
//
//  Created by Wingle Wong on 12/7/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import "DEYChatMessage.h"
#import "DEYMessageDBManager.h"

@implementation DEYUnreadMessageInfo

@synthesize strChatRoomID;
@synthesize userId;
@synthesize unreadMessageNumber;
@synthesize chatType;

- (id)init{
    
    if (self = [super init]) {
        strChatRoomID = nil;
        userId = nil;
        unreadMessageNumber = 0;
    }
    return self;
}

- (id) InitUnreadMessageInfoWithRoom:(NSString *) chatRoomID andUserID:(NSString *) userID andTotalMessageNo:(int) msgNo andChatType:(eChatType)chattype {
    if (self = [super init]) {
        self.strChatRoomID = chatRoomID;
        self.userId = userID;
        self.unreadMessageNumber = msgNo;
        self.chatType = chattype;
    }
    return self;
}


- (void)dealloc{
    [strChatRoomID release];
    [userId release];
    
    [super dealloc];
}

#pragma mark - UnreadMessage API 
+ (void) saveUnreadMessage:(DEYUnreadMessageInfo *) unreadMessageInfo UseAddMode:(BOOL) addMode {
    if (unreadMessageInfo == nil) {
        return;
    }
    [[DEYMessageDBManager shareDBManager] saveUnreadMessage:unreadMessageInfo UseAddMode:addMode];
}

+ (int) getAllUnreadMsgNumber:(NSString *) UserID {
    if (UserID == nil) {
        return 0;
    }
    return [[DEYMessageDBManager shareDBManager] getAllUnreadMsgNumber:[UserID intValue]];
}

+ (int) getUnreadMsgNumberFromGroup:(NSString *) ChatRoomID UserID:(NSString *) UserID {
    if (ChatRoomID == nil || UserID == nil) {
        return 0;
    }
    return [[DEYMessageDBManager shareDBManager] getUnreadMsgNumberFromChatRoom:ChatRoomID UserID:[UserID intValue] byChatType:eChatTypeGroup];
}

+ (int) getUnreadMsgNumberFromP2P:(NSString *) ChatRoomID UserID:(NSString *) UserID {
    if (ChatRoomID == nil || UserID == nil) {
        return 0;
    }
    return [[DEYMessageDBManager shareDBManager] getUnreadMsgNumberFromChatRoom:ChatRoomID UserID:[UserID intValue] byChatType:eChatTypeP2P];
}

+ (NSDictionary *) getAllChatRoomUnreadMsgNumber:(NSString *) UserID {
    if (UserID == nil) {
        return nil;
    }
    return [[DEYMessageDBManager shareDBManager] getAllChatRoomUnreadMsgNumber:[UserID intValue]];
}

+ (void) deleteUnreadMsgFrom:(NSString *) chatRoomID andUserID:(NSString *) UserID {
    if (chatRoomID == nil || UserID == nil) {
        return;
    }
    DEYUnreadMessageInfo *unreadMsgInfo = [[DEYUnreadMessageInfo alloc] init];
    unreadMsgInfo.userId = UserID;
    unreadMsgInfo.strChatRoomID = chatRoomID;
    unreadMsgInfo.chatType = eChatTypeGroup;
    [[DEYMessageDBManager shareDBManager] deleteUnreadMsgFrom:unreadMsgInfo];
    unreadMsgInfo.chatType = eChatTypeP2P;
    [[DEYMessageDBManager shareDBManager] deleteUnreadMsgFrom:unreadMsgInfo];
    [unreadMsgInfo release];
}

+ (int) getGroupAllUnreadMsgNum:(NSString *) UserID {
    return [[DEYMessageDBManager shareDBManager] getAllUnreadMsgNumber:[UserID intValue] byChatType:eChatTypeGroup];
}

+ (int) getP2PAllUnreadMsgNum:(NSString *) UserID {
    return [[DEYMessageDBManager shareDBManager] getAllUnreadMsgNumber:[UserID intValue] byChatType:eChatTypeP2P];
}

@end

@interface DEYChatMessage ()

- (NSString *)mediaURL:(BOOL)isFullOrThumbnail;

@end

@implementation DEYChatMessage

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

@synthesize iImageVersion;
//@synthesize imageWidth;
//@synthesize imageHeight;
@synthesize iVoiceLength;
@synthesize iLastChatsNum;
@synthesize imageSize;

@synthesize timeToShow = _timeToShow;

- (id)init
{
    if(self = [super init])
    {
        strLocalMsgId = nil;
        strServerMsgId = nil;
        strChatRoomID = nil;
        strUserId = nil;
        strUserName = nil;
        strTime = nil;
        strMessage = nil;
        strOriginalImageMessage = nil;
        messageType = eMessageTypeInvalid;
        resourceFormat = eMessageResourceFormatInvalid;
        state = eMessageStateInvalid;
        messageData = nil;
        iImageVersion = -1;
        iVoiceLength = 0;
        iLastChatsNum = 0;
        memset(&imageSize, 0, sizeof(DEYChatMessageImageSize));
        _timeToShow = YES;
    }
    return self;
}

- (void)dealloc
{
    [strLocalMsgId release];
    [strServerMsgId release];
    [strChatRoomID release];
    [strUserId release];
    [strUserName release];
    [strTime release];
    [strMessage release];
    [strOriginalImageMessage release];
    [messageData release];
    
    [super dealloc];
}

- (NSString *)originalMediaURL {
    return [self mediaURL:YES];
}

- (NSString *)thumbnailMediaURL {
    return [self mediaURL:NO];
}

- (NSString *)mediaURL:(BOOL)isFullOrThumbnail {
    NSRange range = [self.strMessage rangeOfString:@"chatId"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSString *headLink = [self.strMessage substringWithRange:NSMakeRange(0, range.location-1)];
    NSString *chatID = [self.strMessage substringWithRange:NSMakeRange(range.location, [self.strMessage length]- range.location)];
    
    return [NSString stringWithFormat:@"%@/%@&format=%@&userId=%@&appId=%@&%@",
            CR_REQUEST_URL,
            headLink,
            isFullOrThumbnail ? @"original" : @"thumbnail6060",
            self.strUserId,
            APPID,
            chatID];
}

- (NSString *)userThumbnailURL {
    NSString *imgURL = [NSString stringWithFormat:@"%@/downloadImage.do?appId=%@&type=0&size=0&imgVersion=%d&id=%@",
                        CR_REQUEST_URL,
                        APPID,
                        self.iImageVersion,
                        self.strUserId];
    return imgURL;
}

- (NSString *)voiceFilePath {
    NSString *fileName = [NSString stringWithFormat:@"chat%@.spx", self.strLocalMsgId];
    return [[[self class] chatDataDirectory] stringByAppendingPathComponent:fileName];
}

+ (NSString *)chatDataDirectory {
    NSString *directory = [NSString stringWithFormat:@"%@/tmp/forum",NSHomeDirectory()];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (NO == [fm fileExistsAtPath:directory]){
        [fm createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:nil];;
    }
    
    return directory;
}

@end
