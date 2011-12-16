//
//  AxesDrawer.h
//
//  Created for Stanford University CS193p Fall 2010.
//

#import <Foundation/Foundation.h>

// AxesDrawer is a simple axis-drawing helper class.

@interface AxesDrawer : NSObject

// Draws an x axis and y axis in the specified bounds in the current context,
//   with its origin at the specified axisOrigin and scaled to the passed pointsPerUnit,
//
// The scale is the number of points (not pixels) per unit on the axis.
// For example, if the size is 280 wide and the scale is 14, the x axis would go from -10 to +10.
// If the size is 280 wide and the scale is 2, the x axis would go from -70 to +70.
// The graph is also drawn so that it's origin is axisOrigin.
//
// Only marks whole numbers on an axis.
//
// Does not set any graphics state, so set the colors, linewidths, etc., you want before calling.

+ (void)drawAxesInRect:(CGRect)bounds 
         originAtPoint:(CGPoint)axisOrigin
                 scaleX:(CGFloat)pointsPerUnitX
                scaleY:(CGFloat)pointsPerUnitY;

@end
