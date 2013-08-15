//
//  FourthViewController.h
//  GDemo
//
//  Created by Wingle Wong on 8/15/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "FillInBlankViewController.h"
#import "SelectViewController.h"

@interface FourthViewController : UITableViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, FillInBlankDelegate, SelectCellDelegate>

@end
