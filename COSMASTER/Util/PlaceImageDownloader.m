
#import "PlaceImageDownloader.h"
#import "PlaceInfo.h"

#import "AppDelegate.h"
#import "CoreDataManager.h"


#define kAppIconSize 48

@interface PlaceImageDownloader ()
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@end


@implementation PlaceImageDownloader

#pragma mark
- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    
    NSString *reName = self.placeInfo.name;
    
    // Create the predicate
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"SELF endswith %@", @"점"];
    
    // Run the predicate
    // match == YES if the predicate is successful
    BOOL match = [myPredicate evaluateWithObject:reName];
    
    // Do what you want
    if (match) {
        // do something
        NSMutableArray *strList = [NSMutableArray arrayWithArray:[reName componentsSeparatedByString:@" "]];
        // 마지막 ??점 을 빼기 위한 작업.
        [strList removeLastObject];
        reName = [strList componentsJoinedByString:@" "];
    }
    
    NSString *url = [CoreDataManager typicalImageWithPlaceName:reName inManagedContext:ap.managedObjectContext];
    NSLog(@"START DONWLOAD : %@",url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
	{
        CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
		UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.placeInfo.image = [NSData dataWithData:UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext())];
		UIGraphicsEndImageContext();
    }
    else
    {
        self.placeInfo.image = [NSData dataWithData:UIImagePNGRepresentation(image)];
    }
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
        
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();
}


@end

