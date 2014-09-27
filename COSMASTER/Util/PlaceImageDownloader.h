@class PlaceInfo;

@interface PlaceImageDownloader : NSObject

@property (nonatomic, strong) PlaceInfo *placeInfo;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
