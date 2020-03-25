//
//  HexCodes.m
//  SmartLightControl
//
//  Created by 李凯 on 2020/1/10.
//  Copyright © 2020 李凯. All rights reserved.
//

#import "HexCodes.h"

#define FLOAT_TO_UINT16(value) ((uint16_t)roundf(value * 255.0))

@implementation UIColor (HexCodes)

- (NSString *)formatHexCode
{
    CGFloat red, green, blue, alpha;
    if([self getRed:&red green:&green blue:&blue alpha:&alpha]){
        
        return [NSString stringWithFormat:@"#%02X%02X%02X", FLOAT_TO_UINT16(red), FLOAT_TO_UINT16(green), FLOAT_TO_UINT16(blue)];
    }
    
    return nil;
}

/**
*  判断三色值是否在色温的范围内
*
*  @param red   红色值
*  @param green 绿色值
*  @param blue  蓝色值
*
*/
- (BOOL)getColor:(CGFloat *)red withGreen:(CGFloat *)green withBlue:(CGFloat *)blue
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    unsigned int redTemp = components[0] * 255;
    unsigned int greenTemp = components[1] * 255;
    unsigned int blueTemp = components[2] * 255;
    
    if (redTemp >= 227 && redTemp <= 255 && greenTemp >= 141 && greenTemp <= 233 && blueTemp >= 11 && blueTemp <= 255)
    {
        *red = redTemp;
        *green = greenTemp;
        *blue = blueTemp;
        
        return YES;
    }
    return NO;
}

/**
*  获取颜色的三色值 范围（0~255）
*
*  @param red   红色值
*  @param green 绿色值
*  @param blue  蓝色值
*/
- (void)getColorWithRed:(CGFloat *)red withGreen:(CGFloat *)green withBlue:(CGFloat *)blue
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    *red = components[0] * 255;
    *green = components[1] * 255;
    *blue = components[2] * 255;
}


@end
