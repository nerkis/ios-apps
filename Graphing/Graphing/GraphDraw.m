//
//  GraphDraw.m
//  Graphing
//
//  Created by Nicole Erkis on 10/11/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import "GraphDraw.h"
#import "AxesDrawer.h"

@implementation GraphDraw

@synthesize delegate;

- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        //initialization code?
    }
    return self;
}

//drawRect to draw the function
- (void)drawRect:(CGRect)rect
{
    NSLog(@"draw");
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size = self.bounds.size.width/2;
    if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height/2;
    size *= 0.90;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blackColor] setStroke];
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:midPoint scale:0.2];
    
    //first set up the graphics context
    //make sure to use same scaling approach as is used in the axesdrawer class
    //see professor facedraw for example--set the drawing context, then draw axes

    //draw axes here using helper code
    //AxesDrawer drawAxesInRect:(CGRect)bounds originAtPoint:(CGPoint)axisOrigin scale:(CGFloat)pointsPerUnit;
    
    
    //after all that, deal with drawing the function?
    //how to fill in x values without having graphdraw know about calculator brains?
    //x values are the value of the axes at this point
}

- (void)dealloc {
    [super dealloc];
}

@end
