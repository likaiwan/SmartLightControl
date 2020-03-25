//
//  LKTransferDataHelper.h
//  SmartLightControl
//
//  Created by 李凯 on 2020/3/24.
//  Copyright © 2020 李凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//网络传输是大端字节顺序 蓝牙传输是小端字节顺序
typedef NS_ENUM(NSInteger,JKTransferByteSortType){
    JKTransferByteSortBig,            ///< 大端字节顺序  byte sort big model
    JKTransferByteSortSmall           ///< 小端字节顺序  byte sort smallModel
};

@interface LKTransferDataConfig : NSObject

@property (nonatomic,assign) NSUInteger mtuSize;       ///< the transportlation unit  the size is byte
@property (nonatomic,assign) NSUInteger packetHeadSize;///<  the data head,the unit is byte
@property (nonatomic,assign) JKTransferByteSortType byteSortType;///<

+ (instancetype)configMTUSize:(NSUInteger)mtuSize packetHeadSize:(NSUInteger)packetHeadSize byteSortType:(JKTransferByteSortType)byteSortType;


@end

@interface LKTransferDataHelper : NSObject

/**
 handle the data with packet sort Num
 //主要是对要传输的数据进行转换，根据需求为每个传输单元加上序列号
 @param data binary data
 @param dataConfig dataConfig
 @return data with sort Num
 */
+ (NSMutableData *)formatData:(NSData *)data dataConfig:(LKTransferDataConfig *)dataConfig;

/**
 remove the sort Num in binary data
 //对接收到的含有序列号的数据，去掉序列号的包头，然后重新拼接成为我们真正需求要的数据
 @param data binary data
 @param dataConfig dataConfig
 @return binary without sorNum
 */
+ (NSMutableData *)unFormatData:(NSMutableData *)data dataConfig:(LKTransferDataConfig *)dataConfig;

/**
 append unitPacketData
 //数据接收到单元数据，然后感觉需求进行拼接的操作
 @param unitPacketData unitPacketData
 @param originData the origin data
 @param dataLength the target data length
 @param dataConfig dataConfig
 @return <#return value description#>
 */
+ (NSMutableData *)appendUnitPacketData:(NSData *)unitPacketData originData:(NSMutableData *)originData dataLength:(NSUInteger)dataLength dataConfig:(LKTransferDataConfig *)dataConfig;

/**
 config the binary data head
 //根据数据的长度，生成包头数据
 @param originDataLength the data length
 @param dataConfig dataConfig
 @return the binary data of data head
 */
+ (NSData *)configPacketHead:(NSUInteger)originDataLength dataConfig:(LKTransferDataConfig *)dataConfig;

/**
 get the origin data length
 //获取包头数据，并解析出数据的长度
 @param data  binary data
 @param dataConfig dataConfig
 @return the origin length of the data
 */
+ (NSUInteger)getOriginDataLength:(NSData *)data dataConfig:(LKTransferDataConfig *)dataConfig;

/**
 get the format dataLength with packet sort Num
 //根据需求，获取数据添加万序列号以后的长度。
 @param originData originData
 @param dataConfig dataConfig
 @return the dataLenght
 */
+ (NSUInteger)getFormatBodyDataLengthWithOriginData:(NSData *)originData dataConfig:(LKTransferDataConfig *)dataConfig;


/**
 get appropriate PacketHeadSize with originData and mtuSize
 //根据要传输的数据，计算出合适的传输包序列号所占的字节长度。
 @param originData originData
 @param mtuSize mtuSize
 @return PacketHeasSize
 */
+ (NSUInteger)getPacketHeadSizeWithOriginData:(NSData *)originData mtuSize:(NSUInteger)mtuSize;


@end

NS_ASSUME_NONNULL_END
