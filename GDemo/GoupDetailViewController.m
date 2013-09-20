//
//  GoupDetailViewController.m
//  GDemo
//
//  Created by Wingle Wong on 9/20/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "GoupDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GDUserInfo.h"
#import "GroupCell.h"

@interface GoupDetailViewController ()
@property (nonatomic, retain) NSMutableArray *dataSource;

@end

@implementation GoupDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
    self.tableView.separatorColor = [UIColor lightGrayColor];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.type == kMyGroup) {
        GDGroupInfo *group1 = [[[GDGroupInfo alloc] init] autorelease];
        group1.groupFounder = @"陈崐";
        group1.groupName = @"我的群1";
        group1.memberCount = 29;
        [self.dataSource addObject:group1];
        
        GDGroupInfo *group2 = [[[GDGroupInfo alloc] init] autorelease];
        group2.groupFounder = @"方钦";
        group2.groupName = @"我的群2";
        group2.memberCount = 19;
        [self.dataSource addObject:group2];
        
        GDGroupInfo *group3 = [[[GDGroupInfo alloc] init] autorelease];
        group3.groupFounder = @"黄允明";
        group3.groupName = @"我的群3";
        group3.memberCount = 15;
        [self.dataSource addObject:group3];
    }else if (self.type == kHotGroup) {
        GDGroupInfo *group1 = [[[GDGroupInfo alloc] init] autorelease];
        group1.groupFounder = @"陈崐";
        group1.groupName = @"热门群组 01";
        group1.memberCount = 29;
        [self.dataSource addObject:group1];
        
        GDGroupInfo *group2 = [[[GDGroupInfo alloc] init] autorelease];
        group2.groupFounder = @"方钦";
        group2.groupName = @"热门群组 02";
        group2.memberCount = 19;
        [self.dataSource addObject:group2];
        
        GDGroupInfo *group3 = [[[GDGroupInfo alloc] init] autorelease];
        group3.groupFounder = @"黄允明";
        group3.groupName = @"热门群组 03";
        group3.memberCount = 15;
        [self.dataSource addObject:group3];
    }
    
    
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
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *groupCellIdentifier = @"GroupCell";
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:groupCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GroupCell" owner:self options:nil];
        for (NSObject *obj in nib) {
            if ([obj isKindOfClass:[GroupCell class]]) {
                cell = (GroupCell *) obj;
                cell.headImgView.layer.masksToBounds = YES;
                cell.headImgView.layer.cornerRadius = 5.0;
            }
        }
    }
    
    GDGroupInfo *groupInfo = [self.dataSource objectAtIndex:indexPath.row];
    cell.headImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"group%d",indexPath.row+1]];
    cell.nameLabel.text = groupInfo.groupName;
    cell.founderLabel.text = [NSString stringWithFormat:@"群主:%@",groupInfo.groupFounder];
    cell.memberCountLabel.text = [NSString stringWithFormat:@"群人数:%d",groupInfo.memberCount];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
