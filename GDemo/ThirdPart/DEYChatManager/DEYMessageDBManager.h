//
//  DEYMessageDBManager.h
//  DEYSocketClientTest
//
//  Created by Wingle Wong on 12/7/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEYChatMessage.h"

@class FMDatabaseQueue;
@class DEYChatMessage;

@interface DEYMessageDBManager : NSObject {
    FMDatabaseQueue *queue;
}
@property(nonatomic, retain) FMDatabaseQueue *queue;

#pragma mark - init

+ (DEYMessageDBManager *)shareDBManager;

#pragma mark - API
#pragma mark -- for chatMessage
- (void) saveChatMessages:(DEYChatMessage *) chatData byUserID:(int) userId;
- (NSArray *) getTheLatestChatMessage:(NSString *) ChatRoomID withUser:(int) userId byTotalnumber:(NSInteger) count chatType:(eChatType) chatType;
- (NSArray *) getChatMessage:(NSString *)ChatRoomID fromMsgID:(long long)startMsgID withUserID:(int) userId byTotalNumber:(NSInteger)number chatType:(eChatType) chatType;
- (void) deleteMsgFrom:(NSString *) ChatRoomID withUserID:(int) userId byChatType:(eChatType) chatTpye;
- (NSArray *) getAllUnsendChatMessage:(int) userId;


#pragma mark -- for Unreadmessage
- (void) saveUnreadMessage:(DEYUnreadMessageInfo *) unreadMessageInfo UseAddMode:(BOOL) addMode;
- (int) getAllUnreadMsgNumber:(int) userId;
- (int) getAllUnreadMsgNumber:(int)userId byChatType:(eChatType) chattype;
- (int) getUnreadMsgNumberFromChatRoom:(NSString *) ChatRoomID UserID:(int) userId byChatType:(eChatType) chattype;
- (NSDictionary *) getAllChatRoomUnreadMsgNumber:(int) userId;
- (void) deleteUnreadMsgFrom:(DEYUnreadMessageInfo *) unreadMsgInfo;

@end
