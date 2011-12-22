//
//  Bowdoin_Buoy_App_iPhone_Summary_Data.m
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky on 12/20/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import "Bowdoin_Buoy_App_iPhone_Summary_Data.h"

#define STANDARD_BLOCK_SIZE 50

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

#define TIMESTAMP_STRING_CUTOFF @"T"
#define TITLE_STRING_CUTOFF @" :"
#define CLOSED_PARENTHESIS @")"
#define GREATER_THAN @"<"
#define TITLE_SEPARATOR @": "

#define SALINITY_READING_UNITS_IDENTIFIER @"psu"

#define LONG_WAVE_HEIGHT_READING_UNITS_IDENTIFIER @"meters"
#define WAVE_HEIGHT_READING_UNITS_IDENTIFIER @"m"

#define LONG_CHLOROPHYLL_READING_UNITS_IDENTIFIER @"micrograms/liter"
#define CHLOROPHYLL_READING_UNITS_IDENTIFIER @"µg/L"

#define LONG_PAR_READING_UNITS_IDENTIFIER @"microE/m^2/s"
#define PAR_READING_UNITS_IDENTIFIER @"µE/m^2/s"

#define POSITION_MINUTES_IDENTIFIER @"#180;"
#define LONG_POSITION_MINUTES_IDENTIFIER @"&#180;"
#define POSITION_DEGREES_IDENTIFIER @"&deg"

#define POSITION_MINUTES_SYMBOL @"´"
#define POSITION_DEGREES_SYMBOL @"°"



@implementation Bowdoin_Buoy_App_iPhone_Summary_Data

@synthesize airTempProperty, windSpeedProperty, waveHeightProperty, waterTempProperty, salinityProperty, chlorophyllProperty, PARProperty, locationProperty, longitudeProperty, latitudeProperty, timeStampProperty, title;

@synthesize webPageAsString;

- (void)grabHTMLfromURL:(NSURL *)fileURL 
{
    self.webPageAsString = [NSString stringWithContentsOfURL:fileURL encoding:NSASCIIStringEncoding error:nil];
}

/*---------- GETS AND SETS THE PROPERTIES ----------*/

/*
    These methods grab a block of text from the main page by looking for an identifier. They then trim it and format it to the appropriate size and layout, finally setting the property
 */
- (void)getAirTemperature
{
    NSRange airTempRange = [self.webPageAsString rangeOfString:AIR_TEMP_FILTER];
    
    NSRange airTempBlockRange = NSMakeRange(airTempRange.location+airTempRange.length, STANDARD_BLOCK_SIZE);
    NSString *airTempBlock = [self.webPageAsString substringWithRange:airTempBlockRange];
    NSRange airTempEndRange = [airTempBlock rangeOfString:CLOSED_PARENTHESIS];
    self.airTempProperty = [airTempBlock substringToIndex:airTempEndRange.location+CLOSED_PARENTHESIS.length];    
}

- (void)getWindSpeed
{
    NSRange windSpeedRange = [self.webPageAsString rangeOfString:WIND_SPEED_FILTER];
    
    NSRange windSpeedBlockRange = NSMakeRange(windSpeedRange.location+windSpeedRange.length, STANDARD_BLOCK_SIZE);
    NSString *windSpeedBlock = [self.webPageAsString substringWithRange:windSpeedBlockRange];
    NSRange windSpeedEndRange = [windSpeedBlock rangeOfString:CLOSED_PARENTHESIS];
    self.windSpeedProperty = [windSpeedBlock substringToIndex:windSpeedEndRange.location+CLOSED_PARENTHESIS.length];
    
}

- (void)getWaveHeight 
{
    NSRange waveHeightRange = [self.webPageAsString rangeOfString:WAVE_HEIGHT_FILTER];
    
    NSRange waveHeightBlockRange = NSMakeRange(waveHeightRange.location+waveHeightRange.length, STANDARD_BLOCK_SIZE);
    NSString *waveHeightBlock = [self.webPageAsString substringWithRange:waveHeightBlockRange];
    NSRange waveHeightEndRange = [waveHeightBlock rangeOfString:CLOSED_PARENTHESIS];
    self.waveHeightProperty = [waveHeightBlock substringToIndex:waveHeightEndRange.location+CLOSED_PARENTHESIS.length];
    self.waveHeightProperty = [self.waveHeightProperty stringByReplacingOccurrencesOfString:LONG_WAVE_HEIGHT_READING_UNITS_IDENTIFIER withString:WAVE_HEIGHT_READING_UNITS_IDENTIFIER];
}

- (void)getWaterTemperature
{
    NSRange waterTempRange = [self.webPageAsString rangeOfString:WATER_TEMPERATURE_FILTER];
    
    NSRange waterTempBlockRange = NSMakeRange(waterTempRange.location+waterTempRange.length, STANDARD_BLOCK_SIZE);
    NSString *waterTempBlock = [self.webPageAsString substringWithRange:waterTempBlockRange];
    NSRange waterTempEndRange = [waterTempBlock rangeOfString:CLOSED_PARENTHESIS];
    self.waterTempProperty = [waterTempBlock substringToIndex:waterTempEndRange.location+CLOSED_PARENTHESIS.length];
}

- (void)getSalinity 
{
    NSRange salinityRange = [self.webPageAsString rangeOfString:SALINITY_FILTER];
    
    NSRange salinityBlockRange = NSMakeRange(salinityRange.location+salinityRange.length, STANDARD_BLOCK_SIZE);
    NSString *salinityBlock = [self.webPageAsString substringWithRange:salinityBlockRange];
    NSRange salinityEndRange = [salinityBlock rangeOfString:SALINITY_READING_UNITS_IDENTIFIER];
    self.salinityProperty = [salinityBlock substringToIndex:salinityEndRange.location+SALINITY_READING_UNITS_IDENTIFIER.length];
}

- (void)getChlorophyll 
{
    NSRange chlorophyllRange = [self.webPageAsString rangeOfString:CHLOROPHYLL_FILTER];
    
    NSRange chlorophyllBlockRange = NSMakeRange(chlorophyllRange.location+chlorophyllRange.length, STANDARD_BLOCK_SIZE);
    NSString *chlorophyllBlock = [self.webPageAsString substringWithRange:chlorophyllBlockRange];
    NSRange chlorophyllEndRange = [chlorophyllBlock rangeOfString:LONG_CHLOROPHYLL_READING_UNITS_IDENTIFIER];
    self.chlorophyllProperty = [chlorophyllBlock substringToIndex:chlorophyllEndRange.location+LONG_CHLOROPHYLL_READING_UNITS_IDENTIFIER.length];
    self.chlorophyllProperty = [self.chlorophyllProperty stringByReplacingOccurrencesOfString:LONG_CHLOROPHYLL_READING_UNITS_IDENTIFIER withString:CHLOROPHYLL_READING_UNITS_IDENTIFIER];
}

- (void)getPAR 
{
    NSRange PARRange = [self.webPageAsString rangeOfString:PAR_FILTER];
    
    NSRange PARBlockRange = NSMakeRange(PARRange.location+PARRange.length, STANDARD_BLOCK_SIZE);
    NSString *PARBlock = [self.webPageAsString substringWithRange:PARBlockRange];
    NSRange PAREndRange = [PARBlock rangeOfString:LONG_PAR_READING_UNITS_IDENTIFIER];
    self.PARProperty = [PARBlock substringToIndex:PAREndRange.location+LONG_PAR_READING_UNITS_IDENTIFIER.length];
    self.PARProperty = [self.PARProperty stringByReplacingOccurrencesOfString:LONG_PAR_READING_UNITS_IDENTIFIER withString:PAR_READING_UNITS_IDENTIFIER];
}

- (void)getTitleAndPosition
{
    NSRange titleRange = [self.webPageAsString rangeOfString:TITLE_FILTER];
    
    NSRange titleBlockRange = NSMakeRange(titleRange.location+titleRange.length, STANDARD_BLOCK_SIZE);
    NSString *titleBlock = [self.webPageAsString substringWithRange:titleBlockRange];
    NSRange titleEndRange = [titleBlock rangeOfString:TITLE_STRING_CUTOFF];
    NSString *titleString = [titleBlock substringToIndex:titleEndRange.location];
    self.title = titleString;
    
    
    NSRange latitudeRange = [self.webPageAsString rangeOfString:LATITUDE_FILTER];
    
    NSRange latitudeBlockRange = NSMakeRange(latitudeRange.location+latitudeRange.length, STANDARD_BLOCK_SIZE);
    NSString *latitudeBlock = [self.webPageAsString substringWithRange:latitudeBlockRange];
    NSRange latitudeEndRange = [latitudeBlock rangeOfString:POSITION_MINUTES_IDENTIFIER];
    self.latitudeProperty = [latitudeBlock substringToIndex:latitudeEndRange.location+LONG_POSITION_MINUTES_IDENTIFIER.length];
    self.latitudeProperty = [self.latitudeProperty stringByReplacingOccurrencesOfString:LONG_POSITION_MINUTES_IDENTIFIER withString:POSITION_MINUTES_SYMBOL];
    self.latitudeProperty = [self.latitudeProperty stringByReplacingOccurrencesOfString:POSITION_DEGREES_IDENTIFIER withString:POSITION_DEGREES_SYMBOL];
    
    
    NSRange longitudeRange = [self.webPageAsString rangeOfString:LONGITUDE_FILTER];
    
    NSRange longitudeBlockRange = NSMakeRange(longitudeRange.location+longitudeRange.length, STANDARD_BLOCK_SIZE);
    NSString *longitudeBlock = [self.webPageAsString substringWithRange:longitudeBlockRange];
    NSRange longitudeEndRange = [longitudeBlock rangeOfString:POSITION_MINUTES_IDENTIFIER];
    self.longitudeProperty = [longitudeBlock substringToIndex:longitudeEndRange.location+LONG_POSITION_MINUTES_IDENTIFIER.length];
    self.longitudeProperty = [self.longitudeProperty stringByReplacingOccurrencesOfString:LONG_POSITION_MINUTES_IDENTIFIER withString:POSITION_MINUTES_SYMBOL];
    self.longitudeProperty = [self.longitudeProperty stringByReplacingOccurrencesOfString:POSITION_DEGREES_IDENTIFIER withString:POSITION_DEGREES_SYMBOL];
    
    NSRange locationStartRange = [titleBlock rangeOfString:TITLE_SEPARATOR];
    self.locationProperty = [titleBlock substringFromIndex:locationStartRange.location+locationStartRange.length];
    NSRange locationEndRange = [self.locationProperty rangeOfString:GREATER_THAN];
    self.locationProperty = [self.locationProperty substringToIndex:locationEndRange.location];
    
}

- (void)getTimeStamp 
{
    NSRange timeStampRange = [self.webPageAsString rangeOfString:TIMESTAMP_FILTER];
    
    NSRange timeStampBlockRange = NSMakeRange(timeStampRange.location+timeStampRange.length, STANDARD_BLOCK_SIZE);
    NSString *timeStampBlock = [self.webPageAsString substringWithRange:timeStampBlockRange];
    NSRange timeStampEndRange = [timeStampBlock rangeOfString:TIMESTAMP_STRING_CUTOFF];
    self.timeStampProperty = [timeStampBlock substringToIndex:timeStampEndRange.location+TIMESTAMP_STRING_CUTOFF.length];
    
}

- (void)setProperties
{
    [self getAirTemperature];
    [self getWaterTemperature];
    [self getSalinity];
    [self getWaveHeight];
    [self getWindSpeed];
    [self getChlorophyll];
    [self getPAR];    
    [self getTimeStamp];
    [self getTitleAndPosition];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self grabHTMLfromURL:[NSURL URLWithString:@"http://gyre.umeoce.maine.edu/data/gomoos/buoy/html/D02.html"]];
        [self setProperties];  
    }
    
    return self;
}

@end
