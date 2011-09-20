//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Nicole Erkis on 9/8/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject {
    double operand;
    NSString *waitingOperation; //stores operation for two-operand operations
    double waitingOperand; //second operand
    double memory; //memory storage
}

//sets operand value
- (void) setOperand:(double)aDouble;

//returns the result
- (double) performOperation:(NSString*)operation;

//returns YES if it is OK to add a decimal point to operand
- (BOOL) setFloatingPointNumber:(NSString*)inputNum;

@end
