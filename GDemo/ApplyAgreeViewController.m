//
//  ApplyAgreeViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/17/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "ApplyAgreeViewController.h"
#import "ApplyAgreeCellView.h"

#define CELL_TAG        2130811001

@interface ApplyAgreeViewController ()
@property (nonatomic, retain) NSMutableArray *dataSource;

@end

@implementation ApplyAgreeViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    GDUserInfo *usrinfo = [[GDUserInfo alloc] init];
    usrinfo.nickName = @"任志强";
    usrinfo.gender = 0;
    usrinfo.area = 2;
    usrinfo.gameServer = 3;
    usrinfo.relationship = kRelationshipFriends;
    usrinfo.imagestringURL = @"http://farm4.static.flickr.com/3488/4020067072_7c60a7a60a_s.jpg";
    usrinfo.userSign = @"我爱潘石屹";
    [self.dataSource addObject:usrinfo];
    [usrinfo release];
    usrinfo = nil;
    
    GDUserInfo *usrinfo1 = [[GDUserInfo alloc] init];
    usrinfo1.nickName = @"潘石屹";
    usrinfo1.userSign = @"任志强不要乱爱我，我已经有老婆了";
    usrinfo1.gender = 0;
    usrinfo1.area = 3;
    usrinfo1.gameServer = 2;
    usrinfo1.relationship = kRelationshipStranger;
    usrinfo1.imagestringURL = @"http://farm4.static.flickr.com/3524/4018550718_c4f43a83d0_s.jpg";
    [self.dataSource addObject:usrinfo1];
    [usrinfo1 release];
    usrinfo1 = nil;
    
    GDUserInfo *usrinfo2 = [[GDUserInfo alloc] init];
    usrinfo2.nickName = @"李开复";
    usrinfo2.userSign = @"任志强不要乱爱我，我已经有老婆了";
    usrinfo2.gender = 0;
    usrinfo2.area = 3;
    usrinfo2.gameServer = 2;
    usrinfo2.relationship = kRelationshipStranger;
    usrinfo2.imagestringURL = @"http://farm4.static.flickr.com/3524/4018550718_c4f43a83d0_s.jpg";
    [self.dataSource addObject:usrinfo2];
    [usrinfo2 release];
    usrinfo2 = nil;
    
    GDUserInfo *usrinfo3 = [[GDUserInfo alloc] init];
    usrinfo3.nickName = @"罗永浩";
    usrinfo3.userSign = @"任志强不要乱爱我，我已经有老婆了";
    usrinfo3.gender = 0;
    usrinfo3.area = 3;
    usrinfo3.gameServer = 2;
    usrinfo3.relationship = kRelationshipStranger;
    usrinfo3.imagestringURL = @"http://farm4.static.flickr.com/3524/4018550718_c4f43a83d0_s.jpg";
    [self.dataSource addObject:usrinfo3];
    [usrinfo3 release];
    usrinfo3 = nil;
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.frame = CGRectZero;
        ApplyAgreeCellView *viewCell = [ApplyAgreeCellView cellView];
        viewCell.tag = CELL_TAG;
        [cell.contentView addSubview:viewCell];
    }
    
    // Configure the cell...
    GDUserInfo *userinfo = [self.dataSource objectAtIndex:[indexPath row]];
    ApplyAgreeCellView *viewCell = (ApplyAgreeCellView *) [cell.contentView viewWithTag:CELL_TAG];
//    viewCell.delegate = self;
//    [viewCell setUserInfo:userinfo withIndexPath:indexPath];
    [viewCell.nameLabel setText:userinfo.nickName];
    [viewCell.imgBtn setImageURL:[NSURL URLWithString:userinfo.imagestringURL]];
//    viewCell.userInfo = userinfo;
    cell.frame = viewCell.frame;
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row=%d",[indexPath row]);
}


#pragma mark - 
- (void)agreeUser:(GDUserInfo *) user {
    NSLog(@"agree, %@",user.nickName);
}
- (void)disagreeUser:(GDUserInfo *) user {
     NSLog(@"disagree, %@",user.nickName);
    
}

@end
