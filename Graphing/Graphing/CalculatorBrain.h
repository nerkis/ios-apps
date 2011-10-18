//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Nicole Erkis on 9/8/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject { //<Solver>

    @public
        double operand;
    
    @private
        NSString *waitingOperation; //stores operation for two-operand operations
        double waitingOperand; //second operand
        double memory; //memory storage
        NSMutableArray *internalExpression; //holds the expression (has variables)
}

//check this: made NSString object copy because it has a mutable subclass
@property (nonatomic, copy) NSString *waitingOperation; //stores operation for two-operand operations
@property (nonatomic) double operand; //operand property
@property (readonly) id expression;


- (id) expression;

//sets operand value
- (void) setOperand:(double)aDouble;

//sets variable as an operand
- (void) setVariableAsOperand:(NSString *)variableName;

//performs operations requiring two operands
- (void)performWaitingOperation;

//returns the result
- (NSString *) performOperation:(NSString*)operation;

//returns YES if it is OK to add a decimal point to operand
- (BOOL) setFloatingPointNumber:(NSString*)inputNum;

//returns the y value for a given x value
- (double) getYFromX:(double)x;

//returns result of expression using test variable values
+ (double) evaluateExpression:(id)anExpression
          usingVariableValues:(NSDictionary *) variables;

//returns set of variables in the expression
+ (NSSet *)variablesInExpression:(id)anExpression;

//returns string representation of expression
+ (NSString *)descriptionOfExpression:(id)anExpression;

//returns property list of expression and vice versa, respectively
+ (id)propertyListForExpression:(id)anExpression;
+ (id)expressionForPropertyList:(id)propertyList;

@end