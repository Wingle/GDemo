//
//  GoupListViewController.m
//  GDemo
//
//  Created by Wingle Wong on 9/20/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "GoupListViewController.h"
#import "GoupDetailViewController.h"

@interface GoupListViewController ()
@property (nonatomic, retain) NSMutableDictionary *dataDic;

@end

@implementation GoupListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return self;
}

- (void) dealloc {
    [_dataDic release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //,@"热门群组",@"查找群组",
    NSArray *array0 = [NSArray arrayWithObject:@"我的群组"];
    [self.dataDic setObject:array0 forKey:@"0"];
    
    NSArray *array1 = [NSArray arrayWithObject:@"热门群组"];
    [self.dataDic setObject:array1 forKey:@"1"];
    
    NSArray *array2 = [NSArray arrayWithObject:@"查找群组"];
    [self.dataDic setObject:array2 forKey:@"2"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataDic count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *array = [self.dataDic objectForKey:[NSString stringWithFormat:@"%d",section]];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSArray *array = [self.dataDic objectForKey:[NSString stringWithFormat:@"%d",section]];
    NSString *content = [array objectAtIndex:row];
    
    cell.textLabel.text = content;
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger section = indexPath.section;    
    if (section == 2) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"此功能即将推出，敬请期待"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alter show];
        [alter release];
        alter = nil;
        return;
    }
    GoupDetailViewController *vc = [[[GoupDetailViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    if (section == 0) {
        vc.type = kMyGroup;
    }else {
        vc.type = kHotGroup;
    }
    [self.navigationController pushViewController:vc animated:YES];

}

@end
