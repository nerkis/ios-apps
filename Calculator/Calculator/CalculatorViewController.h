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
    //IBOutlet identifies outlet to graphical tool for
    //connecting the Controller and View
    IBOutlet UILabel *display;
    CalculatorBrain *brain;
    BOOL userIsInTheMiddleOfTypingANumber;
}

//IBAction is the same as void but is important to put app together
//headers for view controller methods
- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;

@end
