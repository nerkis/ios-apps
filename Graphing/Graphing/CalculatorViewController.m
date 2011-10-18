//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Nicole Erkis on 9/8/11.
//  Copyright 2011 Bowdoin College. All rights reserved.

#import "CalculatorViewController.h"
#import "GraphViewController.h"

//private brain property
@interface CalculatorViewController()
@property (nonatomic, retain) CalculatorBrain* brain;
@end

@implementation CalculatorViewController
@synthesize brain;
@synthesize displayLabel, button;


//creates a brain object, used to perform calculations
- (CalculatorBrain *) brain
{
    if (!brain) brain = [[CalculatorBrain alloc] init];
    return brain;
}

//returns the value of the display
- (NSString *) displayLabel
{
    return [display text];
}

//sets the display via setting a string label
- (void) setDisplayLabel:(NSString *)label
{
    [display setText:label];
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
        if (![self.brain setFloatingPointNumber:[display text]]) 
            return;
    }
    
    //if user was typing, add next digit to display
    if (userIsInTheMiddleOfTypingANumber)
    {
        self.displayLabel = [self.displayLabel stringByAppendingString:digit];
    }
    
    //if user wasn't typing, add first digit to display
    else 
    {
        self.displayLabel = digit;
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
        self.brain.operand = [self.displayLabel doubleValue];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    
    //perform the operation
    NSString *operation = [[self.button titleLabel] text];
    NSString *output = [self.brain performOperation:operation];
    
    
    //check if dealing with variables
    if (isExpression)
    { 
        self.displayLabel = [CalculatorBrain descriptionOfExpression: self.brain.expression];
    }
    else 
        self.displayLabel = output;
}

/* evaluates the expression using test set of variable values
 * calls evaluateExpression:usingVariableValues:
 */
- (IBAction)solvePressed:(UIButton *)sender
{            
    self.button = sender;
    
    //create NSDictionary
    NSArray *keys = [[NSArray alloc] initWithObjects:@"x", @"a", @"b", @"c", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:2], [NSNumber numberWithDouble:4], [NSNumber numberWithDouble:6], [NSNumber numberWithDouble:8], nil];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:values forKeys: keys];
    
    //get results from evaluateExpression:usingVariableValues:
    double output = [CalculatorBrain evaluateExpression:self.brain.expression
     usingVariableValues:dictionary];
    
    //display results
    self.displayLabel = [NSString stringWithFormat:@"%g", output];
    
    [keys release];
    [values release];
    [dictionary release];
}

/* pushes a graphviewcontroller onto the UINavigationController
 * stack: brings up a graph view
 */
- (IBAction)graphPressed:(UIButton *)sender
{
    GraphViewController *gvc = [[GraphViewController alloc] init];
    //make a graphViewController expression?
    //graph class can't know about expressions or calculator brains though!
    //gvc.graph = diagnosis;
    gvc.title = @"Graph";
    [self.navigationController pushViewController:gvc animated:YES];
    [gvc release];
}

//gives calculator view a title
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Calculator";
    // Do any additional setup after loading the view from its nib.
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