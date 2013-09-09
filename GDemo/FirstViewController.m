//
//  FirstViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/17/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "FirstViewController.h"
#import "CCRGlobalConf.h"
#import "GDUserInfo.h"
#import "DEYChatViewController.h"
#import "SBJson.h"
#import "UserInfoCell.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *str = @"消息";
        self.title = str;
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        self.tabBarItem.title = str;
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    NSString *format = [NSString stringWithFormat:@"%@/friends.do?userId=%d&type=0",CR_REQUEST_URL,CCRConf.userId];
    format = [format stringByAppendingString:@"&pageIndex=%d&pageSize=%d"];
    [self setRequestFormat:format requestMoreBy:RequestMoreByPageFromPage];
    self.numberOfDataPerPage = 20;
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.allowsSelection = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserInfoCell";
    UserInfoCell *cell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserInfoCell" owner:self options:nil];
        for (NSObject *obj in nib) {
            if ([obj isKindOfClass:[UserInfoCell class]]) {
                cell = (UserInfoCell *) obj;
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    GDUserInfo *usrinfo = [self.dataArray objectAtIndex:[indexPath row]];
    // Configure the cell...
    cell.imgView.placeholderImage = [UIImage imageNamed:@"headDefault"];
    [cell.imgView setImageURL:[NSURL URLWithString:usrinfo.imagestringURL]];

    cell.nameLabel.text = usrinfo.nickName;
    cell.gameLabel.text = usrinfo.stringgameServer;
    cell.areaLabel.text = usrinfo.stringArea;
    
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
    return 56.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDUserInfo *userinfo = [self.dataArray objectAtIndex:[indexPath row]];
    DEYChatViewController *vc = [[DEYChatViewController alloc] initWithNibName:@"DEYChatViewController" bundle:nil UserID:[NSString stringWithFormat:@"%d",CCRConf.userId] RoomID:[NSString stringWithFormat:@"%d",userinfo.userID] ChatType:eChatTypeP2P];
    vc.title = userinfo.nickName;
    vc.userInfo = userinfo;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    vc = nil;
}

#pragma mark - refrash
- (void)loadDataRequestSuccess:(ASIHTTPRequest *)request {
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
        [self.dataArray addObject:usrinfo];
        [usrinfo release];
        usrinfo = nil;
    }
    if ([self.dataArray count]) {
        [self.tableView reloadData];
    }
    
    
}
- (void)loadDataRequestFailed:(ASIHTTPRequest *)request {

}


@end
