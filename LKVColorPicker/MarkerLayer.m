//
//  MarkerLayer.m
//  SmartLightControl
//
//  Created by 李凯 on 2020/1/10.
//  Copyright © 2020 李凯. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "MarkerLayer.h"

@implementation MarkerLayer

- (void)drawInContext:(CGContextRef)ctx
{
    float const thickness = 0.0f;
    CGContextSetLineWidth(ctx, thickness);
    //    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    CGContextAddEllipseInRect(ctx, CGRectInset(self.bounds, thickness, thickness));
    //    CGContextStrokePath(context);
    CGContextFillPath(ctx);
}

@end
