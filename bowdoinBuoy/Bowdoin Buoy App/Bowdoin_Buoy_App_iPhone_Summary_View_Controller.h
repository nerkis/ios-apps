//
//  Bowdoin_Buoy_App_iPhone_Summary_View_Controller.h
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky on 11/19/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bowdoin_Buoy_App_iPhone_Summary_View_Controller : UIViewController 
{    
    IBOutlet UILabel *airTempDisplay;
    IBOutlet UILabel *windSpeedDisplay;
    IBOutlet UILabel *waveHeightDisplay;
    IBOutlet UILabel *waterSurfaceDisplay;
    IBOutlet UILabel *surfaceSalinityDisplay;
    IBOutlet UILabel *chlorophyllDisplay;
    IBOutlet UILabel *PARDisplay;
    IBOutlet UILabel *locationDisplay;
    IBOutlet UILabel *latitudeDisplay;
    IBOutlet UILabel *longitudeDisplay;
    IBOutlet UILabel *timeStampDisplay;
}

@property (nonatomic, retain) IBOutlet UILabel *airTempDisplay;
@property (nonatomic, retain) IBOutlet UILabel *windSpeedDisplay;
@property (nonatomic, retain) IBOutlet UILabel *waveHeightDisplay;
@property (nonatomic, retain) IBOutlet UILabel *waterSurfaceDisplay;
@property (nonatomic, retain) IBOutlet UILabel *surfaceSalinityDisplay;
@property (nonatomic, retain) IBOutlet UILabel *chlorophyllDisplay;
@property (nonatomic, retain) IBOutlet UILabel *PARDisplay;
@property (nonatomic, retain) IBOutlet UILabel *locationDisplay;
@property (nonatomic, retain) IBOutlet UILabel *latitudeDisplay;
@property (nonatomic, retain) IBOutlet UILabel *longitudeDisplay;
@property (nonatomic, retain) IBOutlet UILabel *timeStampDisplay;

@end
