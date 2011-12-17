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

// identifiers that indicate location of current conditions in the HTML
#define AIR_TEMP_FILTER @"Air Temperature</a><i> </i> (-2m)</td><td>"
#define WIND_SPEED_FILTER @"Wind Speed</a><i> [Primary] </i> (-2m)</td><td>"
#define WAVE_HEIGHT_FILTER @"Significant Wave Height</a><i> </i> (0m)</td><td>"
#define WATER_TEMPERATURE_FILTER @"Water Temperature</a><i> </i> (2m)</td><td>"
#define SALINITY_FILTER @"Salinity</a><i> </i> (2m)</td><td>"
#define CHLOROPHYLL_FILTER @"Average Chlorophyll Concentration</a><i> </i> (3m)</td><td>"
#define PAR_FILTER @"Downwelling Irradiance of PAR (400-700nm)</a><i> </i> (0m)</td><td>"
#define TITLE_FILTER @"<h2>"
#define LATITUDE_FILTER @"<br><b>Latitude</b>: "
#define LONGITUDE_FILTER @"<br><b>Longitude</b>: "
#define TIMESTAMP_FILTER @"<br><b>Last Cell Phone Transmission</b>: "


@implementation Bowdoin_Buoy_App_iPhone_Summary_View_Controller

@synthesize airTempDisplay, windSpeedDisplay, waveHeightDisplay, waterTempDisplay, salinityDisplay, chlorophyllDisplay, PARDisplay, locationDisplay, latitudeDisplay, longitudeDisplay, timeStampDisplay;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

- (void)viewDidLoad {[super viewDidLoad];}

- (void)viewDidUnload {[super viewDidUnload];}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


/* sets labels to display current conditions in summary view.
 * 
 * grabs HTML of web page containing current conditions, scans
 * the resulting string for the conditions, and sets labels to
 * display them.
 */
- (void)viewWillAppear: (BOOL)animated
{
    //access HTML of web page and convert contents to a string
    NSURL *buoyPageURL = 
    [NSURL URLWithString:@"http://gyre.umeoce.maine.edu/data/gomoos/buoy/html/D02.html"];
    NSString *wholePage = 
    [NSString stringWithContentsOfURL:buoyPageURL encoding:NSASCIIStringEncoding error:nil];
    
    
    //find the location of each identifier
    NSRange airTempRange = [wholePage rangeOfString:AIR_TEMP_FILTER];
    NSRange windSpeedRange = [wholePage rangeOfString:WIND_SPEED_FILTER];
    NSRange waveHeightRange = [wholePage rangeOfString:WAVE_HEIGHT_FILTER];
    NSRange waterTempRange = [wholePage rangeOfString:WATER_TEMPERATURE_FILTER];
    NSRange salinityRange = [wholePage rangeOfString:SALINITY_FILTER];
    NSRange chlorophyllRange = [wholePage rangeOfString:CHLOROPHYLL_FILTER];
    NSRange PARRange = [wholePage rangeOfString:PAR_FILTER];
    NSRange titleRange = [wholePage rangeOfString:TITLE_FILTER];
    NSRange latitudeRange = [wholePage rangeOfString:LATITUDE_FILTER];
    NSRange longitudeRange = [wholePage rangeOfString:LONGITUDE_FILTER];
    NSRange timeStampRange = [wholePage rangeOfString:TIMESTAMP_FILTER];
    
    
    // using the location of the identifier and the range of an end 
    // identifier, grabs text containing relevant buoy information
    NSRange titleBlockRange = NSMakeRange(titleRange.location+titleRange.length, 50);
    NSString *titleBlock = [wholePage substringWithRange:titleBlockRange];
    NSRange titleEndRange = [titleBlock rangeOfString:@" :"];
    NSString *title = [titleBlock substringToIndex:titleEndRange.location];
    self.title = title;
    
    NSRange timeStampBlockRange = NSMakeRange(timeStampRange.location+timeStampRange.length, 50);
    NSString *timeStampBlock = [wholePage substringWithRange:timeStampBlockRange];
    NSRange timeStampEndRange = [timeStampBlock rangeOfString:@"T"];
    NSString *timeStamp = [timeStampBlock substringToIndex:timeStampEndRange.location+1];
    
    NSRange latitudeBlockRange = NSMakeRange(latitudeRange.location+latitudeRange.length, 50);
    NSString *latitudeBlock = [wholePage substringWithRange:latitudeBlockRange];
    NSRange latitudeEndRange = [latitudeBlock rangeOfString:@"#180;"];
    NSString *latitude = [latitudeBlock substringToIndex:latitudeEndRange.location+6];
    latitude = [latitude stringByReplacingOccurrencesOfString:@"&#180;" withString:@"´"];
    latitude = [latitude stringByReplacingOccurrencesOfString:@"&deg" withString:@"°"];
    
    NSRange longitudeBlockRange = NSMakeRange(longitudeRange.location+longitudeRange.length, 50);
    NSString *longitudeBlock = [wholePage substringWithRange:longitudeBlockRange];
    NSRange longitudeEndRange = [longitudeBlock rangeOfString:@"#180;"];
    NSString *longitude = [longitudeBlock substringToIndex:longitudeEndRange.location+6];
    longitude = [longitude stringByReplacingOccurrencesOfString:@"&#180;" withString:@"´"];
    longitude = [longitude stringByReplacingOccurrencesOfString:@"&deg" withString:@"°"];
    
    NSRange locationStartRange = [titleBlock rangeOfString:@": "];
    NSString *location = [titleBlock substringFromIndex:locationStartRange.location+locationStartRange.length];
    NSRange locationEndRange = [location rangeOfString:@"<"];
    location = [location substringToIndex:locationEndRange.location];
    
    
    // using the location of the identifier and the range of an end 
    // identifier, grabs text containing relevant current condition information
    NSRange airTempBlockRange = NSMakeRange(airTempRange.location+airTempRange.length, 30);
    NSString *airTempBlock = [wholePage substringWithRange:airTempBlockRange];
    NSRange airTempEndRange = [airTempBlock rangeOfString:@")"];
    NSString *airTemp = [airTempBlock substringToIndex:airTempEndRange.location+1];
    
    NSRange windSpeedBlockRange = NSMakeRange(windSpeedRange.location+windSpeedRange.length, 30);
    NSString *windSpeedBlock = [wholePage substringWithRange:windSpeedBlockRange];
    NSRange windSpeedEndRange = [windSpeedBlock rangeOfString:@")"];
    NSString *windSpeed = [windSpeedBlock substringToIndex:windSpeedEndRange.location+1];
    
    NSRange waveHeightBlockRange = NSMakeRange(waveHeightRange.location+waveHeightRange.length, 30);
    NSString *waveHeightBlock = [wholePage substringWithRange:waveHeightBlockRange];
    NSRange waveHeightEndRange = [waveHeightBlock rangeOfString:@")"];
    NSString *waveHeight = [waveHeightBlock substringToIndex:waveHeightEndRange.location+1];
    waveHeight = [waveHeight stringByReplacingOccurrencesOfString:@"meters" withString:@"m"];
    
    NSRange waterTempBlockRange = NSMakeRange(waterTempRange.location+waterTempRange.length, 30);
    NSString *waterTempBlock = [wholePage substringWithRange:waterTempBlockRange];
    NSRange waterTempEndRange = [waterTempBlock rangeOfString:@")"];
    NSString *waterTemp = [waterTempBlock substringToIndex:waterTempEndRange.location+1];
    
    NSRange salinityBlockRange = NSMakeRange(salinityRange.location+salinityRange.length, 30);
    NSString *salinityBlock = [wholePage substringWithRange:salinityBlockRange];
    NSRange salinityEndRange = [salinityBlock rangeOfString:@"u"];
    NSString *salinity = [salinityBlock substringToIndex:salinityEndRange.location+1];
    
    NSRange chlorophyllBlockRange = NSMakeRange(chlorophyllRange.location+chlorophyllRange.length, 30);
    NSString *chlorophyllBlock = [wholePage substringWithRange:chlorophyllBlockRange];
    NSRange chlorophyllEndRange = [chlorophyllBlock rangeOfString:@"er"];
    NSString *chlorophyll = [chlorophyllBlock substringToIndex:chlorophyllEndRange.location+2];
    chlorophyll = [chlorophyll stringByReplacingOccurrencesOfString:@"micrograms/liter" withString:@"µg/L"];
    
    NSRange PARBlockRange = NSMakeRange(PARRange.location+PARRange.length, 30);
    NSString *PARBlock = [wholePage substringWithRange:PARBlockRange];
    NSRange PAREndRange = [PARBlock rangeOfString:@"s"];
    NSString *PAR = [PARBlock substringToIndex:PAREndRange.location+1];
    PAR = [PAR stringByReplacingOccurrencesOfString:@"microE/m^2/s" withString:@"µE/m^2/s"];
    
    
    //sets label text
    [self.airTempDisplay setText:airTemp];
    [self.windSpeedDisplay setText:windSpeed];
    [self.waveHeightDisplay setText:waveHeight];
    [self.waterTempDisplay setText:waterTemp];
    [self.salinityDisplay setText:salinity];
    [self.chlorophyllDisplay setText:chlorophyll];
    [self.PARDisplay setText:PAR];
    [self.locationDisplay setText:location];
    [self.latitudeDisplay setText:latitude];
    [self.longitudeDisplay setText:longitude];
    [self.timeStampDisplay setText:timeStamp];
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
