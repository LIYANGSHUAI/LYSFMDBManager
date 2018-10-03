//
//  LYSFMDBAddData.m
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBAddData.h"

@implementation LYSFMDBAddData
// 添加数据
// @"INSERT INTO TableName (name, age) VALUES (?, ?)"
- (void)addLineWithDict:(NSDictionary<NSString *, id> *)valueDict tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"INSERT INTO %@ (",tableName];
    NSMutableString *parmStr = [NSMutableString stringWithString:@"("];
    NSMutableArray *argums = [NSMutableArray array];
    __block NSInteger index = 0;
    [valueDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (index == 0) {
            [sqlStr appendString:key];
            [parmStr appendString:@"?"];
        } else {
            [sqlStr appendFormat:@", %@",key];
            [parmStr appendString:@", ?"];
        }
        [argums addObject:obj];
        index++;
    }];
    [sqlStr appendString:@") VALUES "];
    [parmStr appendString:@")"];
    [sqlStr appendString:parmStr];
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL isSucInsert = [db executeUpdate:sqlStr withArgumentsInArray:argums];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(isSucInsert);});}
    }];
}
// 批量插入数据
// @"INSERT INTO TableName (name, age) VALUES (?, ?)"
- (void)batchAddLineWithDict:(NSArray<NSDictionary<NSString *, id> *> *)valueAry tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        int num = 0;
        for (int i = 0; i < [valueAry count]; i++) {
            NSDictionary *valueDict = [valueAry objectAtIndex:i];
            NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"INSERT INTO %@ (",tableName];
            NSMutableString *parmStr = [NSMutableString stringWithString:@"("];
            NSMutableArray *argums = [NSMutableArray array];
            __block NSInteger index = 0;
            [valueDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if (index == 0) {
                    [sqlStr appendString:key];
                    [parmStr appendString:@"?"];
                } else {
                    [sqlStr appendFormat:@", %@",key];
                    [parmStr appendString:@", ?"];
                }
                [argums addObject:obj];
                index++;
            }];
            [sqlStr appendString:@") VALUES "];
            [parmStr appendString:@")"];
            [sqlStr appendString:parmStr];
            BOOL isSucInsert = [db executeUpdate:sqlStr withArgumentsInArray:argums];
            if (isSucInsert) {
                num++;
            }
            if (callBack && num == [valueAry count] - 1) {
                dispatch_async(dispatch_get_main_queue(), ^{callBack(isSucInsert);});
            }
            if (!isSucInsert) {
                *rollback = YES;
                return;
            }
        }
    }];
}
@end
