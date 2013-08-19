//
//  FriendViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/16/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "FriendViewController.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "FriendsCellView.h"
#import "GDUserInfo.h"
#import "GDUserInfoViewController.h"
#import "CCRGlobalConf.h"


#define CELL_TAG        2013081611

@interface FriendViewController ()
@property (nonatomic, retain) NSMutableArray *dataSource;

@end

@implementation FriendViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud showWhileExecuting:@selector(requestNetWork) onTarget:self withObject:nil animated:YES];
    [self.view addSubview:hud];
    [hud release];
    hud = nil;
    
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
//    usrinfo.relationship = kRelationshipStranger;
//    usrinfo1.imagestringURL = @"http://farm4.static.flickr.com/3524/4018550718_c4f43a83d0_s.jpg";
//    [self.dataSource addObject:usrinfo1];
//    [usrinfo1 release];
//    usrinfo1 = nil;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [_dataSource release];
    [super dealloc];
}

#pragma mark - 
- (void) requestNetWork {
    NSString *strURL = nil;
    if (self.type == kFriendViewController) {
        strURL = [NSString stringWithFormat:@"%@/friends.do?userId=%d&type=0",CR_REQUEST_URL,CCRConf.userId];
    }else if (self.type == kNearByViewControoler) {
        strURL = [NSString stringWithFormat:@"%@/search.do?userId=%d&lat=%.6f&lng=%.6f",CR_REQUEST_URL,CCRConf.userId,CCRConf.myLocation.coordinate.latitude,CCRConf.myLocation.coordinate.longitude];
    }
    NSURL *URL = [NSURL URLWithString:strURL];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setTimeOutSeconds:5];
    request.delegate = self;
    [request startSynchronous];
   
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        FriendsCellView *cellView = [FriendsCellView cellView];
        cellView.tag = CELL_TAG;
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cellView.frame.size.height);
        [cell.contentView addSubview:cellView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    FriendsCellView *fView = (FriendsCellView *) [cell.contentView viewWithTag:CELL_TAG];
    GDUserInfo *userInfo = [self.dataSource objectAtIndex:[indexPath row]];
    NSString *url = userInfo.imagestringURL;
    [fView.imgBtn setImageURL:[NSURL URLWithString:url]];
    [fView.nameLabel setText:userInfo.nickName];
    [fView.areaLabel setText:userInfo.stringArea];
    [fView.gameLabel setText:userInfo.stringgameServer];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDUserInfo *userInfo = [self.dataSource objectAtIndex:[indexPath row]];
    GDUserInfoViewController *vc = [[GDUserInfoViewController alloc] initWithNibName:@"GDUserInfoViewController" bundle:nil];
    vc.userInfo = userInfo;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    vc = nil;
}

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
        usrinfo.imagestringURL = @"http://farm4.static.flickr.com/3488/4020067072_7c60a7a60a_s.jpg";
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
