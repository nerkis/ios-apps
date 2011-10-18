//
//  GraphViewController.h
//  erkisGraphing
//
//  Created by Nicole Erkis on 10/15/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphDraw.h"

#define DEFAULT_SCALE 20.0;
#define SCALE_CHANGE 5.0;

@interface GraphViewController : UIViewController <GraphDrawDelegate>
{
    @private
    IBOutlet GraphDraw *graphDraw;
    
    @public
    CGFloat scale;
}

@property (retain) IBOutlet GraphDraw *graphDraw;

@property CGFloat scale;

- (CGFloat) scale;

//updates graph scale when zoom in is pressed
- (IBAction)zoomInPressed:(UIButton *)sender;

//updates graph scale when zoom out is pressed
- (IBAction)zoomOutPressed:(UIButton *)sender;

@end
