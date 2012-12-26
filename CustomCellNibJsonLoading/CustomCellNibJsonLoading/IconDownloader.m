
#import "IconDownloader.h"
#import "ProductModel.h"

#define kAppIconWidth 57
#define kAppIconHeight 94


@implementation IconDownloader

@synthesize appRecord;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;

#pragma mark


- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://fiyatbilir.com/static/",appRecord.ProductPictureURL]]] delegate:self];
    self.imageConnection = conn;
    conn=nil;
}

- (void)startDownload1
{
    [self performSelectorInBackground:@selector(load) withObject:nil];
}

-(void)load
{
     UIImage * image=[UIImage imageWithData:[NSData dataWithContentsOfURL:
                                            [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://fiyatbilir.com/static/",appRecord.ProductPictureURL]]]];
    NSLog(@"Finished Image downloading");
    if (image.size.width != kAppIconWidth || image.size.height != kAppIconWidth)
	{
        CGSize itemSize = CGSizeMake(kAppIconWidth, kAppIconWidth);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.appRecord.ProductImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.appRecord.ProductImage = image;
    }
    [delegate appImageDidLoad:self.indexPathInTableView];
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    NSLog(@"Error while downloading \n %@ ",error);
    // Release the connection now that it's finished
    self.imageConnection = nil;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    NSLog(@"Finished Image downloading");
    if (image.size.width != kAppIconWidth || image.size.height != kAppIconWidth)
	{
        CGSize itemSize = CGSizeMake(kAppIconWidth, kAppIconHeight);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.appRecord.ProductImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.appRecord.ProductImage = image;
    }
    
    self.activeDownload = nil;
    image=nil;
    //[image release];
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
        
    // call our delegate and tell it that our icon is ready for display
    [delegate appImageDidLoad:self.indexPathInTableView];
}

@end

