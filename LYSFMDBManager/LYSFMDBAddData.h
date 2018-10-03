//
//  LYSFMDBAddData.h
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBCreateTable.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYSFMDBAddData : LYSFMDBCreateTable
/**
 添加数据
 
 @param valueDict 以JSON的形式向数据库中添加数据
 @param tableName 数据表的名字
 @param callBack 返回是否添加成功回调
 */
- (void)addLineWithDict:(NSDictionary<NSString *, id> *)valueDict
              tableName:(NSString *)tableName
               callBack:(void(^)(BOOL isSuccess))callBack;
/**
 批量插入数据,事务
 
 @param valueAry 数组嵌套JSON的形式批量插入数据
 @param tableName 数据表的名字
 @param callBack 返回是否插入成功
 */
- (void)batchAddLineWithDict:(NSArray<NSDictionary<NSString *, id> *> *)valueAry
                   tableName:(NSString *)tableName
                    callBack:(void(^)(BOOL isSuccess))callBack;
@end

NS_ASSUME_NONNULL_END
