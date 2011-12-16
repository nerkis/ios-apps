//
//  Bowdoin_Buoy_App_iPhone_Summary_View_Controller.m
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky on 11/19/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import "Bowdoin_Buoy_App_iPhone_Summary_View_Controller.h"
//#import "Bowdoin_Buoy_App_iPhone_Graph_View_Controller.h"

@implementation Bowdoin_Buoy_App_iPhone_Summary_View_Controller

@synthesize airTempDisplay, windSpeedDisplay, waveHeightDisplay, waterSurfaceDisplay, surfaceSalinityDisplay, chlorophyllDisplay, PARDisplay, locationDisplay, latitudeDisplay, longitudeDisplay, timeStampDisplay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewWillAppear: (BOOL)animated

{
    
    NSURL *buoyPageURL = 
        [NSURL URLWithString:@"http://gyre.umeoce.maine.edu/data/gomoos/buoy/html/D02.html"];
    NSString *wholePage = 
        [NSString stringWithContentsOfURL:buoyPageURL encoding:NSASCIIStringEncoding error:nil];

    
        
    
    NSString *airTempFiter = @"Air Temperature</a><i> </i> (-2m)</td><td>";
    NSString *windSpeedFilter = @"Wind Speed</a><i> [Primary] </i> (-2m)</td><td>";
    NSString *waveHeightFilter = @"Significant Wave Height</a><i> </i> (0m)</td><td>";
    NSString *waterSurfaceTempFilter = @"Water Temperature</a><i> </i> (2m)</td><td>";
    NSString *surfaceSalinityFilter = @"Salinity</a><i> </i> (2m)</td><td>";
    NSString *chlorophyllFilter = @"Average Chlorophyll Concentration</a><i> </i> (3m)</td><td>";
    NSString *PARFilter = @"Downwelling Irradiance of PAR (400-700nm)</a><i> </i> (0m)</td><td>";
    NSString *titleFilter = @"<h2>";
    NSString *latitudeFilter = @"<br><b>Latitude</b>: ";
    NSString *longitudeFilter = @"<br><b>Longitude</b>: ";
    NSString *timeStampFilter = @"<br><b>Last Cell Phone Transmission</b>: ";

    
    NSRange airTempRange = [wholePage rangeOfString:airTempFiter];
    NSRange windSpeedRange = [wholePage rangeOfString:windSpeedFilter];
    NSRange waveHeightRange = [wholePage rangeOfString:waveHeightFilter];
    NSRange waterSurfaceTempRange = [wholePage rangeOfString:waterSurfaceTempFilter];
    NSRange surfaceSalinityRange = [wholePage rangeOfString:surfaceSalinityFilter];
    NSRange chlorophyllRange = [wholePage rangeOfString:chlorophyllFilter];
    NSRange PARRange = [wholePage rangeOfString:PARFilter];
    NSRange titleRange = [wholePage rangeOfString:titleFilter];
    NSRange latitudeRange = [wholePage rangeOfString:latitudeFilter];
    NSRange longitudeRange = [wholePage rangeOfString:longitudeFilter];
    NSRange timeStampRange = [wholePage rangeOfString:timeStampFilter];

    
    NSRange titleBlockRange = NSMakeRange(titleRange.location+titleRange.length, 50);
    NSString *titleBlock = [wholePage substringWithRange:titleBlockRange];
    
    NSRange timeStampBlockRange = NSMakeRange(timeStampRange.location+timeStampRange.length, 50);
    NSString *timeStampBlock = [wholePage substringWithRange:timeStampBlockRange];
    
    NSRange latitudeBlockRange = NSMakeRange(latitudeRange.location+latitudeRange.length, 50);
    NSString *latitudeBlock = [wholePage substringWithRange:latitudeBlockRange];
    
    NSRange longitudeBlockRange = NSMakeRange(longitudeRange.location+longitudeRange.length, 50);
    NSString *longitudeBlock = [wholePage substringWithRange:longitudeBlockRange];
    
    NSRange airTempBlockRange = NSMakeRange(airTempRange.location+airTempRange.length, 30);
    NSString *airTempBlock = [wholePage substringWithRange:airTempBlockRange];
    
    NSRange windSpeedBlockRange = NSMakeRange(windSpeedRange.location+windSpeedRange.length, 30);
    NSString *windSpeedBlock = [wholePage substringWithRange:windSpeedBlockRange];

    NSRange waveHeightBlockRange = NSMakeRange(waveHeightRange.location+waveHeightRange.length, 30);
    NSString *waveHeightBlock = [wholePage substringWithRange:waveHeightBlockRange];

    NSRange waterSurfaceTempBlockRange = NSMakeRange(waterSurfaceTempRange.location+waterSurfaceTempRange.length, 30);
    NSString *waterSurfaceTempBlock = [wholePage substringWithRange:waterSurfaceTempBlockRange];

    NSRange surfaceSalinityBlockRange = NSMakeRange(surfaceSalinityRange.location+surfaceSalinityRange.length, 30);
    NSString *surfaceSalinityBlock = [wholePage substringWithRange:surfaceSalinityBlockRange];

    NSRange chlorophyllBlockRange = NSMakeRange(chlorophyllRange.location+chlorophyllRange.length, 30);
    NSString *chlorophyllBlock = [wholePage substringWithRange:chlorophyllBlockRange];

    NSRange PARBlockRange = NSMakeRange(PARRange.location+PARRange.length, 30);
    NSString *PARBlock = [wholePage substringWithRange:PARBlockRange];

    
    //NSLog(@"%@", titleBlock);
    NSRange titleEndRange = [titleBlock rangeOfString:@" :"];
    NSString *title = [titleBlock substringToIndex:titleEndRange.location];
    //NSLog(@"%@", title);
    self.title = title;
    
    //NSLog(@"%@", timeStampBlock);
    NSRange timeStampEndRange = [timeStampBlock rangeOfString:@"T"];
    NSString *timeStamp = [timeStampBlock substringToIndex:timeStampEndRange.location+1];
    //NSLog(@"%@", timeStamp);
    
    NSRange locationStartRange = [titleBlock rangeOfString:@": "];
    NSString *location = [titleBlock substringFromIndex:locationStartRange.location+locationStartRange.length];
    NSRange locationEndRange = [location rangeOfString:@"<"];
    location = [location substringToIndex:locationEndRange.location];
    //NSLog(@"%@", location);
    
    //NSLog(@"%@", latitudeBlock);
    NSRange latitudeEndRange = [latitudeBlock rangeOfString:@"#180;"];
    NSString *latitude = [latitudeBlock substringToIndex:latitudeEndRange.location+6];
    latitude = [latitude stringByReplacingOccurrencesOfString:@"&#180;" withString:@"´"];
    latitude = [latitude stringByReplacingOccurrencesOfString:@"&deg" withString:@"°"];
    //NSLog(@"%@", latitude);
    
    //NSLog(@"%@", longitudeBlock);
    NSRange longitudeEndRange = [longitudeBlock rangeOfString:@"#180;"];
    NSString *longitude = [longitudeBlock substringToIndex:longitudeEndRange.location+6];
    longitude = [longitude stringByReplacingOccurrencesOfString:@"&#180;" withString:@"´"];
    longitude = [longitude stringByReplacingOccurrencesOfString:@"&deg" withString:@"°"];
    //NSLog(@"%@", longitude);
    
    //NSLog(@"%@", airTempBlock);
    NSRange airTempEndRange = [airTempBlock rangeOfString:@")"];
    NSString *airTemp = [airTempBlock substringToIndex:airTempEndRange.location+1];
    //NSLog(@"%@", airTemp);
    
    //NSLog(@"%@", windSpeedBlock);
    NSRange windSpeedEndRange = [windSpeedBlock rangeOfString:@")"];
    NSString *windSpeed = [windSpeedBlock substringToIndex:windSpeedEndRange.location+1];
    //NSLog(@"%@", windSpeed);
    
    //NSLog(@"%@", waveHeightBlock);
    NSRange waveHeightEndRange = [waveHeightBlock rangeOfString:@")"];
    NSString *waveHeight = [waveHeightBlock substringToIndex:waveHeightEndRange.location+1];
    waveHeight = [waveHeight stringByReplacingOccurrencesOfString:@"meters" withString:@"m"];
    //NSLog(@"%@", waveHeight);
    
    //NSLog(@"%@", waterSurfaceTempBlock);
    NSRange waterSurfaceTempEndRange = [waterSurfaceTempBlock rangeOfString:@")"];
    NSString *surfaceTemp = [waterSurfaceTempBlock substringToIndex:waterSurfaceTempEndRange.location+1];
    //NSLog(@"%@", surfaceTemp);
    
    //NSLog(@"%@", surfaceSalinityBlock);
    NSRange surfaceSalinityEndRange = [surfaceSalinityBlock rangeOfString:@"u"];
    NSString *surfaceSalinity = [surfaceSalinityBlock substringToIndex:surfaceSalinityEndRange.location+1];
    //NSLog(@"%@", surfaceSalinity);
    
    //NSLog(@"%@", chlorophyllBlock);
    NSRange chlorophyllEndRange = [chlorophyllBlock rangeOfString:@"er"];
    NSString *chlorophyll = [chlorophyllBlock substringToIndex:chlorophyllEndRange.location+2];
    chlorophyll = [chlorophyll stringByReplacingOccurrencesOfString:@"micrograms/liter" withString:@"µg/L"];
    //NSLog(@"%@", chlorophyll);
    
    //NSLog(@"%@", PARBlock);
    NSRange PAREndRange = [PARBlock rangeOfString:@"s"];
    NSString *PAR = [PARBlock substringToIndex:PAREndRange.location+1];
    PAR = [PAR stringByReplacingOccurrencesOfString:@"microE/m^2/s" withString:@"µE/m^2/s"];
    //NSLog(@"%@", PAR);
    
    [self.airTempDisplay setText:airTemp];
    [self.windSpeedDisplay setText:windSpeed];
    [self.waveHeightDisplay setText:waveHeight];
    [self.waterSurfaceDisplay setText:surfaceTemp];
    [self.surfaceSalinityDisplay setText:surfaceSalinity];
    [self.chlorophyllDisplay setText:chlorophyll];
    [self.PARDisplay setText:PAR];
    [self.locationDisplay setText:location];
    [self.latitudeDisplay setText:latitude];
    [self.longitudeDisplay setText:longitude];
    [self.timeStampDisplay setText:timeStamp];
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)releaseOutlets
{
    [self.airTempDisplay release];
    [self.windSpeedDisplay release];
    [self.waveHeightDisplay release];
    [self.waterSurfaceDisplay release];
    [self.surfaceSalinityDisplay release];
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
