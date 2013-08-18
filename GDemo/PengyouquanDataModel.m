//
//  PengyouquanDataModel.m
//  GDemo
//
//  Created by Wingle Wong on 8/16/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "PengyouquanDataModel.h"

@implementation PengyouquanDataModel

- (void) dealloc {
    [_userNickName release];
    [_contentImgURL release];
    [_contentText release];
    [_newsDate release];
    [_contentImg release];
    
    [_stringURLForUser release];
    [super dealloc];
}

//- (NSString *) stringURLForUser {
//    NSString *ulr = [NSString stringWithFormat:@"%d",self.userID];
//    return ulr;
//}

@end
