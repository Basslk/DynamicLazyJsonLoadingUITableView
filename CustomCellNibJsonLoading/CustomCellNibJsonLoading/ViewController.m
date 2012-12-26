//
//  ViewController.m
//  CustomCellNibJsonLoading
//
//  Created by Ufuk ARSLAN on 9/21/12.
//  Copyright (c) 2012 Mobilistbilisim. All rights reserved.
//

#import "ViewController.h"
#import "ProductModel.h"
#import "IconDownloader.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()

@end

@implementation ViewController

@synthesize cellItem=_cellItem;
@synthesize tableView=_tableView;
@synthesize myObjectsArray;
@synthesize json;
@synthesize appListData,appListFeedConnection,imageDownloadsInProgress;



int dif=0;
int count=0;
BOOL loading=NO;


-(void)flip
{
    loading=NO;
}

-(void) test
{
    @try
    {
        dif=[self.myObjectsArray count];
        NSString * urlString=[NSString stringWithFormat:@"%@%@",@"http://mytestapi.lite-soft.com/api/Products/?count=",(NSString *)[NSString stringWithFormat:@"%d",count]];
        NSURL * url=[[NSURL alloc]initWithString:urlString];
        
        NSData * data=[[NSData alloc]initWithContentsOfURL:url];
        NSError * error;
        json=(NSMutableDictionary * ) [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"JSON error %@",error.localizedDescription);
        for (NSDictionary * p in json)
        {
            [self.myObjectsArray addObject:[ProductModel CreateObject:(int)[p objectForKey:@"ProductID"] AndName:[p objectForKey:@"ProductName"] AndUrl:[p objectForKey:@"ProductPictureURL"] AndIsNEw:(BOOL)[p objectForKey:@"IsFeatured"] AndIsIndirim:(BOOL)[p objectForKey:@"IsNewProduct"]]];
        }
        dif=[self.myObjectsArray count]-dif;
        if([self.myObjectsArray count]==count)
            return ;
        
        [self.tableView reloadData];
        [self performSelectorOnMainThread:@selector(flip) withObject:nil waitUntilDone:NO];
        
        
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception: %@", e);
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"No internet connection"
                              message: @"This app needs internet connection to fetch currency rates, Plesae check and try again"
                              delegate: self
                              cancelButtonTitle:@"Work offline"
                              otherButtonTitles:@"Settings", nil];
        [alert show];
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tableView.delegate=self;
   
    self.myObjectsArray =[NSMutableArray array];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [self performSelectorInBackground:@selector(test) withObject:Nil];
     self.tableView.dataSource=self;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

ProductModel *appRecord;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if you want to change this string, update the custom cell identifire on the custom nib file, or you will have bad performance :)
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ProductCell" owner:self options:nil];
        
        cell = _cellItem;
        self.cellItem = nil;
        UIColor *pinkDarkOp = [UIColor colorWithRed:0.9f green:0.53f blue:0.69f alpha:1.0];
        UIColor *pinkLightOp = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = [[cell layer] bounds];
        gradient.cornerRadius = 7;
        gradient.colors = [NSArray arrayWithObjects:
                           (id)pinkDarkOp.CGColor,
                           (id)pinkLightOp.CGColor,
                           nil];
        gradient.locations = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.0f],
                              [NSNumber numberWithFloat:0.7],
                              nil];
        
        [[cell layer] insertSublayer:gradient atIndex:0];
        
          }
    
    int nodeCount = [self.myObjectsArray count];
    // Leave cells empty if there's no data yet
    if (nodeCount > 0)
	{
        // Set up the cell...
        appRecord = [self.myObjectsArray objectAtIndex:indexPath.row];
        
        UILabel *label;
        label = (UILabel *)[cell viewWithTag:1];
        label.text = appRecord.ProductName;
        
        // Only load cached images; defer new downloads until scrolling ends
        if (!appRecord.ProductImage)
        {
            NSLog(@"!appRecord.appIcon %d",!appRecord.ProductImage);
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
            UIImageView *imageView;
            imageView=(UIImageView*)[cell viewWithTag:0];
            imageView.image=[UIImage imageNamed:@"Placeholder.png"];

        }
        else
        {
            UIImageView *imageView;
            imageView=(UIImageView*)[cell viewWithTag:0];
            NSLog(@"!appRecord.appIcon %d",!appRecord.ProductImage);
            //cell.imageView.image = appRecord.ProductImage;
            imageView.image=appRecord.ProductImage;
            [imageView reloadInputViews];
        }
        
    }
    
    if(indexPath.row==[self.myObjectsArray count]-1 )
    {
        if(loading==NO)
        {
            loading=YES;
            NSLog(@"reached %d",indexPath.row);
            count +=dif;
            [self performSelectorOnMainThread:@selector(test) withObject:Nil waitUntilDone:YES];
        }
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of time zone names.
    NSLog(@"%d",[myObjectsArray count]);
	return [self.myObjectsArray count];
}

- (void)startIconDownload:(ProductModel*)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%d",indexPath.row);
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload1];
    }
}
// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.myObjectsArray count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            ProductModel *appRecord = [self.myObjectsArray objectAtIndex:indexPath.row];
            
            if (!appRecord.ProductImage) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = iconDownloader.appRecord.ProductImage;
    }
    
    // Remove the IconDownloader from the in progress list.
    // This will result in it being deallocated.
    [imageDownloadsInProgress removeObjectForKey:indexPath];
}

/*
 To conform to Human Interface Guildelines, since selecting a row would have no effect (such as navigation), make sure that rows cannot be selected.
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate && !loading)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(!loading)
    [self loadImagesForOnscreenRows];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row% 10==0) //self.array is the array of items you are displaying
    {
        
        //If it is the last cell, Add items to your array here & update the table view
        //NSLog(@"Reached %d",indexPath.row);
    }
}







@end
