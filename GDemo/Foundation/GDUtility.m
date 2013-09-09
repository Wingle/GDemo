//
//  GDUtility.m
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "GDUtility.h"
#define Min_Head_Icon_Edge 60
#define Min_Img_Short_Edge 320
#define Max_Img_Short_Edge 480

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

#pragma mark -
#pragma mark img reproduce
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)reproduceImage:(UIImage *)originImg for:(ImgReproducePlan)reproducePlan{
    if (originImg==nil) {
        return nil;
    }
    LOG(@"originImg.size.width : %f ; originImg.size.height: %f",originImg.size.width,originImg.size.height);
    LOG(@"UIImagePNGRepresentation(contentData.contentPhoto).length : %d",UIImagePNGRepresentation(originImg).length);
    float edgeMinLength = Min_Img_Short_Edge;
    float edgeMaxLength = Max_Img_Short_Edge;
    if (reproducePlan==kImgReproduceForUserHeadIcon){
        edgeMinLength = Min_Head_Icon_Edge;
        edgeMaxLength = Min_Head_Icon_Edge;
    }
    CGSize newSize;
    float scaleFactor = 1;
    if (originImg.size.width>originImg.size.height) {
        if (originImg.size.height>edgeMaxLength) {
            scaleFactor = edgeMaxLength/originImg.size.height;
        }
        else if(originImg.size.height<edgeMinLength){
            scaleFactor = edgeMinLength/originImg.size.height;
        }
    }
    else{
        if (originImg.size.width>edgeMaxLength) {
            scaleFactor = edgeMaxLength/originImg.size.width;
        }
        else if(originImg.size.width<edgeMinLength){
            scaleFactor = edgeMinLength/originImg.size.width;
        }
    }
    newSize = CGSizeMake(originImg.size.width*scaleFactor, originImg.size.height*scaleFactor);
    if (scaleFactor==1) {
        return originImg;
    }
    UIImage * newImage = [[self class] imageWithImage:originImg scaledToSize:newSize];
    LOG(@"newImage.size.width : %f ; newImage.size.height: %f",newImage.size.width,newImage.size.height);
    LOG(@"UIImagePNGRepresentation(newImage).length : %d",UIImagePNGRepresentation(newImage).length);
    return newImage;
}



@end
