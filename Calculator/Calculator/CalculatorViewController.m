//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Nicole Erkis on 9/8/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import "CalculatorViewController.h"

@implementation CalculatorViewController

//creates a brain object, used to perform calculations
- (CalculatorBrain *) brain
{
    if (!brain) brain = [[CalculatorBrain alloc] init];
    return brain;
}

/* updates the display when a digit is pressed
 * calls setFloatingPointNumber to make sure decimals OK
 *
 * @param sender: the button that was pressed
 * @returns IBAction: updates display
 */
- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [[sender titleLabel] text];
    
    //if new digit is a decimal point, make sure adding it is legal
    if ([@"." isEqual: digit]) 
    {
        if (![[self brain]setFloatingPointNumber:[display text]]) 
            return;
    }
    
    //if user was typing, add next digit to display
    if (userIsInTheMiddleOfTypingANumber)
    {
        [display setText:[[display text]stringByAppendingString:digit]];
    }
    
    //if user wasn't typing, add first digit to display
    else 
    {
        [display setText:digit];
        userIsInTheMiddleOfTypingANumber = YES;
    }
}

/* performs operation when operations are pressed
 * calls performOperation
 *
 * @param sender: the button that was pressed
 * @returns IBAction: updates display with the result
 */
- (IBAction)operationPressed:(UIButton *)sender
{
    //if user typing, set operand
    if (userIsInTheMiddleOfTypingANumber) 
    {
        [[self brain]setOperand: [[display text] doubleValue]];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    
    //perform the operation
    NSString *operation = [[sender titleLabel] text];
    double result = [[self brain] performOperation:operation];
    [display setText: [NSString stringWithFormat:@"%g", result]];
}

@end
