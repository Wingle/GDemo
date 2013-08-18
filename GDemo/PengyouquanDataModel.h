//
//  PengyouquanDataModel.h
//  GDemo
//
//  Created by Wingle Wong on 8/16/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PengyouquanDataModel : NSObject
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger newsID;
@property (nonatomic, retain) NSString *userNickName;
@property (nonatomic, retain) NSString *contentText;
@property (nonatomic, retain) NSString *contentImgURL;
@property (nonatomic, retain) NSDate *newsDate;
@property (nonatomic, assign) NSInteger newsType;
@property (nonatomic, retain) UIImage *contentImg;

@property (nonatomic, retain) NSString *stringURLForUser;

//- (NSString *) stringURLForUser;


@end
