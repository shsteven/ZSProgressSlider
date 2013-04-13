//
//  ProgressSliderCell.m
//  CustomSliderTest
//
//  Created by Steven Zhang on 26/2/12.
//  Copyright (c) 2012 Steve's Studio. All rights reserved.
//

#import "ProgressSliderCell.h"
#import "CommonCGFunctions.h"

@implementation ProgressSliderCell

#define DOT_RADIUS 1.0
#define DOT_SPACING 8.0

// Know is created by padding a dot, then drawing a border
#define KNOB_BORDER_WIDTH 2*DOT_RADIUS
#define KNOB_INNER_PADDING_X 5.0
#define KNOB_INNER_PADDING_Y 3.0

// Total width: 3.0 + 9.0 + 1.5*2 + 9.0 + 3.0
// Total height: 3.0 + 6.0 + 1.5*2 + 6.0 + 3.0

#pragma mark -
#pragma mark Drawing Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    self.paginationProgress = 1.0;
    self.paginating = NO;
    self.isNightMode = NO;
    return self;
}

- (void)drawBarInside:(NSRect)aRect flipped:(BOOL)flipped {
	
	if([self sliderType] == NSLinearSlider) {
		
		if(![self isVertical]) {
			
			[self drawHorizontalBarInFrame: aRect];
		} else {
			
			[self drawVerticalBarInFrame: aRect];
		}
	} else {
		// Don't bother about NSCircularSlider
	}
}

- (void)drawKnob:(NSRect)aRect {
    if (self.paginating)
    return;
    
	// Prevent drawing outside the rectangle to prevent ghost lines
	// when moving the slider
	// The ghost lines appear because of the shadow in highlight
	NSBezierPath *clipPath = [NSBezierPath new];
	[clipPath appendBezierPathWithRect:aRect];
	[clipPath addClip];
	
	if([self sliderType] == NSLinearSlider) {
		
		if(![self isVertical]) {
			
			[self drawHorizontalKnobInFrame: aRect];
		} else {
			
			[self drawVerticalKnobInFrame: aRect];
		}
	} else {
		
		//Place holder for when I figure out how to draw NSCircularSlider
	}
      
      
}

- (void)drawHorizontalBarInFrame:(NSRect)frame {
	
//    return;
    
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    
    NSColor *darkDotColor;
    NSColor *lightDotColor;
    
    if (self.isNightMode) {
        // Night mode
        darkDotColor = [NSColor colorWithDeviceHue:0.0 saturation:0.0 brightness:0.79 alpha:1.0];
        lightDotColor = [NSColor colorWithDeviceHue:0.0 saturation:0.0 brightness:0.39 alpha:1.0];
    } else {
        darkDotColor = [NSColor colorWithDeviceHue:0.0 saturation:0.0 brightness:0.39 alpha:1.0];
        lightDotColor = [NSColor colorWithDeviceHue:0.0 saturation:0.0 brightness:0.79 alpha:1.0];
    }
    
    
    NSInteger numberOfDots = floor((frame.size.width + DOT_SPACING - KNOB_BORDER_WIDTH - KNOB_INNER_PADDING_X) / (DOT_RADIUS * 2 + DOT_SPACING));
    
    CGPoint origin = CGPointZero;
    origin.x = KNOB_BORDER_WIDTH + KNOB_INNER_PADDING_X;
    origin.y = floor(frame.size.height/2 - DOT_RADIUS);
    
    for (NSInteger i = 0; i < numberOfDots; i++) {
        CGRect pointRect = CGRectMake(origin.x, origin.y, 2*DOT_RADIUS, 2*DOT_RADIUS);

        if (origin.x / frame.size.width < _paginationProgress)
            [darkDotColor setFill];
        else
            [lightDotColor setFill];
        CGContextFillEllipseInRect(ctx, pointRect);
        origin.x += DOT_SPACING + DOT_RADIUS * 2;
    }

    
    
 }

- (void)drawHorizontalKnobInFrame:(NSRect)frame {
    

    CGContextRef context= [[NSGraphicsContext currentContext] graphicsPort];

    
    // Outer rounded rect
    CGContextSaveGState(context);
    
    [[NSColor whiteColor] setFill];
    
    CGContextSetShadow(context, CGSizeMake(0, -1.5), 
                       2.0);
        
    
    CGFloat width = 2 * (KNOB_BORDER_WIDTH + KNOB_INNER_PADDING_X + DOT_RADIUS);
    CGFloat height = 2 * (KNOB_BORDER_WIDTH + KNOB_INNER_PADDING_Y + DOT_RADIUS);
    
    CGPoint origin = frame.origin;
    origin.y = floor( NSMidY(frame) - KNOB_INNER_PADDING_Y - KNOB_BORDER_WIDTH - DOT_RADIUS);
    CGRect rrect = CGRectMake(origin.x, origin.y, width, height); 
    CGFloat radius = KNOB_BORDER_WIDTH; 
    
    CGMutablePathRef outerPath = createRoundedRectForRect(rrect, radius);
    CGContextAddPath(context, outerPath);
    
    CFRelease(outerPath);
    
    CGContextFillPath(context);
    
//    CFRelease(outerPath);
    
    _rectForKnob = rrect;
    
    CGContextRestoreGState(context); // Reset shadow settings
    
    
    // Draw the inner rect
    radius = DOT_RADIUS;
    
    rrect = CGRectInset(rrect, KNOB_BORDER_WIDTH, KNOB_BORDER_WIDTH); // CGRectMake(origin.x, origin.y, width, height); 

    CGMutablePathRef innerPath = createRoundedRectForRect(rrect, radius);
    
    CGRect innerRect = rrect;
    
    
    CGFloat hue = 32/360.0;
    CGFloat saturation = 0.29;
    CGFloat actualBrightness;
    
    actualBrightness = 0.7;
    
    if (self.isDragging)
        actualBrightness = 0.5;
    
  
    // local vars topColor and bottomColor will prevent ARC from releasing it toooo soon
    NSColor *topColor = [NSColor colorWithDeviceHue:hue saturation:saturation brightness:0.90*actualBrightness alpha:1.0];
    NSColor *bottomColor = [NSColor colorWithDeviceHue:hue saturation:saturation brightness:0.70*actualBrightness alpha:1.0];
    
    CGColorRef innerTop = topColor.CGColor;
    CGColorRef innerBottom = bottomColor.CGColor;

    
    // Draw gradient for inner path
    CGContextSaveGState(context);
    CGContextAddPath(context, innerPath);
    CGContextClip(context);
    
    drawGlossAndGradient(context, innerRect, innerTop, innerBottom);
    

    CGContextRestoreGState(context);

    
    CFRelease(innerPath);
    
    CGContextSaveGState(context);
    
    // Draw the center dot
    [[NSColor whiteColor] setFill];
    
    origin.x += KNOB_BORDER_WIDTH + KNOB_INNER_PADDING_X;
    origin.y += KNOB_BORDER_WIDTH + KNOB_INNER_PADDING_Y;
    CGRect dotRect = CGRectMake(origin.x, origin.y, 2*DOT_RADIUS, 2*DOT_RADIUS);
    CGContextFillEllipseInRect(context, dotRect);

    CGContextRestoreGState(context);
}

- (void)drawVerticalBarInFrame:(NSRect)frame {
    // Don't bother
}


- (void)drawVerticalKnobInFrame:(NSRect)frame {
    // Unimplemented
}

#pragma mark -
#pragma mark Overridden Methods

- (BOOL)_usesCustomTrackImage {
	return YES;
}

#pragma mark -
#pragma mark Tracking
-(BOOL) startTrackingAt:(NSPoint)startPoint inView:(NSView*)controlView
{
    
    if (_paginating) return NO; // Disable tracking when paginating
    
	dragState = kTSDragStarted;

	self.dragging = YES;
    return [super startTrackingAt:startPoint inView:controlView];
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag
{
	dragState = kTSDragStopped;
	self.dragging = NO;
	[super stopTracking:lastPoint at:stopPoint inView:controlView mouseIsUp:flag];	
    
    [controlView performSelector:@selector(sliderCellDidStopTracking)];
}

- (BOOL)continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)controlView
{
	switch (dragState) {
            // stopped
		case kTSDragStopped:
//			self.dragging = NO;
			break;
            // started
		case kTSDragStarted:
			dragState = kTSDragContinue;
			break;
            // continue
		default:
			self.dragging = YES;
			break;
	}
	
	return [super continueTracking:lastPoint at:currentPoint inView:controlView];

}

@end
