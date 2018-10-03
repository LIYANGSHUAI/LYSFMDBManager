//
//  LYSFMDBDeleteData.m
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBDeleteData.h"

@implementation LYSFMDBDeleteData
// 删除数据
// @"DELETE FROM TableName WHERE name=? AND age=?"
- (void)deleteLineWithDict:(NSDictionary<NSString *,id> *)dict tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"DELETE FROM %@",tableName];
    NSMutableArray *argums = [NSMutableArray array];
    __block NSInteger index = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (index == 0) {
            [sqlStr appendFormat:@"WHERE %@=?",key];
        } else {
            [sqlStr appendFormat:@" AND %@=?",key];
        }
        [argums addObject:obj];
        index++;
    }];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isSucDelete = [db executeUpdate:sqlStr withArgumentsInArray:argums];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(isSucDelete);});}
    }];
}
// 批量删除数据
// @"DELETE FROM TableName WHERE name=? AND age=?"
- (void)batchDeleteLineWithDict:(NSArray<NSDictionary<NSString *,id> *> *)dictAry tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        int num = 0;
        for (int i = 0; i < [dictAry count]; i++) {
            NSDictionary *dict = [dictAry objectAtIndex:i];
            NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"DELETE FROM %@",tableName];
            NSMutableArray *argums = [NSMutableArray array];
            __block NSInteger index = 0;
            [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if (index == 0) {
                    [sqlStr appendFormat:@"WHERE %@=?",key];
                } else {
                    [sqlStr appendFormat:@" AND %@=?",key];
                }
                [argums addObject:obj];
                index++;
            }];
            BOOL isSucDelete = [db executeUpdate:sqlStr withArgumentsInArray:argums];
            if (isSucDelete) {
                num++;
            }
            if (callBack && num == [dictAry count] - 1) {
                dispatch_async(dispatch_get_main_queue(), ^{callBack(isSucDelete);});
            }
            if (!isSucDelete) {
                *rollback = YES;
                return;
            }
        }
    }];
}
// 清空表格
//@"DELETE FROM TableName"
- (void)clearTableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"DELETE FROM %@",tableName];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isSucClear = [db executeUpdate:sqlStr];
        if (callBack) {
            dispatch_async(dispatch_get_main_queue(), ^{callBack(isSucClear);});
        }
    }];
}
// 删除表格
// @"DROP TABLE IF EXISTS TableName"
- (void)deleteTableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isSucDelete = [db executeUpdate:sqlStr];
        if (callBack) {
            dispatch_async(dispatch_get_main_queue(), ^{callBack(isSucDelete);});
        }
    }];
}
@end
