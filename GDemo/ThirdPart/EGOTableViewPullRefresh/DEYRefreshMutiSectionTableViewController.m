//
//  DEYRefreshMutiSectionTableViewController.m
//  DEyes
//
//  Created by zhenhua lu on 7/5/12.
//  Copyright (c) 2012 NeuSoft. All rights reserved.
//

#import "DEYRefreshMutiSectionTableViewController.h"

@interface DEYRefreshMutiSectionTableViewController ()

@end

@implementation DEYRefreshMutiSectionTableViewController

@synthesize dataDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataDict = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - get Methods
- (NSUInteger)loadedRowCount {
    NSUInteger count = 0;
    for (NSArray *array in self.dataDict.allValues) {
        count += [array count];
    }
    return count;
}

- (NSObject *)objectForIndexPath:(NSIndexPath *)indexPath {
    assert([self.dataArray count] == [self.dataDict count]);
    
    if (indexPath.section >= [self numberOfSectionsInTableView:self.tableView]) {
        return nil;
    }
    
    NSObject *sectionKey = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *rowArray = [self.dataDict objectForKey:sectionKey];
    if (indexPath.row >= [rowArray count]) {
        return nil;
    }
    
    return [rowArray objectAtIndex:indexPath.row];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)removeDeprecatedDataWhenRequestSuccess:(ASIHTTPRequest *)request {
    if ((request.tag == RequestTagForReload)
        || ([self requestMoreType] == RequestMoreAllInOnce)) 
    {
        [self.dataArray removeAllObjects];
        [self.dataDict removeAllObjects];
        return;
    }
    
    if ([self requestMoreType] == RequestMoreByPageFromPage) {
        NSUInteger currentRowCount = [self loadedRowCount];
        NSUInteger loadedPageNumber = currentRowCount / self.numberOfDataPerPage;
        NSUInteger deprecatedDataCount = currentRowCount - loadedPageNumber * self.numberOfDataPerPage;
        
        if (deprecatedDataCount == 0) {
            return;
        }
        
        if (deprecatedDataCount == currentRowCount) {
            [self.dataArray removeAllObjects];
            [self.dataDict removeAllObjects];
            return;
        }
        
        while ([self.dataArray count] > 0) {
            NSObject *lastSectionObj = [self.dataArray lastObject];
            NSMutableArray *rowArrayInSection = [self.dataDict objectForKey:lastSectionObj];
            if (deprecatedDataCount >= [rowArrayInSection count]) {
                [self.dataDict removeObjectForKey:lastSectionObj];
                [self.dataArray removeLastObject];
                deprecatedDataCount -= [rowArrayInSection count];
            } else {
                NSRange deprecatedRange;
                deprecatedRange.location = [rowArrayInSection count] - deprecatedDataCount;
                deprecatedRange.length = deprecatedDataCount;
                [rowArrayInSection removeObjectsInRange:deprecatedRange];
                return;
            }
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataDict count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    assert([self.dataArray count] == [self.dataDict count]);
    return [[self.dataDict objectForKey:[self.dataArray objectAtIndex:section]] count];
}

@end
