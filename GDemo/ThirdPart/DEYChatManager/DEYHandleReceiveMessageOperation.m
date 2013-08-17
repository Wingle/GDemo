//
//  DEYHandleReceiveMessageOperation.m
//  DEYSocketClientTest
//
//  Created by Wingle Wong on 12/12/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import "DEYHandleReceiveMessageOperation.h"
#import "DEYMessageDBManager.h"

@implementation DEYHandleReceiveMessageOperation
@synthesize chatMessage;

- (void)main
{
    [[DEYMessageDBManager shareDBManager] saveChatMessages:chatMessage byUserID:_userId];
}

- (id)initwithMessage:(DEYChatMessage *)message byUserId:(int) userID {
    if (self = [super init]) {
        self.chatMessage = message;
        _userId = userID;
    }
    return self;
}

- (void)dealloc
{
    [chatMessage release];
    [super dealloc];
}

@end
