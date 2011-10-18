//
//  GraphDraw.m
//  Graphing
//
//  Created by Nicole Erkis on 10/11/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import "GraphDraw.h"

@implementation GraphDraw

@synthesize delegate;

- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        //initialization code?
    }
    return self;
}

/* method like axesDrawer that draws the
 * graphical expression
 */
- (void)drawExpressionInContext:(CGContextRef)context scale:(CGFloat)pointsPerUnit
{
    //draw the expression
}

/* custom drawRect that draws the axes using
 * axesDrawer and then draws the graphical expression
 */
- (void)drawRect:(CGRect)rect
{
    NSLog(@"draw");
    
    //find midpoint of rect for axes origin
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    //CGFloat size = self.bounds.size.width/2;
    //if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height/2;
    //size *= 0.90;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blackColor] setStroke];
    
    //make scale a variable!!
    //draw the axes
    [AxesDrawer drawAxesInRect:rect originAtPoint:midPoint scale:30];
    
    //call drawing method
    [self drawExpressionInContext: context scale:30];
}

- (void)dealloc {
    [super dealloc];
}

@end
