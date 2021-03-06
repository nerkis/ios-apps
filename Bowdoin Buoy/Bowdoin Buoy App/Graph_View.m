//
//  Graph_View.m
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky and Nicole Erkis on 12/3/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//
//  A class that draws the graphs of the buoy data.
//

#import "Graph_View.h"
#import "AxesDrawer.h"

@implementation Graph_View

@synthesize delegate;
@synthesize scaleY, scaleX, yAxisMarker, originalScaleY, scaleFactor;
@synthesize graphOrigin, originalGraphOrigin;
@synthesize shouldSetYAxisMarker, originalOriginIsSet;
@synthesize drawTripleTemperature, drawChlorophyll, drawTripleSalinity, timeIntervalIsWeek, timeIntervalIsDay,
    timeIntervalIsMonth;
@synthesize firstDayForData;
@synthesize startDate;
@synthesize myInfo;

//constants for graph types
#define TWO_METER_WATER 0
#define TEN_METER_WATER 1
#define TWENTY_METER_WATER 2

#define TWO_METER_WATER_TEMP 10
#define TEN_METER_WATER_TEMP 11
#define TWENTY_METER_WATER_TEMP 12

#define TWO_METER_WATER_SALINITY 100
#define TEN_METER_WATER_SALINITY 111
#define TWENTY_METER_WATER_SALINITY 122

#define CHLOROPHYLL_IDENTIFIER 25000

#define TRIPLE_TEMPERATURE_GRAPH 0
#define TRIPLE_SALINITY_GRAPH 1
#define CHLOROPHYLL_GRAPH 2

//constants for date ranges
#define DAY_TIMEFRAME 0
#define WEEK_TIMEFRAME 1
#define MONTH_TIMEFRAME 2

#define DAY_INTERVAL 1
#define WEEK_INTERVAL 7
#define MONTH_INTERVAL 28

#define MINIMUM_DAY 10
#define MINIMUM_MONTH 3
#define MINIMUM_YEAR 2011

//constants for drawing axes and graph
#define RIGHT_EDGE_BUFFER 10


#define IPHONE_SCALE_X_FACTOR_DAY 18.23
#define IPHONE_SCALE_X_FACTOR_WEEK 2.57
#define IPHONE_SCALE_X_FACTOR_MONTH 10 /*****/

#define IPHONE_DEFAULT_SCALE_X_DAY 19.3
#define IPHONE_DEFAULT_SCALE_X_WEEK 64
#define IPHONE_DEFAULT_SCALE_X_MONTH 10 /*****/


#define IPAD_SCALE_X_FACTOR_DAY 42
#define IPAD_SCALE_X_FACTOR_WEEK 5.75
#define IPAD_SCALE_X_FACTOR_MONTH 10 /*****/

#define IPAD_DEFAULT_SCALE_X_DAY 43.1
#define IPAD_DEFAULT_SCALE_X_WEEK 140.5
#define IPAD_DEFAULT_SCALE_X_MONTH 10 /*****/


#define IPHONE_DEFAULT_SCALE_Y_CHLOROPHYLL 20
#define IPHONE_DEFAULT_SCALE_Y_TEMPERATURE 17
#define IPHONE_DEFAULT_SCALE_Y_SALINITY 5

#define IPAD_DEFAULT_SCALE_Y_CHLOROPHYLL 40
#define IPAD_DEFAULT_SCALE_Y_TEMPERATURE 40
#define IPAD_DEFAULT_SCALE_Y_SALINITY 14

#define MINIMUM_SCALE_Y 1
#define MAXIMUM_SCALE_Y 150

#define LEFT_Y_AXIS_OFFSET 25
#define BOTTOM_X_AXIS_OFFSET 25

#define CIRCLE_RADIUS 2

#define TEMPERATURE_UNITS @"Degrees Celsius: °C"
#define CHLOROPHYLL_UNITS @"Micrograms/liter: µg/L"
#define DAY_UNITS @"Hours"
#define WEEK_UNITS @"Days"
/*****CHANGE*****/
#define MONTH_UNITS @"12 Hours"

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {}
    return self;
}

- (Graph_Info_View_Controller *)myInfo
{
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    if (!iPad && !myInfo)
    {
        myInfo = [[Graph_Info_View_Controller alloc] initWithNibName:@"Graph_Info_View_Controller_iPhone" bundle:nil];
    }
    else if (iPad && !myInfo)
    {
        myInfo = [[Graph_Info_View_Controller alloc] initWithNibName:@"Graph_Info_View_Controller_iPad" bundle:nil];
    }
    return myInfo;
}	


/*---------- GRAPH SETUP ----------*/

- (void)defineOrigin
{
    //hard-coded good offset 
    self.graphOrigin = CGPointMake(LEFT_Y_AXIS_OFFSET, self.bounds.size.height - BOTTOM_X_AXIS_OFFSET);
    self.originalGraphOrigin = self.graphOrigin;
    self.originalScaleY = self.scaleY;
    self.shouldSetYAxisMarker = YES;
}

- (void)setFirstDay:(NSString *)date
{
    self.firstDayForData = date;
    self.myInfo.startDate = date;

}

- (void)setTimeInterval:(int)identifier
{
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);

    switch (identifier) 
    {
        case DAY_TIMEFRAME:
            self.timeIntervalIsDay = YES;
            self.timeIntervalIsWeek = NO;
            self.timeIntervalIsMonth = NO;
            self.shouldSetYAxisMarker = YES;
            self.myInfo.xAxisUnits = DAY_UNITS;

            if (!iPad)
            {
                self.scaleX = IPHONE_DEFAULT_SCALE_X_DAY;
                self.scaleFactor = IPHONE_SCALE_X_FACTOR_DAY;

            }
            else if (iPad)
            {
                self.scaleX = IPAD_DEFAULT_SCALE_X_DAY;
                self.scaleFactor = IPAD_SCALE_X_FACTOR_DAY;
            }
            break;
            
        case WEEK_TIMEFRAME:
            self.timeIntervalIsDay = NO;
            self.timeIntervalIsWeek = YES;
            self.timeIntervalIsMonth = NO;
            self.shouldSetYAxisMarker = YES;
            self.myInfo.xAxisUnits = WEEK_UNITS;

            if (!iPad)
            {
                self.scaleX = IPHONE_DEFAULT_SCALE_X_WEEK;
                self.scaleFactor = IPHONE_SCALE_X_FACTOR_WEEK;

            }
            else if (iPad)
            {
                self.scaleX = IPAD_DEFAULT_SCALE_X_WEEK;
                self.scaleFactor = IPAD_SCALE_X_FACTOR_WEEK;
            }
            break;
            
        case MONTH_TIMEFRAME:
            self.timeIntervalIsDay = NO;
            self.timeIntervalIsWeek = NO;
            self.timeIntervalIsMonth = YES;
            self.shouldSetYAxisMarker = YES;
            self.myInfo.xAxisUnits = MONTH_UNITS;
            
            if (!iPad)
            {
                self.scaleX = IPHONE_DEFAULT_SCALE_X_MONTH;
                self.scaleFactor = IPHONE_SCALE_X_FACTOR_MONTH;
                
            }
            else if (iPad)
            {
                self.scaleX = IPAD_DEFAULT_SCALE_X_MONTH;
                self.scaleFactor = IPAD_SCALE_X_FACTOR_MONTH;
            }
            break;
            
        default:
            break;
    }
}

- (void)setDrawingMode:(int)identifier
{
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    switch (identifier) 
    {
        case TRIPLE_SALINITY_GRAPH:
            self.drawTripleTemperature = NO;
            self.drawTripleSalinity = YES;
            self.drawChlorophyll = NO;
            self.shouldSetYAxisMarker = YES;
            self.myInfo.yAxisUnits = @"Practical Salinity Units: psu";

            if (!iPad)
            {
                self.originalScaleY = IPHONE_DEFAULT_SCALE_Y_SALINITY;
                self.scaleY = IPHONE_DEFAULT_SCALE_Y_SALINITY;
            }
            else if (iPad)
            {
                self.originalScaleY = IPAD_DEFAULT_SCALE_Y_SALINITY;
                self.scaleY = IPAD_DEFAULT_SCALE_Y_SALINITY;

            }
            break;
            
        case TRIPLE_TEMPERATURE_GRAPH:
            self.drawTripleTemperature = YES;
            self.drawTripleSalinity = NO;
            self.drawChlorophyll = NO;
            self.shouldSetYAxisMarker = YES;
            self.myInfo.yAxisUnits = TEMPERATURE_UNITS;

            if (!iPad)
            {            
                self.originalScaleY = IPHONE_DEFAULT_SCALE_Y_TEMPERATURE;
                self.scaleY = IPHONE_DEFAULT_SCALE_Y_TEMPERATURE;
            }
            else if (iPad)
            {
                self.originalScaleY = IPAD_DEFAULT_SCALE_Y_TEMPERATURE;
                self.scaleY = IPAD_DEFAULT_SCALE_Y_TEMPERATURE;
            }

            break;
            
        case CHLOROPHYLL_GRAPH:
            self.myInfo.yAxisUnits = CHLOROPHYLL_UNITS;
            self.drawTripleTemperature = NO;
            self.drawTripleSalinity = NO;
            self.drawChlorophyll = YES;
            self.shouldSetYAxisMarker = YES;
            if (!iPad)
            {
                self.originalScaleY = IPHONE_DEFAULT_SCALE_Y_CHLOROPHYLL;
                self.scaleY = IPHONE_DEFAULT_SCALE_Y_CHLOROPHYLL;
            }
            else if (iPad)
            {
                self.originalScaleY = IPAD_DEFAULT_SCALE_Y_CHLOROPHYLL;
                self.scaleY = IPAD_DEFAULT_SCALE_Y_CHLOROPHYLL;

            }
            break;
            
        default:
            break;
    }
    [self doubleTap:nil];
}

/*---------- ACTION SHEET, POPOVER, AND ALERT HANDLERS ----------*/

//creates date picker configured for our graph
- (UIDatePicker *) configureDatePicker
{
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    if (!iPad)
        firstDayPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 150, 100, 0)];
    else if (iPad)
        firstDayPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];

    [firstDayPicker setDatePickerMode:UIDatePickerModeDate];
    
    //create the earliest date that can be set
    NSDateComponents *minDateComponents = [[[NSDateComponents alloc] init] autorelease];
    [minDateComponents setDay:MINIMUM_DAY];
    [minDateComponents setMonth:MINIMUM_MONTH];
    [minDateComponents setYear:MINIMUM_YEAR];
    minimumDate = [[NSCalendar currentCalendar] dateFromComponents:minDateComponents]; 
    
    //set min and max date: user cannot pick date after today or before first data
    todayDate = firstDayPicker.date;
    [firstDayPicker setMaximumDate:todayDate];
    [firstDayPicker setMinimumDate:minimumDate];
    
    //helps launch picker with last chosen date
    if (self.startDate)
        [firstDayPicker setDate:self.startDate];
        
    return firstDayPicker;
}

//creates toolbar for the popover view (ipad)
- (UIToolbar *) configurePopoverToolbar
{
    //create a toolbar to hold buttons and make buttons
    pickerToolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    
    //add toolbar buttons
    UIBarButtonItem *todayButton = [[[UIBarButtonItem alloc]
                                     initWithTitle:@"Today" style:UIBarButtonItemStyleBordered 
                                     target:self action:@selector(todayButtonPressed:)] autorelease];
    [toolbarItems addObject:todayButton];
    UIBarButtonItem *weekButton = [[[UIBarButtonItem alloc]
                                    initWithTitle:@"Week Ago" style:UIBarButtonItemStyleBordered 
                                    target:self action:@selector(weekButtonPressed:)] autorelease];
    [toolbarItems addObject:weekButton];
    UIBarButtonItem *monthButton = [[[UIBarButtonItem alloc] 
                                     initWithTitle:@"Month Ago" style:UIBarButtonItemStyleBordered target:self action:@selector(monthButtonPressed:)] autorelease];
    [toolbarItems addObject:monthButton];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] 
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                      target:nil action:nil];
    [toolbarItems addObject:flexibleSpace];
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] 
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone           
                                    target:self action:@selector(saveButtonPressed:)] autorelease];
    [toolbarItems addObject:saveButton];
    
    [pickerToolbar setItems:toolbarItems animated:YES];
    [toolbarItems release];
    
    [pickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
    return pickerToolbar;
}

//creates the toolbar for the action sheet (iphone)
//needs to be written
- (UIToolbar *) configureActionSheetToolbar
{
    return pickerToolbar;
}

//action sheet save button handler
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) 
    {
        //grab date picker date and redraw graph with it
        NSLog(@"grabbing date from date picker");
        NSDate *chosenDate = firstDayPicker.date;
        
        //convert chosen date into a string
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString* firstDay = [formatter stringFromDate:chosenDate];
        [self setFirstDay:firstDay];
        NSLog(@"set first day as: %@", firstDay);
        
        //ensures launch with last chosen date
        self.startDate = firstDayPicker.date;
        
        [self setNeedsDisplay];
    }
}

//popover today button handler
- (IBAction)todayButtonPressed:(id)sender
{    
    [firstDayPicker setDate:todayDate];
}

//popover week button handler
- (IBAction)weekButtonPressed:(id)sender
{
    NSDateComponents *weekChange = [[[NSDateComponents alloc] init] autorelease];
    weekChange.week = -1;
    weekDate = [[NSCalendar currentCalendar] dateByAddingComponents:weekChange toDate:todayDate options:0];
    [firstDayPicker setDate:weekDate];
}

- (IBAction)monthButtonPressed:(id)sender
{
    NSDateComponents *monthChange = [[[NSDateComponents alloc] init] autorelease];
    monthChange.month = -1;
    monthDate = [[NSCalendar currentCalendar] dateByAddingComponents:monthChange toDate:todayDate options:0];
    [firstDayPicker setDate:monthDate];
}

//popover save button handler
- (IBAction)saveButtonPressed:(id)sender
{
    [popoverController dismissPopoverAnimated:YES];
    
    //grab date picker date and redraw graph with it
    NSLog(@"grabbing date from date picker");
    NSDate *chosenDate = firstDayPicker.date;
    
    //convert chosen date into a string
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* firstDay = [formatter stringFromDate:chosenDate];
    [self setFirstDay:firstDay];
    NSLog(@"set first day as: %@", firstDay);
    
    //ensures launch with last chosen date
    self.startDate = firstDayPicker.date;
    
    [self setNeedsDisplay];
}

- (void)presentDatePicker
{
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    if (!iPad)          //datepicker in action sheet for iphone
    {        
        //create the action sheet
        graphActionSheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self 
                            cancelButtonTitle:@"Cancel" 
                            destructiveButtonTitle:@"Save" 
                            otherButtonTitles:nil];
        
        [self configureDatePicker];
        
        //add picker view to action sheet
        [graphActionSheet addSubview:firstDayPicker];
        [graphActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [graphActionSheet showInView:self];
        [graphActionSheet setBounds:CGRectMake(0, 0, 480, 464)];//80, -50, 320, 400)];
        [graphActionSheet release];
    }
    else if (iPad)          //datepicker in popover view for ipad
    {        
        //create view to hold the picker
        UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        
        [self configurePopoverToolbar];
        [pickerView addSubview:pickerToolbar];
        
        [self configureDatePicker];
        [pickerView addSubview:firstDayPicker];
        
        //create a view controller and add view holding picker as its view
        UIViewController *popoverContent = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        popoverContent.view = pickerView;
        popoverContent.contentSizeForViewInPopover = popoverContent.view.frame.size;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        [popoverController presentPopoverFromRect:CGRectMake(360, 440, 320, 344) inView:self permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        [popoverContent release];
    }
}

//alert choose date button handler
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) 
    {
        [self presentDatePicker];
    }
}

- (void)presentDateAlert
{
    //create alert and display it
    dateAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Selected date range is missing data. Please choose a different start date." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Choose New Date", nil];
    [dateAlert show];
}

/*---------- GESTURE RECOGNIZERS ----------*/

//method for a zoom by pinching
- (void)pinch:(UIPinchGestureRecognizer *)recognizer 
{
    CGFloat factor = recognizer.scale;
    self.scaleY = self.scaleY*factor;
    
    //ensures reasonable zooming
    if (self.scaleY < MINIMUM_SCALE_Y)
        self.scaleY = MINIMUM_SCALE_Y;
    if (self.scaleY > MAXIMUM_SCALE_Y)
        self.scaleY = MAXIMUM_SCALE_Y;
    
    [self doubleTap:(recognizer)];
    
    [self setNeedsDisplay];
}

//moves the graph's origin around by panning
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

//re-center on origin by double tapping
- (void)doubleTap:(UITapGestureRecognizer *)recognizer 
{
    CGFloat offsetFactor = self.originalScaleY - self.scaleY;
    NSLog(@"originalScaleY = %f", self.originalScaleY);
    NSLog(@"current ScaleY = %f", self.scaleY);
    NSLog(@"offsetFactor = %f", offsetFactor);
    
    NSLog(@"yaxisMarker = %f", self.yAxisMarker);
    
    CGFloat offset = offsetFactor * self.yAxisMarker;
    NSLog(@"offset = %f", offset);
    
    CGPoint dummy = self.graphOrigin;
    dummy.y = self.originalGraphOrigin.y - offset;
    
    self.graphOrigin = dummy;
    [self setNeedsDisplay];
}

//resets scale by triple tapping
- (void)tripleTap:(UITapGestureRecognizer *)recognizer 
{
    [self defineOrigin];
    
    if (drawChlorophyll){
        [self setDrawingMode:CHLOROPHYLL_GRAPH];
    }
    
    if (drawTripleSalinity){
        [self setDrawingMode:TRIPLE_SALINITY_GRAPH];
    }
    
    if (drawTripleTemperature){
        [self setDrawingMode:TRIPLE_TEMPERATURE_GRAPH];
    }
    
    //self.yAxisMarker = YES;
    [self setNeedsDisplay];
}

//brings up date picker after a swipe
- (void)swipe:(UIGestureRecognizer *)recognizer
{
    [self presentDatePicker];
}


/*---------- CUSTOM DRAWING METHODS ----------*/

- (void)drawDotAtPoint:(CGPoint)point inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, point.x, point.y, CIRCLE_RADIUS, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (void)drawGraphForTwoMeterWaterTempOverTimeInterval:(int)interval andContext:(CGContextRef)context andStartDate:(NSString *)date
{
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 3);
    CGContextBeginPath(context);
    [[Graph_View myLightBlueColor] setStroke];
    
    //get data from delegate
    NSArray *dataTwo = [self.delegate dataForGraphingFromDelegate:self withCategoryID:TWO_METER_WATER_TEMP andNumberOfDays:interval andStartDate:date];
    
    //don't graph if missing data
    if (dataTwo)
    {
        CGFloat width = self.bounds.size.width;
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:24];

        //graph water temperature at 2m for one day
        if (interval == DAY_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
        
            for (int counter = 0; counter < [dataTwo count]; counter++) 
            {
                if (counter == 0)
                {
                    //get the value
                    NSArray *readingsForHour = [dataTwo objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:[readingsForHour count] - 1];
                    double doubleTempValue = [tempReading doubleValue];
                
                    //move to the first point
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    CGContextMoveToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]];
                }
                else 
                {
                    //get the value
                    NSArray *readingsForHour = [dataTwo objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:[readingsForHour count] - 1];
                    double doubleTempValue = [tempReading doubleValue];
                
                    //draw to the next value
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]];
                }
            }
  
            NSLog(@"drew 2M water graph for one day");
        }
    
        //graph water temperature at 2m for one week
        if (interval == WEEK_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
            BOOL didFirstDay = NO;
            int numberOfPointsGraphed = 0;
        
            //for each day in the week
            for (NSArray *day in dataTwo) 
            {
                for (int counter = 0; counter < [day count]; counter++) 
                {
                    if (counter == 0 && !didFirstDay)
                    {
                        //get the value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *tempReading = [readingsForHour objectAtIndex:[readingsForHour count] - 1];
                        double doubleTempValue = [tempReading doubleValue];
                        
                        //move to the first point
                        CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    
                        didFirstDay = YES;
                        numberOfPointsGraphed ++;                    
                    }
                    else 
                    {
                        //get the value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *tempReading = [readingsForHour objectAtIndex:[readingsForHour count] - 1];
                        double doubleTempValue = [tempReading doubleValue];

                        //draw to the next value
                        CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    
                        numberOfPointsGraphed ++;
                    }
                }
            }
        
            NSLog(@"drew 2M water graph for one week");
        }
    
        //set context for axes
        CGContextStrokePath(context);
    
        for (NSValue *position in points)
        {
            CGPoint nextPoint = [position CGPointValue];
            [self drawDotAtPoint:nextPoint inContext:context];
        }
    }
    else
    {
        [self presentDateAlert];
    }
    
    //create context for axes
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
    
    //get data from delegate
    NSArray *dataTen = [self.delegate dataForGraphingFromDelegate:self withCategoryID:TEN_METER_WATER_TEMP andNumberOfDays:interval andStartDate:date];
    
    if (dataTen)
    {
        CGFloat width = self.bounds.size.width;
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:24];

        //graph water temperature at 10m for one day
        if (interval == DAY_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
        
            for (int counter = 0; counter < [dataTen count]; counter++) 
            {
                if (counter == 0)
                {
                    //get the value
                    NSArray *readingsForHour = [dataTen objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleTempValue = [tempReading doubleValue];

                    //move to first point
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    CGContextMoveToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]];
                }
                else 
                {
                    //get the value
                    NSArray *readingsForHour = [dataTen objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleTempValue = [tempReading doubleValue];

                    //draw to the next value
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]];
                }
            }
        
            NSLog(@"drew 10M water graph for one day");
        }
    
        //graph water temperature at 10m for one week
        if (interval == WEEK_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
            BOOL didFirstDay = NO;
            int numberOfPointsGraphed = 0;
        
            //for each day in the week
            for (NSArray *day in dataTen) 
            {
                for (int counter = 0; counter < [day count]; counter++) 
                {
                    if (counter == 0 && !didFirstDay)
                    {
                        //get the value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                        double doubleTempValue = [tempReading doubleValue];

                        //move to first point
                        CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    
                        didFirstDay = YES;
                        numberOfPointsGraphed ++;                    
                    }
                    else 
                    {
                        //get the value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                        double doubleTempValue = [tempReading doubleValue];

                        //draw to the next value
                        CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    
                        numberOfPointsGraphed ++;
                    }
                }
            }     
        
            NSLog(@"drew 10M water graph for one week");
        }
    
        //set context for axes
        CGContextStrokePath(context);
    
        for (NSValue *position in points)
        {
            CGPoint nextPoint = [position CGPointValue];
            [self drawDotAtPoint:nextPoint inContext:context];
        }
    }
    else
    {
        //NSLog(@"MISSING DATA, CAN'T GRAPH");
    }
    
    //create context for axes
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
        
    //get data from delegate
    NSArray *dataTwenty = [self.delegate dataForGraphingFromDelegate:self withCategoryID:TWENTY_METER_WATER_TEMP andNumberOfDays:interval andStartDate:date];
    
    if (dataTwenty)
    {
        CGFloat width = self.bounds.size.width;
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:24];

        //graph water temperature at 20M for one day
        if (interval == DAY_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
        
            for (int counter = 0; counter < [dataTwenty count]; counter++) 
            {
                if (counter == 0)
                {
                    //get the value
                    NSArray *readingsForHour = [dataTwenty objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleTempValue = [tempReading doubleValue];

                    //move to first point                
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    CGContextMoveToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]];

                    if (self.shouldSetYAxisMarker)
                    {
                        self.yAxisMarker = doubleTempValue;
                        self.shouldSetYAxisMarker = NO;
                    }
                }
                else 
                {
                    //get the value
                    NSArray *readingsForHour = [dataTwenty objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleTempValue = [tempReading doubleValue];
                    
                    //draw to next value
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]];            
                }
            }
        }
        //graph water temperature at 20m for one week
        if (interval == WEEK_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
            BOOL didFirstDay = NO;
            int numberOfPointsGraphed = 0;
        
            //for each day in the week
            for (NSArray *day in dataTwenty) 
            {
                for (int counter = 0; counter < [day count]; counter++) 
                {
                    if (counter == 0 && !didFirstDay)
                    {
                        //get the value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                        double doubleTempValue = [tempReading doubleValue];

                        //move to first point
                        CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    
                        didFirstDay = YES;
                    
                        if (self.shouldSetYAxisMarker)
                        {
                            self.yAxisMarker = doubleTempValue;
                            self.shouldSetYAxisMarker = NO;
                        }

                        numberOfPointsGraphed ++;                    
                    }
                    else 
                    {
                        //get the value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                        double doubleTempValue = [tempReading doubleValue];

                        //draw to next value
                        CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleTempValue));
                    
                        numberOfPointsGraphed ++;
                    }
                }
            }       
        
            NSLog(@"drew 20M water graph for one week");
        }
    
        //set context for axes
        CGContextStrokePath(context);
    
        for (NSValue *position in points)
        {
            CGPoint nextPoint = [position CGPointValue];
            [self drawDotAtPoint:nextPoint inContext:context];
        }
    }
    else
    {
        //NSLog(@"MISSING DATA, CAN'T GRAPH");
    }
    
    //create context for axes
    CGContextSetLineWidth(context, 1);
    [[UIColor blackColor] setStroke];
    UIGraphicsPopContext();
}

- (void)drawGraphForTwoMeterWaterSalinityOverTimeInterval:(int)interval andContext:(CGContextRef)context andStartDate:(NSString *)date
{
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 3);
    CGContextBeginPath(context);
    [[Graph_View myLightRedColor] setStroke];
    
    //get data from delegate
    NSArray *dataTwo = [self.delegate dataForGraphingFromDelegate:self withCategoryID:TWO_METER_WATER_SALINITY andNumberOfDays:interval andStartDate:date];
    
    if (dataTwo)
    {
        CGFloat width = self.bounds.size.width;
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:24];
        
        //graph salinity at 2m for one day
        if (interval == DAY_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
        
            for (int counter = 0; counter < [dataTwo count]; counter++) 
            {
                if (counter == 0)
                {
                    //get the value
                    NSArray *readingsForHour = [dataTwo objectAtIndex:counter];
                    NSNumber *salinityReading = [readingsForHour objectAtIndex:0];
                    double doubleSalinityValue = [salinityReading doubleValue];

                    //move to first point
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    CGContextMoveToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]];
                }
                else 
                {
                    //get the value
                    NSArray *readingsForHour = [dataTwo objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleSalinityValue = [tempReading doubleValue];

                    //draw to next value
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]]; 
                }
            }
        }
    
        //graph salinity at 2m for one week
        if (interval == WEEK_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
            BOOL didFirstDay = NO;
            int numberOfPointsGraphed = 0;
        
            //for each day in the week
            for (NSArray *day in dataTwo) 
            {
                for (int counter = 0; counter < [day count]; counter++) 
                {
                    if (counter == 0 && !didFirstDay)
                    {
                        //get the value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *salinityReading = [readingsForHour objectAtIndex:0];
                        double doubleSalinityValue = [salinityReading doubleValue];

                        //move to first point
                        CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleSalinityValue));

                        didFirstDay = YES;
                        numberOfPointsGraphed ++;                    
                    }
                    else 
                    {
                        //get the value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *salinityReading = [readingsForHour objectAtIndex:0];
                        double doubleSalinityValue = [salinityReading doubleValue];

                        //draw to next value
                        CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    
                        numberOfPointsGraphed ++;
                    }
                }
            }       
        
            NSLog(@"drew 2M salinity graph for one week");
        }
    
        //set context for axes
        CGContextStrokePath(context);
    
        for (NSValue *position in points)
        {
            CGPoint nextPoint = [position CGPointValue];
            [self drawDotAtPoint:nextPoint inContext:context];
        }
    }
    else
    {
        [self presentDateAlert];
    }
    
    //create context for axes
    CGContextSetLineWidth(context, 1);
    [[UIColor blackColor] setStroke];
    UIGraphicsPopContext();
}

- (void)drawGraphForTenMeterWaterSalinityOverTimeInterval:(int)interval andContext:(CGContextRef)context andStartDate:(NSString *)date
{
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 3);
    CGContextBeginPath(context);
    [[Graph_View myMediumRedColor] setStroke];

    //get data from delegate
    NSArray *dataTen = [self.delegate dataForGraphingFromDelegate:self withCategoryID:TEN_METER_WATER_SALINITY andNumberOfDays:interval andStartDate:date];
    
    if (dataTen)
    {
        CGFloat width = self.bounds.size.width;
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:24];

        //graph salinity at 10M for one day
        if (interval == DAY_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
        
            for (int counter = 0; counter < [dataTen count]; counter++) 
            {
                if (counter == 0)
                {
                    //get value
                    NSArray *readingsForHour = [dataTen objectAtIndex:counter];
                    NSNumber *salinityReading = [readingsForHour objectAtIndex:1];
                    double doubleSalinityValue = [salinityReading doubleValue];

                    //move to first point
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    CGContextMoveToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]];
                }
                else 
                {
                    //get value
                    NSArray *readingsForHour = [dataTen objectAtIndex:counter];
                    NSNumber *salinityReading = [readingsForHour objectAtIndex:1];
                    double doubleSalinityValue = [salinityReading doubleValue];

                    //draw to next value
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]]; 
                }
            }
        }
    
        //graph salinity at 10m for one week
        if (interval == WEEK_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
            BOOL didFirstDay = NO;
            int numberOfPointsGraphed = 0;
        
            //for each day in the week
            for (NSArray *day in dataTen) 
            {
                for (int counter = 0; counter < [day count]; counter++) 
                {
                    if (counter == 0 && !didFirstDay)
                    {
                        //get value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *salinityReading = [readingsForHour objectAtIndex:1];
                        double doubleSalinityValue = [salinityReading doubleValue];

                        //move to first point
                        CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                                        
                        didFirstDay = YES;
                        numberOfPointsGraphed ++;                    
                    }
                    else 
                    {
                        //get value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *salinityReading = [readingsForHour objectAtIndex:1];
                        double doubleSalinityValue = [salinityReading doubleValue];

                        //draw to next value
                        CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    
                        numberOfPointsGraphed ++;
                    }
                }
            }       
        
            NSLog(@"drew 10M salinity graph for one week");    
        }
    
        //set context for axes
        CGContextStrokePath(context);
    
        for (NSValue *position in points)
        {
            CGPoint nextPoint = [position CGPointValue];
            [self drawDotAtPoint:nextPoint inContext:context];
        }
    }
    else
    {
        //NSLog(@"MISSING DATA, CAN'T GRAPH");
    }
    
    //create context for axes
    CGContextSetLineWidth(context, 1);
    [[UIColor blackColor] setStroke];
    UIGraphicsPopContext();
}

- (void)drawGraphForTwentyMeterWaterSalinityOverTimeInterval:(int)interval andContext:(CGContextRef)context andStartDate:(NSString *)date
{
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 3);
    CGContextBeginPath(context);
    [[Graph_View myDarkRedColor] setStroke];

    //get data from delegate
    NSArray *dataTwenty = [self.delegate dataForGraphingFromDelegate:self withCategoryID:TWENTY_METER_WATER_SALINITY andNumberOfDays:interval andStartDate:date];
    
    if (dataTwenty)
    {
        CGFloat width = self.bounds.size.width;
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:24];
    
        //graph salinity at 20M for one day
        if (interval == DAY_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
        
            for (int counter = 0; counter < [dataTwenty count]; counter++) 
            {
                if (counter == 0)
                {
                    //get value
                    NSArray *readingsForHour = [dataTwenty objectAtIndex:counter];
                    NSNumber *salinityReading = [readingsForHour objectAtIndex:1];
                    double doubleSalinityValue = [salinityReading doubleValue];

                    //move to first point
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    CGContextMoveToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]];
                
                    if (self.shouldSetYAxisMarker)
                    {
                        self.yAxisMarker = doubleSalinityValue;
                        self.shouldSetYAxisMarker = NO;
                    }
                }
                else 
                {
                    //get value
                    NSArray *readingsForHour = [dataTwenty objectAtIndex:counter];
                    NSNumber *salinityReading = [readingsForHour objectAtIndex:1];
                    double doubleSalinityValue = [salinityReading doubleValue];

                    //draw to next value
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]]; 
                }
            }
        }
    
        //graph salinity at 20m for one week
        if (interval == WEEK_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
            BOOL didFirstDay = NO;
            int numberOfPointsGraphed = 0;
        
            //for each day in the week
            for (NSArray *day in dataTwenty) 
            {
                for (int counter = 0; counter < [day count]; counter++) 
                {
                    if (counter == 0 && !didFirstDay)
                    {
                        //get value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *salinityReading = [readingsForHour objectAtIndex:1];
                        double doubleSalinityValue = [salinityReading doubleValue];

                        //move to first point
                        CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                                        
                        if (self.shouldSetYAxisMarker)
                        {
                            self.yAxisMarker = doubleSalinityValue;
                            self.shouldSetYAxisMarker = NO;
                        }

                        didFirstDay = YES;
                        numberOfPointsGraphed ++;                    
                    }
                    else 
                    {
                        //get value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *tempReading = [readingsForHour objectAtIndex:1];
                        double doubleSalinityValue = [tempReading doubleValue];

                        //draw to next value
                        CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleSalinityValue));
                    
                        numberOfPointsGraphed ++;
                    }
                }
            }       
        }
    
        //set context for axes
        CGContextStrokePath(context);
    
        for (NSValue *position in points)
        {
            CGPoint nextPoint = [position CGPointValue];
            [self drawDotAtPoint:nextPoint inContext:context];
        }
    }
    else
    {
        //NSLog(@"MISSING DATA, CAN'T GRAPH");
    }
    
    //create context for axes
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
    
    //get data from delegate
    NSArray *dataChlorophyll = [self.delegate dataForGraphingFromDelegate:self withCategoryID:CHLOROPHYLL_IDENTIFIER andNumberOfDays:interval andStartDate:date];
    
    if (dataChlorophyll)
    {
        CGFloat width = self.bounds.size.width;
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:24];

        //graph chlorophyll at 2.5 M for one day
        if (interval == DAY_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
        
            for (int counter = 0; counter < [dataChlorophyll count]; counter++) 
            {
                if (counter == 0)
                {
                    //get value
                    NSArray *readingsForHour = [dataChlorophyll objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleChlorophyllValue = [tempReading doubleValue];

                    //move to first point
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleChlorophyllValue));
                    CGContextMoveToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]];
                
                    if (self.shouldSetYAxisMarker)
                    {
                        self.yAxisMarker = doubleChlorophyllValue;
                        self.shouldSetYAxisMarker = NO;
                    }
                }
                else 
                {
                    //get value
                    NSArray *readingsForHour = [dataChlorophyll objectAtIndex:counter];
                    NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                    double doubleChlorophyllValue = [tempReading doubleValue];

                    //draw to next value
                    CGPoint nextPoint = CGPointMake(self.graphOrigin.x+(counter*widthIncrement), self.graphOrigin.y-(self.scaleY*doubleChlorophyllValue));
                    CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
                    [points addObject: [NSValue valueWithCGPoint:nextPoint]]; 
                }
            }
        }
    
        //graph chlorophyll for one week
        if (interval == WEEK_INTERVAL)
        {
            double spacing = (self.bounds.size.width - self.graphOrigin.x)/self.scaleFactor;
            double widthIncrement = ((double)width)/(spacing);
            BOOL didFirstDay = NO;
            int numberOfPointsGraphed = 0;
        
            //for each day in the week
            for (NSArray *day in dataChlorophyll) 
            {
                for (int counter = 0; counter < [day count]; counter++) 
                {
                    if (counter == 0 && !didFirstDay)
                    {
                        //get value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                        double doubleChlorophyllValue = [tempReading doubleValue];

                        //move to first point
                        CGContextMoveToPoint(context, self.graphOrigin.x, self.graphOrigin.y-(self.scaleY*doubleChlorophyllValue));
                    
                        if (self.shouldSetYAxisMarker)
                        {
                            self.yAxisMarker = doubleChlorophyllValue;
                            self.shouldSetYAxisMarker = NO;
                        }
                    
                        didFirstDay = YES;
                        numberOfPointsGraphed ++;                    
                    }
                    else 
                    {
                        //get value
                        NSArray *readingsForHour = [day objectAtIndex:counter];
                        NSNumber *tempReading = [readingsForHour objectAtIndex:0];
                        double doubleChlorophyllValue = [tempReading doubleValue];

                        //draw to next value
                        CGContextAddLineToPoint(context, self.graphOrigin.x+(widthIncrement*numberOfPointsGraphed), self.graphOrigin.y-(self.scaleY*doubleChlorophyllValue));
                    
                        numberOfPointsGraphed ++;
                    }
                }
            }       
        }
    
        CGContextStrokePath(context);
    
        for (NSValue *position in points)
        {
            CGPoint nextPoint = [position CGPointValue];
            [self drawDotAtPoint:nextPoint inContext:context];
        }
    }
    else
    {
        [self presentDateAlert];
    }
    
    //create context for axes
    CGContextSetLineWidth(context, 1);
    [[UIColor blackColor] setStroke];
    UIGraphicsPopContext();
}



/*  overridden |drawRect|, calls draw methods for appropriate
 *  graph type, time interval, and start date
 */
- (void)drawRect:(CGRect)rect
{    
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
    
    //draws axes
    [AxesDrawer drawAxesInRect:canvas originAtPoint:self.graphOrigin scaleX:self.scaleX scaleY:self.scaleY];
}


/*---------- DEFINE CUSTOM COLORS ----------*/

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

- (void)dealloc {[super dealloc];}

@end

