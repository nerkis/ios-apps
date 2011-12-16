//
//  Bowdoin_Buoy_App_iPhone_Graph_View_Controller.h
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky on 12/3/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graph_View.h"
#import "Bowdoin_Buoy_App_iPhone_Graph_Data.h"

@interface Bowdoin_Buoy_App_iPhone_Graph_View_Controller : 
    UIViewController <GraphViewDelegate>

{
    Graph_View *graphView;
    Bowdoin_Buoy_App_iPhone_Graph_Data *dataModel;
    NSArray *graphChoices;
    int currentGraphType;
    UINavigationItem *navBar;    
}

@property (nonatomic, retain) IBOutlet Graph_View *graphView;
@property (nonatomic, retain) Bowdoin_Buoy_App_iPhone_Graph_Data *dataModel;
@property (nonatomic, retain) NSArray *graphChoices;
@property (nonatomic) int currentGraphType;
@property (nonatomic, retain) IBOutlet UINavigationItem *navBar;

@end