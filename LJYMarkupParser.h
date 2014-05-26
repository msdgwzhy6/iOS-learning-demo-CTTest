//
//  LJYMarkupParser.h
//  CTTest
//
//  Created by Daniel Liu on 14-5-23.
//  Copyright (c) 2014年 wmss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJYMarkupParser : NSObject
@property (strong, nonatomic) NSString* font;
@property (strong, nonatomic) UIColor* color;
@property (strong, nonatomic) UIColor* strokeColor;
@property (assign, readwrite) float strokeWidth;

@property (strong, nonatomic) NSMutableArray* images;

-(NSAttributedString*)attrStringFromMarkup:(NSString*)markup;
@end
