//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Nicole Erkis on 9/8/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import "CalculatorBrain.h"
#import "Math.h"

@implementation CalculatorBrain

//init function
- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

//sets the operand value
- (void) setOperand:(double)aDouble
{
    operand = aDouble;
}

//performs operations requiring two operands
- (void)performWaitingOperation
{
    //addition
    if ([@"+" isEqual:waitingOperation])
        operand = waitingOperand + operand;
    
    //multiplication
    else if ([@"*" isEqual:waitingOperation])
        operand = waitingOperand * operand;
    
    //subtraction
    else if ([@"-" isEqual:waitingOperation])
        operand = waitingOperand - operand;
    
    //division
    else if ([@"/" isEqual: waitingOperation]) 
    {
        if (operand != 0)
            operand = waitingOperand / operand;
            
        else
            printf("%s", "Cannot divide by zero.");
    }
}

/* performs single-operand operations
 *
 * @param operation: string representing operation pressed
 * @return: double operand value
 */
- (double) performOperation:(NSString *)operation
{
    //square root
    if ([operation isEqual:@"sqrt"]) 
    {
        if (operand > 0) 
            operand = sqrt(operand);
    }
    
    //change from positive to negative and vice-versa
    else if ([@"+/-" isEqual: operation])
        operand = - operand;
    
    //return 1/x
    else if ([@"1/x" isEqual: operation])
    {
        if (operand != 0)
            operand = 1/operand;
        else
            printf("%s", "Cannot divide by zero.");
    }
    
    //calculate sine
    else if ([@"sin" isEqual: operation])
        operand = sin(operand);
    
    //calculate cosine
    else if ([@"cos" isEqual: operation])
        operand = cos(operand);
    
    //calculate tangent
    else if([@"tan" isEqual: operation])
        operand = tan(operand);
    
    //store current display
    else if ([@"Store" isEqual: operation])
        memory = operand;
    
    //recall value in memory
    else if ([@"Recall" isEqual: operation])
        operand = memory;
    
    //mem+ add value of display to value stored in memory
    else if ([@"Mem+" isEqual: operation])
        memory += operand;
    
    //clear display, waiting operations, and memory
    else if([@"C" isEqual: operation])
    {
        operand = 0;
        waitingOperand = 0;
        memory = 0;
    }
    
    //clear only memory
    else if([@"ClearM" isEqual: operation])
        memory = 0;
    
    //clear only display
    else if([@"ClearD" isEqual: operation])
    {
        operand = 0;
        waitingOperand = 0;
    }
    
    //if operation reqires two operands, performWaitingOperation
    else 
    {
        [self performWaitingOperation];
        waitingOperation = operation;
        waitingOperand = operand;
    }
    
    return operand;
}

/* checks if operand contains a decimal point
 *
 * @param inputNum: string representing operand so far
 * @return: NO if inputNum contains a decimal point, else YES
 */
- (BOOL)setFloatingPointNumber:(NSString *)inputNum
{
    if ([inputNum rangeOfString:@"."].location != NSNotFound) 
    {
        printf("%s", "Operand contains decimal point already.");
        return NO;
    }
    else
        return YES;
}

@end
