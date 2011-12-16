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

@interface Graph_View : UIView 
{
    CGFloat scaleY;   
    CGFloat scaleX;

    CGFloat yAxisMarker;
    
    BOOL shouldSetYAxisMarker;
    
    CGPoint graphOrigin;
    
    NSString *firstDayForData;
    
    id <GraphViewDelegate> delegate;
}

@property (assign) id <GraphViewDelegate> delegate;
@property (nonatomic) CGFloat scaleY;
@property (nonatomic) CGFloat scaleX;
@property (nonatomic) CGFloat yAxisMarker;
@property (nonatomic) BOOL shouldSetYAxisMarker;

@property (nonatomic) BOOL drawTripleTemperature;
@property (nonatomic) BOOL drawChlorophyll;
@property (nonatomic) BOOL drawTripleSalinity;
@property (nonatomic) BOOL timeIntervalIsWeek;
@property (nonatomic) BOOL timeIntervalIsDay;

@property (nonatomic) CGPoint graphOrigin;

@property (nonatomic, retain) NSString *firstDayForData;


+ (UIColor*)myLightBlueColor;
+ (UIColor*)myMediumBlueColor;
+ (UIColor*)myDarkBlueColor;
+ (UIColor*)myLightRedColor;
+ (UIColor*)myMediumRedColor;
+ (UIColor*)myDarkRedColor;

- (void)doubleTap:(UIGestureRecognizer *)recognizer;

- (void)setTimeInterval:(int)identifier;
- (void)setDrawingMode:(int)identifier;

- (void)defineOrigin;
- (void)setFirstDay:(NSString *)date;




@end
