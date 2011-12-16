//
//  Graph_View.m
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky on 12/3/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import "Graph_View.h"
#import "AxesDrawer.h"

@implementation Graph_View

@synthesize delegate;
@synthesize scaleY, scaleX, yAxisMarker;
@synthesize graphOrigin;
@synthesize shouldSetYAxisMarker;
@synthesize drawTripleTemperature, drawChlorophyll, drawTripleSalinity, timeIntervalIsWeek, timeIntervalIsDay;
@synthesize firstDayForData;

#define TWO_METER_WATER 0
#define TWO_METER_WATER_TEMP 10
#define TWO_METER_WATER_SALINITY 100


#define TEN_METER_WATER 1
#define TEN_METER_WATER_TEMP 11
#define TEN_METER_WATER_SALINITY 111

#define TWENTY_METER_WATER 2
#define TWENTY_METER_WATER_TEMP 12
#define TWENTY_METER_WATER_SALINITY 122

#define DAY_INTERVAL 1
#define WEEK_INTERVAL 7
#define MONTH_INTERVAL 28

#define RIGHT_EDGE_BUFFER 10
#define SCALE_X_FACTOR_DAY 18
#define SCALE_X_FACTOR_WEEK 2.57

#define CHLOROPHYLL_IDENTIFIER 25000

#define IPHONE_DEFAULT_SCALE_Y_CHLOROPHYLL 20
#define IPHONE_DEFAULT_SCALE_Y_TEMPERATURE 20
#define IPHONE_DEFAULT_SCALE_Y_SALINITY 7

#define IPHONE_DEFAULT_SCALE_X_DAY 18.39
#define IPHONE_DEFAULT_SCALE_X_WEEK 64

#define MINIMUM_SCALE_Y 1
#define MAXIMUM_SCALE_Y 100

#define TRIPLE_TEMPERATURE_GRAPH 0
#define TRIPLE_SALINITY_GRAPH 1
#define CHLOROPHYLL_GRAPH 2

#define DAY_TIMEFRAME 89
#define WEEK_TIMEFRAME 99

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)defineOrigin
{
    //good offset for an iPhone
    self.graphOrigin = CGPointMake(25, self.bounds.size.height - 68);
    //self.graphOrigin = CGPointMake(30, self.bounds.size.height-30);
}

- (void)setFirstDay:(NSString *)date
{
    self.firstDayForData = date;
}

- (void)setTimeInterval:(int)identifier
{
    switch (identifier) {
        case DAY_TIMEFRAME:
            self.timeIntervalIsDay = YES;
            self.timeIntervalIsWeek = NO;
            self.scaleX = IPHONE_DEFAULT_SCALE_X_DAY;
            break;
            
        case WEEK_TIMEFRAME:
            self.timeIntervalIsDay = NO;
            self.timeIntervalIsWeek = YES;
            self.scaleX = IPHONE_DEFAULT_SCALE_X_WEEK;
            
        default:
            break;
    }
}

- (void)setDrawingMode:(int)identifier
{
    switch (identifier) {
        case TRIPLE_SALINITY_GRAPH:
            self.drawTripleTemperature = NO;
            self.drawTripleSalinity = YES;
            self.drawChlorophyll = NO;
            self.scaleY = IPHONE_DEFAULT_SCALE_Y_SALINITY;
            break;
        case TRIPLE_TEMPERATURE_GRAPH:
            self.drawTripleTemperature = YES;
            self.drawTripleSalinity = NO;
            self.drawChlorophyll = NO;
            self.scaleY = IPHONE_DEFAULT_SCALE_Y_TEMPERATURE;
            break;
        case CHLOROPHYLL_GRAPH:
            self.drawTripleTemperature = NO;
            self.drawTripleSalinity = NO;
            self.drawChlorophyll = YES;
            self.scaleY = IPHONE_DEFAULT_SCALE_Y_CHLOROPHYLL;
            break;
        default:
            break;
    }
}


+ (UIColor*)myLightBlueColor 
{  
    return [UIColor colorWithRed:145.0f/255.0f green:185.0f/255.0f blue:210.0f/255.0f alpha:1.0f];  
}
+ (UIColor*)myMediumBlueColor
{  
    return [UIColor colorWithRed:100.0f/255.0f green:150.0f/255.0f blue:210.0f/255.0f alpha:1.0f];  
}
+ (UIColor*)myDarkBlueColor 
{  
    return [UIColor colorWithRed:70.0f/255.0f green:110.0f/255.0f blue:210.0f/255.0f alpha:1.0f];  
}
+ (UIColor*)myLightRedColor
{
    return [UIColor colorWithRed:255.0f/255.0f green: 0.0f/255.0f blue:0.0f/255.0f alpha:0.33f];
}
+ (UIColor*)myMediumRedColor
{
    return [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.66f];
}
+ (UIColor*)myDarkRedColor
{
    return [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
}


- (void)drawGraphForTwoMeterWaterTempOverTimeInterval:(int)interval andContext:(CGContextRef)context andStartDate:(NSString *)date

{
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 3);
    CGContextBeginPath(context);
    [[Graph_View myLightBlueColor] setStroke];

    NSArray *dataTwo = [self.delegate dataForGraphingFromDelegate:self withCategoryID:TWO_METER_WATER_TEMP andNumberOfDays:interval andStartDate:date];

    CGFloat width = self.bounds.size.width;

    //graph water temp at 2M

    if (interval == DAY_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x)/SCALE_X_FACTOR_DAY;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        for (int counter = 0; counter < [dataTwo count]; counter++) {
            if (counter == 0)
            {
                //NSLog(@"%i", [[dataTwo objectAtIndex:counter] count]);
                NSArray *readingsForHour = [dataTwo objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:[readingsForHour count] - 1];
                double doubleTempValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleTempValue);
                CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleTempValue));
            }
            else 
            {
                NSArray *readingsForHour = [dataTwo objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:[readingsForHour count] - 1];
                double doubleTempValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleTempValue);
                CGContextAddLineToPoint(context, self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleTempValue));
            }
        }
        NSLog(@"drew 2M water graph for one day");
    }
    
    if (interval == WEEK_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x + RIGHT_EDGE_BUFFER)/SCALE_X_FACTOR_WEEK;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        BOOL didFirstDay = NO;
        int numberOfPointsGraphed = 0;
        for (NSArray *day in dataTwo) {
            for (int counter = 0; counter < [day count]; counter++) {
                if (counter == 0 && !didFirstDay)
                {
                    //NSLog(@"%i", [[day objectAtIndex:counter] count]);
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:[readingsForHour count] - 1];
                    double doubleTempValue = [tempReading doubleValue];
                    //NSLog(@"%f", doubleTempValue);
                    CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    didFirstDay = YES;
                    //NSLog(@"inside");
                    numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);

                }
                else 
                {
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:[readingsForHour count] - 1];
                    double doubleTempValue = [tempReading doubleValue];
                    //NSLog(@"%f", self.graphOrigin.x+(counter*widthIncrement));
                    CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);
                }
            }
        }
        NSLog(@"drew 2M water graph for one week");
    }

    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 1);
    [[UIColor blackColor] setStroke];
    UIGraphicsPopContext();
}





- (void)drawGraphForTenMeterWaterTempOverTimeInterval:(int)interval andContext:(CGContextRef)context andStartDate:(NSString *)date
{
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 3);
    CGContextBeginPath(context);
    [[Graph_View myMediumBlueColor] setStroke];


    CGFloat width = self.bounds.size.width;

    NSArray *dataTen = [self.delegate dataForGraphingFromDelegate:self withCategoryID:TEN_METER_WATER_TEMP andNumberOfDays:interval andStartDate:date];
    
    //graph water temp at 10M
    
    if (interval == DAY_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x)/SCALE_X_FACTOR_DAY;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        for (int counter = 0; counter < [dataTen count]; counter++) {
            if (counter == 0)
            {
                //NSLog(@"%i", [[dataTen objectAtIndex:counter] count]);
                NSArray *readingsForHour = [dataTen objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                double doubleTempValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleTempValue);
                CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleTempValue));
            
            }
            else 
            {
                NSArray *readingsForHour = [dataTen objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                double doubleTempValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleTempValue);
                CGContextAddLineToPoint(context, self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleTempValue));
            }
        }
        NSLog(@"drew 10M water graph for one day");
    }
    if (interval == WEEK_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x + RIGHT_EDGE_BUFFER)/SCALE_X_FACTOR_WEEK;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        BOOL didFirstDay = NO;
        int numberOfPointsGraphed = 0;
        for (NSArray *day in dataTen) {
            for (int counter = 0; counter < [day count]; counter++) {
                if (counter == 0 && !didFirstDay)
                {
                    //NSLog(@"%i", [[day objectAtIndex:counter] count]);
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleTempValue = [tempReading doubleValue];
                    //NSLog(@"%f", doubleTempValue);
                    CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    didFirstDay = YES;
                    //NSLog(@"inside");
                    numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);
                    
                }
                else 
                {
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleTempValue = [tempReading doubleValue];
                    //NSLog(@"%f", self.graphOrigin.x+(counter*widthIncrement));
                    CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);
                }
            }
        }       
        NSLog(@"drew 10M water graph for one week");
    }

    
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 1);
    [[UIColor blackColor] setStroke];
    UIGraphicsPopContext();
}






- (void)drawGraphForTwentyMeterWaterTempOverTimeInterval:(int)interval andContext:(CGContextRef)context andStartDate:(NSString *)date
{
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 3);
    CGContextBeginPath(context);
    [[Graph_View myDarkBlueColor] setStroke];
    
    CGFloat width = self.bounds.size.width;
   
    
    NSArray *dataTwenty = [self.delegate dataForGraphingFromDelegate:self withCategoryID:TWENTY_METER_WATER_TEMP andNumberOfDays:interval andStartDate:date];
    
    //graph water temp at 20M
    if (interval == DAY_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x)/SCALE_X_FACTOR_DAY;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        for (int counter = 0; counter < [dataTwenty count]; counter++) {
            if (counter == 0)
            {
                //NSLog(@"%i", [[dataTwenty objectAtIndex:counter] count]);
                NSArray *readingsForHour = [dataTwenty objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                double doubleTempValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleTempValue);
                CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleTempValue));
                if (shouldSetYAxisMarker)
                {
                    self.yAxisMarker = self.graphOrigin.y+(self.scaleY*doubleTempValue);
                    self.shouldSetYAxisMarker = NO;
                }
            }
            else 
            {
                NSArray *readingsForHour = [dataTwenty objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                double doubleTempValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleTempValue);
                CGContextAddLineToPoint(context, self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleTempValue));
            }
        }
    }
    if (interval == WEEK_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x + RIGHT_EDGE_BUFFER)/SCALE_X_FACTOR_WEEK;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        BOOL didFirstDay = NO;
        int numberOfPointsGraphed = 0;
        for (NSArray *day in dataTwenty) {
            for (int counter = 0; counter < [day count]; counter++) {
                if (counter == 0 && !didFirstDay)
                {
                    //NSLog(@"%i", [[day objectAtIndex:counter] count]);
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleTempValue = [tempReading doubleValue];
                    //NSLog(@"%f", doubleTempValue);
                    CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleTempValue));
                        didFirstDay = YES;
                    if (shouldSetYAxisMarker)
                    {
                        self.yAxisMarker = self.graphOrigin.y-(self.scaleY*doubleTempValue);
                        self.shouldSetYAxisMarker = NO;
                    }
                    //NSLog(@"inside");
                    numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);
                        
                }
                else 
                {
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleTempValue = [tempReading doubleValue];
                    //NSLog(@"%f", self.graphOrigin.x+(counter*widthIncrement));
                    CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleTempValue));
                        numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);
                }
            }
        }       
            NSLog(@"drew 20M water graph for one week");
    }
    
    
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 1);
    [[UIColor blackColor] setStroke];
    UIGraphicsPopContext();

}





- (void)drawGraphForTwoMeterWaterSalinityOverTimeInterval:(int)interval andContext:(CGContextRef)context andStartDate:(NSString *)date

{
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 3);
    
    NSArray *dataTwo = [self.delegate dataForGraphingFromDelegate:self withCategoryID:TWO_METER_WATER_SALINITY andNumberOfDays:interval andStartDate:date];
    
    //NSLog(@"size of dataTwo is %i", [dataTwo count]);
    
    CGFloat width = self.bounds.size.width;
    
    //graph water temp at 2M
    CGContextBeginPath(context);
    
    [[Graph_View myLightRedColor] setStroke];
    
    //graph water temp at 20M
    if (interval == DAY_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x)/SCALE_X_FACTOR_DAY;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        for (int counter = 0; counter < [dataTwo count]; counter++) {
            if (counter == 0)
            {
                //NSLog(@"%i", [[dataTwenty objectAtIndex:counter] count]);
                NSArray *readingsForHour = [dataTwo objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                double doubleSalinityValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleSalinityValue);
                CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                if (shouldSetYAxisMarker)
                {
                    self.yAxisMarker = self.graphOrigin.y+(self.scaleY*doubleSalinityValue);
                    self.shouldSetYAxisMarker = NO;
                }
            }
            else 
            {
                NSArray *readingsForHour = [dataTwo objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                double doubleSalinityValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleSalinityValue);
                CGContextAddLineToPoint(context, self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
            }
        }
    }
    if (interval == WEEK_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x + RIGHT_EDGE_BUFFER)/SCALE_X_FACTOR_WEEK;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        BOOL didFirstDay = NO;
        int numberOfPointsGraphed = 0;
        for (NSArray *day in dataTwo) {
            for (int counter = 0; counter < [day count]; counter++) {
                if (counter == 0 && !didFirstDay)
                {
                    //NSLog(@"%i", [[day objectAtIndex:counter] count]);
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleSalinityValue = [tempReading doubleValue];
                    //NSLog(@"%f", doubleSalinityValue);
                    CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    didFirstDay = YES;
                    if (shouldSetYAxisMarker)
                    {
                        self.yAxisMarker = self.graphOrigin.y-(self.scaleY*doubleSalinityValue);
                        self.shouldSetYAxisMarker = NO;
                    }
                    //NSLog(@"inside");
                    numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);
                    
                }
                else 
                {
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleSalinityValue = [tempReading doubleValue];
                    //NSLog(@"%f", doubleSalinityValue);
                    //NSLog(@"%f", self.graphOrigin.x+(counter*widthIncrement));
                    CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);
                }
            }
        }       
        NSLog(@"drew 2M salinity graph for one week");
    }
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 1);
    [[UIColor blackColor] setStroke];
    UIGraphicsPopContext();
}


- (void)drawGraphForTenMeterWaterSalinityOverTimeInterval:(int)interval andContext:(CGContextRef)context andStartDate:(NSString *)date
{
    UIGraphicsPushContext(context);
    
    NSArray *dataTen = [self.delegate dataForGraphingFromDelegate:self withCategoryID:TEN_METER_WATER_SALINITY andNumberOfDays:interval andStartDate:date];
    
    CGFloat width = self.bounds.size.width;
    
    
    CGContextSetLineWidth(context, 3);
    
    //graph water salinity at 10M
    CGContextBeginPath(context);
    
    [[Graph_View myMediumRedColor] setStroke];
    
    //graph water temp at 20M
    if (interval == DAY_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x)/SCALE_X_FACTOR_DAY;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        for (int counter = 0; counter < [dataTen count]; counter++) {
            if (counter == 0)
            {
                //NSLog(@"%i", [[dataTwenty objectAtIndex:counter] count]);
                NSArray *readingsForHour = [dataTen objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                double doubleSalinityValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleSalinityValue);
                CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                if (shouldSetYAxisMarker)
                {
                    self.yAxisMarker = self.graphOrigin.y+(self.scaleY*doubleSalinityValue);
                    self.shouldSetYAxisMarker = NO;
                }
            }
            else 
            {
                NSArray *readingsForHour = [dataTen objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                double doubleSalinityValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleSalinityValue);
                CGContextAddLineToPoint(context, self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
            }
        }
    }
    if (interval == WEEK_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x + RIGHT_EDGE_BUFFER)/SCALE_X_FACTOR_WEEK;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        BOOL didFirstDay = NO;
        int numberOfPointsGraphed = 0;
        for (NSArray *day in dataTen) {
            for (int counter = 0; counter < [day count]; counter++) {
                if (counter == 0 && !didFirstDay)
                {
                    //NSLog(@"%i", [[day objectAtIndex:counter] count]);
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleSalinityValue = [tempReading doubleValue];
                    //NSLog(@"%f", doubleSalinityValue);
                    CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    didFirstDay = YES;
                    if (shouldSetYAxisMarker)
                    {
                        self.yAxisMarker = self.graphOrigin.y-(self.scaleY*doubleSalinityValue);
                        self.shouldSetYAxisMarker = NO;
                    }
                    //NSLog(@"inside");
                    numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);
                    
                }
                else 
                {
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleSalinityValue = [tempReading doubleValue];
                    //NSLog(@"%f", self.graphOrigin.x+(counter*widthIncrement));
                    CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);
                }
            }
        }       
        NSLog(@"drew 10M salinity graph for one week");    }
    
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 1);
    [[UIColor blackColor] setStroke];
    UIGraphicsPopContext();
}

- (void)drawGraphForTwentyMeterWaterSalinityOverTimeInterval:(int)interval andContext:(CGContextRef)context andStartDate:(NSString *)date
{
    UIGraphicsPushContext(context);
    
    NSArray *dataTwenty = [self.delegate dataForGraphingFromDelegate:self withCategoryID:TWENTY_METER_WATER_SALINITY andNumberOfDays:interval andStartDate:date];
    
    CGFloat width = self.bounds.size.width;
    
    
    CGContextSetLineWidth(context, 3);
    
    //graph water salinity at 20M
    CGContextBeginPath(context);
    
    [[Graph_View myDarkRedColor] setStroke];
    
    //graph water temp at 20M
    if (interval == DAY_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x)/SCALE_X_FACTOR_DAY;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        for (int counter = 0; counter < [dataTwenty count]; counter++) {
            if (counter == 0)
            {
                //NSLog(@"%i", [[dataTwenty objectAtIndex:counter] count]);
                NSArray *readingsForHour = [dataTwenty objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                double doubleSalinityValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleSalinityValue);
                CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                if (shouldSetYAxisMarker)
                {
                    self.yAxisMarker = self.graphOrigin.y+(self.scaleY*doubleSalinityValue);
                    self.shouldSetYAxisMarker = NO;
                }
            }
            else 
            {
                NSArray *readingsForHour = [dataTwenty objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                double doubleSalinityValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleSalinityValue);
                CGContextAddLineToPoint(context, self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
            }
        }
    }
    if (interval == WEEK_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x + RIGHT_EDGE_BUFFER)/SCALE_X_FACTOR_WEEK;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        BOOL didFirstDay = NO;
        int numberOfPointsGraphed = 0;
        for (NSArray *day in dataTwenty) {
            for (int counter = 0; counter < [day count]; counter++) {
                if (counter == 0 && !didFirstDay)
                {
                    //NSLog(@"%i", [[day objectAtIndex:counter] count]);
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleSalinityValue = [tempReading doubleValue];
                    //NSLog(@"%f", doubleSalinityValue);
                    CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    didFirstDay = YES;
                    if (shouldSetYAxisMarker)
                    {
                        self.yAxisMarker = self.graphOrigin.y-(self.scaleY*doubleSalinityValue);
                        self.shouldSetYAxisMarker = NO;
                    }
                    //NSLog(@"inside");
                    numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);
                    
                }
                else 
                {
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleSalinityValue = [tempReading doubleValue];
                    //NSLog(@"%f", self.graphOrigin.x+(counter*widthIncrement));
                    CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);
                }
            }
        }       
        NSLog(@"drew 20M salinity graph for one week");
    }
    
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 1);
    [[UIColor blackColor] setStroke];
    UIGraphicsPopContext();
}

- (void)drawGraphForChlorophyllOverTimeInterval:(int)interval andContext:(CGContextRef)context andStartDate:(NSString *)date
{
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 3);
    CGContextBeginPath(context);
    [[UIColor greenColor] setStroke];
    
    
    CGFloat width = self.bounds.size.width;
    
    NSArray *dataChlorophyll = [self.delegate dataForGraphingFromDelegate:self withCategoryID:CHLOROPHYLL_IDENTIFIER andNumberOfDays:interval andStartDate:date];
    
    //graph chlorophyll @2.5 M
    if (interval == DAY_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x)/SCALE_X_FACTOR_DAY;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        for (int counter = 0; counter < [dataChlorophyll count]; counter++) {
            if (counter == 0)
            {
                //NSLog(@"%i", [[dataTen objectAtIndex:counter] count]);
                NSArray *readingsForHour = [dataChlorophyll objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                double doubleChlorophyllValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleTempValue);
                CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleChlorophyllValue));
                
            }
            else 
            {
                NSArray *readingsForHour = [dataChlorophyll objectAtIndex:counter];
                NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                double doubleChlorophyllValue = [tempReading doubleValue];
                //NSLog(@"%f", doubleTempValue);
                CGContextAddLineToPoint(context, self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleChlorophyllValue));
            }
        }
        NSLog(@"drew 2.5M chlorophyll graph for one day");
    }
    if (interval == WEEK_INTERVAL)
    {
        //CHANGED
        double spacing = (self.bounds.size.width - self.graphOrigin.x + RIGHT_EDGE_BUFFER)/SCALE_X_FACTOR_WEEK;
        //NSLog(@"spacing = %f", spacing);
        double widthIncrement = ((double)width)/(spacing);
        BOOL didFirstDay = NO;
        int numberOfPointsGraphed = 0;
        for (NSArray *day in dataChlorophyll) {
            for (int counter = 0; counter < [day count]; counter++) {
                if (counter == 0 && !didFirstDay)
                {
                    //NSLog(@"%i", [[day objectAtIndex:counter] count]);
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleChlorophyllValue = [tempReading doubleValue];
                    //NSLog(@"%f", doubleTempValue);
                    CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleChlorophyllValue));
                    didFirstDay = YES;
                    //NSLog(@"inside");
                    numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);
                    
                }
                else 
                {
                    NSArray *readingsForHour = [day objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleChlorophyllValue = [tempReading doubleValue];
                    //NSLog(@"%f", self.graphOrigin.x+(counter*widthIncrement));
                    CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleChlorophyllValue));
                    numberOfPointsGraphed ++;
                    //NSLog(@"numberOfPointsGraphed = %i", numberOfPointsGraphed);
                }
            }
        }       
        NSLog(@"drew 2.5M chlorophyll graph for one week");
    }
    
    
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 1);
    [[UIColor blackColor] setStroke];
    UIGraphicsPopContext();
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //NSLog(@"called drawRect in Graph_View");
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGRect canvas = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, height);
        
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (drawChlorophyll) 
    {
        if (timeIntervalIsDay) 
        {
            [self drawGraphForChlorophyllOverTimeInterval:DAY_INTERVAL andContext:context andStartDate:self.firstDayForData];
        }
        if (timeIntervalIsWeek)
        {
            [self drawGraphForChlorophyllOverTimeInterval:WEEK_INTERVAL andContext:context andStartDate:self.firstDayForData];
        }
    }
    
    if (drawTripleSalinity) 
    {
        if (timeIntervalIsDay)
        {
            [self drawGraphForTwoMeterWaterSalinityOverTimeInterval:DAY_INTERVAL andContext:context andStartDate:self.firstDayForData];
            [self drawGraphForTenMeterWaterSalinityOverTimeInterval:DAY_INTERVAL andContext:context andStartDate:self.firstDayForData];
            [self drawGraphForTwentyMeterWaterSalinityOverTimeInterval:DAY_INTERVAL andContext:context andStartDate:self.firstDayForData];
        }
        if (timeIntervalIsWeek)
        {
            [self drawGraphForTwoMeterWaterSalinityOverTimeInterval:WEEK_INTERVAL andContext:context andStartDate:self.firstDayForData];
            [self drawGraphForTenMeterWaterSalinityOverTimeInterval:WEEK_INTERVAL andContext:context andStartDate:self.firstDayForData];
            [self drawGraphForTwentyMeterWaterSalinityOverTimeInterval:WEEK_INTERVAL andContext:context andStartDate:self.firstDayForData];
        }
    }
    
    if (drawTripleTemperature) 
    {
        if (timeIntervalIsDay) 
        {   [self drawGraphForTwoMeterWaterTempOverTimeInterval:DAY_INTERVAL andContext:context andStartDate:self.firstDayForData];
            [self drawGraphForTenMeterWaterTempOverTimeInterval:DAY_INTERVAL andContext:context andStartDate:self.firstDayForData];
            [self drawGraphForTwentyMeterWaterTempOverTimeInterval:DAY_INTERVAL andContext:context andStartDate:self.firstDayForData];
        }
        if (timeIntervalIsWeek)
        {
            [self drawGraphForTwoMeterWaterTempOverTimeInterval:WEEK_INTERVAL andContext:context andStartDate:self.firstDayForData];
            [self drawGraphForTenMeterWaterTempOverTimeInterval:WEEK_INTERVAL andContext:context andStartDate:self.firstDayForData];
            [self drawGraphForTwentyMeterWaterTempOverTimeInterval:WEEK_INTERVAL andContext:context andStartDate:self.firstDayForData];
        }
    }
    
    
    [AxesDrawer drawAxesInRect:canvas originAtPoint:self.graphOrigin scaleX:self.scaleX scaleY:self.scaleY];
}

//FIX THIS
//method for a zoom by pinching
- (void)pinch:(UIPinchGestureRecognizer *)recognizer 
{
    CGFloat factor = recognizer.scale;
    self.scaleY = self.scaleY*factor;
    
    //if (recognizer.state == UIGestureRecognizerStateEnded)
    //{
        //CGPoint dummy = self.graphOrigin;
        //dummy.y = dummy.y-self.yAxisMarker+self.bounds.size.height/2;
        //dummy.y = dummy.y-self.scaleY*self.bounds.size.height/2;
        //self.graphOrigin = dummy;
    //}
    
    //ensures reasonable zooming
    if (self.scaleY < MINIMUM_SCALE_Y)
        self.scaleY = MINIMUM_SCALE_Y;
    if (self.scaleY > MAXIMUM_SCALE_Y)
        self.scaleY = MAXIMUM_SCALE_Y;
    
    [self doubleTap:(recognizer)];
    
    [self setNeedsDisplay];
}


//moves the graph's origin around
- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    
    if ((recognizer.state == UIGestureRecognizerStateChanged) || 
        (recognizer.state == UIGestureRecognizerStateEnded))
    {
        CGPoint translation = [recognizer translationInView:self]; 
        self.graphOrigin = CGPointMake(self.graphOrigin.x, self.graphOrigin.y +translation.y); 
        [recognizer setTranslation:CGPointZero inView:self];
    }
    [self setNeedsDisplay];
}

//FIX THIS
//re-center on origin by double tapping
- (void)doubleTap:(UIPinchGestureRecognizer *)recognizer 
{
    
    CGPoint dummy = self.graphOrigin;
    //dummy.y = dummy.y-self.yAxisMarker+self.bounds.size.height/2;   
    dummy.y = self.yAxisMarker*self.scaleY+(self.bounds.size.height/2)*self.scaleY/20.0;

    self.graphOrigin = dummy;
    [self setNeedsDisplay];
    
}

//resets scale
- (void)tripleTapGesture:(UIPinchGestureRecognizer *)recognizer 
{
    [self defineOrigin];
    if (drawChlorophyll)
    {
        [self setDrawingMode:CHLOROPHYLL_GRAPH];
    }
    if (drawTripleSalinity)
    {
        [self setDrawingMode:TRIPLE_SALINITY_GRAPH];
    }
    if (drawTripleTemperature)
    {
        [self setDrawingMode:TRIPLE_TEMPERATURE_GRAPH];
    }
    self.yAxisMarker = YES;
    [self setNeedsDisplay];
}

- (void)dealloc {
    [super dealloc];
}

@end
 
