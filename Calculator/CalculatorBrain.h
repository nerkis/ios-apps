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
    NSString *waitingOperation;
    double waitingOperand;
    double memory;
}

//headers for the calculatorBrain methods
- (void) setOperand:(double)aDouble;
- (double) performOperation:(NSString*)operation;
- (BOOL) setFloatingPointNumber:(NSString*)inputNum;

@end
