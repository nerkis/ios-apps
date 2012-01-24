//
//  Bowdoin_Buoy_App_iPhone_Graph_View_Controller.h
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky and Nicole Erkis on 12/3/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graph_View.h"
#import "Bowdoin_Buoy_App_iPhone_Graph_Data.h"

@interface Bowdoin_Buoy_App_iPhone_Graph_View_Controller : 

UIViewController <GraphViewDelegate>
{
    Graph_View *graphView;                          //class that draws graph
    Bowdoin_Buoy_App_iPhone_Graph_Data *dataModel;  //class that collects data
    
    int currentGraphType;
    int currentTimeframe;
    
    UINavigationItem *navBar; 
    UISegmentedControl *dateRangeControl;
    UISegmentedControl *graphTypeControl;
}

@property (nonatomic, retain) IBOutlet Graph_View *graphView;
@property (nonatomic, retain) Bowdoin_Buoy_App_iPhone_Graph_Data *dataModel;

@property (nonatomic) int currentGraphType;
@property (nonatomic) int currentTimeframe;

@property (nonatomic, retain) IBOutlet UINavigationItem *navBar;
@property (nonatomic, retain) IBOutlet UISegmentedControl *dateRangeControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *graphTypeControl;

//called when user interacts with segmented controls
- (IBAction)graphSegmentedControlIndexChanged;
- (IBAction)dateSegmentedControlIndexChanged;
- (IBAction)infoButtonPressed:(UIButton *)sender;


@end
