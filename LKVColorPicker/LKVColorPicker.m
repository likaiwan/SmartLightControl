//
//  LKVColorPicker.m
//  SmartLightControl
//
//  Created by 李凯 on 2019/11/20.
//  Copyright © 2019 李凯. All rights reserved.
//

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>

#import "LKVColorPicker.h"
#import "HueCircleLayer.h"
#import "MarkerLayer.h"
#import "SaturationBrightnessLayer.h"
#import "config.h"

@implementation LKVColorPicker

@synthesize subDivisions, delegate;


//+ (EAGLContext *)sharedEAGLContext
//{
//    static EAGLContext * sharedEAGLContext;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    });
//    return sharedEAGLContext;
//}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [self setup];
    [super awakeFromNib];
}

- (void)setup{
    
    self.opaque = NO;
    self.color = [UIColor whiteColor];
    
    //初始化大色环
    layerHueCircle = [[HueCircleLayer alloc] init];
    layerHueCircle.frame = self.bounds;                 //图层大小和位置
    [layerHueCircle setNeedsDisplay];                   //异步执行drawRect,告诉系统重绘界面
    [self.layer addSublayer:layerHueCircle];            //添加子视图
    
    //初始化饱和度
//    layerSaturationBrightnessBox = [[SaturationBrightnessLayer alloc] initWithContext:[LKVColorPicker sharedEAGLContext]];
//    layerSaturationBrightnessBox.frame = self.bounds;
//    [layerSaturationBrightnessBox setNeedsDisplay];
//    [self.layer addSublayer:layerSaturationBrightnessBox];
    
    //初始化色环标记层
    layerHueMarker = [[MarkerLayer alloc] init];
    [layerHueMarker setNeedsDisplay];
    [self.layer addSublayer:layerHueMarker];
    
//    //初始化饱和度标记层
//    layerSaturationBrightnessMarker = [[MarkerLayer alloc] init];
//    [layerSaturationBrightnessMarker setNeedsDisplay];
//    [self.layer addSublayer:layerSaturationBrightnessMarker];
    
    //色环手势识别器--长按手势
    hueGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragHue:)];
    hueGestureRecognizer.allowableMovement = FLT_MAX;
    hueGestureRecognizer.minimumPressDuration = 0.0f;
    hueGestureRecognizer.delegate = self;
    //视图添加长按手势
    [self addGestureRecognizer:hueGestureRecognizer];
    
    //饱和度亮度手势识别器
//    saturationBrightnessGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragSaturationBrightness:)];
//    saturationBrightnessGestureRecognizer.allowableMovement = FLT_MAX;
//    saturationBrightnessGestureRecognizer.minimumPressDuration = 0.0;
//    saturationBrightnessGestureRecognizer.delegate = self;
//    [self addGestureRecognizer:saturationBrightnessGestureRecognizer];
    
    self.subDivisions = 256;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float const resolution = MIN(self.bounds.size.width, self.bounds.size.height);
    
    radius = resolution / 2.0f;
    thickness = CIRCLE_THICKNESS * radius;
    boxSize = sqrt(BOX_THICKNESS * radius * BOX_THICKNESS * radius / 2.0f) * 2.0f;
    center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);

    layerHueCircle.frame = self.bounds;
    //layerSaturationBrightnessBox.frame = CGRectMake((self.bounds.size.width - boxSize) / 2.0f, (self.bounds.size.height - boxSize) / 2.0f, boxSize, boxSize);
    layerHueMarker.frame = [self hueMarkerRect];
    layerSaturationBrightnessMarker.frame = [self saturationBrightnessMarkerRect];
}

#pragma mark - Properties

- (void)setColor:(UIColor *)aColor
{
    colorHue = 1.0f;
    colorSaturation = 1.0f;
    colorBrightness = 1.0f;
    colorAlpha = 1.0f;
    if ( [aColor getHue:&colorHue saturation:&colorSaturation brightness:&colorBrightness alpha:&colorAlpha] == NO )
    {
        colorHue = 0.0;
        colorSaturation = 0.0f;
        [aColor getWhite:&colorBrightness alpha:&colorAlpha];
    }
        
    //layerSaturationBrightnessBox.hue = colorHue;
    layerHueMarker.frame = [self hueMarkerRect];
    layerSaturationBrightnessMarker.frame = [self saturationBrightnessMarkerRect];
}

//返回根据HSB（色调、饱和度、亮度）生成的颜色
- (UIColor *)color
{
    return [UIColor colorWithHue:colorHue saturation:1 brightness:1 alpha:colorAlpha];
}

//设置大色环-色调范围值
- (void)setSubDivisions:(unsigned int)value
{
    subDivisions = value;
    layerHueCircle.subDivisions = value;
}

//获取大色环-色调范围值
- (unsigned int)subDivisions
{
    return subDivisions;
}


#pragma mark - Marker positioning

#pragma 画圆圈
- (CGRect)hueMarkerRect
{
    CGFloat const radians = colorHue * 2.0f * M_PI;
    CGPoint const position = CGPointMake(cos(radians) * (radius - thickness / 2.0f), -sin(radians) * (radius - thickness / 2.0f));
    return CGRectMake(position.x - thickness / 2.0f + self.bounds.size.width / 2.0f, position.y - thickness / 2.0f+ self.bounds.size.height / 2.0f, thickness, thickness);
}

- (CGRect)saturationBrightnessMarkerRect
{
    return CGRectMake(colorSaturation * boxSize - boxSize / 2.0f - thickness / 2.0f + self.bounds.size.width / 2.0f, (1.0f - colorBrightness) * boxSize - boxSize / 2.0f - thickness / 2.0f + self.bounds.size.height / 2.0f, thickness, thickness);
}

#pragma mark - Touch handling

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( gestureRecognizer == hueGestureRecognizer )
    {
        // Check if the touch started inside the circle.
        CGPoint const position = [gestureRecognizer locationInView:self];
        CGFloat const distanceSquared = (center.x - position.x) * (center.x - position.x) + (center.y - position.y) * (center.y - position.y);
        return ( (radius - thickness) * (radius - thickness) < distanceSquared ) && ( distanceSquared <= radius * radius );
    }
    else if ( gestureRecognizer == saturationBrightnessGestureRecognizer )
    {
        // Check if the touch started inside the circle.
        CGPoint const position = [gestureRecognizer locationInView:self];
        CGFloat const saturation = (position.x - center.x) / boxSize + 0.5f;
        CGFloat const brightness = (position.y - center.y) / boxSize + 0.5f;
        
        return (saturation > -0.1) && (saturation < 1.1) && (brightness > -0.1) && (brightness < 1.1);
    }
    return YES;
}

#pragma mark - 长按手势事件

//长按手势激活事件
- (void)handleDragHue:(UIGestureRecognizer *)gestureRecognizer
{
    //判断手势：拖动与开始
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
        
//        layerSaturationBrightnessBox.hue = colorHue;
        [CATransaction begin];
        [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
        layerHueMarker.frame = [self hueMarkerRect];
        [CATransaction commit];
    }
    //判断手势：结束
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        if ([delegate respondsToSelector:@selector(colorPicker:changedColor:)])
        {
            [delegate colorPicker:self changedColor:self.color];
        }
    }
}


- (void)handleDragSaturationBrightness:(UIGestureRecognizer *)gestureRecognizer
{
    //判断手势：拖动与开始
    if ( (gestureRecognizer.state == UIGestureRecognizerStateBegan) || (gestureRecognizer.state == UIGestureRecognizerStateChanged) )
    {
        // 返回触摸在View视图上的位置
        CGPoint const position = [gestureRecognizer locationInView:self];
        //获取饱和度、亮度
        colorSaturation = MAX(1.0f, MIN(0.0f, (position.x - center.x) / boxSize + 0.5f));
        colorBrightness = MAX(1.0f, MIN(0.0f, (center.y - position.y) / boxSize + 0.5f));
        
        //创建动画
        [CATransaction begin];
        [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
        layerSaturationBrightnessMarker.frame = [self saturationBrightnessMarkerRect];
        [CATransaction commit];
        
        if ( [delegate respondsToSelector:@selector(colorPicker:changedColor:)] )
        {
            [delegate colorPicker:self changedColor:self.color];
        }
    }
}


@end
