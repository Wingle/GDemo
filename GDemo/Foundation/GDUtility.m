//
//  GDUtility.m
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "GDUtility.h"

@implementation GDUtility

+ (NSString *) imagePathForKey:(NSString *) key {
    NSString  *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imagePath = [docPath stringByAppendingFormat:@"/%@_image.jpg",key];
    return imagePath;
}

+ (void)saveImage:(UIImage*)image imageKey:(NSString *) key {
    NSString *imagePath = [[self class] imagePathForKey:key];
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    
}

+ (UIImage *)loadImageForKey:(NSString *) key {
    NSString *imagePath = [[self class] imagePathForKey:key];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

+ (NSString *) getHeadImageDownLoadStringUrl:(NSInteger) userid {
    NSString *strURL = [NSString stringWithFormat:@"%@/download.do?id=%d&type=0",CR_REQUEST_URL, userid];
    return strURL;
}

+ (NSString *) getWeiboImageDownLoadStringUrl:(NSInteger) newsid {
    NSString *strURL = [NSString stringWithFormat:@"%@/download.do?id=%d&type=2",CR_REQUEST_URL, newsid];
    return strURL;
}

+ (NSString *)date:(NSDate *) time ByFormatter:(NSString*)strTimeFormatter
{
    NSDateFormatter	* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:strTimeFormatter];
    
    return [formatter stringFromDate:time];
}
+ (NSString *)dateToString:(NSDate *) date ByFormatter:(NSString*)strTimeFormatter {
    NSDateFormatter	* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:strTimeFormatter];
    return [formatter stringFromDate:date];
}

@end
