//
//  V2FirstViewController.m
//  GDemo
//
//  Created by Wingle Wong on 9/18/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "V2FirstViewController.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "FriendsCellView.h"
#import "GDUserInfo.h"
#import "GDUserInfoViewController.h"
#import "CCRGlobalConf.h"
#import "FriendViewController.h"

#define CELL_TAG        2013081611

@implementation GDGroupInfo

- (void) dealloc {
    [_groupName release];
    [_groupFounder release];
    [super dealloc];
}

@end

@interface V2FirstViewController ()
@property (nonatomic, retain) NSMutableArray *peopleDataSource;
@property (nonatomic, retain) NSMutableArray *groupDataSource;

@end

@implementation V2FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _peopleDataSource = [[NSMutableArray alloc] initWithCapacity:0];
        _groupDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.segmentController addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    GDGroupInfo *group1 = [[[GDGroupInfo alloc] init] autorelease];
    group1.groupFounder = @"陈崐";
    group1.groupName = @"附近群1";
    group1.memberCount = 29;
    [self.groupDataSource addObject:group1];
    
    GDGroupInfo *group2 = [[[GDGroupInfo alloc] init] autorelease];
    group2.groupFounder = @"方钦";
    group2.groupName = @"附近群2";
    group2.memberCount = 19;
    [self.groupDataSource addObject:group2];
    
    GDGroupInfo *group3 = [[[GDGroupInfo alloc] init] autorelease];
    group3.groupFounder = @"黄允明";
    group3.groupName = @"附近群3";
    group3.memberCount = 15;
    [self.groupDataSource addObject:group3];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud showWhileExecuting:@selector(requestNetWork) onTarget:self withObject:nil animated:YES];
    [self.view addSubview:hud];
    [hud release];
    hud = nil;
    
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_segmentController release];
    [_tableView release];
    [_groupDataSource release];
    [_peopleDataSource release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSegmentController:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
#pragma mark -
#pragma mark -
- (void) requestNetWork {
    NSString *strURL = [NSString stringWithFormat:@"%@/search.do?userId=%d&lat=%.6f&lng=%.6f",CR_REQUEST_URL,CCRConf.userId,CCRConf.myLocation.coordinate.latitude,CCRConf.myLocation.coordinate.longitude];
    NSURL *URL = [NSURL URLWithString:strURL];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setTimeOutSeconds:5];
    request.delegate = self;
    [request startSynchronous];
    
}

- (void) segmentChanged:(UISegmentedControl *) segment {
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
        {
            [self.tableView reloadData];
            break;
        }
        case 1:
        {
            [self.tableView reloadData];
            break;
        }    
        default:
            break;
    }
}

#pragma mark tableView delegte -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger tag = self.segmentController.selectedSegmentIndex;
    NSInteger rows = 0;
    switch (tag) {
        case 0:
            rows = [self.peopleDataSource count];
            break;
        case 1:
            rows = [self.groupDataSource count];
        default:
            break;
    }
    return rows;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentController.selectedSegmentIndex == 0) {
        return 70.0;
    }else {
        return 52.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger tag = self.segmentController.selectedSegmentIndex;
    if (tag == 0) {
        static NSString *peopleCellIdentifier = @"peopleCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:peopleCellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:peopleCellIdentifier] autorelease];
            FriendsCellView *cellView = [FriendsCellView cellView];
            cellView.tag = CELL_TAG;
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cellView.frame.size.height);
            [cell.contentView addSubview:cellView];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        // Configure the cell...
        FriendsCellView *fView = (FriendsCellView *) [cell.contentView viewWithTag:CELL_TAG];
        GDNearByUserInfo *userInfo = [self.peopleDataSource objectAtIndex:[indexPath row]];
        fView.gameLabel.hidden = YES;
        fView.distanceLabel.hidden = NO;
        NSString *url = userInfo.imagestringURL;
        fView.imgBtn.placeholderImage = [UIImage imageNamed:@"headDefault"];
        [fView.imgBtn setImageURL:[NSURL URLWithString:url]];
        [fView.nameLabel setText:userInfo.nickName];
        [fView.areaLabel setText:userInfo.stringArea];
        [fView.gameLabel setText:userInfo.stringgameServer];
        CLLocationDistance distance = [userInfo.location distanceFromLocation:CCRConf.myLocation];
        NSString *strDis = nil;
        if (distance <= 1000.0) {
            strDis = [NSString stringWithFormat:@"相距%d米以内",(int)distance];
        }else {
            strDis = [NSString stringWithFormat:@"相距%d公里以内",(int)distance/1000+1];
        }
        fView.distanceLabel.text = strDis;
        return cell;
    }
    static NSString *groupCellIdentifier = @"groupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:groupCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:groupCellIdentifier];
    }
    
    GDGroupInfo *groupInfo = [self.groupDataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = groupInfo.groupName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"群主:%@      群人数:%d",groupInfo.groupFounder,groupInfo.memberCount];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.segmentController.selectedSegmentIndex == 0) {
        GDUserInfo *userInfo = [self.peopleDataSource objectAtIndex:[indexPath row]];
        GDUserInfoViewController *vc = [[GDUserInfoViewController alloc] initWithNibName:@"GDUserInfoViewController" bundle:nil];
        vc.userInfo = userInfo;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
        vc = nil;
    }
    
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
        GDNearByUserInfo *usrinfo = [[GDNearByUserInfo alloc] init];
        usrinfo.userID = [[friend objectForKey:@"userId"] integerValue];
        usrinfo.nickName = [friend objectForKey:@"name"];
        usrinfo.gender = [[friend objectForKey:@"gender"] integerValue];
        usrinfo.area = [[friend objectForKey:@"address"] integerValue];
        usrinfo.gameServer = [[friend objectForKey:@"gameServer"] integerValue];
        usrinfo.userCode = [friend objectForKey:@"seq"];
        usrinfo.userSign = [friend objectForKey:@"signature"];
        usrinfo.userContact = [friend objectForKey:@"contact"];
        NSInteger relation = [[friend objectForKey:@"relation"] integerValue];
        if (relation == 0) {
            usrinfo.relationship = kRelationshipFriends;
        }else {
            usrinfo.relationship = kRelationshipStranger;
        }
        usrinfo.imagestringURL = [GDUtility getHeadImageDownLoadStringUrl:usrinfo.userID];
        usrinfo.location = [[CLLocation alloc] initWithLatitude:39.0121 longitude:120.0211];
        double lat = [[friend objectForKey:@"lat"] doubleValue];
        double lng = [[friend objectForKey:@"lng"] doubleValue];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        usrinfo.location = loc;
        [loc release];
        loc = nil;
        [self.peopleDataSource addObject:usrinfo];
        [usrinfo release];
        usrinfo = nil;
    }
    if ([self.peopleDataSource count]) {
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
