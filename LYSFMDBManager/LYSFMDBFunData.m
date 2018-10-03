//
//  LYSFMDBFunData.m
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBFunData.h"

@implementation LYSFMDBFunData
// 计算表中所以数据某一字段的总和
// @"SELECT SUM(column_name) FROM TableName"
- (void)sumWithDict:(NSDictionary<NSString *,id> *)dict key:(NSString *)key tableName:(NSString *)tableName callBack:(void(^)(CGFloat sumValue))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"SELECT SUM(%@) AS sumValue FROM %@ WHERE ",key,tableName];
    NSMutableArray *argums = [NSMutableArray array];
    __block NSInteger index = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (index == 0) {
            [sqlStr appendFormat:@" %@=?",key];
        }else {
            [sqlStr appendFormat:@" AND %@=?",key];
        }
        [argums addObject:obj];
        index++;
    }];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr withArgumentsInArray:argums];
        while ([resultSet next]) {
            if (callBack) {
                callBack([resultSet doubleForColumn:@"sumValue"]);
            }
        }
    }];
}
// 计算表中所以数据某一字段的最大值
// @"SELECT MAX(column_name) FROM TableName"
- (void)maxWithDict:(NSDictionary<NSString *,id> *)dict key:(NSString *)key tableName:(NSString *)tableName callBack:(void(^)(CGFloat sumValue))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"SELECT MAX(%@) AS maxValue FROM %@ WHERE ",key,tableName];
    NSMutableArray *argums = [NSMutableArray array];
    __block NSInteger index = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (index == 0) {
            [sqlStr appendFormat:@" %@=?",key];
        }else {
            [sqlStr appendFormat:@" AND %@=?",key];
        }
        [argums addObject:obj];
        index++;
    }];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr withArgumentsInArray:argums];
        while ([resultSet next]) {
            if (callBack) {
                callBack([resultSet doubleForColumn:@"maxValue"]);
            }
        }
    }];
}
// 计算表中所以数据某一字段的最小值
// @"SELECT MIN(column_name) FROM TableName"
- (void)minWithDict:(NSDictionary<NSString *,id> *)dict key:(NSString *)key tableName:(NSString *)tableName callBack:(void(^)(CGFloat sumValue))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"SELECT MIN(%@) AS minValue FROM %@ WHERE ",key,tableName];
    NSMutableArray *argums = [NSMutableArray array];
    __block NSInteger index = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (index == 0) {
            [sqlStr appendFormat:@" %@=?",key];
        }else {
            [sqlStr appendFormat:@" AND %@=?",key];
        }
        [argums addObject:obj];
        index++;
    }];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr withArgumentsInArray:argums];
        while ([resultSet next]) {
            if (callBack) {
                callBack([resultSet doubleForColumn:@"minValue"]);
            }
        }
    }];
}
// 计算表中所有数据某一条件下的数据个数
// @"SELECT COUNT(column_name) FROM TableName"
- (void)countWithDict:(NSDictionary<NSString *,id> *)dict key:(NSString *)key tableName:(NSString *)tableName callBack:(void(^)(CGFloat sumValue))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"SELECT COUNT(%@) AS countValue FROM %@ WHERE ",key,tableName];
    NSMutableArray *argums = [NSMutableArray array];
    __block NSInteger index = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (index == 0) {
            [sqlStr appendFormat:@" %@=?",key];
        }else {
            [sqlStr appendFormat:@" AND %@=?",key];
        }
        [argums addObject:obj];
        index++;
    }];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr withArgumentsInArray:argums];
        while ([resultSet next]) {
            if (callBack) {
                callBack([resultSet doubleForColumn:@"countValue"]);
            }
        }
    }];
}
// 计算表中所有数据个数
// @"SELECT COUNT(*) FROM TableName"
- (void)countWithTableName:(NSString *)tableName callBack:(void(^)(CGFloat sumValue))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"SELECT COUNT(*) AS countValue FROM %@",tableName];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]) {
            if (callBack) {
                callBack([resultSet doubleForColumn:@"countValue"]);
            }
        }
    }];
}
// 计算表中某一条件下数据平均值
// @"SELECT AVG(*) FROM TableName"
- (void)avgWithDict:(NSDictionary<NSString *,id> *)dict key:(NSString *)key tableName:(NSString *)tableName callBack:(void(^)(CGFloat sumValue))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"SELECT AVG(%@) AS countValue FROM %@ WHERE",key,tableName];
    NSMutableArray *argums = [NSMutableArray array];
    __block NSInteger index = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (index == 0) {
            [sqlStr appendFormat:@" %@=?",key];
        }else {
            [sqlStr appendFormat:@" AND %@=?",key];
        }
        [argums addObject:obj];
        index++;
    }];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr withArgumentsInArray:argums];
        while ([resultSet next]) {
            if (callBack) {
                callBack([resultSet doubleForColumn:@"countValue"]);
            }
        }
    }];
}
@end
