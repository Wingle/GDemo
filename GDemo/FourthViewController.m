//
//  FourthViewController.m
//  GDemo
//
//  Created by Wingle Wong on 8/13/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "FourthViewController.h"

@interface FourthViewController ()
@property (nonatomic, retain) NSMutableArray *dataSource;

@end

@implementation FourthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString *str = @"设置";
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
    // Do any additional setup after loading the view from its nib.
    
    NSArray *section0SubArray0 = [[NSArray alloc] initWithObjects: @"头像",@"headImageClick:",nil];
    NSArray *section0SubArray1 = [[NSArray alloc] initWithObjects: @"昵称",@"nickNameClick:",nil];
    NSArray *section0SubArray2 = [[NSArray alloc] initWithObjects: @"性别",@"genderClick:",nil];
    NSArray *section0 = [NSArray arrayWithObjects:section0SubArray0,section0SubArray1,section0SubArray2, nil];
    [section0SubArray0 release];
    [section0SubArray1 release];
    [section0SubArray2 release];
    
    [self.dataSource addObject:section0];
    
    NSArray *section1SubArray0 = [[NSArray alloc] initWithObjects: @"地区",@"areaClick:",nil];
    NSArray *section1SubArray1 = [[NSArray alloc] initWithObjects: @"游戏信息",@"gameClick:",nil];
    NSArray *setcion1 = [NSArray arrayWithObjects:section1SubArray0,section1SubArray1, nil];
    [section1SubArray0 release];
    [section1SubArray1 release];
    
    [self.dataSource addObject:setcion1];
    
    NSArray *section2SubArray0 = [[NSArray alloc] initWithObjects: @"个性签名",@"signClick:",nil];
    NSArray *section2SubArray1 = [[NSArray alloc] initWithObjects: @"联系方式",@"contactClick:",nil];
    NSArray *section2SubArray2 = [[NSArray alloc] initWithObjects: @"编号",@"numbaClick:",nil];
    NSArray *section2 = [NSArray arrayWithObjects:section0SubArray0,section0SubArray1,section0SubArray2, nil];
    [section2SubArray0 release];
    [section2SubArray1 release];
    [section2SubArray2 release];
    
    [self.dataSource addObject:section2];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_dataSource release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSource objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"moreViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:identifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    NSArray *keyArray = [self.dataSource objectAtIndex:section];
    if (section == 0 && row == 0) {
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


@end
