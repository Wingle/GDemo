//
//  SecondViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/16/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "SecondViewController.h"
#import "FriendViewController.h"

@interface SecondViewController ()
@property (nonatomic, retain) NSMutableArray *dataSource;

@end

@implementation SecondViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *str = @"关系";
        self.title = str;
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        self.tabBarItem.title = str;
        
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
    
    NSArray *s0a0 = [NSArray arrayWithObjects:@"我的好友",@"myFriendClick:", nil];
    NSArray *s0 = [NSArray arrayWithObject:s0a0];
    [self.dataSource addObject:s0];
    
    NSArray *s1a0 = [NSArray arrayWithObjects:@"附近的人",@"nearByClick:", nil];
    NSArray *s1 = [NSArray arrayWithObject:s1a0];
    [self.dataSource addObject:s1];
    
    [self.tableView reloadData];
    
}

- (void) viewDidUnload {
    [self.dataSource removeAllObjects];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.dataSource objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    // Configure the cell...
    cell.textLabel.text = [[[self.dataSource objectAtIndex:section] objectAtIndex:row] objectAtIndex:0];
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
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray *oneRecord = [[self.dataSource objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    SEL function = NSSelectorFromString([oneRecord objectAtIndex:1]);
    [self performSelector:function];
}

#pragma mark - IBAction
- (IBAction)myFriendClick:(id)sender {
    FriendViewController *vc = [[FriendViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"好友";
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    vc = nil;
    
}

- (IBAction)nearByClick:(id)sender {
    FriendViewController *vc = [[FriendViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"附近的人";
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    vc = nil;
}

@end
