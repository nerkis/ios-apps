//
//  Bowdoin_Buoy_App_iPhone_Graph_Data.h
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky on 12/14/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bowdoin_Buoy_App_iPhone_Graph_Data : NSObject
{
    //dictionaries to hold per-hour and per-day data for each sensor
    NSMutableDictionary *sensorSBE37DataForHourDictionaryForTwoMeterWater; 
    NSMutableDictionary *sensorSBE37DataForDayDictionaryForTwoMeterWater; 
    
    NSMutableDictionary *sensorSBE16DataForHourDictionaryForTenMeterWater;
    NSMutableDictionary *sensorSBE16DataForDayDictionaryForTenMeterWater;
    
    NSMutableDictionary *sensorSBE16DataForHourDictionaryForTwentyMeterWater;
    NSMutableDictionary *sensorSBE16DataForDayDictionaryForTwentyMeterWater;
    
    NSMutableDictionary *sensorOptics_SDataForHourDictionary;
    NSMutableDictionary *sensorOptics_SDataForDayDictionary;
    
}

@property (nonatomic, retain) NSMutableDictionary *sensorSBE37DataForHourDictionaryForTwoMeterWater;
@property (nonatomic, retain) NSMutableDictionary *sensorSBE37DataForDayDictionaryForTwoMeterWater;

@property (nonatomic, retain) NSMutableDictionary *sensorSBE16DataForHourDictionaryForTenMeterWater;
@property (nonatomic, retain) NSMutableDictionary *sensorSBE16DataForDayDictionaryForTenMeterWater;

@property (nonatomic, retain) NSMutableDictionary *sensorSBE16DataForHourDictionaryForTwentyMeterWater;
@property (nonatomic, retain) NSMutableDictionary *sensorSBE16DataForDayDictionaryForTwentyMeterWater;

@property (nonatomic, retain) NSMutableDictionary *sensorOptics_SDataForHourDictionary;
@property (nonatomic, retain) NSMutableDictionary *sensorOptics_SDataForDayDictionary;


//retrieves all sensor data sets from the web
- (void)downloadAllData;

//grab data sets and create dictionaries with hours as keys
- (void)readFromURLforTwoMeterWater:(NSURL *)fileURL;
- (void)readFromURLforTenMeterWater:(NSURL *)fileURL;
- (void)readFromURLforTwentyMeterWater:(NSURL *)fileURL;
- (void)readFromURLforChlorophyll:(NSURL *)fileURL;

//create dictionaries with days as keys
- (void)buildDayTemperatureAndSalinityDictionaryWithGraphType:(int)type;
- (void)buildDayChlorophyll;

//returns an array of data from the appropriate day dictionary
- (NSArray *)getDataFromSensor:(int)identifier andDateRequested:(NSString *)date forNumberofDays:(int)numberOfDays;

@end