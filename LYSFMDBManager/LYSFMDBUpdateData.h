//
//  LYSFMDBUpdateData.h
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBDeleteData.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYSFMDBUpdateData : LYSFMDBDeleteData
/**
 更新数据
 
 @param dict 以JSON的形式匹配要更新的数据
 @param valueDict 以JSON的形式替换匹配要的数据
 @param tableName 数据表的名字
 @param callBack 返回是否更新成功
 */
- (void)updateLineWithDict:(NSDictionary<NSString *,id> *)dict
                 valueDict:(NSDictionary<NSString *,id> *)valueDict
                 tableName:(NSString *)tableName
                  callBack:(void(^)(BOOL isSuccess))callBack;
/**
 批量更新数据,事务
 
 @param dictAry 数组嵌套JSON的形式匹配数据
 @param valueAry 数组嵌套JSON的形式更新数据
 @param tableName 数据表的名字
 @param callBack 返回是否更新成功
 */
- (void)batchUpdateLineWithDict:(NSArray<NSDictionary<NSString *,id> *> *)dictAry
                      valueDict:(NSArray<NSDictionary<NSString *,id> *> *)valueAry
                      tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack;


@end

NS_ASSUME_NONNULL_END
