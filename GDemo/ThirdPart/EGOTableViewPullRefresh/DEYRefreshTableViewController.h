//
//  DEYRefreshTableViewController.h
//  DEyes
//
//  Created by zhenhua lu on 6/29/12.
//  Copyright (c) 2012 NeuSoft. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"
#import "DEYRefreshTableFooterView.h"
#import "ASIHTTPRequest.h"

typedef enum {
	RequestMoreByPageFromPage = 0,
	RequestMoreByPageFromIndex,
	RequestMoreAllInOnce,	
} eRequestMoreType;

#define RequestTagForReload 1
#define RequestTagForLoadMore 2

@interface DEYRefreshTableViewController : UITableViewController  <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate>
{
    NSUInteger numberOfDataPerPage;
    NSDictionary * requestBodyDic;
}

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, assign) NSUInteger numberOfDataPerPage;
@property (nonatomic, assign, readonly) eRequestMoreType requestMoreType;
@property (nonatomic, retain) NSDictionary * requestBodyDic;

- (NSUInteger)loadedRowCount;
- (NSObject *)objectForIndexPath:(NSIndexPath *)indexPath;
- (void)removeDeprecatedDataWhenRequestSuccess:(ASIHTTPRequest *)request;

- (void)setRequestFormat:(NSString *)requestFormat requestMoreBy:(eRequestMoreType)requestMoreType;
- (ASIHTTPRequest *)requestForMoreData:(BOOL)reload;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)loadMoreDataSource;
- (void)doneLoadingMoreDataSource;

/**
 *  @brief 横竖屏切换时，如果当前控制器正在请求网络数据，则取消请求
 */
- (void)cancelRequestWhenOrientationChanged;

//override this
- (void)loadDataRequestSuccess:(ASIHTTPRequest *)request;
- (void)loadDataRequestFailed:(ASIHTTPRequest *)request;

@end
