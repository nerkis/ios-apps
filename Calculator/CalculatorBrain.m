//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Nicole Erkis on 9/8/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import "CalculatorBrain.h"
#import "Math.h"

#define VARIABLE_PREFIX @"%"

@implementation CalculatorBrain
@synthesize waitingOperation, operand;
@synthesize expression = internalExpression; //sets internalExpression as variable

//init function
- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

/* sets the operand value and adds operand to internalExpression
 * @param aDouble: double representing digit pressed
 */
- (void) setOperand:(double)aDouble
{    
    //making sure internalExpression has been initialized
    if ((id)internalExpression == nil)
        internalExpression = [[NSMutableArray alloc] init];
    
    //adds operand to internalExpression
    [internalExpression addObject:[NSNumber numberWithDouble:aDouble]];
    
    operand = aDouble;
}

/* sets variable as an operand
 * @param variableName: string representing variable pressed
 */
- (void) setVariableAsOperand:(NSString *)variableName
{
    //making sure internalExpression has been initialized
    if((id)internalExpression == nil)
        internalExpression = [[NSMutableArray alloc] init];
    
    //add variable prefix to denote a variable
    NSString *vp = VARIABLE_PREFIX;
    variableName = [vp stringByAppendingString:variableName];
    
    [internalExpression addObject:variableName];
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
- (NSString *) performOperation:(NSString *)operation
{
    ///making sure internalExpression has been initialized
    if ((id)internalExpression == nil)
        internalExpression = [[NSMutableArray alloc] init];
    
    //add operation to internalExpression
    [internalExpression addObject:operation];
    
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
        self.waitingOperation = nil;
        [internalExpression removeAllObjects];
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
        self.waitingOperation = operation;
        waitingOperand = operand;
    }
    
    NSString *output = [NSString stringWithFormat:@"%g", operand];
    return output;
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

//returns a copy of internalExpression
//is this necessary because only want one expression (singleton)?
- (id) expression
{
    return [[internalExpression copy] autorelease];
} 


/************if not all of the variables are defined in variables dictionary, return value undefined***************/

/* returns the result of anExpression using test variable values
 *
 * @param anExpression: the expression being evaluated
 * @param variables: dictionary of NSNumber objects mapped to NSString vars
 * @return: double result of the evaluation 
 */
+ (double) evaluateExpression:(id)anExpression
          usingVariableValues:(NSDictionary *) variables
{
    //create a "worker-bee" brain
    CalculatorBrain *tempBrain = [[CalculatorBrain alloc] init];
    
    //create double to hold results
    double output;
    
    //enumerate elements of anExpression, find variables
    for (id section in anExpression)
    {
        //if section is a number (operand)
        if ([section isKindOfClass:[NSNumber class]])
        {
            [tempBrain setOperand:[section doubleValue]];
        }
        //if section is a string (operation or variable)
        else if ([section isKindOfClass:[NSString class]])
        {
            //if length == 1, must be an operation
            if ([section length] == 1)
                [tempBrain performOperation: section];
            
            //make sure, but otherwise probably a variable
            else if ([section length] >= ([VARIABLE_PREFIX length] + 1) &&
                     ([section characterAtIndex:0] == '%'))
            {
                //use variable as key in dictionary
                NSString *dictionaryKey = [section substringFromIndex:[VARIABLE_PREFIX length]];
                
                //set operand to dictionary's stored value
                id operand = [variables valueForKey:dictionaryKey];
                [tempBrain setOperand:[operand doubleValue]];
            }
        }
    }
    
    //set results as operand
    output = tempBrain.operand;
    [tempBrain release];
    
    return output;
}


/* looks at an expression and returns the set of variables contained
 * within that expression.
 *
 * @param anExpression: the expression
 * @return: NSSet of the variables in the expression
 */
+ (NSSet *)variablesInExpression:(id)anExpression
{
    //create set, set up memory management
    NSMutableSet *setOfVariables = [[[NSMutableSet alloc] init] autorelease];
    
    //create a "worker-bee" brain
    CalculatorBrain *tempBrain = [[CalculatorBrain alloc] init];
    
    //enumerate variables in the expression
    for (id section in anExpression)
    {
        //if section is a string AND is the right length AND
        //contains the prefix, it is a variable
        if ([section isKindOfClass:[NSString class]] &&
            [section length] >= ([VARIABLE_PREFIX length] + 1) &&
            ([section characterAtIndex:0] == '%')) {
            
            //set nextVariable to current section minus the prefix
            NSString *nextVariable = [section substringFromIndex:[VARIABLE_PREFIX length]];
            
            //if not already in the set, add this variable to the set
            if (![setOfVariables member:nextVariable])
                [setOfVariables addObject:nextVariable];
        }
    }
    
    //make sure to release things we alloc
    [tempBrain release];
    
    return setOfVariables;
}


/* uses for-in to build string representation of anExpression
 *
 * @param anExpression: the expression being converted to string
 * @return: the NSString representation of anExpression
 */
+ (NSString *)descriptionOfExpression:(id)anExpression
{
    //the string to hold description
    NSMutableString *description = [[[NSString alloc] init] autorelease];
    
    //create a "worker bee" brain
    CalculatorBrain *tempBrain = [[CalculatorBrain alloc] init];
    
    //enumerate elements of anExpression, add them to description
    for (id section in anExpression)
    {
        //if section is a number (operand)
        if ([section isKindOfClass:[NSNumber class]])
        {
            description = [NSString stringWithFormat:@"%@%@ ", description, section];
        }
        //if section is a string (operation or variable)
        else if ([section isKindOfClass:[NSString class]])
        {
            //if length == 1, must be an operation
            if ([section length] == 1)
                description = [NSString stringWithFormat:@"%@%@ ", description, section];
            
            //make sure, but otherwise probably a variable
            else if ([section length] >= ([VARIABLE_PREFIX length] + 1) &&
                     ([section characterAtIndex:0] == '%'))
                     {
                         description = [NSString stringWithFormat:@"%@%@ ", description, [section substringFromIndex:[VARIABLE_PREFIX length]]];
                     }
        }
    }
    
    //make sure to release things we alloc
    [tempBrain release];    
    return description;
}


/* returns an expression as a propertyList
 *
 * @param expression: expression input
 * @return: propertyList (as expression, since expression IS a PL)
 */
+ (id)propertyListForExpression:(id)anExpression
{
    [anExpression autorelease];
    return [anExpression copy];
}

/* returns a propertyList as an expression
 *
 * @param propertyList: propertyList input
 * @return: expression (as propertyList, since expression IS a PL)
 */
+ (id)expressionForPropertyList:(id)propertyList
{
    [propertyList autorelease];
    return [propertyList copy];
}
 
//dealloc
- (void) dealloc
{
    //release properties
    [waitingOperation release];
    [internalExpression release];
 
    [super dealloc];
}

@end