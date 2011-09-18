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

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

//sets the operand value
- (void) setOperand:(double)aDouble
{
    operand = aDouble;
}

//performs +, *, -, /
//waits for a second number before performOperation
- (void)performWaitingOperation
{
    if ([@"+" isEqual:waitingOperation]) {
        operand = waitingOperand + operand; }
    else if ([@"*" isEqual:waitingOperation]) {
        operand = waitingOperand * operand; }
    else if ([@"-" isEqual:waitingOperation]) {
        operand = waitingOperand - operand; }
    else if ([@"/" isEqual: waitingOperation]) {
        if (operand) {
            operand = waitingOperand / operand;
        }
    }
}

//performs single-operand operations
- (double) performOperation:(NSString *)operation
{
    //square root
    if ([operation isEqual:@"sqrt"]) {
        if (operand > 0) {
            operand = sqrt(operand);
        }
    }
    //change from positive to negative and vice-versa
    else if ([@"+/-" isEqual: operation]){
        operand = - operand;
    }
    //change to 1/x
    else if ([@"1/x" isEqual: operation]){
        if (operand != 0)
            operand = 1/operand;
        else
            printf("%s", "Cannot divide by zero.");
    }
    //calculate sine
    else if ([@"sin" isEqual: operation]){
        operand = sin(operand);
    }
    //calculate cosine
    else if ([@"cos" isEqual: operation]){
        operand = cos(operand);
    }
    //store current display
    else if ([@"Store" isEqual: operation]){
        memory = operand;
    }
    //recall value in memory
    else if ([@"Recall" isEqual: operation]){
        operand = memory;
    }
    //mem+ add value of display to value stored in memory
    else if ([@"Mem+" isEqual: operation]){
        memory += operand;
    }
    else if([@"C" isEqual: operation]){
        operand = 0;
        waitingOperand = 0;
        memory = 0;
    }
    else if([@"ClearM" isEqual: operation]){
        memory = 0;
    }
    else {
        //if performing operation that requires two operands,
        //performWaitingOperation
        [self performWaitingOperation];
        waitingOperation = operation;
        waitingOperand = operand;
    }
    return operand;
}

//allows user to enter floating point numbers
- (BOOL)setFloatingPointNumber:(NSString *)inputNum
{
    //when . is pressed, checks if . is already present in number
    //if ok to add . returns YES
    NSRange range = [inputNum rangeOfString:@"."];
    if (range.location == NSNotFound)
        return YES;
    else
    {
        printf("%s","Operand contains decimal point already.");
        return NO;
    }
}

@end
