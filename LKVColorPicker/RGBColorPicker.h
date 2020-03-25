//
//  RGBColorPicker.h
//  SmartLightControl
//
//  Created by 李凯 on 2020/1/10.
//  Copyright © 2020 李凯. All rights reserved.
//

#import "LKVColorPicker.h"

@class HueCircleLayer;
@class SaturationBrightnessLayer;
@class MarkerLayer;

NS_ASSUME_NONNULL_BEGIN

@interface RGBColorPicker : LKVColorPicker
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
}

@end

NS_ASSUME_NONNULL_END
