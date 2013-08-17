//
//  DEYMessageDBManager.m
//  DEYSocketClientTest
//
//  Created by Wingle Wong on 12/7/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import "DEYMessageDBManager.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "DEYChatMessage.h"

#define trimNullString(obj) ((obj==nil)?(@""):(obj))
#define DBFileName @"Message.db"
#define DBVersionKey @"DataBaseVersion"

static DEYMessageDBManager *gDataBaseManager = nil;

@implementation DEYMessageDBManager
@synthesize queue;


#pragma mark - init

+ (DEYMessageDBManager *)shareDBManager
{
    if (gDataBaseManager == nil) {
        gDataBaseManager = [[DEYMessageDBManager alloc] init];
    }
    return gDataBaseManager;
}

- (void)getDBQueue
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DBFileName];
    DEBUGLOG(@"DBPath = %@",writableDBPath);
    BOOL bCreate = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    bCreate = [fm fileExistsAtPath:writableDBPath];
    self.queue = [FMDatabaseQueue databaseQueueWithPath:writableDBPath];
    int DataBaseVersion = [[NSUserDefaults standardUserDefaults] integerForKey:DBVersionKey];
    if (!bCreate) {
        DataBaseVersion = 1;
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:1] forKey:DBVersionKey];
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sqlChatMessage = @"create table if not Exists ChatMessage (id integer PRIMARY KEY autoincrement,chatType integer,serverChatId long long integer, chatId long long integer NOT NULL,userId integer,ChatRoomID integer,resourceType integer, resourceFormat integer, publishUserId integer,publishName text,iImageVersion integer,strChatTime text,strMessage text,msgData blob,chatState integer,imageWidth integer,imageHeight integer, iVoiceLength integer,iLastChatsNum integer,constraint UQ_serverChatID_ChatRoomID UNIQUE(chatId,userId,ChatRoomID,chatType))";
        
        NSString * sqlUnreadMessage = @"create table if not EXISTS 'UnreadMessage' (userId integer,ChatRoomID interger,unreadNum interger,chatType interger,PRIMARY KEY (userId, ChatRoomID,chatType))";
        
        BOOL res = [db executeUpdate:sqlChatMessage];
        if (res) {
            DEBUGLOG(@"succ to creating db table ChatMessage ");
        }else{
            DEBUGLOG(@"error when creating db table ChatMessage,error Code is %d , error message is %@",[db lastErrorCode], [db lastErrorMessage]);
        }
        
        res = [db executeUpdate:sqlUnreadMessage];
        if (res) {
            DEBUGLOG(@"succ to creating db table UnreadMessage ");
        }else{
            DEBUGLOG(@"error when creating db table UnreadMessage,error Code is %d , error message is %@",[db lastErrorCode], [db lastErrorMessage]);
        }
        
    }];
    
    if (DataBaseVersion == 1) {
        //下次数据库表字段更新的话做些操作
        
    }
}

- (id)init
{
    if (self = [super init]) {
        [self getDBQueue];
    }
    return self;
}

- (void)dealloc
{
    [queue release];
    [super dealloc];
}

#pragma mark - API
#pragma mark -- For ChatMessage 

- (NSInteger) insertChatMessages:(DEYChatMessage *) chatData byUserID:(int) userId {
    if (chatData == nil) {
        return -1;
    }
    
    NSString *sqlString = @"insert into ChatMessage (chatType, serverChatId, chatId, userId, ChatRoomID, resourceType, resourceFormat, publishUserId, publishName, iImageVersion, strChatTime, strMessage, msgData, chatState, imageWidth, imageHeight, iVoiceLength, iLastChatsNum) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    [queue inDatabase:^(FMDatabase *db)
     {
         BOOL flag = [db executeUpdate:sqlString,
                      [NSNumber numberWithInt:chatData.msgChatTpye],
                      [chatData.strServerMsgId longLongValue] ? [NSNumber numberWithLongLong:[chatData.strServerMsgId longLongValue]] : NULL,
                      [NSNumber numberWithLongLong:[chatData.strLocalMsgId longLongValue]],
                      [NSNumber numberWithInt:userId],
                      [NSNumber numberWithInt:[chatData.strChatRoomID intValue]],
                      [NSNumber numberWithInt:chatData.messageType],
                      [NSNumber numberWithInt:chatData.resourceFormat],
                      [NSNumber numberWithInt:[chatData.strUserId intValue]],
                      trimNullString(chatData.strUserName),
                      [NSNumber numberWithInt:chatData.iImageVersion],
                      trimNullString(chatData.strTime),
                      trimNullString(chatData.strMessage),
                      chatData.messageData,
                      [NSNumber numberWithInt:chatData.state],
                      [NSNumber numberWithInt:chatData.imageSize.width],
                      [NSNumber numberWithInt:chatData.imageSize.height],
                      [NSNumber numberWithInt:chatData.iVoiceLength],
                      [NSNumber numberWithInt:chatData.iLastChatsNum]
                      ];
         
         if (flag) {
             DEBUGLOG(@"insert ChatMessage success,ServerChatId:%lli ,strChatId:%lli ,ChatRoomID:%d",[chatData.strServerMsgId longLongValue],[chatData.strLocalMsgId longLongValue],[chatData.strChatRoomID intValue]);
         }else {
             DEBUGLOG(@"insert ChatMessage faild ,ServerChatId:%lli ,strChatId:%lli ,ChatRoomID:%d",[chatData.strServerMsgId longLongValue],[chatData.strLocalMsgId longLongValue],[chatData.strChatRoomID intValue]);
         }
         
         if ([db hadError]) {
             DEBUGLOG(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
         }
         
     }];
    return 0;
    
}

- (void) updateChatMessage:(DEYChatMessage *) chatData byUserID:(int) userId {
    NSString * ChatMessageUpdate = @"update ChatMessage set serverChatId=?,chatState=? where userId=? and ChatRoomID=? and chatId=? and chatType=?";
    
    [queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:ChatMessageUpdate,
          [NSNumber numberWithLongLong:[chatData.strServerMsgId longLongValue]],
          [NSNumber numberWithInt:chatData.state],
          [NSNumber numberWithInt:userId],
          [NSNumber numberWithInt:[chatData.strChatRoomID intValue]],
          [NSNumber numberWithLongLong:[chatData.strLocalMsgId longLongValue]],
          [NSNumber numberWithInt:chatData.msgChatTpye]];
         
         if ([db hadError]) {
             DEBUGLOG(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
         }
     }];
    
}

- (BOOL) checkChatMessagesIsExist:(DEYChatMessage *) chatData withUser:(int) userId {
    NSString *strSQL = @"select count(1) 'num' from ChatMessage where userId=? and ChatRoomID=? and chatId=? and chatType=?";
    __block int iCount = 0;
    [queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:strSQL,
                            [NSNumber numberWithInt:userId],
                            [NSNumber numberWithInt:[chatData.strChatRoomID intValue]],
                            [NSNumber numberWithLongLong:[chatData.strLocalMsgId longLongValue]],
                            [NSNumber numberWithInt:chatData.msgChatTpye]];
         while ([rs next]) {
             iCount = [rs intForColumn:@"num"];
         }
         [rs close];
         
     }];
    
    return iCount ? YES : NO;
}

- (void) saveChatMessages:(DEYChatMessage *) chatData byUserID:(int) userId {
    if (chatData == nil) {
        return;
    }
    
    if ([self checkChatMessagesIsExist:chatData withUser:userId]) {
        [self updateChatMessage:chatData byUserID:userId];
    }else {
        [self insertChatMessages:chatData byUserID:userId];
    }
}

- (NSArray *) getTheLatestChatMessage:(NSString *) ChatRoomID withUser:(int) userId byTotalnumber:(NSInteger) count chatType:(eChatType) chatType {
    NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    NSString *GobiQuery = @"select * from ChatMessage where ChatRoomID = ? and userId = ? and chatType = ? order by id desc limit ?";
    
    [queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:GobiQuery,
                            [NSNumber numberWithInt:[ChatRoomID intValue]],
                            [NSNumber numberWithInt:userId],
                            [NSNumber numberWithInt:chatType],
                            [NSNumber numberWithInt:count]];
         
         while ([rs next]) {
             DEYChatMessage *chatData = [[DEYChatMessage alloc] init];
             chatData.msgChatTpye = [rs intForColumn:@"chatType"];
             chatData.strServerMsgId = [rs longLongIntForColumn:@"serverChatId"] ? [NSString stringWithFormat:@"%lli",[rs longLongIntForColumn:@"serverChatId"]] : nil;
             
             chatData.strLocalMsgId = [NSString stringWithFormat:@"%lli",[rs longLongIntForColumn:@"chatId"]];
             chatData.strUserId = [NSString stringWithFormat:@"%d",[rs intForColumn:@"publishUserId"]];
             chatData.strChatRoomID = [NSString stringWithFormat:@"%d",[rs intForColumn:@"ChatRoomID"]];
             chatData.messageType = [rs intForColumn:@"resourceType"];
             chatData.resourceFormat =[rs intForColumn:@"resourceFormat"];
             chatData.iImageVersion = [rs intForColumn:@"iImageVersion"];
             chatData.strTime = trimNullString([rs stringForColumn:@"strChatTime"]);
             chatData.strMessage = trimNullString([rs stringForColumn:@"strMessage"]);
             chatData.state = [rs intForColumn:@"chatState"];
             DEYChatMessageImageSize newSize = {0,0};
             newSize.width = [rs intForColumn:@"imageWidth"];
             newSize.height = [rs intForColumn:@"imageHeight"];
             chatData.imageSize = newSize;
             chatData.iVoiceLength = [rs intForColumn:@"iVoiceLength"];
             chatData.iLastChatsNum = [rs intForColumn:@"iLastChatsNum"];
             chatData.strUserName = trimNullString([rs stringForColumn:@"publishName"]);
             chatData.messageData = [rs dataForColumn:@"msgData"];
             
             [result insertObject:chatData atIndex:0];
             [chatData release];
             chatData = nil;
         }
         
         if ([db hadError]) {
             DEBUGLOG(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
         }
         
         [rs close];
     }];
    
    return result;
    
}

- (NSArray *) getChatMessage:(NSString *)ChatRoomID fromMsgID:(long long)startMsgID withUserID:(int) userId byTotalNumber:(NSInteger)number chatType:(eChatType) chatType {
    NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    NSString *GobiQuery = @"select * from ChatMessage where ChatRoomID = ? and userId = ? and chatType = ? and id < (select id from ChatMessage where (serverChatId = ? or chatId = ?) and ChatRoomID = ? and userId = ? and chatType = ? limit 1) order by id desc limit ?";
    
    [queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:GobiQuery,
                            [NSNumber numberWithInt:[ChatRoomID intValue]],
                            [NSNumber numberWithInt:userId],
                            [NSNumber numberWithInt:chatType],
                            [NSNumber numberWithLongLong:startMsgID],
                            [NSNumber numberWithLongLong:startMsgID],
                            [NSNumber numberWithInt:[ChatRoomID intValue]],
                            [NSNumber numberWithInt:userId],
                            [NSNumber numberWithInt:chatType],
                            [NSNumber numberWithInteger:number]];
         
         while ([rs next]) {
             DEYChatMessage *chatData = [[DEYChatMessage alloc] init];
             long long int serverChatId = [rs longLongIntForColumn:@"serverChatId"];
             chatData.strServerMsgId = serverChatId ? [NSString stringWithFormat:@"%lli",serverChatId] : nil;
             chatData.strLocalMsgId = [NSString stringWithFormat:@"%lli",[rs longLongIntForColumn:@"chatId"]];
             chatData.strUserId = [NSString stringWithFormat:@"%d",[rs intForColumn:@"publishUserId"]];
             chatData.strChatRoomID = [NSString stringWithFormat:@"%d",[rs intForColumn:@"ChatRoomID"]];
             chatData.messageType = [rs intForColumn:@"resourceType"];
             chatData.resourceFormat =[rs intForColumn:@"resourceFormat"];
             chatData.iImageVersion = [rs intForColumn:@"iImageVersion"];
             chatData.strTime = trimNullString([rs stringForColumn:@"strChatTime"]);
             chatData.strMessage = trimNullString([rs stringForColumn:@"strMessage"]);
             chatData.state = [rs intForColumn:@"chatState"];
             DEYChatMessageImageSize newSize = {0,0};
             newSize.width = [rs intForColumn:@"imageWidth"];
             newSize.height = [rs intForColumn:@"imageHeight"];
             chatData.imageSize = newSize;
             chatData.iVoiceLength = [rs intForColumn:@"iVoiceLength"];
             chatData.iLastChatsNum = [rs intForColumn:@"iLastChatsNum"];
             chatData.strUserName = trimNullString([rs stringForColumn:@"publishName"]);
             chatData.msgChatTpye = [rs intForColumn:@"chatType"];
             chatData.messageData = [rs dataForColumn:@"msgData"];
             
             [result insertObject:chatData atIndex:0];
             [chatData release];
             chatData = nil;
         }
         
         if ([db hadError]) {
             DEBUGLOG(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
         }
         
         [rs close];
     }];
    return result;
}

- (void) deleteMsgFrom:(NSString *) ChatRoomID withUserID:(int) userId byChatType:(eChatType) chatTpye {
    NSString *strSQL = @"delete from ChatMessage where userId=? and ChatRoomID=? and chatType = ?";
    [queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:strSQL,
          [NSNumber numberWithInt:userId],
          [NSNumber numberWithInt:[ChatRoomID intValue]],
          [NSNumber numberWithInt:chatTpye]];
         if ([db hadError]) {
             DEBUGLOG(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
         }
     }];
}

- (NSArray *) getAllUnsendChatMessage:(int) userId{
    NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    NSString *unsendChatMessage = @"select * from ChatMessage where chatState= ? and userId=?";
    [queue inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery:unsendChatMessage,
                           [NSNumber numberWithInt:eMessageStateWaitForSend],
                           [NSNumber numberWithInt:userId]];
        
        while ([rs next]) {
            DEYChatMessage *chatData = [[DEYChatMessage alloc] init];
            long long int serverChatId = [rs longLongIntForColumn:@"serverChatId"];
            chatData.strServerMsgId = serverChatId ? [NSString stringWithFormat:@"%lli",serverChatId] : nil;
            chatData.strLocalMsgId = [NSString stringWithFormat:@"%lli",[rs longLongIntForColumn:@"chatId"]];
            chatData.strUserId = [NSString stringWithFormat:@"%d",[rs intForColumn:@"publishUserId"]];
            chatData.strChatRoomID = [NSString stringWithFormat:@"%d",[rs intForColumn:@"ChatRoomID"]];
            chatData.messageType = [rs intForColumn:@"resourceType"];
            chatData.resourceFormat =[rs intForColumn:@"resourceFormat"];
            chatData.iImageVersion = [rs intForColumn:@"iImageVersion"];
            chatData.strTime = trimNullString([rs stringForColumn:@"strChatTime"]);
            chatData.strMessage = trimNullString([rs stringForColumn:@"strMessage"]);
            chatData.state = [rs intForColumn:@"chatState"];
            DEYChatMessageImageSize newSize = {0,0};
            newSize.width = [rs intForColumn:@"imageWidth"];
            newSize.height = [rs intForColumn:@"imageHeight"];
            chatData.imageSize = newSize;
            chatData.iVoiceLength = [rs intForColumn:@"iVoiceLength"];
            chatData.iLastChatsNum = [rs intForColumn:@"iLastChatsNum"];
            chatData.strUserName = trimNullString([rs stringForColumn:@"publishName"]);
            chatData.msgChatTpye = [rs intForColumn:@"chatType"];
            chatData.messageData = [rs dataForColumn:@"msgData"];
            
            [result insertObject:chatData atIndex:0];
            [chatData release];
            chatData = nil;
        }
    }];
    
    return result;
}


#pragma mark -- For UnreadMessage

- (void) insertUnreadMessage:(DEYUnreadMessageInfo *)unreadMessageInfo {
    NSString *UnreadMessageInsert = @"insert into UnreadMessage(userId,ChatRoomID,unreadNum,chatType) values(?,?,?,?)";
    [queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:UnreadMessageInsert,
          [NSNumber numberWithInt:[unreadMessageInfo.userId intValue]],
          [NSNumber numberWithInt:[unreadMessageInfo.strChatRoomID intValue]],
          [NSNumber numberWithInt:unreadMessageInfo.unreadMessageNumber],
          [NSNumber numberWithInt:unreadMessageInfo.chatType]];
         
         if ([db hadError]) {
             DEBUGLOG(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
         }
     }];
}

- (void) updateUnreadMessage:(DEYUnreadMessageInfo *) unreadMessageInfo UseAddMode:(BOOL) addMode {
    NSString *UnreadMessageUpdate = nil;
    if (addMode) {
        UnreadMessageUpdate = @"update UnreadMessage set unreadNum=unreadNum+? where userId=? and ChatRoomID=? and chatType = ?";
    }
    else {
        UnreadMessageUpdate = @"update UnreadMessage set unreadNum=? where userId=? and ChatRoomID=? and chatType = ?";
    }
    [queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:UnreadMessageUpdate,
          [NSNumber numberWithInt:unreadMessageInfo.unreadMessageNumber],
          [NSNumber numberWithInt:[unreadMessageInfo.userId intValue]],
          [NSNumber numberWithInt:[unreadMessageInfo.strChatRoomID intValue]],
          [NSNumber numberWithInt:unreadMessageInfo.chatType]];
         if ([db hadError]) {
             DEBUGLOG(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
         }
     }];
}

- (BOOL) checkUnreadMessageIsExist:(DEYUnreadMessageInfo *) unreadMessageInfo {
    NSString *UnreadMessageQuery = @"select count(1) 'num' from UnreadMessage where userId = ? and ChatRoomID = ? and chatType = ?";
    __block int iCount = 0;
    [queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:UnreadMessageQuery,
                            [NSNumber numberWithInt:[unreadMessageInfo.userId intValue]],
                            [NSNumber numberWithInt:[unreadMessageInfo.strChatRoomID intValue]],
                            [NSNumber numberWithInt:unreadMessageInfo.chatType]];
         while ([rs next]) {
             iCount = [rs intForColumn:@"num"];
         }
         
         [rs close];
         
     }];
    
    return iCount ? YES : NO;
}

- (void) saveUnreadMessage:(DEYUnreadMessageInfo *) unreadMessageInfo UseAddMode:(BOOL) addMode {
    if (unreadMessageInfo == nil) {
        return;
    }
    
    if ([self checkUnreadMessageIsExist:unreadMessageInfo]) {
        [self updateUnreadMessage:unreadMessageInfo UseAddMode:addMode];
    }else {
        [self insertUnreadMessage:unreadMessageInfo];
    }
}

- (int) getAllUnreadMsgNumber:(int) userId {
    NSString *UnreadMessageQuery = @"select sum(unreadNum) 'num' from UnreadMessage where userId = ?";
    __block int iCount = 0;
    [queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:UnreadMessageQuery,[NSNumber numberWithInt:userId]];
         while ([rs next]) {
             iCount = [rs intForColumn:@"num"];
             DEBUGLOG(@"userID = %d, totalNum = %d",userId, iCount);
         }
         if ([db hadError]) {
             DEBUGLOG(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
         }
         [rs close];
     }];
    return iCount;
}

- (int) getAllUnreadMsgNumber:(int)userId byChatType:(eChatType) chattype {
    NSString *UnreadMessageQuery = @"select sum(unreadNum) 'num' from UnreadMessage where userId = ? and chatType = ?";
    __block int iCount = 0;
    [queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:UnreadMessageQuery,
                            [NSNumber numberWithInt:userId],
                            [NSNumber numberWithInt:chattype]];
         while ([rs next]) {
             iCount = [rs intForColumn:@"num"];
             DEBUGLOG(@"userID = %d, totalNum = %d",userId, iCount);
         }
         if ([db hadError]) {
             DEBUGLOG(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
         }
         [rs close];
     }];
    return iCount;
}

- (int) getUnreadMsgNumberFromChatRoom:(NSString *) ChatRoomID UserID:(int) userId byChatType:(eChatType) chattype {
    NSString *UnreadMessageQuery = @"select sum(unreadNum) 'num' from UnreadMessage where ChatRoomID = ? and userId = ? and chatType = ?";
    __block int iCount = 0;
    [queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:UnreadMessageQuery,
                            [NSNumber numberWithInt:[ChatRoomID intValue]],
                            [NSNumber numberWithInt:userId],
                            [NSNumber numberWithInt:chattype]];
         
         while ([rs next]) {
             iCount = [rs intForColumn:@"num"];
             DEBUGLOG(@"userID = %d, ChatRoomID = %@, totalNum = %d",userId,ChatRoomID,iCount);
         }
         if ([db hadError]) {
             DEBUGLOG(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
         }
         
         [rs close];
     }];
    return iCount;
}

- (NSDictionary *) getAllChatRoomUnreadMsgNumber:(int) userId {
    NSMutableDictionary *groupIdToUnreadNumber = [[[NSMutableDictionary alloc] init] autorelease];
    NSString *UnreadMessageQuery = @"select ChatRoomID, unreadNum from UnreadMessage where userId = ?";
    [queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:UnreadMessageQuery,[NSNumber numberWithInt:userId]];
         while ([rs next]) {
             NSString *ChatRoomID = [NSString stringWithFormat:@"%d",[rs intForColumn:@"ChatRoomID"]];
             NSString *unreadNum = [NSString stringWithFormat:@"%d",[rs intForColumn:@"unreadNum"]];
             [groupIdToUnreadNumber setObject:unreadNum forKey:ChatRoomID];
             DEBUGLOG(@"userID = %d, unreadNum = %@, ChatRoomID = %@",userId, unreadNum, ChatRoomID);
         }
         if ([db hadError]) {
             DEBUGLOG(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
         }
     }];
    return groupIdToUnreadNumber;
}

- (void) deleteUnreadMsgFrom:(DEYUnreadMessageInfo *) unreadMsgInfo {
    NSString *UnreadMessageDelete = @"delete from UnreadMessage where userId=? and ChatRoomID=? and chatType = ?";
    [queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:UnreadMessageDelete,
                [NSNumber numberWithInt:[unreadMsgInfo.userId intValue]],
          [NSNumber numberWithInt:[unreadMsgInfo.strChatRoomID intValue]],
          [NSNumber numberWithInt:unreadMsgInfo.chatType]];
         if ([db hadError]) {
             DEBUGLOG(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
         }
     }];
}

@end
