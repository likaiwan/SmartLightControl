//
//  HueCircleLayer.m
//  SmartLightControl
//
//  Created by 李凯 on 2020/1/10.
//  Copyright © 2020 李凯. All rights reserved.
//
//  大色环
//

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>
//#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "HueCircleLayer.h"
#import "config.h"


@implementation HueCircleLayer

@synthesize subDivisions;

// CALayer重新绘制时，执行的方法
- (void)drawInContext:(CGContextRef)ctx
{
    float const radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2.0f;
    float const thickness = radius * CIRCLE_THICKNESS;
    
    float const sliceAngle = 2.0f * M_PI / self.subDivisions;
    
    //创建矩形区域、路径、将矩形区域加入至路径中
    CGMutablePathRef path = CGPathCreateMutable();
    //设置路径起点
    CGPathMoveToPoint(path,
                      NULL,
                      cos(-sliceAngle / 2.0f) * (radius - thickness),
                      sin(-sliceAngle / 2.0f) * (radius - thickness));
    
    //向路径中追加一组圆弧
    CGPathAddArc(path,                              //动画的路径
                 NULL,
                 0.0f,                              //中心点X坐标
                 0.0f,                              //中心点Y坐标
                 radius - thickness,                //半径
                 -sliceAngle / 2.0f,                //起始的角度点
                 sliceAngle / 2.0f + 1.0e-2f,       //结束的角度点
                 false);                            //是否顺时针
    
    //向路径中追加一组圆弧
    CGPathAddArc(path,                              //动画的路径
                 NULL,
                 0.0f,                              //中心点X坐标
                 0.0f,                              //中心点Y坐标
                 radius,                            //半径
                 sliceAngle / 2.0f + 1.0e-2f,       //起始的角度点
                 -sliceAngle / 2.0f,                //结束的角度点
                 true);                             //是否顺时针
    
    //闭合路径、关闭路径、闭合路径的收尾相连的
    CGPathCloseSubpath(path);
    
    //平移变换
    CGContextTranslateCTM(ctx, self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
    //中心旋转角度值
    float const incrementAngle = 2.0f * M_PI / (float)self.subDivisions;
    
    for (int i=0; i<self.subDivisions; ++i) {
        
        //根据HSB（色调、饱和度、亮度）生成颜色
        UIColor *color = [UIColor colorWithHue:(float)i/(float)self.subDivisions    //色调
                                    saturation:1    //饱和度
                                    brightness:1    //亮度
                                         alpha:1];  //透明度
        //将路径添加到绘图上下文中
        CGContextAddPath(ctx, path);
        //填充颜色
        CGContextSetFillColorWithColor(ctx, color.CGColor);
        //设置填充的路径
        CGContextFillPath(ctx);
        //旋转变换
        CGContextRotateCTM(ctx, -incrementAngle);
    }
    
    //释放路径
    CGPathRelease(path);
}

@end
