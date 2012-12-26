//
//  ViewController.h
//  CustomCellNibJsonLoading
//
//  Created by Ufuk ARSLAN on 9/21/12.
//  Copyright (c) 2012 Mobilistbilisim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"

@interface ViewController : UIViewController<IconDownloaderDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    UITableViewCell *tvCell;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellItem;
@property (strong,nonatomic) NSMutableArray * myObjectsArray;
@property (strong,nonatomic)  NSMutableDictionary * json;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) NSURLConnection *appListFeedConnection;
@property (nonatomic, strong) NSMutableData *appListData;

@end
