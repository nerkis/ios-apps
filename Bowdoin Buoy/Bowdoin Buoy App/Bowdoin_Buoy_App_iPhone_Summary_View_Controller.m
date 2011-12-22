//
//  Bowdoin_Buoy_App_iPhone_Summary_View_Controller.m
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky on 11/19/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//
//  A class that displays a summary of the current conditions
//  at Bowdoin's buoy D0205.
//

#import "Bowdoin_Buoy_App_iPhone_Summary_View_Controller.h"

@implementation Bowdoin_Buoy_App_iPhone_Summary_View_Controller

@synthesize airTempDisplay, windSpeedDisplay, waveHeightDisplay, waterTempDisplay, salinityDisplay, chlorophyllDisplay, PARDisplay, locationDisplay, latitudeDisplay, longitudeDisplay, timeStampDisplay;

@synthesize summaryData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

- (void)viewDidLoad {[super viewDidLoad];}

- (void)viewDidUnload {[super viewDidUnload];}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (Bowdoin_Buoy_App_iPhone_Summary_Data *)summaryData
{
    if (!summaryData)
    {
        summaryData = [[Bowdoin_Buoy_App_iPhone_Summary_Data alloc] init];
    }
    return summaryData;
}	

- (void)updateOutlets
{
    //updates the text displays
    [self.airTempDisplay setText:self.summaryData.airTempProperty];
    [self.windSpeedDisplay setText:self.summaryData.windSpeedProperty];
    [self.waveHeightDisplay setText:self.summaryData.waveHeightProperty];
    [self.waterTempDisplay setText:self.summaryData.waterTempProperty];
    [self.salinityDisplay setText:self.summaryData.salinityProperty];
    [self.chlorophyllDisplay setText:self.summaryData.chlorophyllProperty];
    [self.PARDisplay setText:self.summaryData.PARProperty];
    [self.locationDisplay setText:self.summaryData.locationProperty];
    [self.latitudeDisplay setText:self.summaryData.latitudeProperty];
    [self.longitudeDisplay setText:self.summaryData.longitudeProperty];
    [self.timeStampDisplay setText:self.summaryData.timeStampProperty];
}


/* sets labels to display current conditions in summary view.
 * 
 * grabs HTML of web page containing current conditions, scans
 * the resulting string for the conditions, and sets labels to
 * display them.
 */
- (void)viewWillAppear: (BOOL)animated
{
    [self updateOutlets];
}


- (void)releaseOutlets
{
    [self.airTempDisplay release];
    [self.windSpeedDisplay release];
    [self.waveHeightDisplay release];
    [self.waterTempDisplay release];
    [self.salinityDisplay release];
    [self.chlorophyllDisplay release];
    [self.PARDisplay release];
    [self.locationDisplay release];
    [self.latitudeDisplay release];
    [self.longitudeDisplay release];
    [self.timeStampDisplay release];
}

- (void)dealloc
{
    [super dealloc];
    [self releaseOutlets];
}

@end
