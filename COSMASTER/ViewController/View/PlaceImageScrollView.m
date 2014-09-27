//
//  PlaceImageScrollView.m
//  COSMASTER
//
//  Created by NCri on 2014. 9. 5..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "PlaceImageScrollView.h"

#define kImageWidthHeight 250
#define kActivityTag    99
@interface PlaceImageScrollView()

@end

@implementation PlaceImageScrollView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"INIT");
    }
    return self;
}
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void) insertImage:(UIImage *)image{
    UIActivityIndicatorView *activity;
    UIImage * newImage = [PlaceImageScrollView imageWithImage:image scaledToSize:CGSizeMake(kImageWidthHeight, kImageWidthHeight)];
    for(UIImageView *imageView in [self subviews]){
        if(nil == imageView.image){
            imageView.image = newImage;
            activity = (UIActivityIndicatorView *)[imageView viewWithTag:kActivityTag];
            activity.hidden = TRUE;
            [activity stopAnimating];
            return;
        }
    }
}
- (void) setImageCapacity:(NSUInteger)capacity{
    
    if(capacity != 0){
        double contentSizeWidth = capacity * kImageWidthHeight;
        
        // 이미지 갯수 만큼 Content Size를 늘려준다.
        [self setContentSize:CGSizeMake(contentSizeWidth, self.contentSize.height)];
        CGFloat centerY = ((self.frame.size.height - 67)/2) - (kImageWidthHeight/2);
        // Image 갯수 만큼 ImageView를 셋팅해준다.
        UIActivityIndicatorView *activity = nil;
        for(int i = 0; i < capacity; i++){
            UIImageView * imgView = [[UIImageView alloc] init];
            imgView.frame = CGRectMake(i * kImageWidthHeight, centerY, kImageWidthHeight, kImageWidthHeight);
            imgView.image = nil;
            [[imgView layer] setBorderWidth:1.0f];
            [[imgView layer] setBorderColor:[UIColor blackColor].CGColor];
            imgView.clipsToBounds = YES;
            imgView.layer.cornerRadius = 15;
            
            activity = [[UIActivityIndicatorView alloc] initWithFrame:
                        CGRectMake((kImageWidthHeight/2) - 20, (kImageWidthHeight/2) - 20, 40, 40)];
            activity.tag = kActivityTag;
            [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
            [imgView addSubview : activity];
            
            // ProgressBar Start
            activity.hidden= FALSE;
            [activity startAnimating];
            
            [self addSubview:imgView];
        }
    }else{
        CGFloat centerY = ((self.frame.size.height - 67)/2) - (kImageWidthHeight/2);
        
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width / 2) - (kImageWidthHeight / 2) , centerY, kImageWidthHeight, kImageWidthHeight)];
        imgView.image = [UIImage imageNamed:@"food2.jpg"];
        [[imgView layer] setBorderWidth:1.0f];
        [[imgView layer] setBorderColor:[UIColor blackColor].CGColor];
        imgView.clipsToBounds = YES;
        imgView.layer.cornerRadius = 15;
        [self addSubview:imgView];
    }
}
- (void) setImages:(NSArray *) images{
//    UIImageView *placeImageView = [[UIImageView alloc] initWithFrame:
//                                   CGRectMake(0, 0, kPlaceImageWidth, kPlaceImageHeight)];
//    
    double contentSizeWidth = [images count] * kImageWidthHeight;
    
    // 이미지 갯수 만큼 Content Size를 늘려준다.
    [self setContentSize:CGSizeMake(contentSizeWidth, self.contentSize.height)];
    CGFloat centerY = ((self.frame.size.height - 67)/2) - (kImageWidthHeight/2);
    // Image 갯수 만큼 ImageView를 셋팅해준다.
    for(int i = 0; i < images.count; i++){
        UIImageView * imgView = [[UIImageView alloc] initWithImage:[images objectAtIndex:i]];
        imgView.frame = CGRectMake(i * kImageWidthHeight, centerY, kImageWidthHeight, kImageWidthHeight);
        [self addSubview:imgView];

//        UIButton * imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [imgButton setFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height-50)];
//        [imgButton setImage:[images objectAtIndex:i] forState:UIControlStateNormal];
//        [imgButton addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:imgButton];
//        placeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kPlaceImageWidth, 0, kPlaceImageWidth, kPlaceImageHeight)];
//        placeImageView.image = [images objectAtIndex:i];
//
//        [self addSubview:placeImageView];
        
    }
}

- (IBAction)clickImage:(id)sender{
    if([_datasource respondsToSelector:@selector(didClickPlaceImage:)]){
        UIButton * imgButton = (UIButton *)sender;
        [_datasource didClickPlaceImage:[imgButton imageForState:UIControlStateNormal]];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
