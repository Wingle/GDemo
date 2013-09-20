//
//  GDUserInfo.m
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "GDUserInfo.h"

@implementation GDUserInfo

- (void) dealloc {
    [_imagestringURL release];
    [_nickName release];
    [_userCode release];
    [_userContact release];
    [_userSign release];
    [super dealloc];
}



- (NSString *) strGender {
    if (self.gender == 0) {
        return @"男";
    }else {
        return @"女";
    }
}

- (UIImage *) image {
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imagestringURL]]];
    return img;
}

- (NSString *) stringArea {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"citys.plist"]];
    NSArray *areaArray = [dic objectForKey:@"city"];
    return [areaArray objectAtIndex:self.area];
    
}

- (NSString *) stringgameServer {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"gameServer.plist"]];
    NSArray *gameArray = [dic objectForKey:@"server"];
    return [gameArray objectAtIndex:self.gameServer];
    
}

@end

@implementation GDGroupInfo

- (void) dealloc {
    [_groupName release];
    [_groupFounder release];
    [super dealloc];
}

@end
