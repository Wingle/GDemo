//
//  DEYHandleReceiveMessageOperation.h
//  DEYSocketClientTest
//
//  Created by Wingle Wong on 12/12/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DEYChatMessage;

@interface DEYHandleReceiveMessageOperation : NSOperation {
    DEYChatMessage * chatMessage;
    int _userId;
}
@property(nonatomic,retain) DEYChatMessage * chatMessage;

- (id)initwithMessage:(DEYChatMessage *)message byUserId:(int) userID;
@end
