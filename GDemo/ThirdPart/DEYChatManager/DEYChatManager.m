//
//  DEYChatManager.m
//  DEYSocketClientTest
//
//  Created by Wingle Wong on 12/7/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import "DEYChatManager.h"
#import "DEYSocketClient.h"
#import "DEYChatMessage.h"
#import "DEYProtocol.h"
#import "DEYMessageDBManager.h"
#import "DEYSocketMessageSendDataResult.h"
#import "DEYHandleReceiveMessageOperation.h"
#import "DEYStateContext.h"
#import "DEYChatContext.h"
#import "DEYSocketMessageChatPublish.h"


static DEYChatManager *gChatManager = nil;
NSTimeInterval MsgSendTimeOutInterval = 15;

@interface DEYChatManager (private)
- (void)stopSendDataToServer;
@end

@implementation DEYChatManager
@synthesize delegate = _delegate;
@synthesize viewdelegate = _viewdelegate;
@synthesize waitForSendArr;
@synthesize receiveQueue;

#pragma mark - init
- (id)init
{
    if (self = [super init]) {
        isChating = NO;
        waitForSendArr = [[NSMutableArray alloc]initWithCapacity:0];
        arrCondition = [[NSCondition alloc]init];
        sendDataCondition = [[NSCondition alloc]init];
        receiveQueue = [[NSOperationQueue alloc]init];
        _canStartReceiveMsg = NO;
        _userID = -1;
        
        DEYChatContext *chatContext = (DEYChatContext *)[DEYSocketClient sharedSocketClient].chatContext;
        chatContext.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    isChating = NO;
    [self stopSendDataToServer];
    [waitForSendArr release];
    [arrCondition release];
    [sendDataCondition release];
    [receiveQueue release];
    [super dealloc];
}

+ (DEYChatManager *)shareChatManager
{
    if (gChatManager == nil) {
        gChatManager = [[DEYChatManager alloc] init];
    }
    return gChatManager;
}

#pragma mark - utility functions
+ (NSString *)dateToString:(NSDate *) date ByFormatter:(NSString*)strTimeFormatter {
    NSDateFormatter	* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:strTimeFormatter];
    return [formatter stringFromDate:date];
}

#pragma mark - intenal Function
// 使timer失效
- (void) invalidateTimer{
    if (timeOutTimer == nil) {
        return;
    }
    if ([timeOutTimer isValid]) {
        [timeOutTimer invalidate];
        timeOutTimer = nil;
    }
}

//发送数据后调用，超时计时
- (void)startTimeOutEvent:(DEYChatMessage * )message
{
    [self invalidateTimer];
    timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:MsgSendTimeOutInterval
                                                    target:self
                                                  selector:@selector(timeoutEvent:)
                                                  userInfo:message
                                                   repeats:NO];
}

//超时时间到了，释放信号告诉发送线程
- (void)timeoutEvent:(NSTimer *)timer {
    DEYChatMessage *chatMessage = [timer userInfo];
    
    if (!chatMessage)  return;
    chatMessage.state = eMessageStateSendedTimeOunt;
    [sendDataCondition lock];
    [sendDataCondition signal];
    [sendDataCondition unlock];
    
    [self invalidateTimer];
}

//发送线程
- (void)sendDataToServer
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    bRun = YES;
    while (bRun) {
        [arrCondition lock];
        if (waitForSendArr.count == 0) {
            [arrCondition wait];
            [arrCondition unlock];
            continue;
        }
        if(!bRun) {//遇到退出发送的信号，解锁并退出
            [arrCondition unlock];
            break;
        }
        DEYChatMessage * message = [waitForSendArr objectAtIndex:0];
        [arrCondition unlock];
        
        
        NSAutoreleasePool *sendDataPool = [[NSAutoreleasePool alloc] init];
        int sendCount = 0;
        while (sendCount < 3) {
            [sendDataCondition lock];
            message.state = eMessageStateWaitForSend;
            [self performSelectorOnMainThread:@selector(startTimeOutEvent:) withObject:message waitUntilDone:NO];
            LOG(@"发送消息: %@",message.strMessage);
            DEYSocketClient *client = [DEYSocketClient sharedSocketClient];
            [client writeChatMessage:message];
            sendCount ++;
            [sendDataCondition wait];
            [sendDataCondition unlock];
            if (!bRun) {
                //遇到退出发送的信号，跳出循环
                [self invalidateTimer];
                break;
            }
            if (message.state == eMessageStateSended) {
                //发送成功
                //待增加数据库存储
                [self invalidateTimer];
                if (_delegate && [_delegate respondsToSelector:@selector(managerDidSendDataSuccess:)]) {
                    [_delegate managerDidSendDataSuccess:message];
                }
                break;
            }else if(message.state == eMessageStateGroupDismiss || message.state == eMessageStateShotOffGroup){
                [self invalidateTimer];
                
                if (_delegate && [_delegate respondsToSelector:@selector(managerDidSendDataFailed:)]) {
                    [_delegate managerDidSendDataFailed:message];
                }
                
                break;
            }else if (message.state == eMessageStateSendedTimeOunt)
            {
                continue;
            }
        }
        if (!bRun) {
            [sendDataPool release];
            break;//退出线程
            
        }
        //连续3次超时，返回错误
        if (message.state == eMessageStateSendedTimeOunt) {
            if (_delegate && [_delegate respondsToSelector:@selector(managerDidSendDataFailed:)]) {
                [_delegate managerDidSendDataFailed:message];
            }
        }
        [arrCondition lock];
        [waitForSendArr removeObject:message];
        message = nil;
        
        [arrCondition unlock];
        [sendDataPool release];
    }
    
    //退出发送线程时，清空waitForSendArr
    [arrCondition lock];
    [waitForSendArr removeAllObjects];
    [arrCondition unlock];
    [pool release];
}

- (void)stopSendDataToServer
{
    bRun = NO;
    [sendDataCondition lock];
    [sendDataCondition signal];
    [sendDataCondition unlock];
    [arrCondition lock];
    [waitForSendArr removeAllObjects];
    [arrCondition signal];
    [arrCondition unlock];
}

#pragma mark - Socket delegate Methods

- (void)startSendingChatMessage {
    [arrCondition lock];
    [waitForSendArr removeAllObjects];
    [arrCondition unlock];
    [NSThread detachNewThreadSelector:@selector(sendDataToServer) toTarget:self withObject:nil];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray *unsendMsgs = [[DEYMessageDBManager shareDBManager] getAllUnsendChatMessage:_userID];
    int iCount = [unsendMsgs count];
    for (int i = 0; i < iCount; i++) {
        DEYChatMessage *chatMessage = [unsendMsgs objectAtIndex:i];
        if (chatMessage == nil) {
            continue;
        }
        [arrCondition lock];
        [waitForSendArr addObject:chatMessage];
        [arrCondition signal];
        [arrCondition unlock];
    }
    [pool release];
}

- (void)stopSendingChatMessage {
    [self stopSendDataToServer];
}

//接收socket收到的发送反馈
- (void)chatMessageSendResultReceived:(DEYSocketMessageSendDataResult *)message
{
    if (message == nil) {
        return;
    }
    DEYChatMessage * chatMessage = nil;
    [arrCondition lock];
    if ([waitForSendArr count] > 0) {
        chatMessage  = [waitForSendArr objectAtIndex:0];
    }
    [arrCondition unlock];
    if (chatMessage == nil) {
        return;
    }
    if (message.errCode == 0) {
        chatMessage.state = eMessageStateSended;
    }else if(message.errCode == 1){
        chatMessage.state = eMessageStateGroupDismiss;
    }else if(message.errCode == 2){
        chatMessage.state = eMessageStateShotOffGroup;
    }
    chatMessage.strServerMsgId = message.chatId;
    [[DEYMessageDBManager shareDBManager] saveChatMessages:chatMessage byUserID:_userID];
    [sendDataCondition lock];
    [sendDataCondition signal];
    [sendDataCondition unlock];
    
    DEBUGLOG(@"信息反馈：%d,%@,%@",chatMessage.state,chatMessage.strLocalMsgId,chatMessage.strServerMsgId);
    
}

//接收socket收到的数据
- (void)chatMessageReceived:(DEYSocketMessage *)chatMessage
{
    DEYSocketMessageChatPublish *chatMsgPublish = (DEYSocketMessageChatPublish *) chatMessage;
    
    int iCount = [chatMsgPublish.chatDataArray count];
    for (int i = 0; i < iCount; i++) {
        DEYChatMessage *message = [chatMsgPublish.chatDataArray objectAtIndex:i];
        if (message.strLocalMsgId == nil || [message.strLocalMsgId isEqualToString:@""]) {
            message.strLocalMsgId = [[self class] dateToString:[NSDate date] ByFormatter:@"yyyyMMddHHmmssSSS"];
        }
        message.state = eMessageStateReceive;
        
        // Network -> DB -> View
        // save to DB
        DEYHandleReceiveMessageOperation * op = [[DEYHandleReceiveMessageOperation alloc] initwithMessage:message byUserId:_userID];
        [receiveQueue addOperation:op];
        [op release];
        
        if (_delegate && [_delegate respondsToSelector:@selector(managerDidReceiveData:)]) {
            [_delegate managerDidReceiveData:message];
        }
        
        if (_viewdelegate && [_viewdelegate respondsToSelector:@selector(noticeChatMainViewReceivedMessage:)]) {
            [_viewdelegate noticeChatMainViewReceivedMessage:message];
        }
    }
    [[DEYSocketClient sharedSocketClient] writeChatMessageFeedback:chatMessage];    //暂时认为收到的都是对的，以后得区分前台插入是否成功
    if (_viewdelegate && [_viewdelegate respondsToSelector:@selector(noticeChatMainViewToUpdateUnreadMsg:)]) {
        [_viewdelegate noticeChatMainViewToUpdateUnreadMsg:chatMsgPublish.chatDataArray];
    }
    
}

#pragma mark - API for View
- (void)startReceiveChatMessage:(int)userID {
    _userID = userID;
    if (isChating) {
        return;
    }
    
    //启动socket接受消息
    isChating = [[DEYSocketClient sharedSocketClient] startReceiveChatStatus];

}

- (void)stopReceiveChatMessage
{
    if (!isChating) {
        return;
    }
    _userID = -1;
    isChating = NO;
    //结束发送线程
    [self stopSendDataToServer];
    //结束socket接受消息
    [[DEYSocketClient sharedSocketClient] stopReceiveChatStatus];
    
}

- (void)sendChatMessage:(DEYChatMessage *)message {
    if (message == nil) {
        return;
    }
    
    [[DEYMessageDBManager shareDBManager] saveChatMessages:message byUserID:_userID];
    [arrCondition lock];
    [waitForSendArr addObject:message];
    [arrCondition signal];
    [arrCondition unlock];
}

- (NSArray *) getGroupHistoryMessages:(NSString *) ChatRoomID fromMsgID:(NSString *) msgID ByTotalNum:(NSInteger) count {
    if (ChatRoomID == nil || msgID == nil) {
        return nil;
    }
    if (count <= 0) {
        return nil;
    }
    return [[DEYMessageDBManager shareDBManager] getChatMessage:ChatRoomID
                                                      fromMsgID:[msgID longLongValue]
                                                     withUserID:_userID
                                                  byTotalNumber:count
                                                       chatType:eChatTypeGroup];
}

- (NSArray *) getP2PHistoryMessages:(NSString *) ChatRoomID fromMsgID:(NSString *) msgID ByTotalNum:(NSInteger) count {
    if (ChatRoomID == nil || msgID == nil) {
        return nil;
    }
    if (count <= 0) {
        return nil;
    }
    return [[DEYMessageDBManager shareDBManager] getChatMessage:ChatRoomID
                                                      fromMsgID:[msgID longLongValue]
                                                     withUserID:_userID
                                                  byTotalNumber:count
                                                       chatType:eChatTypeP2P];
}

- (NSArray *) getGroupLatestMessages:(NSString *) ChatRoomID ByTotalNum:(NSInteger) count {
    if (ChatRoomID == nil) {
        return nil;
    }
    if (count <= 0) {
        return nil;
    }
    return [[DEYMessageDBManager shareDBManager] getTheLatestChatMessage:ChatRoomID
                                                                withUser:_userID
                                                           byTotalnumber:count
                                                                chatType:eChatTypeGroup];
}
- (NSArray *) getP2PLatestMessages:(NSString *) ChatRoomID ByTotalNum:(NSInteger) count {
    if (ChatRoomID == nil) {
        return nil;
    }
    if (count <= 0) {
        return nil;
    }
    return [[DEYMessageDBManager shareDBManager] getTheLatestChatMessage:ChatRoomID
                                                                withUser:_userID
                                                           byTotalnumber:count
                                                                chatType:eChatTypeP2P];
}

- (void) deleteP2PMsgFrom:(NSString *) ChatRoomID withUserID:(NSString *) UserId {
    if (ChatRoomID == nil || UserId == nil) {
        return;
    }
    [[DEYMessageDBManager shareDBManager] deleteMsgFrom:ChatRoomID withUserID:[UserId intValue] byChatType:eChatTypeP2P];
}
- (void) deleteGroupMsgFrom:(NSString *) ChatRoomID withUserID:(NSString *) UserId {
    if (ChatRoomID == nil || UserId == nil) {
        return;
    }
    [[DEYMessageDBManager shareDBManager] deleteMsgFrom:ChatRoomID withUserID:[UserId intValue] byChatType:eChatTypeGroup];
}

@end