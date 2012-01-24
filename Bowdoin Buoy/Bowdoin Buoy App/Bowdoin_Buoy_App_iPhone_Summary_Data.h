//
//  Bowdoin_Buoy_App_iPhone_Summary_Data.h
//  Bowdoin Buoy App
//
//  Created by Peter Yaworsky and Nicole Erkis on 12/20/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bowdoin_Buoy_App_iPhone_Summary_Data : NSObject

{
    NSString *airTempProperty;
    NSString *windSpeedProperty;
    NSString *waveHeightProperty;
    NSString *waterTempProperty;
    NSString *salinityProperty;
    NSString *chlorophyllProperty;
    NSString *PARProperty;
    NSString *locationProperty;
    NSString *latitudeProperty;
    NSString *longitudeProperty;
    NSString *timeStampProperty;
    NSString *title;
        
    NSString *webPageAsString;
}

@property (nonatomic, retain) NSString *airTempProperty;
@property (nonatomic, retain) NSString *windSpeedProperty;
@property (nonatomic, retain) NSString *waveHeightProperty;
@property (nonatomic, retain) NSString *waterTempProperty;
@property (nonatomic, retain) NSString *salinityProperty;
@property (nonatomic, retain) NSString *chlorophyllProperty;
@property (nonatomic, retain) NSString *PARProperty;
@property (nonatomic, retain) NSString *locationProperty;
@property (nonatomic, retain) NSString *latitudeProperty;
@property (nonatomic, retain) NSString *longitudeProperty;
@property (nonatomic, retain) NSString *timeStampProperty;
@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSString *webPageAsString;

-(void)updateWebPage;


@end
