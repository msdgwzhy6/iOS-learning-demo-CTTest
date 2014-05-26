//
//  LJYViewController.m
//  CTTest
//
//  Created by Daniel Liu on 14-5-23.
//  Copyright (c) 2014年 wmss. All rights reserved.
//

#import "LJYViewController.h"
#import "LJYCTView.h"
#import "LJYMarkupParser.h"


@interface LJYViewController ()
@property (weak, nonatomic) IBOutlet LJYCTView *contentView;

@end

@implementation LJYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString* path = [[NSBundle mainBundle] pathForResource:@"zombies" ofType:@"txt"];
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
    NSString* text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    LJYMarkupParser* p = [[LJYMarkupParser alloc] init];
    NSAttributedString* attrString = [p attrStringFromMarkup:text];
    [self.contentView setAttrString:attrString withImages:p.images];
    [self.contentView buildFrames];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
