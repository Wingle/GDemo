//
//  GDUserInfo.h
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kRelationshipStranger = 0,
    kRelationshipFriends = 1
}GDRelationShip;

@interface GDUserInfo : NSObject
@property (nonatomic, retain) NSString *imagestringURL;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger area;
@property (nonatomic, assign) NSInteger gameServer;
@property (nonatomic, retain) NSString *userContact;
@property (nonatomic, retain) NSString *userCode;
@property (nonatomic, assign) GDRelationShip relationship;
@property (nonatomic, retain) NSString *userSign;

- (NSString *) strGender;
- (NSString *) stringArea;
- (NSString *) stringgameServer;
- (UIImage *) image;



@end
