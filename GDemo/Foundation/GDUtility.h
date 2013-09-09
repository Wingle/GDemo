//
//  GDUtility.h
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _ImgReproducePlan{
    kImgReproduceForUserHeadIcon=1,
    kImgReproducePlanFullScreen
}ImgReproducePlan;

@interface GDUtility : NSObject

+ (void)saveImage:(UIImage*)image imageKey:(NSString *) key;
+ (UIImage *)loadImageForKey:(NSString *) key;

+ (NSString *) getHeadImageDownLoadStringUrl:(NSInteger) userid;
+ (NSString *) getWeiboImageDownLoadStringUrl:(NSInteger) newsid;
+ (NSString *)date:(NSDate *) time ByFormatter:(NSString*)strTimeFormatter;
+ (NSString *)dateToString:(NSDate *) date ByFormatter:(NSString*)strTimeFormatter;

+ (UIImage *)reproduceImage:(UIImage *)originImg for:(ImgReproducePlan)reproducePlan;
@end
