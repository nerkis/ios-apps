//
//  GraphViewController.h
//  erkisGraphing
//
//  Created by Nicole Erkis on 10/15/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphDraw.h"

@interface GraphViewController : UIViewController <GraphDrawDelegate>
{
    @private
        GraphDraw *graphDraw;
}

@property (retain) IBOutlet GraphDraw *graphDraw;

//updates graph scale when zoom in is pressed
- (IBAction)zoomInPressed:(UIButton *)sender;

//updates graph scale when zoom out is pressed
- (IBAction)zoomOutPressed:(UIButton *)sender;

@end
