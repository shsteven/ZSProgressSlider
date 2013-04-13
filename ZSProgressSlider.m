//
//  ZSProgressSlider.m
//  CustomSliderTest
//
//  Created by Steven Zhang on 27/2/12.
//  Copyright (c) 2012 Steve's Studio. All rights reserved.
//

#import "ZSProgressSlider.h"

@implementation ZSProgressSlider

- (void)awakeFromNib {
    ProgressSliderCell *cell = self.cell;
    [cell addObserver:self
           forKeyPath:@"dragging"
              options:NSKeyValueObservingOptionNew
              context:NULL];
    
    [cell addObserver:self
           forKeyPath:@"paginating"
              options:NSKeyValueObservingOptionNew
              context:NULL];
    
    [cell addObserver:self
           forKeyPath:@"paginationProgress"
              options:NSKeyValueObservingOptionNew
              context:NULL];
    
    [cell addObserver:self
           forKeyPath:@"isNightMode"
              options:NSKeyValueObservingOptionNew
              context:NULL];
    
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc addObserver:self selector:@selector(themeChanged:) name:COLOR_THEME_CHANGE_NOTIFICATION object:nil];
}

- (void)dealloc {
    [self.cell removeObserver:self forKeyPath:@"dragging"];
    [self.cell removeObserver:self forKeyPath:@"paginating"];
    [self.cell removeObserver:self forKeyPath:@"paginationProgress"];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"dragging"]) {
        [self showOrHidePopover];
    }

    if ([keyPath isEqualToString: @"paginating"] || [keyPath isEqualToString:@"paginationProgress"] || [keyPath isEqualToString:@"isNightMode"]) {
        [self setNeedsDisplay:YES];
    }
}

- (void)showOrHidePopover {
    ProgressSliderCell *cell = self.cell;

    if (!self.popover) {
        self.popover = [[NSPopover alloc] init];
        self.popover.appearance = NSPopoverAppearanceHUD;
        self.popover.animates = NO;
    }
    
    NSViewController *vc = [self.delegate popoverViewControllerForSlider:self];
    if (!vc)  {
        NSLog(@"ZSProgressSlider: delegate must supply a view controller");
        return;
    }
    
    if (self.popover.contentViewController != vc)
        [self.popover setContentViewController:vc];

    if (cell.dragging) {
        
        [self.popover showRelativeToRect:cell.rectForKnob
                                  ofView:self
                           preferredEdge:NSMinYEdge];
        
    } else {
        [self.popover close];
    }
}

- (BOOL)paginating {
    ProgressSliderCell *cell = self.cell;
    return cell.paginating;
}

- (void)setPaginating: (BOOL)paginating {
    ProgressSliderCell *cell = self.cell;

    cell.paginating = paginating;
}

- (float)paginationProgress {
    ProgressSliderCell *cell = self.cell;

    return cell.paginationProgress;
}

- (void)setPaginationProgress: (float)progress {
    ProgressSliderCell *cell = self.cell;
    cell.paginationProgress = progress;
}

- (BOOL)isNightMode {
    ProgressSliderCell *cell = self.cell;
    return cell.isNightMode;
}

- (void)setIsNightMode:(BOOL)isNightMode {
    ProgressSliderCell *cell = self.cell;
    cell.isNightMode = isNightMode;

}

- (void)sliderCellDidStopTracking {
    [self.delegate sliderDidChangeValue:self];
}

- (void)themeChanged: (id)sender {
    [self setNeedsDisplay];
}

@end
