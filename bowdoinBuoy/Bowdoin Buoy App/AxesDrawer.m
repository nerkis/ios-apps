//
//  AxesDrawer.m
//
//  Created for Stanford University CS193p Fall 2010.
//

#import "AxesDrawer.h"

@implementation AxesDrawer

#define ANCHOR_CENTER 0
#define ANCHOR_TOP 1
#define ANCHOR_LEFT 2
#define ANCHOR_BOTTOM 3
#define ANCHOR_RIGHT 4

#define HASH_MARK_FONT_SIZE 12.0

#define HORIZONTAL_TEXT_MARGIN 6
#define VERTICAL_TEXT_MARGIN 3

+ (void)drawString:(NSString *)text atPoint:(CGPoint)location withAnchor:(int)anchor
{
	if ([text length])
	{
		UIFont *font = [UIFont systemFontOfSize:HASH_MARK_FONT_SIZE];
		
		CGRect textRect;
		textRect.size = [text sizeWithFont:font];
		textRect.origin.x = location.x - textRect.size.width / 2;
		textRect.origin.y = location.y - textRect.size.height / 2;
		
		switch (anchor) {
			case ANCHOR_TOP: textRect.origin.y += textRect.size.height / 2 + VERTICAL_TEXT_MARGIN; break;
			case ANCHOR_LEFT: textRect.origin.x += textRect.size.width / 2 - 3*HORIZONTAL_TEXT_MARGIN; break;
			case ANCHOR_BOTTOM: textRect.origin.y -= textRect.size.height / 2 + VERTICAL_TEXT_MARGIN; break;
			case ANCHOR_RIGHT: textRect.origin.x -= textRect.size.width / 2- 3*HORIZONTAL_TEXT_MARGIN; break;
		}
		
		[text drawInRect:textRect withFont:font];
	}
}

#define HASH_MARK_SIZE 3
#define MIN_PIXELS_PER_HASHMARK 25

+ (void)drawHashMarksInRect:(CGRect)bounds originAtPoint:(CGPoint)axisOrigin scaleX:(CGFloat)pointsPerUnitX scaleY:(CGFloat)pointsPerUnitY
{
	if (!pointsPerUnitX || !pointsPerUnitY) return;

	if (((axisOrigin.x < bounds.origin.x) || (axisOrigin.x > bounds.origin.x+bounds.size.width)) &&
		((axisOrigin.y < bounds.origin.y) || (axisOrigin.y > bounds.origin.y+bounds.size.height))) {
		return;
	}

	int unitsPerHashmarkX = MIN_PIXELS_PER_HASHMARK / pointsPerUnitX;
    int unitsPerHashmarkY = MIN_PIXELS_PER_HASHMARK * 2 / pointsPerUnitY;

	if (!unitsPerHashmarkX) unitsPerHashmarkX = 1;
	if (!unitsPerHashmarkY) unitsPerHashmarkY = 1;
	CGFloat pixelsPerHashmarkX = pointsPerUnitX * unitsPerHashmarkX;
    CGFloat pixelsPerHashmarkY = pointsPerUnitY * unitsPerHashmarkY;


	BOOL boundsContainsOrigin = CGRectContainsPoint(bounds, axisOrigin);
	if (boundsContainsOrigin) {
		if ((axisOrigin.x - pixelsPerHashmarkX < bounds.origin.x) &&
			(axisOrigin.x + pixelsPerHashmarkX > bounds.origin.x + bounds.size.width) &&
			(axisOrigin.y - pixelsPerHashmarkY < bounds.origin.y) &&
			(axisOrigin.y + pixelsPerHashmarkY > bounds.origin.y + bounds.size.height)) {
			return;
		}
        
	} else {
		if ((axisOrigin.y >= bounds.origin.y) &&
			(axisOrigin.y <= bounds.origin.y+bounds.size.height) &&
			(bounds.size.width <= pixelsPerHashmarkX)) {
			return;
		}
		if ((axisOrigin.x >= bounds.origin.x) &&
			(axisOrigin.x <= bounds.origin.x+bounds.size.width) &&
			(bounds.size.height <= pixelsPerHashmarkY)) {
			return;
		}
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	


	int started = NO;
	int stillGoing = YES;
    for (int offset = unitsPerHashmarkY; !started || stillGoing; offset += unitsPerHashmarkY)
	{
        //NSLog(@"unitsPerHashmarkY = %i", unitsPerHashmarkY);
        //NSLog(@"pointsPerUnitY = %f", pointsPerUnitY);
        
    

		NSString *positiveLabel = nil;
		NSString *negativeLabel = nil;
		BOOL drew = NO;
		CGFloat scaledOffset = floor(offset * pointsPerUnitY);

        //NSLog(@"scaledOffset = %f", scaledOffset);

 		CGPoint hashMarkPoint;
        hashMarkPoint.x = axisOrigin.x;
		hashMarkPoint.y = axisOrigin.y-scaledOffset;
        if (hashMarkPoint.y > bounds.size.height)
            hashMarkPoint.y = bounds.size.height;
        
		if (CGRectContainsPoint(bounds, hashMarkPoint)) {
			CGContextMoveToPoint(context, hashMarkPoint.x-HASH_MARK_SIZE, hashMarkPoint.y);
			CGContextAddLineToPoint(context, hashMarkPoint.x+HASH_MARK_SIZE, hashMarkPoint.y);
			if (!positiveLabel) {
				if (boundsContainsOrigin) positiveLabel = negativeLabel;
				if (!positiveLabel) positiveLabel = [NSString stringWithFormat:@"%d", offset];
			}
			[self drawString:positiveLabel atPoint:hashMarkPoint withAnchor:ANCHOR_LEFT];
			drew = YES;
		}    
        
		hashMarkPoint.y = axisOrigin.y+scaledOffset;
		if (CGRectContainsPoint(bounds, hashMarkPoint)) {
			CGContextMoveToPoint(context, hashMarkPoint.x-HASH_MARK_SIZE, hashMarkPoint.y);
			CGContextAddLineToPoint(context, hashMarkPoint.x+HASH_MARK_SIZE, hashMarkPoint.y);
			if (!negativeLabel) {
				if (boundsContainsOrigin) negativeLabel = positiveLabel;
				if (!negativeLabel) negativeLabel = [NSString stringWithFormat:@"%d", (boundsContainsOrigin ? offset : -offset)];
			}
			[self drawString:negativeLabel atPoint:hashMarkPoint withAnchor:ANCHOR_LEFT];
			drew = YES;
		}

		positiveLabel = nil;
		negativeLabel = nil;
		if (drew) started = YES;
		stillGoing = drew;
	}
    
    started = NO;
	stillGoing = YES;
    
    //problem happens in here
    
	for (int offset = unitsPerHashmarkX; !started || stillGoing; offset += unitsPerHashmarkX)
	{
        //NSLog(@"unitsPerHashmarkX = %i", unitsPerHashmarkX);
		NSString *positiveLabel = nil;
		NSString *negativeLabel = nil;
        
		BOOL drew = NO;
        //NSLog(@"pointsPerUnitX = %f", pointsPerUnitX);

		CGFloat scaledOffset = floor(offset * pointsPerUnitX);
        //NSLog(@"scaledOffset = %f", scaledOffset);

 		CGPoint hashMarkPoint;
        
		hashMarkPoint.x = axisOrigin.x+scaledOffset;
		hashMarkPoint.y = axisOrigin.y;
        
		if (CGRectContainsPoint(bounds, hashMarkPoint)) 
        {
            //NSLog(@"here inside contains");
			CGContextMoveToPoint(context, hashMarkPoint.x, hashMarkPoint.y-HASH_MARK_SIZE);
            
			CGContextAddLineToPoint(context, hashMarkPoint.x, hashMarkPoint.y+HASH_MARK_SIZE);
            
			if (!positiveLabel) positiveLabel = [NSString stringWithFormat:@"%d", offset];
            
			[self drawString:positiveLabel atPoint:hashMarkPoint withAnchor:ANCHOR_TOP];
            
			drew = YES;
		}
        else 
            break;
        
		/*hashMarkPoint.x = axisOrigin.x-scaledOffset;
		if (CGRectContainsPoint(bounds, hashMarkPoint)) {
			CGContextMoveToPoint(context, hashMarkPoint.x, hashMarkPoint.y-HASH_MARK_SIZE);
			CGContextAddLineToPoint(context, hashMarkPoint.x, hashMarkPoint.y+HASH_MARK_SIZE);
			if (boundsContainsOrigin) negativeLabel = positiveLabel;
			if (!negativeLabel) negativeLabel = [NSString stringWithFormat:@"%d", (boundsContainsOrigin ? offset : -offset)];
			[self drawString:negativeLabel atPoint:hashMarkPoint withAnchor:ANCHOR_TOP];
			drew = YES;
		}*/
        positiveLabel = nil;
		negativeLabel = nil;
		if (drew)
        {
           started = YES; 
        }
		stillGoing = drew;
	}
    CGContextStrokePath(context);

}


+ (void)drawAxesInRect:(CGRect)bounds originAtPoint:(CGPoint)axisOrigin scaleX:(CGFloat)pointsPerUnitX scaleY:(CGFloat)pointsPerUnitY
{
	CGContextRef context = UIGraphicsGetCurrentContext();

	UIGraphicsPushContext(context);

	CGContextBeginPath(context);
	CGContextMoveToPoint(context, bounds.origin.x, axisOrigin.y);
	CGContextAddLineToPoint(context, bounds.origin.x+bounds.size.width, axisOrigin.y);
	CGContextMoveToPoint(context, axisOrigin.x, bounds.origin.y);
	CGContextAddLineToPoint(context, axisOrigin.x, bounds.origin.y+bounds.size.height);
	CGContextStrokePath(context);

	[self drawHashMarksInRect:bounds originAtPoint:axisOrigin scaleX:pointsPerUnitX scaleY:pointsPerUnitY];

	UIGraphicsPopContext();
}

@end