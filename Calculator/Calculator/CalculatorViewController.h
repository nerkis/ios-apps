//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Nicole Erkis on 9/8/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface CalculatorViewController : UIViewController {
    
    @private
        CalculatorBrain *brain; //brain created to perform calculations
        IBOutlet UILabel *display; //calculator display
        IBOutlet UIButton *button; //the button pressed
        BOOL userIsInTheMiddleOfTypingANumber; //YES if user is typing
        BOOL isExpression; //YES if evaluating an expression
}

//properties
//@property (nonatomic, retain) IBOutlet UILabel *display;
@property (nonatomic, copy) NSString *displayLabel; //text of the display
@property (nonatomic, retain) IBOutlet UIButton *button;

//updates display when a digit is pressed
- (IBAction)digitPressed:(UIButton *)sender;

//performs an operation when an operation is pressed
- (IBAction)operationPressed:(UIButton *)sender;

//sets variable as operand when variable is pressed
- (IBAction)variablePressed:(UIButton *)sender;

//evaluates the expression using test set of variable values
- (IBAction)solvePressed:(UIButton *)sender;

@end
