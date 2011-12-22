//
//  Bowdoin_Buoy_App_iPhone_Graph_View_Controller.m
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky on 12/3/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//
//  A class that communicates with instances of Graph_View
//  and Bowdoin_Buoy_App_iPhone_Graph_Data to obtain, store,
//  and graph the buoy data.
//

#import "Bowdoin_Buoy_App_iPhone_Graph_View_Controller.h"

@implementation Bowdoin_Buoy_App_iPhone_Graph_View_Controller

@synthesize graphView;
@synthesize dataModel;
@synthesize currentGraphType, currentTimeframe;
@synthesize navBar;
@synthesize dateRangeControl, graphTypeControl;

//constants for graph type
#define TRIPLE_TEMPERATURE_GRAPH 0
#define TRIPLE_SALINITY_GRAPH 1
#define CHLOROPHYLL_GRAPH 2

//constants for date range
#define DAY_TIMEFRAME 0
#define WEEK_TIMEFRAME 1


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;}

- (void)didReceiveMemoryWarning{[super didReceiveMemoryWarning];}

- (void) viewWillAppear:(BOOL)animated
{
    [self.graphView defineOrigin];
}

- (void)releaseOutlets{self.graphView = nil;}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);}


- (Bowdoin_Buoy_App_iPhone_Graph_Data *)dataModel
{
    if (!dataModel)
    {
        dataModel = [[Bowdoin_Buoy_App_iPhone_Graph_Data alloc] init];
    }
    return dataModel;
}	

- (Graph_View *)graphView
{
    if (!graphView)
    {
        graphView = [[Graph_View alloc] init];
    }
    return graphView;
}	


/*---------- ADD GESTURE RECOGNIZERS ----------*/

- (void)addPinchGestureRecognizerToGraph_View:(Graph_View *)graph
{
    UIGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:graph action:@selector(pinch:)];
    [graph addGestureRecognizer:pinchGesture];
    [pinchGesture release];
}

- (void)addPanGestureRecognizerToGraph_View:(Graph_View *)graph
{
    UIGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action: @selector(pan:)];
    [self.graphView addGestureRecognizer:panGesture];
    [panGesture release];
}

- (void)addDoubleTapGestureRecognizerToGraph_View:(Graph_View *)graph
{
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action: @selector(doubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self.graphView addGestureRecognizer:doubleTapGesture];
    [doubleTapGesture release];
}

- (void)addTripleTapGestureRecognizerToGraph_View:(Graph_View *)graph
{
    UITapGestureRecognizer *tripleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action: @selector(tripleTap:)];
    [tripleTapGesture setNumberOfTapsRequired:3];
    [self.graphView addGestureRecognizer:tripleTapGesture];
    [tripleTapGesture release];
}


/*---------- RESPONDING TO SEGMENTED CONTROLS ----------*/

#define TEMPERATURE_TITLE @"Temperature"
#define SALINITY_TITLE @"Salinity"
#define CHLOROPHYLL_TITLE @"Chlorophyll"

//graph type changed
- (void)graphSegmentedControlIndexChanged
{    
    switch (self.graphTypeControl.selectedSegmentIndex)
    {
        case TRIPLE_TEMPERATURE_GRAPH:
            [self.graphView setDrawingMode:TRIPLE_TEMPERATURE_GRAPH];
            [self.graphView setNeedsDisplay];
            break;
            
        case TRIPLE_SALINITY_GRAPH:
            [self.graphView setDrawingMode:TRIPLE_SALINITY_GRAPH];
            [self.graphView setNeedsDisplay];
            break;
            
        case CHLOROPHYLL_GRAPH:
            [self.graphView setDrawingMode:CHLOROPHYLL_GRAPH];
            [self.graphView setNeedsDisplay];
            break;
            
        default:
            break;
    }
}

//date range changed
- (void)dateSegmentedControlIndexChanged
{
    switch (self.dateRangeControl.selectedSegmentIndex)
    {
        case DAY_TIMEFRAME:
            [self.graphView setTimeInterval:DAY_TIMEFRAME];
            [self.graphView setNeedsDisplay];
            break;
            
        case WEEK_TIMEFRAME:
            [self.graphView setTimeInterval:WEEK_TIMEFRAME];
            [self.graphView setNeedsDisplay];
            break;
            
        default:
            break;
    }
}


/*---------- OTHER METHODS ----------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.graphView.delegate = self;
    
    [self addPinchGestureRecognizerToGraph_View:self.graphView];
    [self addPanGestureRecognizerToGraph_View:self.graphView];
    [self addDoubleTapGestureRecognizerToGraph_View:self.graphView];
    [self addTripleTapGestureRecognizerToGraph_View:self.graphView];
    
    //need drawing setup code here to do anything
    [self.graphView defineOrigin];
    [self.graphView setTimeInterval:DAY_TIMEFRAME];
    [self.graphView setDrawingMode:currentGraphType];
    [self.graphView setFirstDay:@"2011-12-08"];
}

//gets data from Bowdoin_Buoy_App_iPhone_Graph_Data using delegate
- (NSArray *)dataForGraphingFromDelegate:(Graph_View *)requestor withCategoryID:(int)identifier andNumberOfDays:(int)numDays andStartDate:(NSString *)startDate
{
    return [self.dataModel getDataFromSensor:identifier andDateRequested:startDate forNumberofDays:numDays];
}

- (void)viewDidUnload
{
    [self setNavBar:nil];
    [self setDateRangeControl:nil];
    [self setGraphTypeControl:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [navBar release];
    [dateRangeControl release];
    [graphTypeControl release];
    [super dealloc];
    [self releaseOutlets];
}
@end
