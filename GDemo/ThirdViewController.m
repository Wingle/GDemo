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
#import "DistrubiteViewController.h"

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
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
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
    
    NSString *format = [NSString stringWithFormat:@"%@/dateGroupMembers.do?appId=%@&userId=%d&groupId=%@&groupType=%d&sort=1",
                        CR_REQUEST_URL,
                        APPID,
                        62,
                        @"123",
                        1];
    format = [format stringByAppendingString:@"&pageIndex=%d&pageSize=%d"];
    [self setRequestFormat:format requestMoreBy:RequestMoreByPageFromPage];
    self.numberOfDataPerPage = 20;
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
	// Do any additional setup after loading the view.
    
    [self.imgBtn setImage:CCRConf.image forState:UIControlStateNormal];
    [self.nameLabel setText:CCRConf.nickName];
    
    self.tableView.tableHeaderView = self.headView;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.allowsSelection = NO;

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
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
    NSLog(@"%d",[indexPath row]);
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
    PengyouquanDataModel *model = [self.dataArray objectAtIndex:[indexPath row]];
    PengyouqunCellView *msgView = (PengyouqunCellView *)[cell.contentView viewWithTag:CELL_TAG];
    [msgView.headImgBtn setImageURL:[NSURL URLWithString:model.stringURLForUser]];
    [msgView.nameLabel setText:model.userNickName];
    [msgView.contentImgView setFrame:CGRectMake(msgView.contentImgView.frame.origin.x,
                                                58.0,
                                                msgView.contentImgView.frame.size.width,
                                                msgView.contentImgView.frame.size.height)];
    [msgView.contentImgView setImageURL:[NSURL URLWithString:model.contentImgURL]];
    [msgView setFrame:CGRectMake(msgView.frame.origin.x, msgView.frame.origin.y, msgView.frame.size.width, 206.0)];
    UILabel *label = msgView.contentTextLabel;
    label.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
    label.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
    [label setBackgroundColor:[UIColor clearColor]];

    //宽度不变，根据字的多少计算label的高度
    CGSize size = [model.contentText sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //根据计算结果重新设置UILabel的尺寸
    CGFloat apal = size.height - 21.0;
    NSLog(@"apal = %f",apal);
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
    NSLog(@"kdkd");
    PengyouquanDataModel *model = [[PengyouquanDataModel alloc] init];
    model.newsDate = [NSDate date];
    model.newsID = 100;
    model.newsType = 1;
    model.userID = 62;
    model.userNickName = @"黄允明";
    model.contentText = @"我们成功了！可以更改此内容进行测试，宽度不变，高度根据内容自动调节.真的吗，来吧。快来爆。";
    model.contentImgURL = @"http://farm3.static.flickr.com/2436/4015786038_7b530f9cce_s.jpg";
    model.stringURLForUser = @"http://farm3.static.flickr.com/2643/4020492457_84c4140077_s.jpg";
    
    [self.dataArray addObject:model];
    [model release];
    model = nil;
    
    PengyouquanDataModel *model1 = [[PengyouquanDataModel alloc] init];
    model1.newsDate = [NSDate date];
    model1.newsID = 100;
    model1.newsType = 1;
    model1.userID = 62;
    model1.userNickName = @"潘石屹";
    model1.contentText = @"[李彦宏：百度是一个简单的公司] 什么叫简单，简单就是说话不绕弯子，简单就是上下级之间没有那么多的规矩，层级不那么明显。简单就是没有公司政治，不琢磨那么多乱七八糟的事，直来直去。简单就是你做的产品用户用起来上手很快，不需要学习就会用。14日，李彦宏如上表示。";
    model1.contentImgURL = @"http://farm3.static.flickr.com/2672/4008379269_157e86729e_s.jpg";
    model1.stringURLForUser = @"http://farm3.static.flickr.com/2493/4022863018_6197f81c8d_s.jpg";
    [self.dataArray addObject:model1];
    [model1 release];
    model1 = nil;
    
    PengyouquanDataModel *model2 = [[PengyouquanDataModel alloc] init];
    model2.newsDate = [NSDate date];
    model2.newsID = 100;
    model2.newsType = 1;
    model2.userID = 62;
    model2.userNickName = @"每日经济新闻";
    model2.contentText = @"多位“大佬”缺席互联网大会】马化腾、李彦宏、丁磊、陆兆禧等业界大佬均没有参加今年的互联网大会，忙于修炼“内功”。李彦宏带着刚刚高升的百度副总裁李明远等人南下与91无线签署收购协议，马化腾则在香港推广微信业务，网易刚刚投资了一家游戏开发商北京灵游坊。";
    model2.contentImgURL = @"http://farm3.static.flickr.com/2620/4009289798_bdcf26500a_s.jpg";
    model2.stringURLForUser = @"http://farm3.static.flickr.com/2557/4010652749_1d0c35fabd_s.jpg";
    [self.dataArray addObject:model2];
    [model2 release];
    model2 = nil;
    
}
- (void)loadDataRequestFailed:(ASIHTTPRequest *)request {
    NSLog(@"kkkkkkkkkkkkkk");
    PengyouquanDataModel *model2 = [[PengyouquanDataModel alloc] init];
    model2.newsDate = [NSDate date];
    model2.newsID = 100;
    model2.newsType = 1;
    model2.userID = 62;
    model2.userNickName = @"每日经济新闻";
    model2.contentText = @"多位“大佬”缺席互联网大会】马化腾、李彦宏、丁磊、陆兆禧等业界大佬均没有参加今年的互联网大会，忙于修炼“内功”。李彦宏带着刚刚高升的百度副总裁李明远等人南下与91无线签署收购协议，马化腾则在香港推广微信业务，网易刚刚投资了一家游戏开发商北京灵游坊。";
    model2.contentImgURL = @"http://farm3.static.flickr.com/2620/4009289798_bdcf26500a_s.jpg";
    model2.stringURLForUser = @"http://farm3.static.flickr.com/2557/4010652749_1d0c35fabd_s.jpg";
    [self.dataArray addObject:model2];
    [model2 release];
    model2 = nil;
}

- (void)dealloc {
    [_headView release];
    [_imgBtn release];
    [_nameLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setHeadView:nil];
    [self setImgBtn:nil];
    [self setNameLabel:nil];
    [super viewDidUnload];
}
@end
