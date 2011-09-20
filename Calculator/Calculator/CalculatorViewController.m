//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Nicole Erkis on 9/8/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import "CalculatorViewController.h"

@implementation CalculatorViewController

- (CalculatorBrain *) brain
{
    if (!brain) brain = [[CalculatorBrain alloc] init];
    return brain;
}

//handles typing in the number, displays numbers on label
- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit;
    
    if (![@"Delete" isEqual:[sender titleLabel]]) 
    {
        digit = [[sender titleLabel] text];
    }
    
    //if ([[self brain]setFloatingPointNumber:[display text]]) {

    
        if (userIsInTheMiddleOfTypingANumber)
        {
            if ([@"Delete" isEqual:[sender titleLabel]]){
                if ([[display text] length] > 0) {
                    [display setText:[[display text] substringToIndex:[[display text] length] - 1]];
                }
            }
            else
                [display setText:[[display text]stringByAppendingString:digit]];
        }
        else {
        
            [display setText:digit];
            userIsInTheMiddleOfTypingANumber = YES;
        }
    //}
    //else
      //  return;
}

//implementation of operationPressed
- (IBAction)operationPressed:(UIButton *)sender
{
    //if user in the middle of a number, set operand, change BOOL to NO
    if (userIsInTheMiddleOfTypingANumber) {
        [[self brain]setOperand: [[display text] doubleValue]];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    //if not in middle of typing, perform the operation
    NSString *operation = [[sender titleLabel] text];
    double result = [[self brain] performOperation:operation];
    [display setText: [NSString stringWithFormat:@"%g", result]];
}

@end
