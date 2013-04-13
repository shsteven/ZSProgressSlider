//
//  ProgressSliderCell.h
//  CustomSliderTest
//
//  Created by Steven Zhang on 26/2/12.
//  Copyright (c) 2012 Steve's Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum
{
	kTSDragStopped  = 0,
	kTSDragStarted  = 1,
	kTSDragContinue = 2
} TSDRAG_STATE;

@interface ProgressSliderCell : NSSliderCell {
	TSDRAG_STATE dragState;
}
@property (assign) float paginationProgress; // 0 to 1
@property (assign) BOOL paginating;

@property (assign, getter=isDragging) BOOL dragging;

@property (readonly) CGRect rectForKnob;

@property (assign) BOOL isNightMode;

@end
