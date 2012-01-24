//
//  Bowdoin_Buoy_App_iPhone_Graph_Data.m
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky and Nicole Erkis on 12/14/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//
//  A class that downloads data from the UMaine buoy website.
//  The data from each sensor is parsed into two types of 
//  dictionaries: one where each key maps to the data for one 
//  hour, and one where each key maps to the data for one day.
//

#import "Bowdoin_Buoy_App_iPhone_Graph_Data.h"

@implementation Bowdoin_Buoy_App_iPhone_Graph_Data

@synthesize sensorSBE37DataForHourDictionaryForTwoMeterWater, sensorSBE37DataForDayDictionaryForTwoMeterWater;

@synthesize sensorSBE16DataForHourDictionaryForTenMeterWater, sensorSBE16DataForDayDictionaryForTenMeterWater;

@synthesize sensorSBE16DataForHourDictionaryForTwentyMeterWater, sensorSBE16DataForDayDictionaryForTwentyMeterWater;

@synthesize sensorOptics_SDataForHourDictionary, sensorOptics_SDataForDayDictionary;


//constants for graph types
#define TWO_METER_WATER 0
#define TEN_METER_WATER 1
#define TWENTY_METER_WATER 2

#define TWO_METER_WATER_TEMP 10
#define TEN_METER_WATER_TEMP 11
#define TWENTY_METER_WATER_TEMP 12

#define TWO_METER_WATER_SALINITY 100
#define TEN_METER_WATER_SALINITY 111
#define TWENTY_METER_WATER_SALINITY 122

#define CHLOROPHYLL_IDENTIFIER 25000

//constants for date ranges
#define DAY_INTERVAL 1
#define WEEK_INTERVAL 7
#define MONTH_INTERVAL 28


- (id)init {
    self = [super init];
    if (self) {}
    return self;}


/* sets the URL for each data set and calls  
 * |readFromURLfor...| to download the data for each one
 */
- (void)downloadAllData
{
    NSURL *twoMeterWaterTempAndSalinityURL = 
    [NSURL URLWithString:@"http://gyre.umeoce.maine.edu/data/gomoos/buoy/php/view_csv_file.php?ncfile=/data/gomoos/buoy/archive/D0205/realtime/D0205.sbe37.realtime.2m.nc"];
    
    NSURL *tenMeterWaterTempAndSalinityURL = 
    [NSURL URLWithString:@"http://gyre.umeoce.maine.edu/data/gomoos/buoy/php/view_csv_file.php?ncfile=/data/gomoos/buoy/archive/D0205/realtime/D0205.sbe16.disox.realtime.10m.nc"];
    
    NSURL *twentyMeterWaterAndSalinityTempURL = 
    [NSURL URLWithString:@"http://gyre.umeoce.maine.edu/data/gomoos/buoy/php/view_csv_file.php?ncfile=/data/gomoos/buoy/archive/D0205/realtime/D0205.sbe16.disox.realtime.20m.nc"];
    
    NSURL *sensorThatHasChlorophyllURL = 
    [NSURL URLWithString:@"http://gyre.umeoce.maine.edu/data/gomoos/buoy/php/view_csv_file.php?ncfile=/data/gomoos/buoy/archive/D0205/realtime/D0205.optics_s.bowdoin.realtime.nc"];
    
    [self readFromURLforTwoMeterWater:twoMeterWaterTempAndSalinityURL];
    [self readFromURLforTenMeterWater:tenMeterWaterTempAndSalinityURL];
    [self readFromURLforTwentyMeterWater:twentyMeterWaterAndSalinityTempURL];
    [self readFromURLforChlorophyll:sensorThatHasChlorophyllURL];
}


/*---------- METHODS TO DOWNLOAD DATA FILE FOR EACH SENSOR ----------*/
/*---------- AND CREATE DICTIONARIES USING HOURS FOR KEYS  ----------*/

- (void)readFromURLforTwoMeterWater:(NSURL *)fileURL
{
    //creates a string to hold data file contents
    NSString *fileString = [NSString stringWithContentsOfURL:fileURL 
                                                    encoding:NSUTF8StringEncoding 
                                                       error:nil];
    
    //scanner setup
    NSScanner *scanner = [NSScanner scannerWithString:fileString];
    NSString *line, *time;
    float salinity, sigma_t, conductivity, temperature;
    self.sensorSBE37DataForHourDictionaryForTwoMeterWater = [NSMutableDictionary dictionaryWithCapacity:10];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
    
    //scans the file and parses it into dictionary with hours as keys
    while ([scanner scanUpToString:@"\n" intoString:&line])
    {
        NSScanner *lineParser = [NSScanner scannerWithString:line];
        [lineParser setCharactersToBeSkipped:
         [NSCharacterSet characterSetWithCharactersInString:@", "]];
        [lineParser scanUpToString:@"," intoString:&time];
        [lineParser scanFloat:&salinity];
        [lineParser scanFloat:&sigma_t];
        [lineParser scanFloat:&conductivity];
        [lineParser scanFloat:&temperature];
        NSArray *data = [NSArray arrayWithObjects:
                         [NSNumber numberWithFloat:salinity],
                         [NSNumber numberWithFloat:sigma_t],
                         [NSNumber numberWithFloat:conductivity],
                         [NSNumber numberWithFloat:temperature], nil];
        
        [self.sensorSBE37DataForHourDictionaryForTwoMeterWater setObject:data forKey:time];
    }

    //calls method to create dictionary with days as keys
    [self buildDayTemperatureAndSalinityDictionaryWithGraphType:TWO_METER_WATER];
}

- (void)readFromURLforTenMeterWater:(NSURL *)fileURL
{
    //creates a string to hold data file contents
    NSString *fileString = [NSString stringWithContentsOfURL:fileURL 
                                                    encoding:NSUTF8StringEncoding 
                                                       error:nil];
    
    //scanner setup
    NSScanner *scanner = [NSScanner scannerWithString:fileString];
    NSString *line, *time;
    float temperature, salinity, sigma_t, dissolved_oxygen, oxygen_saturation, percent_oxygen_saturation, conductivity;
    self.sensorSBE16DataForHourDictionaryForTenMeterWater = [NSMutableDictionary dictionaryWithCapacity:10];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
    
    //scans the file and parses it into dictionary with hours as keys
    while ([scanner scanUpToString:@"\n" intoString:&line])
    {
        NSScanner *lineParser = [NSScanner scannerWithString:line];
        [lineParser setCharactersToBeSkipped:
         [NSCharacterSet characterSetWithCharactersInString:@", "]];
        [lineParser scanUpToString:@"," intoString:&time];
        [lineParser scanFloat:&temperature];
        [lineParser scanFloat:&salinity];
        [lineParser scanFloat:&sigma_t];
        [lineParser scanFloat:&dissolved_oxygen];
        [lineParser scanFloat:&oxygen_saturation];
        [lineParser scanFloat:&percent_oxygen_saturation];
        [lineParser scanFloat:&conductivity];
        NSArray *data = [NSArray arrayWithObjects:
                         [NSNumber numberWithFloat:temperature],
                         [NSNumber numberWithFloat:salinity],
                         [NSNumber numberWithFloat:sigma_t],
                         [NSNumber numberWithFloat:dissolved_oxygen],
                         [NSNumber numberWithFloat:oxygen_saturation],
                         [NSNumber numberWithFloat:percent_oxygen_saturation],
                         [NSNumber numberWithFloat:conductivity], nil];
        
        [self.sensorSBE16DataForHourDictionaryForTenMeterWater setObject:data forKey:time];        
    }
    
    //calls method to create dictionary with days as keys
    [self buildDayTemperatureAndSalinityDictionaryWithGraphType:TEN_METER_WATER];
}

- (void)readFromURLforTwentyMeterWater:(NSURL *)fileURL
{
    //creates a string to hold data file contents
    NSString *fileString = [NSString stringWithContentsOfURL:fileURL 
                                                    encoding:NSUTF8StringEncoding 
                                                       error:nil];
   
    //scanner setup
    NSScanner *scanner = [NSScanner scannerWithString:fileString];
    NSString *line, *time;
    float temperature, salinity, sigma_t, dissolved_oxygen, oxygen_saturation, percent_oxygen_saturation, conductivity;
    self.sensorSBE16DataForHourDictionaryForTwentyMeterWater = [NSMutableDictionary dictionaryWithCapacity:10];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
    
    //scans the file and parses it into dictionary with hours as keys
    while ([scanner scanUpToString:@"\n" intoString:&line])
    {
        NSScanner *lineParser = [NSScanner scannerWithString:line];
        [lineParser setCharactersToBeSkipped:
         [NSCharacterSet characterSetWithCharactersInString:@", "]];
        [lineParser scanUpToString:@"," intoString:&time];
        [lineParser scanFloat:&temperature];
        [lineParser scanFloat:&salinity];
        [lineParser scanFloat:&sigma_t];
        [lineParser scanFloat:&dissolved_oxygen];
        [lineParser scanFloat:&oxygen_saturation];
        [lineParser scanFloat:&percent_oxygen_saturation];
        [lineParser scanFloat:&conductivity];
        NSArray *data = [NSArray arrayWithObjects:
                         [NSNumber numberWithFloat:temperature],
                         [NSNumber numberWithFloat:salinity],
                         [NSNumber numberWithFloat:sigma_t],
                         [NSNumber numberWithFloat:dissolved_oxygen],
                         [NSNumber numberWithFloat:oxygen_saturation],
                         [NSNumber numberWithFloat:percent_oxygen_saturation],
                         [NSNumber numberWithFloat:conductivity], nil];
        
        [self.sensorSBE16DataForHourDictionaryForTwentyMeterWater setObject:data forKey:time];        
    }

    //calls method to create dictionary with days as keys
    [self buildDayTemperatureAndSalinityDictionaryWithGraphType:TWENTY_METER_WATER];
}

- (void)readFromURLforChlorophyll:(NSURL *)fileURL
{
    //creates a string to hold data file contents
    NSString *fileString = [NSString stringWithContentsOfURL:fileURL 
                                                    encoding:NSUTF8StringEncoding 
                                                       error:nil];
    
    //scanner setup
    NSScanner *scanner = [NSScanner scannerWithString:fileString];
    NSString *line, *time;
    float chlorophyll, QSE, turbidity;
    self.sensorOptics_SDataForHourDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
    
    //scans the file and parses it into dictionary with hours as keys
    while ([scanner scanUpToString:@"\n" intoString:&line])
    {
        NSScanner *lineParser = [NSScanner scannerWithString:line];
        [lineParser setCharactersToBeSkipped:
         [NSCharacterSet characterSetWithCharactersInString:@", "]];
        [lineParser scanUpToString:@"," intoString:&time];
        [lineParser scanFloat:&chlorophyll];
        [lineParser scanFloat:&QSE];
        [lineParser scanFloat:&turbidity];
        
        NSArray *data = [NSArray arrayWithObjects:
                         [NSNumber numberWithFloat:chlorophyll],
                         [NSNumber numberWithFloat:QSE],
                         [NSNumber numberWithFloat:turbidity], nil];
        
        [self.sensorOptics_SDataForHourDictionary setObject:data forKey:time];        
    }

    //calls method to create dictionary with days as keys
    [self buildDayChlorophyll];
}


/*---------- METHODS TO CREATE DICTIONARIES USING DAYS FOR KEYS ----------*/

/* creates dictionary of per-day data for sensors that provide 
 * temperature and salinity data
 */
- (void)buildDayTemperatureAndSalinityDictionaryWithGraphType:(int)type
{
    NSArray *allOfTheDataInOrderList;
    
    //gets per-hour dictionary depending on depth of water requested
    //and creates an array of the data sorted in chronological order
    switch (type) 
    {
        case TWO_METER_WATER:
            self.sensorSBE37DataForDayDictionaryForTwoMeterWater = [NSMutableDictionary dictionaryWithCapacity:10];
            
            allOfTheDataInOrderList = [[self.sensorSBE37DataForHourDictionaryForTwoMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
            break;
            
        case TEN_METER_WATER:
            self.sensorSBE16DataForDayDictionaryForTenMeterWater = [NSMutableDictionary dictionaryWithCapacity:10];
            
            allOfTheDataInOrderList = [[self.sensorSBE16DataForHourDictionaryForTenMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
            break;
            
        case TWENTY_METER_WATER:
            self.sensorSBE16DataForDayDictionaryForTwentyMeterWater = [NSMutableDictionary dictionaryWithCapacity:10];
            
            allOfTheDataInOrderList = [[self.sensorSBE16DataForHourDictionaryForTwentyMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
            break;
            
        default:
            break;
    }
    
    int indexOfFirstMidnight = -1;
    
    //finds the first full day and fills dictionary with empty arrays using days as keys
    for (NSString *timeStamp in allOfTheDataInOrderList) 
    {
        NSRange rangeOfMorning = [timeStamp rangeOfString:@" 00:00"];
        if (rangeOfMorning.location == 10)
        {
            //make a new array to hold the 24 readings
            NSMutableArray *dataForDay = [NSMutableArray arrayWithCapacity:24];
            
            //strip the times, grab the date
            NSString *date = [timeStamp substringToIndex:rangeOfMorning.location];
            
            //add the day array to the dictionary
            switch (type) 
            {
                case TWO_METER_WATER:
                    [self.sensorSBE37DataForDayDictionaryForTwoMeterWater setObject:dataForDay forKey:date];
                    break;
                case TEN_METER_WATER:
                    [self.sensorSBE16DataForDayDictionaryForTenMeterWater setObject:dataForDay forKey:date];
                    break;  
                case TWENTY_METER_WATER:
                    [self.sensorSBE16DataForDayDictionaryForTwentyMeterWater setObject:dataForDay forKey:date];
                    break;   
                default:
                    break;
            }
            
            //if the index of the first day hasn't been set yet, set it
            if (indexOfFirstMidnight == -1)
            {
                indexOfFirstMidnight = [allOfTheDataInOrderList indexOfObject:timeStamp];
            }
        }
    }
    
    NSArray *uniqueDaysInOrderList;
    
    //creates an array of the day keys in chronological order
    switch (type) 
    {
        case TWO_METER_WATER:
            uniqueDaysInOrderList = [[self.sensorSBE37DataForDayDictionaryForTwoMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
            break;
        case TEN_METER_WATER:
            uniqueDaysInOrderList = [[self.sensorSBE16DataForDayDictionaryForTenMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
            break;   
        case TWENTY_METER_WATER:
            uniqueDaysInOrderList = [[self.sensorSBE16DataForDayDictionaryForTwentyMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
            break;   
        default:
            break;
    }

    //go through each day and fill empty array with appropriate data
    for (NSString *day in uniqueDaysInOrderList) 
    {
        int counter = 0;
        NSMutableArray *temporary;
        
        //sets |temporary| to the empty array for this day
        switch (type) 
        {
            case TWO_METER_WATER:
                temporary = [self.sensorSBE37DataForDayDictionaryForTwoMeterWater objectForKey:day];
                break;
            case TEN_METER_WATER:
                temporary = [self.sensorSBE16DataForDayDictionaryForTenMeterWater objectForKey:day];
                break;   
            case TWENTY_METER_WATER:
                temporary = [self.sensorSBE16DataForDayDictionaryForTwentyMeterWater objectForKey:day];
                break; 
            default:
                break;
        }
        
        //gets and adds data for each hour to |temporary|
        while (counter < 24) 
        {
            int indexOfTheDay = [uniqueDaysInOrderList indexOfObject:day];
            int numberOfTotalDataReadings = [allOfTheDataInOrderList count];
            
            int theIndexOfTheDataReading = indexOfFirstMidnight + indexOfTheDay*24 + counter;
            
            if ((theIndexOfTheDataReading) < numberOfTotalDataReadings)
            {
                NSString *timestamp = [allOfTheDataInOrderList objectAtIndex:theIndexOfTheDataReading];
                NSArray *dataForTimestamp;
                
                //grabs array of data for this hour
                switch (type) 
                {
                    case TWO_METER_WATER:
                        dataForTimestamp = [self.sensorSBE37DataForHourDictionaryForTwoMeterWater objectForKey:timestamp];
                        
                        break;
                    case TEN_METER_WATER:
                        dataForTimestamp = [self.sensorSBE16DataForHourDictionaryForTenMeterWater objectForKey:timestamp];
                        
                        break;   
                    case TWENTY_METER_WATER:
                        dataForTimestamp = [self.sensorSBE16DataForHourDictionaryForTwentyMeterWater objectForKey:timestamp];
                        
                        break;  
                    default:
                        break;
                }
                
                //adds hour of data to |temporary|
                [temporary insertObject:dataForTimestamp atIndex:counter];
            }
            
            counter = counter + 1;
        }
        
        //sets |temporary| to corresponding day in the dictionary
        switch (type) 
        {
            case TWO_METER_WATER:
                [self.sensorSBE37DataForDayDictionaryForTwoMeterWater setObject:temporary forKey:day];
                break;
            case TEN_METER_WATER:
                [self.sensorSBE16DataForDayDictionaryForTenMeterWater setObject:temporary forKey:day];
                break;  
            case TWENTY_METER_WATER:
                [self.sensorSBE16DataForDayDictionaryForTwentyMeterWater setObject:temporary forKey:day];
                break;  
            default:
                break;
        }
    }
    
    NSLog(@"done building temp and salinity dictionaries");
}


/* creates dictionary of per-day data for sensors that provide 
 * chlorophyll data
 */
- (void) buildDayChlorophyll
{
    self.sensorOptics_SDataForDayDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    int indexOfFirstMidnight = -1;
    
    //gets per-hour dictionary and creates array of the data sorted in chronological order
    NSArray *allOfTheDataInOrderList = [[self.sensorOptics_SDataForHourDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
    for (NSString *timeStamp in allOfTheDataInOrderList) 
    {
        NSRange rangeOfMorning = [timeStamp rangeOfString:@" 00:00"];
        if (rangeOfMorning.location == 10)
        {
            //make a new array to hold the 24 readings for one day
            NSMutableArray *dataForDay = [NSMutableArray arrayWithCapacity:24];
            
            //strip the times, grab the date
            NSString *date = [timeStamp substringToIndex:rangeOfMorning.location];
            
            //add the array to the dictionary
            [self.sensorOptics_SDataForDayDictionary setObject:dataForDay forKey:date];
            
            //if the index of the first day hasn't been set yet, set it
            if (indexOfFirstMidnight == -1)
            {
                indexOfFirstMidnight = [allOfTheDataInOrderList indexOfObject:timeStamp];
            }
        }
    }
    
    //creates an array of the day keys in chronological order
    NSArray *uniqueDaysInOrderList = [[self.sensorOptics_SDataForDayDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    //go through each day and fill empty array with appropriate data
    for (NSString *day in uniqueDaysInOrderList) 
    {
        int counter = 0;
        NSMutableArray *temporary = [self.sensorOptics_SDataForDayDictionary objectForKey:day];
        
        while (counter < 24) 
        {
            int indexOfTheDay = [uniqueDaysInOrderList indexOfObject:day];
            int numberOfTotalDataReadings = [allOfTheDataInOrderList count];
            int theIndexOfTheDataReading = indexOfFirstMidnight + indexOfTheDay*24 + counter;
            
            if ((theIndexOfTheDataReading) < numberOfTotalDataReadings)
            {
                NSString *timestamp = [allOfTheDataInOrderList objectAtIndex:theIndexOfTheDataReading];
                
                //grabs array of data for this hour
                NSArray *dataForTimestamp = [self.sensorOptics_SDataForHourDictionary objectForKey:timestamp];
                
                //adds hour of data to |temporary|
                [temporary insertObject:dataForTimestamp atIndex:counter];
            }
            
            counter = counter + 1;
        }
        
        //sets |temporary| to corresponding day in the dictionary
        [self.sensorOptics_SDataForDayDictionary setObject:temporary forKey:day];
    }
    
    NSLog(@"done building chlorophyll dictionaries");
}



/*  returns an array of data from the appropriate per-day dictionary
 *  for the requested start date and number of days
 */
- (NSArray *)getDataFromSensor:(int)identifier andDateRequested:(NSString *)startDate forNumberofDays:(int)numberOfDays
{
    NSArray *uniqueDaysInOrderList;
    
    switch (identifier) 
    {
        case CHLOROPHYLL_IDENTIFIER:
            if (numberOfDays == DAY_INTERVAL) //chlorophyll data for one day
            {
                NSArray *chlorophyllData = [self.sensorOptics_SDataForDayDictionary objectForKey:startDate];                
                return chlorophyllData;
            }
            if (numberOfDays == WEEK_INTERVAL)
            {
                //needs keys in order for seven days
                uniqueDaysInOrderList = [[self.sensorOptics_SDataForDayDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
                
                NSMutableArray *chlorophyllData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                
                //adds data for each day to array
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    if (indexOfFirstDayOfWeek + counter < uniqueDaysInOrderList.count)
                    {
                        [chlorophyllData addObject:[self.sensorOptics_SDataForDayDictionary objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                    }
                    else
                    {
                        chlorophyllData = nil;
                        return chlorophyllData;
                    }
                }
                                
                return chlorophyllData;
            }
            break;
            
        case TWO_METER_WATER_TEMP:
            if (numberOfDays == DAY_INTERVAL) //water temp at 2m data for one day
            {
                NSArray *twoMeterWaterTemperatureData = [self.sensorSBE37DataForDayDictionaryForTwoMeterWater objectForKey:startDate];
                return twoMeterWaterTemperatureData;
            }
            if (numberOfDays == WEEK_INTERVAL) 
            {
                //needs keys in order for seven days
                uniqueDaysInOrderList = [[self.sensorSBE37DataForDayDictionaryForTwoMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
                
                NSMutableArray *twoMeterWaterTemperatureData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                                
                //adds data for each day to array
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    if (indexOfFirstDayOfWeek + counter < uniqueDaysInOrderList.count)
                    {
                        [twoMeterWaterTemperatureData addObject:[self.sensorSBE37DataForDayDictionaryForTwoMeterWater objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                    }
                    else
                    {
                        twoMeterWaterTemperatureData = nil;
                        return twoMeterWaterTemperatureData;
                    }
                }
                                
                return twoMeterWaterTemperatureData;
            }
            
            break;
            
        case TEN_METER_WATER_TEMP:
            if (numberOfDays == DAY_INTERVAL) //water temp at 10m data for one day
            {
                NSArray *data = [self.sensorSBE16DataForDayDictionaryForTenMeterWater objectForKey:startDate];                
                return data;
            }
            if (numberOfDays == WEEK_INTERVAL) 
            {
                //needs keys in order for seven days
                uniqueDaysInOrderList = [[self.sensorSBE16DataForDayDictionaryForTenMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
                                
                NSMutableArray *tenMeterWaterTemperatureData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                            
                //adds data for each day to array
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    if (indexOfFirstDayOfWeek + counter < uniqueDaysInOrderList.count)
                    {
                        [tenMeterWaterTemperatureData addObject:[self.sensorSBE16DataForDayDictionaryForTenMeterWater objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                    }
                    else
                    {
                        tenMeterWaterTemperatureData = nil;
                        return tenMeterWaterTemperatureData;
                    }
                }
                                
                return tenMeterWaterTemperatureData;
            }
            
            break;   
            
        case TWENTY_METER_WATER_TEMP:
            if (numberOfDays == DAY_INTERVAL) //water temp at 20m data for one day
            {
                NSArray *data = [self.sensorSBE16DataForDayDictionaryForTwentyMeterWater objectForKey:startDate];                
                return data;
            }
            if (numberOfDays == WEEK_INTERVAL) 
            {
                //needs keys in order for seven days
                uniqueDaysInOrderList = [[self.sensorSBE16DataForDayDictionaryForTwentyMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
                                
                NSMutableArray *twentyMeterWaterTemperatureData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                                
                //adds data for each day to array
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    if (indexOfFirstDayOfWeek + counter < uniqueDaysInOrderList.count)
                    {
                        [twentyMeterWaterTemperatureData addObject:[self.sensorSBE16DataForDayDictionaryForTwentyMeterWater objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                    }
                    else
                    {
                        twentyMeterWaterTemperatureData = nil;
                        return twentyMeterWaterTemperatureData;
                    }

                }
                                
                return twentyMeterWaterTemperatureData;
            }
            
            break;   
            
        case TWO_METER_WATER_SALINITY:
            if (numberOfDays == DAY_INTERVAL) //salinity at 2m data for one day
            {
                NSArray *twoMeterWaterSalinityData = [self.sensorSBE37DataForDayDictionaryForTwoMeterWater objectForKey:startDate];                
                return twoMeterWaterSalinityData;
            }
            if (numberOfDays == WEEK_INTERVAL) 
            {
                //needs keys in order for seven days
                uniqueDaysInOrderList = [[self.sensorSBE37DataForDayDictionaryForTwoMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
                                
                NSMutableArray *twoMeterWaterSalinityData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                                
                //adds data for each day to array
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    if (indexOfFirstDayOfWeek + counter < uniqueDaysInOrderList.count)
                    {
                        [twoMeterWaterSalinityData addObject:[self.sensorSBE37DataForDayDictionaryForTwoMeterWater objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                    }
                    else
                    {
                        twoMeterWaterSalinityData = nil;
                        return twoMeterWaterSalinityData;
                    }
                }
                                
                return twoMeterWaterSalinityData;
            }
            break;   
            
        case TEN_METER_WATER_SALINITY:
            if (numberOfDays == DAY_INTERVAL) //salinity at 10m data for one day
            {
                NSArray *tenMeterWaterSalinityData = [self.sensorSBE16DataForDayDictionaryForTenMeterWater objectForKey:startDate];
                return tenMeterWaterSalinityData;
            }
            if (numberOfDays == WEEK_INTERVAL) 
            {
                //needs keys in order for seven days
                uniqueDaysInOrderList = [[self.sensorSBE16DataForDayDictionaryForTenMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
                                
                NSMutableArray *tenMeterWaterSalinityData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                                
                //adds data for each day to array
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    if (indexOfFirstDayOfWeek + counter < uniqueDaysInOrderList.count)
                    {
                        [tenMeterWaterSalinityData addObject:[self.sensorSBE16DataForDayDictionaryForTenMeterWater objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                    }
                    else
                    {
                        tenMeterWaterSalinityData = nil;
                        return tenMeterWaterSalinityData;
                    }
                }
                                
                return tenMeterWaterSalinityData;
            }
            break;   
            
        case TWENTY_METER_WATER_SALINITY:
            if (numberOfDays == DAY_INTERVAL) //salinity at 20m data for one day
            {
                NSArray *twentyMeterWaterSalinityData = [self.sensorSBE16DataForDayDictionaryForTwentyMeterWater objectForKey:startDate];
                return twentyMeterWaterSalinityData;
            }
            if (numberOfDays == WEEK_INTERVAL) 
            {
                //needs keys in order for seven days
                uniqueDaysInOrderList = [[self.sensorSBE16DataForDayDictionaryForTwentyMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
                                
                NSMutableArray *twentyMeterWaterSalinityData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                                
                //adds data for each day to array
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    if (indexOfFirstDayOfWeek + counter < uniqueDaysInOrderList.count)
                    {
                        [twentyMeterWaterSalinityData addObject:[self.sensorSBE16DataForDayDictionaryForTwentyMeterWater objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                    }
                    else
                    {
                        twentyMeterWaterSalinityData = nil;
                        return twentyMeterWaterSalinityData;
                    }
                }
                                
                return twentyMeterWaterSalinityData;
            }
            break;   
            
        default:
            break;
    }
    
    return nil;
}

@end
