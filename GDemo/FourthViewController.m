//
//  FourthViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/15/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "FourthViewController.h"
#import "CCRGlobalConf.h"
#import "GDUtility.h"

#define IMAGE_SHEET_TAG         2013081401
#define GENDER_SHEET_TAG        2013081402

#define NICKNAME_TAG            2013081510
#define CONTANCT_TAG            2013081520
#define SIGN_TAG                2013081530

@interface FourthViewController ()
@property (nonatomic, retain) NSMutableArray *dataSource;

- (void) updateDataSource;
@end

@implementation FourthViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSString *str = @"设置";
        self.title = str;
        self.tabBarItem.image = [UIImage imageNamed:@"four"];
        self.tabBarItem.title = str;
        
//        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
//                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
//        self.navigationItem.rightBarButtonItem = barBtnItem;
//        [barBtnItem release];
//        barBtnItem = nil;
        
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void) dealloc {
    [_dataSource release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self updateDataSource];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - methods 
- (void) updateDataSource {
    [self.dataSource removeAllObjects];
    
    NSArray *s0a0 = [NSArray arrayWithObjects:@"头像",@"headImgClick:",CCRConf.image ? CCRConf.image : @"", nil];
    NSArray *s0a1 = [NSArray arrayWithObjects:@"昵称",@"nickNameClick:",CCRConf.nickName ? CCRConf.nickName : @"", nil];
    NSArray *s0a2 = [NSArray arrayWithObjects:@"性别",@"genderClick:",CCRConf.strGender ? CCRConf.strGender : @"", nil];
    NSArray *s0a3 = [NSArray arrayWithObjects:@"联系方式",@"contactClick:",CCRConf.userContact ? CCRConf.userContact : @"", nil];
    NSArray *s0 = [NSArray arrayWithObjects:s0a0,s0a1,s0a2,s0a3, nil];
    [self.dataSource addObject:s0];
    
    NSArray *s1a0 = [NSArray arrayWithObjects:@"地区",@"areaClick:",CCRConf.userArea ? CCRConf.userArea : @"", nil];
    NSArray *s1a1 = [NSArray arrayWithObjects:@"游戏",@"gameClick:",CCRConf.userGameServer ? CCRConf.userGameServer : @"", nil];
    NSArray *s1a2 = [NSArray arrayWithObjects:@"个性签名",@"signClick:",CCRConf.userSign ? CCRConf.userSign : @"", nil];
    NSArray *s1 = [NSArray arrayWithObjects:s1a0,s1a1,s1a2, nil];
    [self.dataSource addObject:s1];
    
    
    NSArray *s2a0 = [NSArray arrayWithObjects:@"编号",@"codeClick:",CCRConf.userCode ? CCRConf.userCode : [NSString stringWithFormat:@"10000%d",CCRConf.userId], nil];
    NSArray *s2 = [NSArray arrayWithObjects:s2a0, nil];
    [self.dataSource addObject:s2];
    
}

- (IBAction)updateTableView:(id)sender {
    [self updateDataSource];
    [self.tableView reloadData];
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        cell.detailTextLabel.numberOfLines = 2;
    }
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    // Configure the cell...
    cell.textLabel.text = [[[self.dataSource objectAtIndex:section] objectAtIndex:row] objectAtIndex:0];
    if (section == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (section == 0 && row == 0) {
        [cell.imageView setImage:CCRConf.image ? CCRConf.image : [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[GDUtility getHeadImageDownLoadStringUrl:CCRConf.userId]]]]];
    }else {
        cell.detailTextLabel.text = [[[self.dataSource objectAtIndex:section] objectAtIndex:row] objectAtIndex:2];
    }
    
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
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    if (section == 0 && row == 0) {
        return 90.0;
    }
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray *oneRecord = [[self.dataSource objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    SEL function = NSSelectorFromString([oneRecord objectAtIndex:1]);
    [self performSelector:function];
}

#pragma mark - functions 
- (IBAction)headImgClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择"
                                  delegate:self
                                  cancelButtonTitle:@"取 消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"图 库",
                                  @"拍 照",nil];
    actionSheet.tag = IMAGE_SHEET_TAG;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
    actionSheet = nil;
    
}
- (IBAction)nickNameClick:(id)sender {
    FillInBlankViewController *fill = [[FillInBlankViewController alloc] initWithNibName:@"FillInBlankViewController" bundle:nil];
    fill.title = @"昵称";
    fill.delegate = self;
    fill.textTag = NICKNAME_TAG;
    fill.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fill animated:YES];
    [fill release];
    fill = nil;
    
}
- (IBAction)genderClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择"
                                  delegate:self
                                  cancelButtonTitle:@"取 消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"男",
                                  @"女",nil];
    actionSheet.tag = GENDER_SHEET_TAG;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
    actionSheet = nil;
    
}
- (IBAction)contactClick:(id)sender {
    FillInBlankViewController *fill = [[FillInBlankViewController alloc] initWithNibName:@"FillInBlankViewController" bundle:nil];
    fill.title = @"联系方式";
    fill.fillTextFiled.keyboardType = UIKeyboardTypeEmailAddress;
    fill.delegate = self;
    fill.textTag = CONTANCT_TAG;
    fill.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fill animated:YES];
    [fill release];
    fill = nil;
    
}
- (IBAction)areaClick:(id)sender {
    SelectViewController *select = [[SelectViewController alloc] initWithNibName:@"SelectViewController" bundle:nil];
    select.title = @"地区";
    select.delegate = self;
    select.type = kLoad_area;
    select.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:select animated:YES];
    [select release];
    select = nil;
    
}
- (IBAction)gameClick:(id)sender {
    SelectViewController *select = [[SelectViewController alloc] initWithNibName:@"SelectViewController" bundle:nil];
    select.title = @"游戏";
    select.delegate = self;
    select.type = kLoad_game;
    select.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:select animated:YES];
    [select release];
    select = nil;
}
- (IBAction)signClick:(id)sender {
    FillInBlankViewController *fill = [[FillInBlankViewController alloc] initWithNibName:@"FillInBlankViewController" bundle:nil];
    fill.title = @"个性签名";
    fill.delegate = self;
    fill.textTag = SIGN_TAG;
    fill.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fill animated:YES];
    [fill release];
    fill = nil;
    
}
- (IBAction)codeClick:(id)sender {
    
}

- (IBAction)nextStep:(id)sender {
    // save info--
}


#pragma mark ------ UIActionSheet Delegate Methods ------
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex])
    {
        switch (buttonIndex) {
            case 0:
            {
                if (actionSheet.tag == IMAGE_SHEET_TAG) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    picker.allowsEditing = YES;
                    picker.delegate = self;
                    [self.navigationController presentModalViewController:picker animated:YES];
                    [picker release];
                    picker = nil;
                }else if (actionSheet.tag == GENDER_SHEET_TAG) {
                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:gUSER_GENDER];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self performSelectorOnMainThread:@selector(updateTableView:) withObject:nil waitUntilDone:YES];
                }
                break;
            }
            case 1:
            {
                if (actionSheet.tag == IMAGE_SHEET_TAG) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.allowsEditing = YES;
                    picker.delegate = self;
                    [self.navigationController presentModalViewController:picker animated:YES];
                    [picker release];
                    picker = nil;
                }else if (actionSheet.tag == GENDER_SHEET_TAG) {
                    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:gUSER_GENDER];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self performSelectorOnMainThread:@selector(updateTableView:) withObject:nil waitUntilDone:YES];
                }
                break;
            }
            default:
                break;
        }
        
    }
    return;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) removePicker:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage * img = [[info objectForKey:UIImagePickerControllerEditedImage] retain];
    [picker dismissModalViewControllerAnimated:NO];
    [GDUtility saveImage:img imageKey:[NSString stringWithFormat:@"%d",CCRConf.userId]];
    [self performSelectorOnMainThread:@selector(updateTableView:) withObject:nil waitUntilDone:YES];
    [img release];
    img = nil;
    [pool release];
    pool = nil;
    
}

#pragma mark - fill
- (void) fillInBlankFinished:(UITextField *) textField {
    [textField retain];
    NSLog(@"tag = %d",textField.tag);
    switch (textField.tag) {
        case NICKNAME_TAG:
        {
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:gNICK_NAME];
            break;
        }
        case CONTANCT_TAG:
        {
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:gUSER_CONTACT];
            break;
        }
        case SIGN_TAG:
        {
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:gUSER_SIGN];
            break;
        }
        default:
            break;
    }
    [textField release];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSelectorOnMainThread:@selector(updateTableView:) withObject:nil waitUntilDone:YES];
}

#pragma mark - select
- (void) didSelectedAreaString:(NSString *) text {
    [self performSelectorOnMainThread:@selector(updateTableView:) withObject:nil waitUntilDone:YES];
}
- (void) didSelectedGameString:(NSString *) text {
    [self performSelectorOnMainThread:@selector(updateTableView:) withObject:nil waitUntilDone:YES];
}


@end
