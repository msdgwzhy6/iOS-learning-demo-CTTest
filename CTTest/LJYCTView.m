//
//  LJYCTView.m
//  CTTest
//
//  Created by Daniel Liu on 14-5-23.
//  Copyright (c) 2014年 wmss. All rights reserved.
//

#import "LJYCTView.h"
#import "LJYCTColomnView.h"
#import <CoreText/CoreText.h>

@interface LJYCTView ()


@end

@implementation LJYCTView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)buildFrames
{
    self.frameXOffset = 20;
    self.frameYOffset = 20;
    self.pagingEnabled = YES;
    self.delegate = self;
    self.frames = [NSMutableArray array];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect textFrame = CGRectInset(self.bounds, _frameXOffset, _frameYOffset);
    CGPathAddRect(path, NULL, textFrame);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attrString);
    
    int textPos = 0;
    int columnIndex = 0;
    
    while (textPos < [self.attrString length]) {
        CGPoint colOffset = CGPointMake((columnIndex + 1)*_frameXOffset + columnIndex * (textFrame.size.width/2), 20);
        CGRect colRect = CGRectMake(0, 0, textFrame.size.width - 10, textFrame.size.height - 40);
        NSLog(@"%@ 💔 💔 💔 💔 💔 💔", NSStringFromCGRect(colRect));     // 💔 💙 💚 💛 💜 💡 💢 💣
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);
        
        //use the column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        
        //create an empty column view
        LJYCTColomnView* contentV = [[LJYCTColomnView alloc] initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
        contentV.backgroundColor = [UIColor clearColor];
        contentV.frame = CGRectMake(colOffset.x, colOffset.y, colRect.size.width, colRect.size.height);
        
        [contentV setCTFrame:(__bridge id)(frame)];
        [self attachImagesWithFrame:frame inColumnView:contentV];
        [self.frames addObject:(__bridge id)frame];
        [self addSubview:contentV];
        
        //prepare for next frame
        textPos += frameRange.length;
        
        //CFRelease(frame);
        CFRelease(path);
        
        columnIndex++;
    }
    int totalpages = (columnIndex +1)/2; //7
    self.contentSize = CGSizeMake(totalpages*self.bounds.size.width, textFrame.size.height);
    
}

-(void)setAttrString:(NSAttributedString *)attrString withImages:(NSArray *)imgs
{
    self.attrString = attrString;
    self.images = imgs;
}

- (void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(LJYCTColomnView *)col
{
    if ([self.images count] == 0) {
        return;
    }
    //drawing images
    NSArray* lines = (NSArray*)CTFrameGetLines(f); //1
    
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins); //2
    
    int imgIndex = 0; //3
    NSDictionary* nextImage = [self.images objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    
    //find images for the current column
    CFRange frameRange = CTFrameGetVisibleStringRange(f); //4
    while (imgLocation < frameRange.location) {
        imgIndex++;
        if (imgIndex>=[self.images count])return;   // quit if no images for this column
        nextImage = [self.images objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) { //5
        CTLineRef line = (__bridge CTLineRef)lineObj;
        for (id runObj in (NSArray*)CTLineGetGlyphRuns(line)) { //6
            CTRunRef run = (__bridge CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            if (runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation) { //7
                CGRect  runBounds;
                CGFloat ascent;
                CGFloat descent;
                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
                runBounds.size.height = ascent + descent;
                
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
                runBounds.origin.x = origins[lineIndex].x + self.frame.origin.x + xOffset + _frameXOffset;
                runBounds.origin.y = origins[lineIndex].y + self.frame.origin.y + _frameYOffset;
                runBounds.origin.y -= descent;
                
                UIImage *img = [UIImage imageNamed:[nextImage objectForKey:@"fileName"]];
                CGPathRef pathRef = CTFrameGetPath(f); //10
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x - _frameXOffset - self.contentOffset.x, colRect.origin.y - _frameYOffset - self.frame.origin.y);
                [col.images addObject:[NSArray arrayWithObjects:img, NSStringFromCGRect(imgBounds), nil]]; //11
                
                //load the next image //12
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = [self.images objectAtIndex:imgIndex];
                    imgLocation = [[nextImage objectForKey:@"location"] intValue];
                }
            }
        }
        lineIndex++;
    }
}


//
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    /// toggle coordinate between left-up and left-down
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    
//    
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, CGRectInset(self.bounds, 10, 30));
//    
//    NSAttributedString* attString = self.attrString;
//    
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
//    
//    CTFrameDraw(frame, context);
//    
//    CFRelease(frame);
//    CFRelease(path);
//    CFRelease(framesetter);
//}


@end
