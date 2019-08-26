//
//  LYSFMDBCreateTable.m
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBCreateTable.h"
@interface LYSFMDBCreateTable ()

@end
@implementation LYSFMDBCreateTable
#pragma mark - 创建数据库表 -
// @"CREATE TABLE IF NOT EXISTS TableName (KeyName integer PRIMARY KEY AUTOINCREMENT, name text, age integer)"
- (void)createTableWithIndexDict:(NSDictionary<NSString *, NSString *> *)indexDict tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    self.columnDict = indexDict;
    NSMutableString *sqlStr = [NSMutableString stringWithString:@"CREATE TABLE IF NOT EXISTS"];
    [sqlStr appendFormat:@" %@ (num integer PRIMARY KEY AUTOINCREMENT",tableName];
    [indexDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [sqlStr appendFormat:@",%@ %@",key, obj];
    }];
    [sqlStr appendString:@")"];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isSucCreate = [db executeUpdate:sqlStr];
        if (callBack) {callBack(isSucCreate);}
    }];
}
@end
