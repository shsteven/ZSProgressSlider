//
//  ZSProgressSlider.h
//  CustomSliderTest
//
//  Created by Steven Zhang on 27/2/12.
//  Copyright (c) 2012 Steve's Studio. All rights reserved.
//
//  Show a popover when sliding

#import <Cocoa/Cocoa.h>
#import "ProgressSliderCell.h"

@class ZSProgressSlider;

@protocol ZSProgressSliderDelegate <NSObject>

- (NSViewController *)popoverViewControllerForSlider: (ZSProgressSlider *)slider;
- (void)sliderDidChangeValue: (ZSProgressSlider *)slider;

@end

@interface ZSProgressSlider : NSSlider

@property (assign) IBOutlet id <ZSProgressSliderDelegate> delegate;
@property (strong) NSPopover *popover;
@property (assign) BOOL paginating;
@property (assign) float paginationProgress;

@property (assign) BOOL isNightMode;

- (void)sliderCellDidStopTracking;

@end
