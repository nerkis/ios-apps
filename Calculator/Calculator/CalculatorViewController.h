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
    IBOutlet UILabel *display; //calculator display
    CalculatorBrain *brain; //brain created to perform calculations
    BOOL userIsInTheMiddleOfTypingANumber; //YES if user is typing
}

//updates display when a digit is pressed
- (IBAction)digitPressed:(UIButton *)sender;

//performs an operation when an operation is pressed
- (IBAction)operationPressed:(UIButton *)sender;

@end
