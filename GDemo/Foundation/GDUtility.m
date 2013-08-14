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
    NSString  *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    NSString *imagePath = [docPath stringByAppendingFormat:@"%@_image.png",key];
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

@end
