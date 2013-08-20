//
//  ApplyAgreeViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/17/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "ApplyAgreeViewController.h"
#import "ApplyAgreeCellView.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "CCRGlobalConf.h"

#define CELL_TAG        2130811001
#define APPLY_AGREE     2013081801
#define APPLY_DISAGREE  2013081802

@interface ApplyAgreeViewController ()
@property (nonatomic, retain) NSMutableArray *dataSource;

- (void) handleUser:(GDUserInfo *)userInfo ActionToAgreeOrDissagreeType:(NSString *) type;

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
//    GDUserInfo *usrinfo = [[GDUserInfo alloc] init];
//    usrinfo.nickName = @"任志强";
//    usrinfo.gender = 0;
//    usrinfo.area = 2;
//    usrinfo.gameServer = 3;
//    usrinfo.relationship = kRelationshipFriends;
//    usrinfo.imagestringURL = @"http://farm4.static.flickr.com/3488/4020067072_7c60a7a60a_s.jpg";
//    usrinfo.userSign = @"我爱潘石屹";
//    [self.dataSource addObject:usrinfo];
//    [usrinfo release];
//    usrinfo = nil;
//    
//    GDUserInfo *usrinfo1 = [[GDUserInfo alloc] init];
//    usrinfo1.nickName = @"潘石屹";
//    usrinfo1.userSign = @"任志强不要乱爱我，我已经有老婆了";
//    usrinfo1.gender = 0;
//    usrinfo1.area = 3;
//    usrinfo1.gameServer = 2;
//    usrinfo1.relationship = kRelationshipStranger;
//    usrinfo1.imagestringURL = @"http://farm4.static.flickr.com/3524/4018550718_c4f43a83d0_s.jpg";
//    [self.dataSource addObject:usrinfo1];
//    [usrinfo1 release];
//    usrinfo1 = nil;
//    
//    GDUserInfo *usrinfo2 = [[GDUserInfo alloc] init];
//    usrinfo2.nickName = @"李开复";
//    usrinfo2.userSign = @"任志强不要乱爱我，我已经有老婆了";
//    usrinfo2.gender = 0;
//    usrinfo2.area = 3;
//    usrinfo2.gameServer = 2;
//    usrinfo2.relationship = kRelationshipStranger;
//    usrinfo2.imagestringURL = @"http://farm4.static.flickr.com/3524/4018550718_c4f43a83d0_s.jpg";
//    [self.dataSource addObject:usrinfo2];
//    [usrinfo2 release];
//    usrinfo2 = nil;
//    
//    GDUserInfo *usrinfo3 = [[GDUserInfo alloc] init];
//    usrinfo3.nickName = @"罗永浩";
//    usrinfo3.userSign = @"任志强不要乱爱我，我已经有老婆了";
//    usrinfo3.gender = 0;
//    usrinfo3.area = 3;
//    usrinfo3.gameServer = 2;
//    usrinfo3.relationship = kRelationshipStranger;
//    usrinfo3.imagestringURL = @"http://farm4.static.flickr.com/3524/4018550718_c4f43a83d0_s.jpg";
//    [self.dataSource addObject:usrinfo3];
//    [usrinfo3 release];
//    usrinfo3 = nil;
//    
//    [self.tableView reloadData];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud showWhileExecuting:@selector(requestNetWork) onTarget:self withObject:nil animated:YES];
    [self.view addSubview:hud];
    [hud release];
    hud = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void) requestNetWork {
    NSString *strURL = [NSString stringWithFormat:@"%@/friends.do?userId=%d&type=1",CR_REQUEST_URL,CCRConf.userId];
    NSURL *URL = [NSURL URLWithString:strURL];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setTimeOutSeconds:5];
    request.delegate = self;
    [request startSynchronous];
    
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
        ApplyAgreeCellView *viewCell = [ApplyAgreeCellView cellView];
        viewCell.tag = CELL_TAG;
        [cell.contentView addSubview:viewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    GDUserInfo *userinfo = [self.dataSource objectAtIndex:[indexPath row]];
    ApplyAgreeCellView *viewCell = (ApplyAgreeCellView *) [cell.contentView viewWithTag:CELL_TAG];
    viewCell.delegate = self;
    [viewCell setUserInfo:userinfo withIndexPath:indexPath];
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, viewCell.frame.size.height);
    
    
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

#pragma mark - user action
- (void) handleUser:(GDUserInfo *)userInfo ActionToAgreeOrDissagreeType:(NSString *) type {
    NSString *strURL = [NSString stringWithFormat:@"%@/concern.do?userId=%d&friendId=%d&type=%@",CR_REQUEST_URL,CCRConf.userId,userInfo.userID,type];
    NSURL *URL = [NSURL URLWithString:strURL];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    request.tag = APPLY_AGREE;
    [request setTimeOutSeconds:5];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *string = [request responseString];
        NSMutableDictionary * dataDict = [string JSONValue];
        NSInteger status = [[dataDict objectForKey:@"status"] integerValue];
        if (status != 0) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"亲，出错了"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alter show];
            [alter release];
            alter = nil;
            return;
        }
        [self.dataSource removeObject:userInfo];
        [self.tableView reloadData];
        return;
        
    }
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"亲，网络不通哦"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alter show];
    [alter release];
    alter = nil;
    return;
    
}


#pragma mark - 
- (void)agreeUser:(GDUserInfo *) user {
    GDUserInfo *userinfo = [user retain];
    NSLog(@"agree, %@",userinfo.nickName);
    [self handleUser:userinfo ActionToAgreeOrDissagreeType:[NSString stringWithFormat:@"%d",0]];
    [userinfo release];
    userinfo = nil;
    
}

- (void)disagreeUser:(GDUserInfo *) user {
    NSLog(@"disagree, %@",user.nickName);
    GDUserInfo *userinfo = [user retain];
    [self handleUser:userinfo ActionToAgreeOrDissagreeType:[NSString stringWithFormat:@"%d",2]];
    [userinfo release];
    userinfo = nil;
}

#pragma mark - ASIHttp---
#pragma mark - ASIHttp---
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *string = [request responseString];
    NSMutableDictionary * dataDict = [string JSONValue];
    NSInteger status = [[dataDict objectForKey:@"status"] integerValue];
    if (status != 0) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"亲，出错了"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alter show];
        [alter release];
        alter = nil;
        return;
    }
    
    NSArray *friends = [dataDict objectForKey:@"friends"];
    for (int i = 0; i < [friends count]; i ++) {
        NSDictionary *friend = [friends objectAtIndex:i];
        GDUserInfo *usrinfo = [[GDUserInfo alloc] init];
        usrinfo.userID = [[friend objectForKey:@"userId"] integerValue];
        usrinfo.nickName = [friend objectForKey:@"name"];
        usrinfo.gender = [[friend objectForKey:@"gender"] integerValue];
        usrinfo.area = [[friend objectForKey:@"address"] integerValue];
        usrinfo.gameServer = [[friend objectForKey:@"gameServer"] integerValue];
        usrinfo.userCode = [friend objectForKey:@"seq"];
        usrinfo.userSign = [friend objectForKey:@"signature"];
        usrinfo.userContact = [friend objectForKey:@"contact"];
        //        usrinfo.relationship = self.relation;
        usrinfo.imagestringURL = [GDUtility getHeadImageDownLoadStringUrl:usrinfo.userID];
        [self.dataSource addObject:usrinfo];
        [usrinfo release];
        usrinfo = nil;
    }
    if ([self.dataSource count]) {
        [self.tableView reloadData];
    }
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"亲，网络不通哦"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alter show];
    [alter release];
    alter = nil;
    return;
    
}


@end
