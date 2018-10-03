//
//  LYSFMDBQueryData.m
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBQueryData.h"

@implementation LYSFMDBQueryData
// 查询所有数据
// @"SELECT * FROM TableName"
- (void)queryAllLineWithTableName:(NSString *)tableName callBack:(void(^)(NSArray *resultAry))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"SELECT * FROM %@",tableName];
    NSMutableArray *tempAry = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]) {
            [tempAry addObject:[self gotValueWithSet:resultSet]];
        }
        [resultSet close];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(tempAry);});}
    }];
}
// 查询给定条件下的数据 AND
// @"SELECT * FROM TableName WHERE name=? AND age=?"
- (void)queryLineWithDict:(NSDictionary<NSString *,id> *)dict tableName:(NSString *)tableName callBack:(void(^)(NSArray *resultAry))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE", tableName];
    NSMutableArray *argums = [NSMutableArray array];
    __block NSInteger index = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (index == 0) {
            [sqlStr appendFormat:@" %@=?",key];
        } else {
            [sqlStr appendFormat:@" AND %@=?",key];
        }
        [argums addObject:obj];
        index++;
    }];
    NSMutableArray *tempAry = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr withArgumentsInArray:argums];
        while ([resultSet next]) {
            [tempAry addObject:[self gotValueWithSet:resultSet]];
        }
        [resultSet close];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(tempAry);});}
    }];
}
// 查询给定区间的数据
- (void)queryLineWithKey:(NSString *)key beginValue:(id)beginValue endValue:(id)endValue tableName:(NSString *)tableName callBack:(void (^)(NSArray * _Nonnull))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE %@ BETWEEN ? AND ?", tableName,key];
    NSMutableArray *tempAry = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr withArgumentsInArray:@[beginValue,endValue]];
        while ([resultSet next]) {
            [tempAry addObject:[self gotValueWithSet:resultSet]];
        }
        [resultSet close];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(tempAry);});}
    }];
}

// 分页查询 查询所有数据
// @"SELECT * FROM TableName LIMIT page, limit"
- (void)queryLineWithPage:(NSInteger)page limit:(NSInteger)limit tableName:(NSString *)tableName callBack:(void(^)(NSArray *resultAry))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"SELECT * FROM %@ LIMIT %ld, %ld",tableName,page,limit];
    NSMutableArray *tempAry = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]) {
            [tempAry addObject:[self gotValueWithSet:resultSet]];
        }
        [resultSet close];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(tempAry);});}
    }];
}
// 模糊查询给定区间的数据
- (void)querySlurLineWithKey:(NSString *)key  value:(NSString *)value tableName:(NSString *)tableName callBack:(void (^)(NSArray * _Nonnull))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE '%@'", tableName,key,value];
    NSMutableArray *tempAry = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]) {
            [tempAry addObject:[self gotValueWithSet:resultSet]];
        }
        [resultSet close];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(tempAry);});}
    }];
}
@end
