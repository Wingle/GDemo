//
//  DEYRefreshTableViewController.m
//  DEyes
//
//  Created by zhenhua lu on 6/29/12.
//  Copyright (c) 2012 NeuSoft. All rights reserved.
//

#import "DEYRefreshTableViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

#ifndef LOG
#define LOG NSLog
#endif

@interface DEYRefreshTableViewController () {
    EGORefreshTableHeaderView *_refreshHeaderView;
    DEYRefreshTableFooterView *_refreshFooterView;
	
	BOOL _reloading;
    
    NSString *_requestMoreURLStringFormat;
    eRequestMoreType _requestMoreType;
    
    ASIHTTPRequest *_processingRequest;
    
    NSUInteger addedRowCount;
}

@property (nonatomic, retain) ASIHTTPRequest *processingRequest;

- (void)addOrRemoveFooterViewAsContentSizeChanged;
- (void)addFooterView;
- (void)removeFooterView;

@end

@implementation DEYRefreshTableViewController

@synthesize dataArray;
@synthesize numberOfDataPerPage;
@synthesize requestMoreType = _requestMoreType;
@synthesize processingRequest = _processingRequest;
@synthesize requestBodyDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
        self.numberOfDataPerPage = 20;
    }
    return self;
}

- (void)setRequestFormat:(NSString *)requestFormat requestMoreBy:(eRequestMoreType)requestMoreType {
    if (_requestMoreURLStringFormat != requestFormat) {
        [_requestMoreURLStringFormat release];
        _requestMoreURLStringFormat = [requestFormat copy];
    }
    
    _requestMoreType = requestMoreType;
    
    addedRowCount = self.numberOfDataPerPage;
    [self addOrRemoveFooterViewAsContentSizeChanged];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
    
	// Do any additional setup after loading the view.
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    
    addedRowCount = self.numberOfDataPerPage;
    [self addOrRemoveFooterViewAsContentSizeChanged];
    
    //  update the last update date
    CGPoint offset = CGPointMake(0, -65.0);
    self.tableView.contentOffset = offset;
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
    //[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)addOrRemoveFooterViewAsContentSizeChanged {
    if (NO == self.isViewLoaded) {
        return;
    }
    
    if (self.tableView.contentSize.height < self.tableView.frame.size.height
        || self.requestMoreType == RequestMoreAllInOnce
        || (addedRowCount < self.numberOfDataPerPage)) 
    {
        [self removeFooterView];
    } else {
        [self addFooterView];
    }
}

- (void)addFooterView {
    if (_refreshFooterView == nil) {
        DEYRefreshTableFooterView *view = [[DEYRefreshTableFooterView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44)];
        self.tableView.tableFooterView = view;
        _refreshFooterView = view;
        [view release];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMoreDataSource)];
        [_refreshFooterView addGestureRecognizer:recognizer];
        [recognizer release];
        recognizer = nil;
    } 
}
- (void)removeFooterView {
    if (_refreshFooterView != nil) {
        self.tableView.tableFooterView = nil;
        _refreshFooterView = nil;
    }
}

- (void)viewDidUnload
{
    _refreshHeaderView = nil;
    _refreshFooterView = nil;
    
    [super viewDidUnload];
}

- (void)dealloc {
	_refreshHeaderView = nil;
    _refreshFooterView = nil;
    
    [self.processingRequest clearDelegatesAndCancel];
    self.processingRequest = nil;
    
    [dataArray release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - get Methods
- (NSUInteger)loadedRowCount {
    return [self.dataArray count];
}

- (NSObject *)objectForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= [self numberOfSectionsInTableView:self.tableView]) {
        return nil;
    }
    
    if (indexPath.row >= [self.dataArray count]) {
        return nil;
    }
    
    return [self.dataArray objectAtIndex:indexPath.row];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)removeDeprecatedDataWhenRequestSuccess:(ASIHTTPRequest *)request {
    if ((request.tag == RequestTagForReload)
        || ([self requestMoreType] == RequestMoreAllInOnce)) 
    {
        [self.dataArray removeAllObjects];
        return;
    }
    
    if ([self requestMoreType] == RequestMoreByPageFromPage) {
        NSUInteger loadedPageNumber = [self loadedRowCount] / self.numberOfDataPerPage;        
        NSRange deprecatedRange;
        deprecatedRange.location = loadedPageNumber * self.numberOfDataPerPage;
        deprecatedRange.length = [self loadedRowCount] - deprecatedRange.location;
        [self.dataArray removeObjectsInRange:deprecatedRange]; 
    }
}

- (ASIHTTPRequest *)requestForMoreData:(BOOL)reload {
    if (nil == _requestMoreURLStringFormat) {
        return nil;
    }
    
    NSString *requestString = nil;
    NSUInteger currentDataCount = reload ? 0 : [self loadedRowCount];

    switch ([self requestMoreType]) {
        case RequestMoreByPageFromPage:
            requestString = [NSString stringWithFormat:_requestMoreURLStringFormat, 
                             1 + currentDataCount / self.numberOfDataPerPage, 
                             numberOfDataPerPage];
            break;
        
        case RequestMoreByPageFromIndex:
            requestString = [NSString stringWithFormat:_requestMoreURLStringFormat, 
                             currentDataCount, 
                             numberOfDataPerPage];
            break;
            
        case RequestMoreAllInOnce:
            requestString = reload ? _requestMoreURLStringFormat : nil;
            
        default:
            break;
    }
    
    NSURL *url = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (url == nil) {
        return nil;
    }
 
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.tag = reload ? RequestTagForReload : RequestTagForLoadMore;
    request.delegate = self;
    if (requestBodyDic!=nil||requestBodyDic.count>0) {
        for(NSString * keyName in [requestBodyDic allKeys]){
            [request setPostValue:[requestBodyDic objectForKey:keyName] forKey:keyName];
        }
    }
    return request;
}

- (void)reloadTableViewDataSource {
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    if (_reloading == YES) {
        LOG(@"Already reloading table view datasource");
        return;
    }
	_reloading = YES;
	self.processingRequest = [self requestForMoreData:YES];
    if (self.processingRequest == nil) {
        [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) 
                               withObject:nil 
                            waitUntilDone:YES];
    } else {
        LOG(@"reload data by request: %@", self.processingRequest.url);
        [self.processingRequest startAsynchronous];
    }
}

- (void)doneLoadingTableViewData {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [self.tableView reloadData];
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    _reloading = NO;
    self.processingRequest = nil;
    
    [pool release];
    pool = nil;
}

- (void)loadMoreDataSource {
    if (_reloading == YES) {
        LOG(@"Already reloading more table view datasource");
        return;
    }
    
    _reloading = YES;
    [_refreshFooterView startAnimating];
    
    self.processingRequest = [self requestForMoreData:NO];
    if (self.processingRequest == nil) {
        [self performSelectorOnMainThread:@selector(doneLoadingMoreDataSource) 
                               withObject:nil 
                            waitUntilDone:YES];
    } else {
        LOG(@"load more data by request: %@", self.processingRequest.url);
        [self.processingRequest startAsynchronous];
    }
}

- (void)doneLoadingMoreDataSource {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [self.tableView reloadData];
    [_refreshFooterView stopAnimating];
    
    _reloading = NO;
    self.processingRequest = nil;
    
    [pool release];
    pool = nil;
}

- (void)cancelRequestWhenOrientationChanged
{
    if ([_processingRequest isExecuting]) {
        [_processingRequest clearDelegatesAndCancel];
        [_processingRequest release];
        _processingRequest = nil;
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if (YES == [self egoRefreshTableHeaderDataSourceIsLoading:_refreshHeaderView]) {
        return;
    }
    
    if (scrollView.contentOffset.y > 0 
        && (scrollView.contentOffset.y+scrollView.bounds.size.height) > scrollView.contentSize.height
        && _refreshFooterView != nil) 
    {
        [self loadMoreDataSource];
    }
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate
- (void)loadDataRequestSuccess:(ASIHTTPRequest *)request {
    [NSException raise:NSInternalInconsistencyException 
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)loadDataRequestFailed:(ASIHTTPRequest *)request {
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = appDelegate.window;
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
	[window addSubview:hud];
    hud.customView = [[[UIView alloc] initWithFrame:CGRectNull] autorelease];
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.labelText = @"无法连接到服务器";
	[hud show:YES];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.8];
    [hud release];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self removeDeprecatedDataWhenRequestSuccess:request];
    
    NSInteger rowCount = [self loadedRowCount];
    [self loadDataRequestSuccess:request];
    addedRowCount = [self loadedRowCount] - rowCount;
    
    SEL doneSelector;
    if (request.tag == RequestTagForReload) {
        doneSelector = @selector(doneLoadingTableViewData);
    } else {
        doneSelector = @selector(doneLoadingMoreDataSource);
    }
    
    [self performSelectorOnMainThread:doneSelector 
                           withObject:nil 
                        waitUntilDone:YES];
    
    [self performSelectorOnMainThread:@selector(addOrRemoveFooterViewAsContentSizeChanged) 
                           withObject:nil 
                        waitUntilDone:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    SEL doneSelector;
    if (request.tag == RequestTagForReload) {
        doneSelector = @selector(doneLoadingTableViewData);
    } else {
        doneSelector = @selector(doneLoadingMoreDataSource);
    }
    
    [self performSelectorOnMainThread:doneSelector 
                           withObject:nil 
                        waitUntilDone:YES];
    
    [self performSelectorOnMainThread:@selector(loadDataRequestFailed:)
                           withObject:request 
                        waitUntilDone:YES];
}

@end
