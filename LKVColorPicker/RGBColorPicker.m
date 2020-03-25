//
//  RGBColorPicker.m
//  SmartLightControl
//
//  Created by 李凯 on 2020/1/10.
//  Copyright © 2020 李凯. All rights reserved.
//

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
//#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "RGBColorPicker.h"
#import "RGBCircleLayer.h"
#import "MarkerLayer.h"
#import "HexCodes.h"

@implementation RGBColorPicker

- (void)setup{
    
    self.opaque = NO;
    //self.color = [UIColor whiteColor];
    
    //初始化大色环
    layerHueCircle = [[RGBCircleLayer alloc] init];
    //图层大小和位置
    layerHueCircle.frame = self.bounds;
    //异步执行drawRect,告诉系统重绘界面
    [layerHueCircle setNeedsDisplay];
    //添加子视图
    [self.layer addSublayer:layerHueCircle];
    
    //初始化标记层圆圈
    layerHueMarker = [[MarkerLayer alloc] init];
    //异步执行drawRect,告诉系统重绘界面
    [layerHueMarker setNeedsDisplay];
    //添加子视图
    [self.layer addSublayer:layerHueMarker];
    
    //初始化长按手势
    hueGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(handleDragHue:)];
    //设置移动数目
    hueGestureRecognizer.allowableMovement = FLT_MAX;
    //设置最小长按时间【默认0.5秒】
    hueGestureRecognizer.minimumPressDuration = 0.0f;
    hueGestureRecognizer.delegate = self;
    [self addGestureRecognizer:hueGestureRecognizer];
    
    //设置大色环-色调范围值
    self.subDivisions = 256;
}

// 长按手势触发事件
- (void)handleDragHue:(UIGestureRecognizer *)gestureRecognizer
{
    //判断触发事件：开始、拖动
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged || gestureRecognizer.state == UIGestureRecognizerStateBegan){
        
        CGPoint const position = [gestureRecognizer locationInView:self];
        CGFloat const distanceSquared = (center.x - position.x) * (center.x - position.x) + (center.y - position.y) * (center.y - position.y);
        if ( distanceSquared < 1.0e-3f )
        {
            return;
        }
        
        CGFloat const radians = atan2(center.y - position.y, position.x - center.x);
        colorHue = radians / (2.0f * M_PI);
        if ( colorHue < 0.0f )
        {
            colorHue += 1.0f;
        }
        
        red = (255 - colorHue * (255 - 227));
        green = (141 + colorHue * (233 - 141));
        blue = (11 + colorHue * (255 - 11));
        
        NSLog(@"r = %f, g = %f, b = %f", (255 - colorHue * (255 - 227)), (141 + colorHue * (233 - 141)), (11 + colorHue * (255 - 11)));
        
//        layerSaturationBrightnessBox.hue = colorHue;
        //当前线程创建一个动画事物
        [CATransaction begin];
        [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
        layerHueMarker.frame = [self hueMarkerRect];
        //执行当前事务期间所做的所有更改
        [CATransaction commit];
    }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        if ( [self.delegate respondsToSelector:@selector(colorPicker:changedColor:)] )
        {
            [self.delegate colorPicker:self changedColor:self.color];
        }
    }
}

- (void)setColor:(UIColor *)color
{
    //移动圆环
    if ([color getColor:&red withGreen:&green withBlue:&blue])
    {
        [self colorFilter];
    }
    
    red = 255 - (255 - 227) * colorHue;
    green = 141 + (233 - 141) * colorHue;
    blue = 11 + (255 - 11) * colorHue;
    
//    layerSaturationBrightnessBox.hue = colorHue;
    layerHueMarker.frame = [self hueMarkerRect];
    layerSaturationBrightnessMarker.frame = [self saturationBrightnessMarkerRect];
}

- (UIColor *)color
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

// 判断三色值是否在有效范围内，即每种颜色的角度都相同
- (void)colorFilter
{
    CGFloat redAngle = (255.0 - red) / ((255.0 - 227.0) * 1.0);
    CGFloat greenAngle = (green - 141.0) / ((233.0 - 141.0) * 1.0);
    CGFloat blueAngle = (blue - 11.0) / ((255.0 - 11.0) * 1.0);
    
    if (!(red >= 227 && red <= 255 && green >= 141 && green <= 233 && blue >= 11 && blue <= 255))
    {
        return;
    }
    
    if (redAngle == greenAngle && greenAngle == blueAngle)
    {
        colorHue = redAngle;
    }
    else
    {
        colorHue = (redAngle + greenAngle + blueAngle) / 3;
    }
}

@end
