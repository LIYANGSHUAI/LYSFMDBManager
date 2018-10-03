//
//  LYSFMDBFunData.h
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBQueryData.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYSFMDBFunData : LYSFMDBQueryData
/**
 计算表中所以数据某一字段的总和
 
 @param dict 条件
 @param tableName 数据表的名字
 @param key 要计算的列名
 @param callBack 回调数据的和
 */
- (void)sumWithDict:(NSDictionary<NSString *,id> *)dict
                key:(NSString *)key
          tableName:(NSString *)tableName
           callBack:(void(^)(CGFloat sumValue))callBack;
/**
 计算表中所以数据某一字段的最大值
 
 @param dict 条件
 @param key 计算的列名
 @param tableName 表名
 @param callBack 返回最大值
 */
- (void)maxWithDict:(NSDictionary<NSString *,id> *)dict
                key:(NSString *)key
          tableName:(NSString *)tableName
           callBack:(void(^)(CGFloat sumValue))callBack;
/**
 计算表中所以数据某一字段的最小值
 
 @param dict 条件
 @param key 计算的列名
 @param tableName 表名
 @param callBack 返回最小值
 */
- (void)minWithDict:(NSDictionary<NSString *,id> *)dict
                key:(NSString *)key
          tableName:(NSString *)tableName
           callBack:(void(^)(CGFloat sumValue))callBack;

/**
 计算表中所有数据某一条件下的数据个数
 
 @param dict 条件
 @param key 计算的列名
 @param tableName 表名
 @param callBack 返回数据个数
 */
- (void)countWithDict:(NSDictionary<NSString *,id> *)dict
                  key:(NSString *)key
            tableName:(NSString *)tableName
             callBack:(void(^)(CGFloat sumValue))callBack;
/**
 计算表中所有数据个数
 
 @param tableName 表名
 @param callBack 返回个数
 */
- (void)countWithTableName:(NSString *)tableName
                  callBack:(void(^)(CGFloat sumValue))callBack;

/**
 计算表中某一条件下数据平均值
 
 @param dict 条件
 @param key 列名
 @param tableName 表名
 @param callBack 返回平局值
 */
- (void)avgWithDict:(NSDictionary<NSString *,id> *)dict
                key:(NSString *)key
          tableName:(NSString *)tableName
           callBack:(void(^)(CGFloat sumValue))callBack;
@end

NS_ASSUME_NONNULL_END
