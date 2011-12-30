//
//  Graph_View.h
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky on 12/3/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Graph_View;

@protocol GraphViewDelegate  
- (NSArray *)dataForGraphingFromDelegate:(Graph_View *)requestor withCategoryID:(int)identifier andNumberOfDays:(int)numDays andStartDate:(NSString *)startDate;
@end

@interface Graph_View : UIView <UIActionSheetDelegate, UIPickerViewDelegate>
{
    CGFloat scaleY;   
    CGFloat scaleX;
    
    //for use in double and triple tap gestures
    CGFloat yAxisMarker;
    BOOL shouldSetYAxisMarker;
    BOOL originalOriginIsSet;
    
    CGPoint originalGraphOrigin;
    CGPoint graphOrigin;
    CGFloat originalScaleY;
    CGFloat scaleFactor;
    
    NSString *firstDayForData;
    
    id <GraphViewDelegate> delegate;
    
    //for choosing graph start date
    UIActionSheet *graphActionSheet;
    UIPopoverController *popoverController;
    UIToolbar *pickerToolbar;
    UIDatePicker *firstDayPicker;
    NSDate *minimumDate;
    NSDate *startDate;
}

@property (assign) id <GraphViewDelegate> delegate;
@property (nonatomic) CGFloat scaleY;
@property (nonatomic) CGFloat scaleX;
@property (nonatomic) CGFloat yAxisMarker;
@property (nonatomic) CGFloat scaleFactor;
@property (nonatomic) BOOL shouldSetYAxisMarker;
@property (nonatomic) BOOL originalOriginIsSet;

@property (nonatomic) BOOL drawTripleTemperature;
@property (nonatomic) BOOL drawChlorophyll;
@property (nonatomic) BOOL drawTripleSalinity;
@property (nonatomic) BOOL timeIntervalIsWeek;
@property (nonatomic) BOOL timeIntervalIsDay;

@property (nonatomic) CGPoint graphOrigin;
@property (nonatomic) CGPoint originalGraphOrigin;
@property (nonatomic) CGFloat originalScaleY;

@property (nonatomic, retain) NSString *firstDayForData;
@property (nonatomic, retain) NSDate *startDate;

//graph setup
- (void)defineOrigin;
- (void)setFirstDay:(NSString *)date;

- (void)setTimeInterval:(int)identifier;
- (void)setDrawingMode:(int)identifier;

//gesture recognizers
- (void)pinch:(UIGestureRecognizer *)recognizer;
- (void)pan:(UIGestureRecognizer *)recognizer;
- (void)doubleTap:(UIGestureRecognizer *)recognizer;
- (void)tripleTap:(UIGestureRecognizer *)recognizer;
- (void)swipe:(UIGestureRecognizer *)recognizer;

//custom drawing
- (void)drawGraphForTwoMeterWaterTempOverTimeInterval:(int)interval andContext:(CGContextRef)context andStartDate:(NSString *)date;

//popover methods
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

//define custom colors
+ (UIColor*)myLightBlueColor;
+ (UIColor*)myMediumBlueColor;
+ (UIColor*)myDarkBlueColor;
+ (UIColor*)myLightRedColor;
+ (UIColor*)myMediumRedColor;
+ (UIColor*)myDarkRedColor;

@end
