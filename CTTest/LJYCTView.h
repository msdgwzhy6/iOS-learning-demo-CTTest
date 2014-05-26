//
//  LJYCTView.h
//  CTTest
//
//  Created by Daniel Liu on 14-5-23.
//  Copyright (c) 2014年 wmss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import "LJYCTColomnView.h"

@interface LJYCTView : UIScrollView<UIScrollViewDelegate>

@property (assign, nonatomic) float frameXOffset;
@property (assign, nonatomic) float frameYOffset;
@property (strong, nonatomic) NSAttributedString *attrString;

@property (strong, nonatomic) NSMutableArray *frames;
@property (strong, nonatomic) NSArray *images;

-(void)buildFrames;
-(void)setAttrString:(NSAttributedString*)attrString withImages:(NSArray*)imgs;
-(void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(LJYCTColomnView*)col;

@end
