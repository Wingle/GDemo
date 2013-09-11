//
//  ThirdViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/15/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "ThirdViewController.h"
#import "CCRGlobalConf.h"
#import "PengyouquanDataModel.h"
#import "PengyouqunCellView.h"
#import "TextCell.h"
#import "PhotoCell.h"
#import "DistrubiteViewController.h"
#import "SBJson.h"

#define IMG_TAG         2012081501
#define NAME_TAG        2012081502

#define CELL_TAG        2013081601
#define CELL_CONTENT_LABEL          2013081602
#define CELL_CONTENT_IMGVIEW        2013081603

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *str = @"主页";
        self.title = str;
        self.tabBarItem.image = [UIImage imageNamed:@"third"];
        self.tabBarItem.title = str;
        
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
        self.navigationItem.rightBarButtonItem = barBtnItem;
        [barBtnItem release];
        barBtnItem = nil;
        
    }
    return self;
}

- (void)viewDidLoad
{
//    http://localhost:8080/demo/weiboList.do?userId=1&id=0
    NSString *format = [NSString stringWithFormat:@"%@/weiboList.do?userId=%d&id=0",
                        CR_REQUEST_URL,CCRConf.userId];
    format = [format stringByAppendingString:@"&pageIndex=%d&pageSize=%d"];
    [self setRequestFormat:format requestMoreBy:RequestMoreByPageFromPage];
    self.numberOfDataPerPage = 20;
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
	// Do any additional setup after loading the view.
//    self.imgBtn.placeholderImage = [UIImage imageNamed:@"headDefault"];
//    if (CCRConf.image) {
//        [self.imgBtn setImage:CCRConf.image forState:UIControlStateNormal];
//    }else {
//        [self.imgBtn setImageURL:[NSURL URLWithString:[GDUtility getHeadImageDownLoadStringUrl:CCRConf.userId]]];
//    }
    self.imgView.placeholderImage = [UIImage imageNamed:@"headDefault"];
    [self.imgView setImageURL:[NSURL URLWithString:[GDUtility getHeadImageDownLoadStringUrl:CCRConf.userId]]];
    [self.nameLabel setText:CCRConf.nickName];
    
    self.tableView.tableHeaderView = self.headView;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.allowsSelection = NO;
    self.tableView.separatorColor = [UIColor colorWithRed:228.0/255 green:228.0/255 blue:228.0/255 alpha:1];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.imgBtn setImage:CCRConf.image forState:UIControlStateNormal];
    [self.nameLabel setText:CCRConf.nickName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (IBAction)nextStep:(id)sender {
    DistrubiteViewController *distrubite = [[DistrubiteViewController alloc] initWithNibName:@"DistrubiteViewController" bundle:nil];
    distrubite.delegate = self;
    UINavigationController *navContr = [[UINavigationController alloc] initWithRootViewController:distrubite];
    [self presentModalViewController:navContr animated:YES];
    [distrubite release];
    distrubite = nil;
    [navContr release];
    navContr = nil;
    
    
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PengyouquanDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
    CGSize size = [model.contentText sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(236.0, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat apal = size.height - 21.0;
    if (model.newsType == 0) {
        return MAX(78.0+apal, 78.0);
    }else if (model.newsType == 1) {
        return 170.0;
    }else {
        return MAX(206.0+apal, 206.0);
    }
    
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows = [self.dataArray count];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *TextCellId = @"TextCell";
    static NSString *PhotoCellId = @"PhotoCell";
    
    PengyouquanDataModel *model = [self.dataArray objectAtIndex:[indexPath row]];
    
    if (model.newsType == 0) {
        TextCell *cell = (TextCell *)[tableView dequeueReusableCellWithIdentifier:TextCellId];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextCell" owner:self options:nil];
            for (NSObject *obj in nib) {
                if ([obj isKindOfClass:[TextCell class]]) {
                    cell = (TextCell *) obj;
                }
            }
        }
        cell.nameLabel.text = model.userNickName;
        cell.headImgBtn.placeholderImage = [UIImage imageNamed:@"headDefault"];
        [cell.headImgBtn setImageURL:[NSURL URLWithString:model.stringURLForUser]];
        
        UILabel *label = cell.contentTextLabel;
        
        CGSize size = [model.contentText sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat apal = size.height - 21.0;
        [cell.contentTextLabel setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, size.height)];
        cell.contentTextLabel.text = model.contentText;
        [cell.newDateLabel setFrame:CGRectMake(cell.newDateLabel.frame.origin.x,
                                                  cell.newDateLabel.frame.origin.y + apal,
                                                  cell.newDateLabel.frame.size.width,
                                                  cell.newDateLabel.frame.size.height)];
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height+apal)];
        
        return cell;
        
    }else if (model.newsType == 1) {
        PhotoCell *cell = (PhotoCell *) [tableView dequeueReusableCellWithIdentifier:PhotoCellId];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:self options:nil];
            for (NSObject *obj in nib) {
                if ([obj isKindOfClass:[PhotoCell class]]) {
                    cell = (PhotoCell *) obj;
                }
            }
        }
        cell.nameLabel.text = model.userNickName;
        cell.headImgBtn.placeholderImage = [UIImage imageNamed:@"headDefault"];
        [cell.headImgBtn setImageURL:[NSURL URLWithString:model.stringURLForUser]];
        if (model.contentImgURL == nil) {
            [cell.contentImgView setImage:model.contentImg];
        }else {
            [cell.contentImgView setImageURL:[NSURL URLWithString:model.contentImgURL]];
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        PengyouqunCellView *msgView = [PengyouqunCellView cellView];
        msgView.tag = CELL_TAG;
        msgView.contentTextLabel.tag = CELL_CONTENT_LABEL;
        msgView.contentImgView.tag = CELL_CONTENT_IMGVIEW;
        [cell.contentView addSubview:msgView];
    }
    
    // Configure the cell...
    PengyouqunCellView *msgView = (PengyouqunCellView *)[cell.contentView viewWithTag:CELL_TAG];
    msgView.headImgBtn.placeholderImage = [UIImage imageNamed:@"headDefault"];
    [msgView.headImgBtn setImageURL:[NSURL URLWithString:model.stringURLForUser]];
    
    [msgView.nameLabel setText:model.userNickName];
    [msgView.contentImgView setFrame:CGRectMake(msgView.contentImgView.frame.origin.x,
                                                58.0,
                                                msgView.contentImgView.frame.size.width,
                                                msgView.contentImgView.frame.size.height)];
    if (model.contentImgURL == nil) {
        [msgView.contentImgView setImage:model.contentImg];
    }else {
        [msgView.contentImgView setImageURL:[NSURL URLWithString:model.contentImgURL]];
    }
    
    [msgView setFrame:CGRectMake(msgView.frame.origin.x, msgView.frame.origin.y, msgView.frame.size.width, 206.0)];
    UILabel *label = msgView.contentTextLabel;
    label.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
    label.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
    [label setBackgroundColor:[UIColor clearColor]];

    //宽度不变，根据字的多少计算label的高度
    CGSize size = [model.contentText sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //根据计算结果重新设置UILabel的尺寸
    CGFloat apal = size.height - 21.0;
    LOG(@"apal = %f",apal);
    [msgView.contentTextLabel setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, size.height)];
    msgView.contentTextLabel.text = model.contentText;
    
    // --imgview gaodu
    
    [msgView.contentImgView setFrame:CGRectMake(msgView.contentImgView.frame.origin.x,
                                                msgView.contentImgView.frame.origin.y + apal,
                                                msgView.contentImgView.frame.size.width,
                                                msgView.contentImgView.frame.size.height)];
    [msgView setFrame:CGRectMake(msgView.frame.origin.x,
                                 msgView.frame.origin.y,
                                 msgView.frame.size.width,
                                 msgView.frame.size.height+ apal)];
    [msgView.newDateLabel setFrame:CGRectMake(msgView.newDateLabel.frame.origin.x,
                                              msgView.contentImgView.frame.origin.y+msgView.contentImgView.frame.size.height,
                                              msgView.newDateLabel.frame.size.width,
                                              msgView.newDateLabel.frame.size.height)];
    [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, msgView.frame.size.height)];
    cell.backgroundColor = [UIColor blueColor];

    
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
    
}

#pragma mark - refrash
- (void)loadDataRequestSuccess:(ASIHTTPRequest *)request {
    [self.dataArray removeAllObjects];
    NSString *string = [request responseString];
    NSLog(@"string = %@",string);
    NSDictionary *dataDic = [string JSONValue];
    NSArray *chats = [dataDic objectForKey:@"chats"];
    for (int i = 0; i < [chats count]; i ++) {
        NSDictionary *message = [chats objectAtIndex:i];
        PengyouquanDataModel *model = [[PengyouquanDataModel alloc] init];
        model.newsID = [[message objectForKey:@"id"] integerValue];
        model.userID = [[message objectForKey:@"userId"] integerValue];
        model.newsType = [[message objectForKey:@"type"] integerValue];
        LOG(@"type = %d",model.newsType);
        model.contentText = [message objectForKey:@"content"];
        model.contentImgURL = [GDUtility getWeiboImageDownLoadStringUrl:model.newsID];
        model.newsDate = [NSDate dateWithTimeIntervalSince1970:[[message objectForKey:@"time"] longLongValue]];
        model.stringURLForUser = [GDUtility getHeadImageDownLoadStringUrl:model.userID];

        NSDictionary *userInfo = [message objectForKey:@"userInfo"];
        if ([[userInfo objectForKey:@"userId"] integerValue] == -1) {
            model.userNickName = CCRConf.nickName;
        }else {
            model.userNickName = [userInfo objectForKey:@"name"];
        }
        [self.dataArray addObject:model];
        [model release];
        model = nil; 
    }
    
}
- (void)loadDataRequestFailed:(ASIHTTPRequest *)request {

}

- (void)dealloc {
    [_headView release];
    [_imgBtn release];
    [_nameLabel release];
    [_imgView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setHeadView:nil];
    [self setImgBtn:nil];
    [self setNameLabel:nil];
    [self setImgView:nil];
    [super viewDidUnload];
}

#pragma mark - 
- (void) FinishedDistrubite:(PengyouquanDataModel *)model {
    PengyouquanDataModel *news = [model retain];
    [self.dataArray insertObject:news atIndex:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    [news release];
    news = nil;
}
@end
