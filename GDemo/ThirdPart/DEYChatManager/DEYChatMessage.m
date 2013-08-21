//
//  DEYChatMessage.m
//  DEYSocketClientTest
//
//  Created by Wingle Wong on 12/7/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import "DEYChatMessage.h"
#import "GDUtility.h"

@interface DEYChatMessage ()

- (NSString *)mediaURL:(BOOL)isFullOrThumbnail;

@end

@implementation DEYChatMessage

@synthesize strLocalMsgId;
@synthesize strServerMsgId;
@synthesize strChatRoomID;
@synthesize strUserId;

@synthesize strUserName;
//@synthesize strTime;
@synthesize strMessage;
@synthesize strOriginalImageMessage;
@synthesize messageType;
@synthesize resourceFormat;
@synthesize state;
@synthesize msgChatTpye;
@synthesize messageData;
@synthesize messageTimeStamp;

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
//        strTime = nil;
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
//    [strTime release];
    [strMessage release];
    [strOriginalImageMessage release];
    [messageData release];
    [messageTimeStamp release];
    
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

- (NSString *) strTime {
    return [GDUtility date:self.messageTimeStamp ByFormatter:@"yyyy/MM/dd HH:mm"];
}

@end
