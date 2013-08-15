//
//  SelectViewController.h
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kLoad_area = 0,
    kLoad_game = 1
}kLoadType;

@protocol SelectCellDelegate <NSObject>
@optional
- (void) didSelectedAreaString:(NSString *) text;
- (void) didSelectedGameString:(NSString *) text;


@end

@interface SelectViewController : UITableViewController
@property (nonatomic, assign) id <SelectCellDelegate> delegate;
@property (nonatomic, assign) kLoadType type;

@end
