//
//  GraphDraw.h
//  Graphing
//
//  Created by Nicole Erkis on 10/11/11.
//  Copyright 2011 Bowdoin College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"

@class GraphDraw;

@protocol GraphDrawDelegate
//add methods like smileForFaceView
@end

//why
@interface GraphDraw : UIView
{
    id <GraphDrawDelegate> delegate;
}

//why
@property (assign) id <GraphDrawDelegate> delegate;

@end
