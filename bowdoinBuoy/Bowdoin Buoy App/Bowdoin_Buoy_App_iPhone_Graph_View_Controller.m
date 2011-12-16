//
//  Bowdoin_Buoy_App_iPhone_Graph_View_Controller.m
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky on 12/3/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import "Bowdoin_Buoy_App_iPhone_Graph_View_Controller.h"

@implementation Bowdoin_Buoy_App_iPhone_Graph_View_Controller

@synthesize graphView;
@synthesize dataModel;
@synthesize currentGraphType;
@synthesize navBar;
@synthesize dateRangeControl, graphTypeControl;

#define TRIPLE_TEMPERATURE_GRAPH 0
#define TRIPLE_SALINITY_GRAPH 1
#define CHLOROPHYLL_GRAPH 2

#define DAY_TIMEFRAME 89
#define WEEK_TIMEFRAME 99

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated
{

}

- (void)releaseOutlets
{
    self.graphView = nil;
}

- (void)dealloc
{
    [navBar release];
    [dateRangeControl release];
    [graphTypeControl release];
    [super dealloc];
    [self releaseOutlets];
}

- (void)addPinchGestureRecognizerToGraph_View:(Graph_View *)graph
{
    //adds a pinch gesture to the graphView
    UIGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:graph action:@selector(pinch:)];
    [graph addGestureRecognizer:pinchGesture];
    [pinchGesture release];
}

- (void)addPanGestureRecognizerToGraph_View:(Graph_View *)graph
{
    //adds a pan gesture to the graphView
    UIGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action: @selector(pan:)];
    [self.graphView addGestureRecognizer:panGesture];
    [panGesture release];
}

- (void)addDoubleTapGestureRecognizerToGraph_View:(Graph_View *)graph
{
    //adds a double tap gesture to the graphView
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action: @selector(doubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self.graphView addGestureRecognizer:doubleTapGesture];
    [doubleTapGesture release];
}

- (void)addTripleTapGestureRecognizerToGraph_View:(Graph_View *)graph
{
    //adds a triple tap gesture to the graphView
    UITapGestureRecognizer *tripleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action: @selector(tripleTapGesture:)];
    [tripleTapGesture setNumberOfTapsRequired:3];
    [self.graphView addGestureRecognizer:tripleTapGesture];
    [tripleTapGesture release];
}

#define TEMPERATURE_TITLE @"Temperature"
#define SALINITY_TITLE @"Salinity"
#define CHLOROPHYLL_TITLE @"Chlorophyll"

- (void)segmentedControlIndexChanged
{
    NSLog(@"Inside changed graph type");
    
    switch (self.graphTypeControl.selectedSegmentIndex){
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
    [self.graphView setTimeInterval:WEEK_TIMEFRAME];
    [self.graphView setDrawingMode:currentGraphType];
    [self.graphView setFirstDay:@"2011-12-01"];
}

- (void)viewDidUnload
{
    [self setNavBar:nil];
    [self setDateRangeControl:nil];
    [self setGraphTypeControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (NSArray *)dataForGraphingFromDelegate:(Graph_View *)requestor withCategoryID:(int)identifier andNumberOfDays:(int)numDays andStartDate:(NSString *)startDate
{
    //NSLog(@"called delegate data method");
    return [self.dataModel getDataFromSensor:identifier andDateRequested:startDate forNumberofDays:numDays];
}
@end
