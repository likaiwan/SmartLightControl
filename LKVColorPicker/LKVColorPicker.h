//
//  LKVColorPicker.h
//  SmartLightControl
//
//  Created by 李凯 on 2019/11/20.
//  Copyright © 2019 李凯. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "HexCodes.h"

NS_ASSUME_NONNULL_BEGIN

@class HueCircleLayer;
@class SaturationBrightnessLayer;
@class MarkerLayer;

@protocol LKVColorPickerDelegate;

//遵循两个协议：
//手势力协议:UIGestureRecognizerDelegate
@interface LKVColorPicker : UIControl<UIGestureRecognizerDelegate>
{
    //大色环
    HueCircleLayer * layerHueCircle;
    
    //饱和亮度层   -   圆圈
    SaturationBrightnessLayer * layerSaturationBrightnessBox;
    
    //标记层   - 圆圈
    MarkerLayer * layerHueMarker;
    MarkerLayer * layerSaturationBrightnessMarker;
    
    // 色调
    CGFloat colorHue;
    
    // 饱和
    CGFloat colorSaturation;
    
    // 亮度
    CGFloat colorBrightness;
    
    CGFloat colorAlpha;
    CGFloat boxSize;
    CGPoint center;
    CGFloat radius;
    CGFloat thickness;
    
    unsigned int subDivisions;
    
    //长按手势
    UILongPressGestureRecognizer * hueGestureRecognizer;
    UILongPressGestureRecognizer * saturationBrightnessGestureRecognizer;
}

@property (retain) UIColor * color;

@property (assign) unsigned int subDivisions;

@property (weak) id<LKVColorPickerDelegate> delegate;

//+ (EAGLContext *)sharedEAGLContext;

- (CGRect)hueMarkerRect;
- (CGRect)saturationBrightnessMarkerRect;

@end

//定义协议
@protocol LKVColorPickerDelegate <NSObject>

//方法必须实现
@required
- (void) colorPicker:(LKVColorPicker *) colorPicker changedColor:(UIColor *)color;

//不一定要实现
@optional

@end

NS_ASSUME_NONNULL_END
