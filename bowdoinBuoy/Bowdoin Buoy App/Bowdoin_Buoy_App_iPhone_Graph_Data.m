//
//  Bowdoin_Buoy_App_iPhone_Graph_Data.m
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky on 12/14/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import "Bowdoin_Buoy_App_iPhone_Graph_Data.h"

#define TWO_METER_WATER 0
#define TWO_METER_WATER_TEMP 10
#define TWO_METER_WATER_SALINITY 100


#define TEN_METER_WATER 1
#define TEN_METER_WATER_TEMP 11
#define TEN_METER_WATER_SALINITY 111

#define TWENTY_METER_WATER 2
#define TWENTY_METER_WATER_TEMP 12
#define TWENTY_METER_WATER_SALINITY 122

#define DAY_INTERVAL 1
#define WEEK_INTERVAL 7
#define MONTH_INTERVAL 28

#define CHLOROPHYLL_IDENTIFIER 25000


@implementation Bowdoin_Buoy_App_iPhone_Graph_Data

@synthesize sensorSBE37DataForHourDictionaryForTwoMeterWater, sensorSBE37DataForDayDictionaryForTwoMeterWater;

@synthesize sensorSBE16DataForHourDictionaryForTenMeterWater, sensorSBE16DataForDayDictionaryForTenMeterWater;

@synthesize sensorSBE16DataForHourDictionaryForTwentyMeterWater, sensorSBE16DataForDayDictionaryForTwentyMeterWater;

@synthesize sensorOptics_SDataForHourDictionary, sensorOptics_SDataForDayDictionary;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) buildDayChlorophyll
{

    self.sensorOptics_SDataForDayDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
            
    NSArray *allOfTheDataInOrderList = [[self.sensorOptics_SDataForHourDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
            
    int indexOfFirstMidnight = -1;
    
    //looks for the first new day, and fills a new dictionary of the dates with an empty mutable array of size 24
    for (NSString *timeStamp in allOfTheDataInOrderList) 
    {
        //NSLog(@"%@", timeStamp);
        NSRange rangeOfMorning = [timeStamp rangeOfString:@" 00:00"];
        if (rangeOfMorning.location == 10)
        {
            //make a new array to hold the 24 readings
            NSMutableArray *dataForDay = [NSMutableArray arrayWithCapacity:24];
            
            //strip the times, grab the date
            NSString *date = [timeStamp substringToIndex:rangeOfMorning.location];
        
            [self.sensorOptics_SDataForDayDictionary setObject:dataForDay forKey:date];
                                
            if (indexOfFirstMidnight == -1)
            {
                indexOfFirstMidnight = [allOfTheDataInOrderList indexOfObject:timeStamp];
            }
            //NSLog(@"%i", [[self.tempDataForDayDictionary objectForKey:date] count]);
        }
    }
    
    NSLog(@"found first new day, index is:");
    NSLog(@"%i", indexOfFirstMidnight);
    
    //takes the dates and sorts them
    NSArray *uniqueDaysInOrderList = [[self.sensorOptics_SDataForDayDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    
    NSLog(@"number of days:");
    NSLog(@"%i", [uniqueDaysInOrderList count]);
    
    //goes through each day, where its data array starts as empty
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
                
                NSArray *dataForTimestamp = [self.sensorOptics_SDataForHourDictionary objectForKey:timestamp];
                                      [temporary insertObject:dataForTimestamp
                                atIndex:counter];
            }
            counter = counter + 1;
        }
        [self.sensorOptics_SDataForDayDictionary setObject:temporary forKey:day];
    }
    
    for (NSString *day in uniqueDaysInOrderList) 
    {
        //NSLog(@"%@", day);
        //NSLog(@"%i", [[self.tempDataForDayDictionary objectForKey:day] count]);
    }
    NSLog(@"done building dictionaries");
    

}
- (void)buildDayTemperatureAndSalinityDictionaryWithGraphType:(int)type
{
    
    NSArray *allOfTheDataInOrderList;
    switch (type) {
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
    
    //looks for the first new day, and fills a new dictionary of the dates with an empty mutable array of size 24
    for (NSString *timeStamp in allOfTheDataInOrderList) 
    {
        //NSLog(@"%@", timeStamp);
        NSRange rangeOfMorning = [timeStamp rangeOfString:@" 00:00"];
        if (rangeOfMorning.location == 10)
        {
            //make a new array to hold the 24 readings
            NSMutableArray *dataForDay = [NSMutableArray arrayWithCapacity:24];
            
            //strip the times, grab the date
            NSString *date = [timeStamp substringToIndex:rangeOfMorning.location];
            
            switch (type) {
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
            
            
            if (indexOfFirstMidnight == -1)
            {
                indexOfFirstMidnight = [allOfTheDataInOrderList indexOfObject:timeStamp];
            }
            //NSLog(@"%i", [[self.tempDataForDayDictionary objectForKey:date] count]);
        }
    }
    
    NSLog(@"found first new day, index is:");
    NSLog(@"%i", indexOfFirstMidnight);
    
    NSArray *uniqueDaysInOrderList;
    //takes the dates and sorts them
    switch (type) {
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
    
    
    
    NSLog(@"number of days:");
    NSLog(@"%i", [uniqueDaysInOrderList count]);
    
    //goes through each day, where its data array starts as empty
    for (NSString *day in uniqueDaysInOrderList) 
    {
        int counter = 0;
        NSMutableArray *temporary;
        switch (type) {
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
        
        while (counter < 24) 
        {
            int indexOfTheDay = [uniqueDaysInOrderList indexOfObject:day];
            int numberOfTotalDataReadings = [allOfTheDataInOrderList count];
            
            int theIndexOfTheDataReading = indexOfFirstMidnight + indexOfTheDay*24 + counter;
            
            if ((theIndexOfTheDataReading) < numberOfTotalDataReadings)
            {
                NSString *timestamp = [allOfTheDataInOrderList objectAtIndex:theIndexOfTheDataReading];
                
                NSArray *dataForTimestamp;
                switch (type) {
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
                
                [temporary insertObject:dataForTimestamp
                                atIndex:counter];
            }
            counter = counter + 1;
        }
        switch (type) {
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
    
    for (NSString *day in uniqueDaysInOrderList) 
    {
        //NSLog(@"%@", day);
        //NSLog(@"%i", [[self.tempDataForDayDictionary objectForKey:day] count]);
    }
    NSLog(@"done building dictionaries");
    
}

- (void)readFromURLforTwoMeterWater:(NSURL *)fileURL
{
    
    //maybe need to get rid of this later after it is used
    NSString *fileString = [NSString stringWithContentsOfURL:fileURL 
                                                    encoding:NSUTF8StringEncoding 
                                                       error:nil];
    
    
    NSScanner *scanner = [NSScanner scannerWithString:fileString];
    NSString *line, *time;
    float salinity, sigma_t, conductivity, temperature;
    self.sensorSBE37DataForHourDictionaryForTwoMeterWater = [NSMutableDictionary dictionaryWithCapacity:10];
    [scanner setCharactersToBeSkipped:
     [NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
    
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
        //NSLog(@"%@", time);
        
    }
    NSLog(@"number of data points in 2M water stuff:");
    NSLog(@"%i", [self.sensorSBE37DataForHourDictionaryForTwoMeterWater count]);
    [self buildDayTemperatureAndSalinityDictionaryWithGraphType:TWO_METER_WATER];
}

- (void)readFromURLforTenMeterWater:(NSURL *)fileURL
{
    
    //maybe need to get rid of this later after it is used
    NSString *fileString = [NSString stringWithContentsOfURL:fileURL 
                                                    encoding:NSUTF8StringEncoding 
                                                       error:nil];
    
    NSScanner *scanner = [NSScanner scannerWithString:fileString];
    NSString *line, *time;
    float temperature, salinity, sigma_t, dissolved_oxygen, oxygen_saturation, percent_oxygen_saturation, conductivity;
    self.sensorSBE16DataForHourDictionaryForTenMeterWater = [NSMutableDictionary dictionaryWithCapacity:10];
    [scanner setCharactersToBeSkipped:
     [NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
    
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
        //NSLog(@"%@", time);
        
    }
    NSLog(@"number of data points in 10M water stuff:");
    NSLog(@"%i", [self.sensorSBE16DataForHourDictionaryForTenMeterWater count]);
    [self buildDayTemperatureAndSalinityDictionaryWithGraphType:TEN_METER_WATER];
}

- (void)readFromURLforTwentyMeterWater:(NSURL *)fileURL
{
    
    //maybe need to get rid of this later after it is used
    NSString *fileString = [NSString stringWithContentsOfURL:fileURL 
                                                    encoding:NSUTF8StringEncoding 
                                                       error:nil];
    
    NSScanner *scanner = [NSScanner scannerWithString:fileString];
    NSString *line, *time;
    float temperature, salinity, sigma_t, dissolved_oxygen, oxygen_saturation, percent_oxygen_saturation, conductivity;
    self.sensorSBE16DataForHourDictionaryForTwentyMeterWater = [NSMutableDictionary dictionaryWithCapacity:10];
    [scanner setCharactersToBeSkipped:
     [NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
    
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
        //NSLog(@"%@", time);
        
    }
    NSLog(@"number of data points in 20M water stuff:");
    NSLog(@"%i", [self.sensorSBE16DataForHourDictionaryForTwentyMeterWater count]);
    [self buildDayTemperatureAndSalinityDictionaryWithGraphType:TWENTY_METER_WATER];
}

- (void)readFromURLforChlorophyll:(NSURL *)fileURL
{
    //maybe need to get rid of this later after it is used
    NSString *fileString = [NSString stringWithContentsOfURL:fileURL 
                                                    encoding:NSUTF8StringEncoding 
                                                       error:nil];
    
    NSScanner *scanner = [NSScanner scannerWithString:fileString];
    NSString *line, *time;
    float chlorophyll, QSE, turbidity;
    //maybe make bigger
    self.sensorOptics_SDataForHourDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    [scanner setCharactersToBeSkipped:
     [NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
    
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
        //NSLog(@"%@", time);
        
    }
    NSLog(@"number of data points in chlorophyll water stuff:");
    NSLog(@"%i", [self.sensorOptics_SDataForHourDictionary count]);
    [self buildDayChlorophyll];

    
}

- (NSArray *)getDataFromSensor:(int)identifier andDateRequested:(NSString *)startDate forNumberofDays:(int)numberOfDays
{
    NSArray *uniqueDaysInOrderList;
    switch (identifier) {
        case CHLOROPHYLL_IDENTIFIER:
            if (numberOfDays == DAY_INTERVAL) 
            {
                NSLog(@"numDays == 1");
                NSArray *chlorophyllData = [self.sensorOptics_SDataForDayDictionary objectForKey:startDate];
                NSLog(@"%i", [chlorophyllData count]);
                
                return chlorophyllData;
            }
            if (numberOfDays == WEEK_INTERVAL) 
            {
                NSLog(@"numDays == 7");
                uniqueDaysInOrderList = [[self.sensorOptics_SDataForDayDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
                NSLog(@"%i", [uniqueDaysInOrderList count]);
                
                NSMutableArray *chlorophyllData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                
                NSLog(@"%i", indexOfFirstDayOfWeek);
                
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    [chlorophyllData addObject:[self.sensorOptics_SDataForDayDictionary objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                }
                
                NSLog(@"%i", [chlorophyllData count]);
                
                return chlorophyllData;
            }
            
            break;

        case TWO_METER_WATER_TEMP:
            if (numberOfDays == DAY_INTERVAL) 
            {
                NSLog(@"numDays == 1");
                NSArray *twoMeterWaterTemperatureData = [self.sensorSBE37DataForDayDictionaryForTwoMeterWater objectForKey:startDate];
                NSLog(@"%i", [twoMeterWaterTemperatureData count]);
                
                return twoMeterWaterTemperatureData;
            }
            if (numberOfDays == WEEK_INTERVAL) 
            {
                NSLog(@"numDays == 7");
                uniqueDaysInOrderList = [[self.sensorSBE37DataForDayDictionaryForTwoMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
                NSLog(@"%i", [uniqueDaysInOrderList count]);
                
                NSMutableArray *twoMeterWaterTemperatureData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                
                NSLog(@"%i", indexOfFirstDayOfWeek);
                
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    [twoMeterWaterTemperatureData addObject:[self.sensorSBE37DataForDayDictionaryForTwoMeterWater objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                }
                
                NSLog(@"%i", [twoMeterWaterTemperatureData count]);
                
                return twoMeterWaterTemperatureData;
            }

            break;
        case TEN_METER_WATER_TEMP:
            if (numberOfDays == 1) 
            {
                NSLog(@"numDays == 1");
                NSArray *data = [self.sensorSBE16DataForDayDictionaryForTenMeterWater objectForKey:startDate];
                NSLog(@"%i", [data count]);
                
                return data;
            }
            if (numberOfDays == WEEK_INTERVAL) 
            {
                NSLog(@"numDays == 7");
                uniqueDaysInOrderList = [[self.sensorSBE16DataForDayDictionaryForTenMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
                
                NSLog(@"%i", [uniqueDaysInOrderList count]);
                
                NSMutableArray *tenMeterWaterTemperatureData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                
                NSLog(@"%i", indexOfFirstDayOfWeek);
                
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    [tenMeterWaterTemperatureData addObject:[self.sensorSBE16DataForDayDictionaryForTenMeterWater objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                }
                
                NSLog(@"%i", [tenMeterWaterTemperatureData count]);
                
                return tenMeterWaterTemperatureData;
            }

            break;   
        case TWENTY_METER_WATER_TEMP:
            if (numberOfDays == 1) 
            {
                NSLog(@"numDays == 1");
                NSArray *data = [self.sensorSBE16DataForDayDictionaryForTwentyMeterWater objectForKey:startDate];
                NSLog(@"%i", [data count]);
                
                return data;
            }
            if (numberOfDays == WEEK_INTERVAL) 
            {
                NSLog(@"numDays == 7");
                uniqueDaysInOrderList = [[self.sensorSBE16DataForDayDictionaryForTwentyMeterWater allKeys] sortedArrayUsingSelector:@selector(compare:)];
                
                NSLog(@"%i", [uniqueDaysInOrderList count]);
                
                NSMutableArray *twentyMeterWaterTemperatureData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                
                NSLog(@"%i", indexOfFirstDayOfWeek);
                
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    [twentyMeterWaterTemperatureData addObject:[self.sensorSBE16DataForDayDictionaryForTwentyMeterWater objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                }
                
                NSLog(@"%i", [twentyMeterWaterTemperatureData count]);
                
                return twentyMeterWaterTemperatureData;
            }

            break;   
        case TWO_METER_WATER_SALINITY:
            if (numberOfDays == DAY_INTERVAL) 
            {
                NSLog(@"numDays == 1");
                NSArray *twoMeterWaterSalinityData = [self.sensorSBE37DataForDayDictionaryForTwoMeterWater objectForKey:startDate];
                NSLog(@"%i", [twoMeterWaterSalinityData count]);
                
                return twoMeterWaterSalinityData;
            }
            if (numberOfDays == WEEK_INTERVAL) 
            {
                NSLog(@"numDays == 7");
                uniqueDaysInOrderList = [[self.sensorOptics_SDataForDayDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
                
                NSLog(@"%i", [uniqueDaysInOrderList count]);
                
                NSMutableArray *twoMeterWaterSalinityData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                
                NSLog(@"%i", indexOfFirstDayOfWeek);
                
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    [twoMeterWaterSalinityData addObject:[self.sensorOptics_SDataForDayDictionary objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                }
                
                NSLog(@"%i", [twoMeterWaterSalinityData count]);
                
                return twoMeterWaterSalinityData;
            }

            break;   
            
        case TEN_METER_WATER_SALINITY:
            if (numberOfDays == DAY_INTERVAL) 
            {
                NSLog(@"numDays == 1");
                NSArray *tenMeterWaterSalinityData = [self.sensorSBE16DataForDayDictionaryForTenMeterWater objectForKey:startDate];
                NSLog(@"%i", [tenMeterWaterSalinityData count]);
                
                return tenMeterWaterSalinityData;
            }
            if (numberOfDays == WEEK_INTERVAL) 
            {
                NSLog(@"numDays == 7");
                uniqueDaysInOrderList = [[self.sensorOptics_SDataForDayDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
                
                NSLog(@"%i", [uniqueDaysInOrderList count]);
                
                NSMutableArray *tenMeterWaterTemperatureData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                
                NSLog(@"%i", indexOfFirstDayOfWeek);
                
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    [tenMeterWaterTemperatureData addObject:[self.sensorOptics_SDataForDayDictionary objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                }
                
                NSLog(@"%i", [tenMeterWaterTemperatureData count]);
                
                return tenMeterWaterTemperatureData;
            }

            break;   
            
        case TWENTY_METER_WATER_SALINITY:
            if (numberOfDays == DAY_INTERVAL) 
            {
                NSLog(@"numDays == 1");
                NSArray *twentyMeterWaterSalinityData = [self.sensorSBE16DataForDayDictionaryForTwentyMeterWater objectForKey:startDate];
                NSLog(@"%i", [twentyMeterWaterSalinityData count]);
                
                return twentyMeterWaterSalinityData;
            }
            if (numberOfDays == WEEK_INTERVAL) 
            {
                NSLog(@"numDays == 7");
                uniqueDaysInOrderList = [[self.sensorOptics_SDataForDayDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
                
                NSLog(@"%i", [uniqueDaysInOrderList count]);
                
                NSMutableArray *twentyMeterWaterSalinityData = [NSMutableArray arrayWithCapacity:WEEK_INTERVAL];
                
                int indexOfFirstDayOfWeek = [uniqueDaysInOrderList indexOfObject:startDate];
                
                NSLog(@"%i", indexOfFirstDayOfWeek);
                
                for (int counter = 0; counter < WEEK_INTERVAL; counter++)
                {
                    [twentyMeterWaterSalinityData addObject:[self.sensorOptics_SDataForDayDictionary objectForKey:[uniqueDaysInOrderList objectAtIndex:(indexOfFirstDayOfWeek + counter)]]];
                }
                
                NSLog(@"%i", [twentyMeterWaterSalinityData count]);
                
                return twentyMeterWaterSalinityData;
            }

            break;   
            
        default:
            break;
    }
    return nil;
}

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




@end
