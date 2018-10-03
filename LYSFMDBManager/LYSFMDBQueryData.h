//
//  LYSFMDBQueryData.h
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBUpdateData.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYSFMDBQueryData : LYSFMDBUpdateData
/**
 查询所有数据
 
 @param tableName 数据表的名字
 @param callBack 返回查询到的所有数据
 */
- (void)queryAllLineWithTableName:(NSString *)tableName
                         callBack:(void(^)(NSArray *resultAry))callBack;

/**
 查询给定条件下的数据 条件关系 AND
 
 @param dict 以JSON的形式匹配数据
 @param tableName 数据表的名字
 @param callBack 返回匹配到的数据
 */
- (void)queryLineWithDict:(NSDictionary<NSString *,id> *)dict
                tableName:(NSString *)tableName
                 callBack:(void(^)(NSArray *resultAry))callBack;

/**
 分页查询 查询所有数据
 
 @param page 要查询的页数
 @param limit 每页的数据
 @param tableName 数据表的名字
 @param callBack 返回查询到的数据
 */
- (void)queryLineWithPage:(NSInteger)page limit:(NSInteger)limit
                tableName:(NSString *)tableName
                 callBack:(void(^)(NSArray *resultAry))callBack;


/**
 查询给定区间的数据

 @param key 参考列名
 @param beginValue 开始值
 @param endValue 结束值
 @param tableName m表名
 @param callBack 返回查询的数据
 */
- (void)queryLineWithKey:(NSString *)key
              beginValue:(id)beginValue
                endValue:(id)endValue
               tableName:(NSString *)tableName
                callBack:(void (^)(NSArray * _Nonnull))callBack;

/**
 模糊查询给定区间的数据

 @param key 查询的列名
 @param value 值
 @param tableName 表名
 @param callBack 返回数据
 */
- (void)querySlurLineWithKey:(NSString *)key
                       value:(NSString *)value
                   tableName:(NSString *)tableName
                    callBack:(void (^)(NSArray * _Nonnull))callBack;
@end

NS_ASSUME_NONNULL_END
