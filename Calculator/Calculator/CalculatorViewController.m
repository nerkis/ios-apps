//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Nicole Erkis on 9/8/11.
//  Copyright 2011 Bowdoin College. All rights reserved.

#import "CalculatorViewController.h"

//private brain property
@interface CalculatorViewController()
@property (nonatomic, retain) CalculatorBrain* brain;
@end

@implementation CalculatorViewController
@synthesize brain;
@synthesize display, button;


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
    self.button = sender;
    
    NSString *digit = [[self.button titleLabel] text];
    
    //if new digit is a decimal point, make sure adding it is legal
    if ([@"." isEqual: digit]) 
    {
        if (![self.brain setFloatingPointNumber:[self.display text]]) 
            return;
    }
    
    //if user was typing, add next digit to display
    if (userIsInTheMiddleOfTypingANumber)
    {
        [self.display setText:[[self.display text]stringByAppendingString:digit]];
    }
    
    //if user wasn't typing, add first digit to display
    else 
    {
        [self.display setText:digit];
        userIsInTheMiddleOfTypingANumber = YES;
    }
}


/* sets variable as operand when variable is pressed
 * calls setVariableAsOperand
 *
 * @param sender: the button that was pressed
 * @returns IBAction: updates display with the result
 */
- (IBAction)variablePressed:(UIButton *)sender
{
    self.button = sender;
    
    //since adding a variable, set isExpression to YES
    isExpression = YES;
    NSString *variable = [[self.button titleLabel] text];
    
    //set variable as an operand
    [self.brain setVariableAsOperand: variable];
}


/* performs operation when operations are pressed
 * calls performOperation
 *
 * @param sender: the button that was pressed
 * @returns IBAction: updates display with the result
 */
- (IBAction)operationPressed:(UIButton *)sender
{
    self.button = sender;
    
    //if user typing, set operand
    if (userIsInTheMiddleOfTypingANumber) 
    {
        self.brain.operand = [[self.display text] doubleValue];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    
    //perform the operation
    NSString *operation = [[self.button titleLabel] text];
    NSString *output = [self.brain performOperation:operation];
    
    
    //check if dealing with variables
    if (isExpression)
    { 
        [self.display setText:[CalculatorBrain descriptionOfExpression: self.brain.expression]];
    }
    else 
        [self.display setText:output];
}


/* evaluates the expression using test set of variable values
 * calls evaluateExpression:usingVariableValues:
 */
- (IBAction)solvePressed
{            
    //create NSDictionary
    NSArray *keys = [[NSArray alloc] initWithObjects:@"x", @"a", @"b", @"c", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:2], [NSNumber numberWithDouble:4], [NSNumber numberWithDouble:6], [NSNumber numberWithDouble:8], nil];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:values forKeys: keys];
    
    //get results from evaluateExpression:usingVariableValues:
    double output = [CalculatorBrain evaluateExpression:self.brain.expression
     usingVariableValues:dictionary];
    
    //display results
    [self.display setText:[NSString stringWithFormat:@"%g", output]];
    
    [keys release];
    [values release];
    [dictionary release];
}


//dealloc method
- (void) dealloc
{
    //release properties
    [brain release];
    [display release];
    [button release];
    
    [super dealloc];
}

@end