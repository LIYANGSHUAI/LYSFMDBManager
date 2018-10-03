//
//  LYSFMDBDeleteData.h
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBAddData.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYSFMDBDeleteData : LYSFMDBAddData
/**
 删除数据
 
 @param dict 以JSON的形式匹配要删除的数据,并删除
 @param tableName 数据表的名字
 @param callBack 返回是否删除成功
 */
- (void)deleteLineWithDict:(NSDictionary<NSString *,id> *)dict
                 tableName:(NSString *)tableName
                  callBack:(void(^)(BOOL isSuccess))callBack;

/**
 批量删除数据,事务
 
 @param dictAry 数组嵌套JSON的形式批量删除数据
 @param tableName 数据表的名字
 @param callBack 返回是否删除成功
 */
- (void)batchDeleteLineWithDict:(NSArray<NSDictionary<NSString *,id> *> *)dictAry
                      tableName:(NSString *)tableName
                       callBack:(void(^)(BOOL isSuccess))callBack;
/**
 清空表格
 
 @param tableName 数据表的名字
 @param callBack 返回是否清除成功
 */
- (void)clearTableName:(NSString *)tableName
              callBack:(void(^)(BOOL isSuccess))callBack;

/**
 删除表格
 
 @param tableName 数据表的名字
 @param callBack 返回是否删除成功
 */
- (void)deleteTableName:(NSString *)tableName
               callBack:(void(^)(BOOL isSuccess))callBack;

@end

NS_ASSUME_NONNULL_END
