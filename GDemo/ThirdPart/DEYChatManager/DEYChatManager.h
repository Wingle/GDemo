//
//  DEYChatManager.h
//  DEYSocketClientTest
//
//  Created by Wingle Wong on 12/7/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEYChatContext.h"

@class DEYChatMessage;
@class DEYUnreadMessageInfo;
@class DEYSocketMessageSendDataResult;

#pragma mark - DEYChatForMainViewDelegate
@protocol DEYChatForMainViewDelegate <NSObject>

// notice the main view list there is a new message received.
- (void) noticeChatMainViewReceivedMessage:(DEYChatMessage *) data;

@optional
- (void) noticeChatMainViewToUpdateUnreadMsg:(NSArray *) mesaages;

@end

#pragma mark - ChatManagerDelegate
@protocol DEYChatManagerDelegate <NSObject>

// send or receive delegate
- (void) managerDidReceiveData:(DEYChatMessage *) data;
- (void) managerDidSendDataSuccess:(DEYChatMessage *) data;
- (void) managerDidSendDataFailed:(DEYChatMessage *) data;

@optional
// load date from server delegate
- (void) managerBegainLoadDataFromServer;
- (void) managerEndLoadDataFromServer;
- (void) managerFaildLoadDataFromServer;

// unread message
- (void) managerReceiveUnreadMessages:(NSArray *) unreadmessages;

@end

#pragma mark - DEYChatManager
@interface DEYChatManager : NSObject <DEYChatContextDelegate> {
    id<DEYChatManagerDelegate> _delegate;
    id<DEYChatForMainViewDelegate> _viewdelegate;
    NSMutableArray *waitForSendArr;
    
    NSOperationQueue  *receiveQueue;
    
    //新增的属性
    NSCondition * arrCondition;     //待发送数组锁
    NSCondition * sendDataCondition;//发送锁
    NSTimer * timeOutTimer;         //超时Timer
    BOOL isChating;
    BOOL bRun;                      //发送线程是否工作
    
    BOOL _canStartReceiveMsg;
    
    int _userID;
    
}
@property(retain) NSMutableArray * waitForSendArr;
@property(nonatomic,assign) id<DEYChatManagerDelegate> delegate;
@property(nonatomic,assign) id<DEYChatForMainViewDelegate> viewdelegate;
@property(nonatomic,retain) NSOperationQueue  *receiveQueue;

+ (DEYChatManager *)shareChatManager;

+ (NSString *)dateToString:(NSDate *) date ByFormatter:(NSString*)strTimeFormatter;

#pragma mark - API for View
//开始聊天功能
- (void)startReceiveChatMessage:(int)userID;

//退出聊天功能
- (void)stopReceiveChatMessage;

//发送数据时调用
- (void)sendChatMessage:(DEYChatMessage *)message;

// 获取历史信息记录调用
- (NSArray *) getGroupHistoryMessages:(NSString *) ChatRoomID fromMsgID:(NSString *) msgID ByTotalNum:(NSInteger) count;
- (NSArray *) getP2PHistoryMessages:(NSString *) ChatRoomID fromMsgID:(NSString *) msgID ByTotalNum:(NSInteger) count;

- (NSArray *) getGroupLatestMessages:(NSString *) ChatRoomID ByTotalNum:(NSInteger) count;
- (NSArray *) getP2PLatestMessages:(NSString *) ChatRoomID ByTotalNum:(NSInteger) count;

- (void) deleteP2PMsgFrom:(NSString *) ChatRoomID withUserID:(NSString *) UserId;
- (void) deleteGroupMsgFrom:(NSString *) ChatRoomID withUserID:(NSString *) UserId;

@end
