//
//  GDUserInfo.h
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDUserInfo : NSObject
@property (nonatomic, retain, readonly) UIImage *image;
@property (nonatomic, retain, readonly) NSString *strGender;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, retain) NSString *nickName;


@end
