//
//  ThirdViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/15/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "ThirdViewController.h"
#import "CCRGlobalConf.h"

#define IMG_TAG         2012081501
#define NAME_TAG        2012081502

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSString *str = @"主页";
        self.title = str;
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        self.tabBarItem.title = str;
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *str = @"主页";
        self.title = str;
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        self.tabBarItem.title = str;
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
    UIImageView *headView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
    headView.frame = CGRectMake(0.0, 0.0, 320.0, 120.0);
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:CCRConf.image];
    imgView.frame = CGRectMake(20.0, 40.0, 60.0, 60.0);
    imgView.tag = IMG_TAG;
    [headView addSubview:imgView];
    [imgView release];
    imgView = nil;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 70.0, 120.0, 30.0)];
    nameLabel.tag = NAME_TAG;
    [nameLabel setText:CCRConf.nickName];
    [nameLabel setTextColor:[UIColor whiteColor]];
    nameLabel.backgroundColor = [UIColor clearColor];
    [headView addSubview:nameLabel];
    [nameLabel release];
    nameLabel = nil;
    
    // ---
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 20)];
//    label.font = [UIFont boldSystemFontOfSize:20.0f];  //UILabel的字体大小
//    label.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
//    [label setBackgroundColor:[UIColor redColor]];
//    
//    //宽度不变，根据字的多少计算label的高度
//    NSString *str = @"可以更改此内容进行测试，宽度不变，高度根据内容自动调节.真的吗，来吧。快来爆。";
//    CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//    //根据计算结果重新设置UILabel的尺寸
//    [label setFrame:CGRectMake(0, 10, 200, size.height)];
//    label.text = str;
//    
//    [headView addSubview:label];
//    [label release];
    
    self.tableView.tableHeaderView = headView;
    [headView release];
    headView = nil;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//- (void) viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    for (UIView *view in [self.tableView.tableHeaderView subviews]) {
//        if (view.tag == IMG_TAG) {
//            UIImageView *imgview = (UIImageView *) view;
//            [imgview setImage:CCRConf.image];
//        }else if (view.tag == NAME_TAG) {
//            UILabel *namelabel = (UILabel *) view;
//            [namelabel setText:CCRConf.nickName];
//        }
//    }
//    
//    NSString *format = [NSString stringWithFormat:@"%@/dateGroupMembers.do?appId=%@&userId=%d&groupId=%@&groupType=%d&sort=1",
//                        CR_REQUEST_URL,
//                        APPID,
//                        62,
//                        @"123",
//                        1];
//    format = [format stringByAppendingString:@"&pageIndex=%d&pageSize=%d"];
//    [self setRequestFormat:format requestMoreBy:RequestMoreByPageFromPage];
//    self.numberOfDataPerPage = 20;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
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
    
}
- (void)loadDataRequestFailed:(ASIHTTPRequest *)request {
    NSLog(@"kkkkkkkkkkkkkk");
}

@end
