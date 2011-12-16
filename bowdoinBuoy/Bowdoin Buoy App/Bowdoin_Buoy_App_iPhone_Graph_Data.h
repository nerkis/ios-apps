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

- (void)buildDayTemperatureAndSalinityDictionaryWithGraphType:(int)type;
- (void)readFromURLforTwoMeterWater:(NSURL *)fileURL;
- (void)readFromURLforTenMeterWater:(NSURL *)fileURL;
- (void)readFromURLforTwentyMeterWater:(NSURL *)fileURL;
- (void)readFromURLforChlorophyll:(NSURL *)fileURL;

- (NSArray *)getDataFromSensor:(int)identifier andDateRequested:(NSString *)date forNumberofDays:(int)numberOfDays;

- (void)downloadAllData;


@end
