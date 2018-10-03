//
//  LYSFMDBUpdateData.m
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBUpdateData.h"

@implementation LYSFMDBUpdateData
// 更新数据
// @"UPDATE TableName SET name=? WHERE age =? "
- (void)updateLineWithDict:(NSDictionary<NSString *,id> *)dict valueDict:(NSDictionary<NSString *,id> *)valueDict tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"UPDATE %@ SET",tableName];
    NSMutableArray *argums = [NSMutableArray array];
    NSMutableString *valueStr = [NSMutableString string];
    NSMutableString *keyStr = [NSMutableString string];
    __block NSInteger index = 0;
    [valueDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (index == 0) {
            [valueStr appendFormat:@"%@=?",key];
        } else {
            [valueStr appendFormat:@", %@=?",key];
        }
        [argums addObject:obj];
        index++;
    }];
    __block NSInteger keyIndex = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (keyIndex == 0) {
            [keyStr appendFormat:@"%@=?",key];
        } else {
            [keyStr appendFormat:@", %@=?",key];
        }
        [argums addObject:obj];
        keyIndex++;
    }];
    [sqlStr appendFormat:@"%@ WHERE %@",valueStr,keyStr];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isSucUpdate = [db executeUpdate:sqlStr withArgumentsInArray:argums];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(isSucUpdate);});}
    }];
}
// 批量更新数据
// @"UPDATE TableName SET name=? WHERE age =? "
- (void)batchUpdateLineWithDict:(NSArray<NSDictionary<NSString *,id> *> *)dictAry valueDict:(NSArray<NSDictionary<NSString *,id> *> *)valueAry tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        int num = 0;
        for (int i = 0; i < [dictAry count]; i++) {
            NSDictionary *dict = [dictAry objectAtIndex:i];
            NSDictionary *valueDict = [valueAry objectAtIndex:i];
            NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"UPDATE %@ SET",tableName];
            NSMutableArray *argums = [NSMutableArray array];
            NSMutableString *valueStr = [NSMutableString string];
            NSMutableString *keyStr = [NSMutableString string];
            __block NSInteger index = 0;
            [valueDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if (index == 0) {
                    [valueStr appendFormat:@"%@=?",key];
                } else {
                    [valueStr appendFormat:@", %@=?",key];
                }
                [argums addObject:obj];
                index++;
            }];
            __block NSInteger keyIndex = 0;
            [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if (keyIndex == 0) {
                    [keyStr appendFormat:@"%@=?",key];
                } else {
                    [keyStr appendFormat:@", %@=?",key];
                }
                [argums addObject:obj];
                keyIndex++;
            }];
            [sqlStr appendFormat:@"%@ WHERE %@",valueStr,keyStr];
            BOOL isSucUpdate = [db executeUpdate:sqlStr withArgumentsInArray:argums];
            if (isSucUpdate) {
                num++;
            }
            if (callBack && num == [dictAry count] - 1) {
                dispatch_async(dispatch_get_main_queue(), ^{callBack(isSucUpdate);});
            }
            if (!isSucUpdate) {
                *rollback = YES;
                return;
            }
        }
    }];
}
@end
