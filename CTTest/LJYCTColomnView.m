//
//  LJYCTColomnView.m
//  CTTest
//
//  Created by Daniel Liu on 14-5-23.
//  Copyright (c) 2014年 wmss. All rights reserved.
//

#import "LJYCTColomnView.h"
#import <CoreText/CoreText.h>

@interface LJYCTColomnView ()

@property (strong, nonatomic) id ctFrame;

@end

@implementation LJYCTColomnView

- (void)setCTFrame:(id)f
{
    self.ctFrame = f;
}

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    /// toggle coordinate between left-up and left-down
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw((CTFrameRef)self.ctFrame, context);

    for (NSArray* imageData in self.images) {
        UIImage* img = [imageData objectAtIndex:0];
        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
        CGContextDrawImage(context, imgBounds, img.CGImage);
    }

}


@end
