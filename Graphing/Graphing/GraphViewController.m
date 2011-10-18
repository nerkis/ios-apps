//
//  GraphViewController.m
//  erkisGraphing
//
//  Created by Nicole Erkis on 10/15/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import "GraphViewController.h"

@implementation GraphViewController

@synthesize graphDraw;
@synthesize scale;

- (void)updateUI
{
    [self.graphDraw setNeedsDisplay];
}

//should this be a regular init?
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.scale = DEFAULT_SCALE;
    }
    return self;
}


/* Changes the scale of the graph accordingly when
 * zoom in button is pressed
 */
- (IBAction)zoomInPressed:(UIButton *)sender
{
    self.scale -= SCALE_CHANGE;
    [self updateUI];
}

/* Changes the scale of the graph accordingly when
 * zoom out button is pressed
 */
- (IBAction)zoomOutPressed:(UIButton *)sender
{
    self.scale += SCALE_CHANGE;
    [self updateUI];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.graphDraw.delegate = self;
    
    [self updateUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [graphDraw release]; 
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [graphDraw release];
    [super dealloc];
}

@end
