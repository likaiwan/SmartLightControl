//
//  config.h
//  SmartLightControl
//
//  Created by 李凯 on 2020/1/10.
//  Copyright © 2020 李凯. All rights reserved.
//

#ifndef config_h
#define config_h

//static float const CIRCLE_THICKNESS = 0.28f;

//static float const BOX_THICKNESS = 0.7f;

#define CIRCLE_THICKNESS    0.28f
#define BOX_THICKNESS       0.70f


// 数据点数据更新的通知
#define GosDeviceControlDataValueUpdateNotification @"GosDeviceControlDataValueUpdateNotification"

// 数据点标识符
#define DATA_ATTR_POWER_SWITCH          @"Power_Switch"             // 灯的开关
#define DATA_ATTR_BRIGHTNESS            @"Brightness"               // 亮度调节
#define DATA_ATTR_COLOR_R               @"Color_R"                  // 红色值
#define DATA_ATTR_COLOR_G               @"Color_G"                  // 绿色值
#define DATA_ATTR_COLOR_B               @"Color_B"                  // 蓝色值
#define DATA_ATTR_MODE                  @"mode"                     // 模式调节 - 0：色彩调节  1：色温调节
#define DATA_ATTR_COUNTDOWN_OFF_MIN     @"CountDown_Off_min"        // 延时时长
#define DATA_ATTR_COUNTDOWN_SWITCH      @"CountDown_Switch"         // 延时开关
#define DATA_ATTR_TEMPERATURE_R         @"Temperature_R"
#define DATA_ATTR_TEMPERATURE_G         @"Temperature_G"
#define DATA_ATTR_TEMPERATURE_B         @"Temperature_B"

#endif /* config_h */
