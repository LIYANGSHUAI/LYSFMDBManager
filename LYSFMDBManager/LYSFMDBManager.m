//
//  LYSFMDBManager.m
//  H5Dev
//
//  Created by liyangshuai on 2018/4/13.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBManager.h"
#import <FMDB/FMDB.h>

@interface LYSFMDBManager ()

@property(nonatomic, strong)FMDatabaseQueue *queue;
@property(nonatomic, copy)NSString *filePath;

@end

@implementation LYSFMDBManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static LYSFMDBManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LYSFMDBManager alloc] init];
    });
    return instance;
}

// Documents
+ (NSString *)document
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

// Library
+ (NSString *)library
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

// Caches
+ (NSString *)caches
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

// 初始化
- (instancetype)initWithFilePath:(NSString *)filePath
{
    if (self = [super init]) {
        self.filePath = filePath;
        self.queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    }
    return self;
}
// 创建数据库表
// @"CREATE TABLE IF NOT EXISTS TableName (KeyName integer PRIMARY KEY AUTOINCREMENT, name text, age integer)"
- (void)createTableWithIndexDict:(NSDictionary<NSString *, NSString *> *)indexDict tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithString:@"CREATE TABLE IF NOT EXISTS"];
    [sqlStr appendFormat:@" %@ (num integer PRIMARY KEY AUTOINCREMENT",tableName];
    NSArray *keyAry = [indexDict allKeys];
    for (int i = 0; i < [keyAry count]; i++)
    {
        NSString *key = [keyAry objectAtIndex:i];
        [sqlStr appendFormat:@",%@ %@",key, indexDict[key]];
    }
    [sqlStr appendString:@")"];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isSucCreate = [db executeUpdate:sqlStr];
        if (callBack) {callBack(isSucCreate);}
    }];
}
// 添加数据
// @"INSERT INTO TableName (name, age) VALUES (?, ?)"
- (void)addLineWithDict:(NSDictionary<NSString *, id> *)valueDict tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithString:@"INSERT INTO"];
    NSMutableString *parmStr = [NSMutableString stringWithString:@"("];
    NSMutableArray *argums = [NSMutableArray array];
    [sqlStr appendFormat:@" %@ (",tableName];
    for (int i = 0; i < [[valueDict allKeys] count]; i++) {
        NSString *key = [valueDict allKeys][i];
        if (i == 0) {
            [sqlStr appendString:key];
            [parmStr appendString:@"?"];
        }else {
            [sqlStr appendString:@", "];
            [sqlStr appendString:key];
            [parmStr appendString:@","];
            [parmStr appendString:@"?"];
        }
        [argums addObject:valueDict[key]];
    }
    [parmStr appendString:@")"];
    [sqlStr appendString:@") VALUES "];
    [sqlStr appendString:parmStr];
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL isSucInsert = [db executeUpdate:sqlStr withArgumentsInArray:argums];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(isSucInsert);});}
    }];
}
// 删除数据
- (void)deleteLineWithDict:(NSDictionary<NSString *,id> *)dict tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithString:@"DELETE FROM"];
    [sqlStr appendFormat:@" %@ WHERE",tableName];
    NSMutableArray *argums = [NSMutableArray array];
    for (int i = 0; i <  [[dict allKeys] count]; i++) {
        NSString *key = [dict allKeys][i];
        if (i == 0) {
            [sqlStr appendFormat:@" %@=?",key];
        }else {
            [sqlStr appendFormat:@" AND %@=?",key];
        }
        [argums addObject:dict[key]];
    }
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isSucDelete = [db executeUpdate:sqlStr withArgumentsInArray:argums];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(isSucDelete);});}
    }];
}
// 更新数据
- (void)updateLineWithDict:(NSDictionary<NSString *,id> *)dict valueDict:(NSDictionary<NSString *,id> *)valueDict tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithString:@"UPDATE "];
    [sqlStr appendFormat:@"%@ SET ",tableName];
    NSMutableArray *argums = [NSMutableArray array];
    NSMutableString *valueStr = [NSMutableString string];
    NSArray *valueAry = [valueDict allKeys];
    for (int i = 0; i < [valueAry count]; i++) {
        NSString *value = [valueAry objectAtIndex:i];
        if (i == 0) {
            [valueStr appendFormat:@"%@=?",value];
        }else {
            [valueStr appendFormat:@", %@=?",value];
        }
        [argums addObject:valueDict[value]];
    }
    NSMutableString *keyStr = [NSMutableString string];
    NSArray *keyAry = [dict allKeys];
    for (int i = 0; i < [keyAry count]; i++) {
        NSString *key = [keyAry objectAtIndex:i];
        if (i == 0) {
            [keyStr appendFormat:@"%@=?",key];
        } else {
            [keyStr appendFormat:@" AND %@=?",key];
        }
        [argums addObject:dict[key]];
    }
    [sqlStr appendFormat:@"%@ WHERE %@",valueStr,keyStr];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isSucUpdate = [db executeUpdate:sqlStr withArgumentsInArray:argums];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(isSucUpdate);});}
    }];
}
// 查询所有数据
- (void)queryAllLineWithTableName:(NSString *)tableName callBack:(void(^)(NSArray *resultAry))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithString:@"SELECT * FROM "];
    [sqlStr appendString:tableName];
    NSMutableArray *tempAry = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]) {
            [tempAry addObject:resultSet.resultDictionary];
        }
        [resultSet close];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(tempAry);});}
    }];
}

// 查询给定条件下的数据
- (void)queryLineWithDict:(NSDictionary<NSString *,id> *)dict tableName:(NSString *)tableName callBack:(void(^)(NSArray *resultAry))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithString:@"SELECT * FROM"];
    [sqlStr appendFormat:@" %@ WHERE",tableName];
    NSMutableArray *argums = [NSMutableArray array];
    for (int i = 0; i <  [[dict allKeys] count]; i++) {
        NSString *key = [dict allKeys][i];
        if (i == 0) {
            [sqlStr appendFormat:@" %@=?",key];
        }else {
            [sqlStr appendFormat:@" AND %@=?",key];
        }
        [argums addObject:dict[key]];
    }
    NSMutableArray *tempAry = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr withArgumentsInArray:argums];
        while ([resultSet next]) {
            [tempAry addObject:resultSet.resultDictionary];
        }
        [resultSet close];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(tempAry);});}
    }];
}
// 分页查询
- (void)queryLineWithPage:(NSInteger)page limit:(NSInteger)limit tableName:(NSString *)tableName callBack:(void(^)(NSArray *resultAry))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithString:@"SELECT * FROM"];
    [sqlStr appendFormat:@" %@ LIMIT %ld, %ld",tableName,page,limit];
    NSMutableArray *tempAry = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]) {
            [tempAry addObject:resultSet.resultDictionary];
        }
        [resultSet close];
        if (callBack) {dispatch_async(dispatch_get_main_queue(), ^{callBack(tempAry);});}
    }];
}
// 批量插入数据
- (void)batchAddLineWithDict:(NSArray<NSDictionary<NSString *, id> *> *)valueAry tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        int num = 0;
        for (int i = 0; i < [valueAry count]; i++) {
            NSDictionary *valueDict = [valueAry objectAtIndex:i];
            NSMutableString *sqlStr = [NSMutableString stringWithString:@"INSERT INTO"];
            NSMutableString *parmStr = [NSMutableString stringWithString:@"("];
            NSMutableArray *argums = [NSMutableArray array];
            [sqlStr appendFormat:@" %@ (",tableName];
            for (int i = 0; i < [[valueDict allKeys] count]; i++) {
                NSString *key = [valueDict allKeys][i];
                if (i == 0) {
                    [sqlStr appendString:key];
                    [parmStr appendString:@"?"];
                }else {
                    [sqlStr appendString:@", "];
                    [sqlStr appendString:key];
                    [parmStr appendString:@","];
                    [parmStr appendString:@"?"];
                }
                [argums addObject:valueDict[key]];
            }
            [parmStr appendString:@")"];
            [sqlStr appendString:@") VALUES "];
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
// 批量删除数据
- (void)batchDeleteLineWithDict:(NSArray<NSDictionary<NSString *,id> *> *)dictAry tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        int num = 0;
        for (int i = 0; i < [dictAry count]; i++) {
            NSDictionary *dict = [dictAry objectAtIndex:i];
            NSMutableString *sqlStr = [NSMutableString stringWithString:@"DELETE FROM"];
            [sqlStr appendFormat:@" %@ WHERE",tableName];
            NSMutableArray *argums = [NSMutableArray array];
            for (int i = 0; i <  [[dict allKeys] count]; i++) {
                NSString *key = [dict allKeys][i];
                if (i == 0) {
                    [sqlStr appendFormat:@" %@=?",key];
                }else {
                    [sqlStr appendFormat:@" AND %@=?",key];
                }
                [argums addObject:dict[key]];
            }
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
// 批量更新数据
- (void)batchUpdateLineWithDict:(NSArray<NSDictionary<NSString *,id> *> *)dictAry valueDict:(NSArray<NSDictionary<NSString *,id> *> *)valueAry tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        int num = 0;
        for (int i = 0; i < [dictAry count]; i++) {
            NSDictionary *dict = [dictAry objectAtIndex:i];
            NSDictionary *valueDict = [valueAry objectAtIndex:i];
            NSMutableString *sqlStr = [NSMutableString stringWithString:@"UPDATE "];
            [sqlStr appendFormat:@"%@ SET ",tableName];
            NSMutableArray *argums = [NSMutableArray array];
            NSMutableString *valueStr = [NSMutableString string];
            NSArray *valueAry = [valueDict allKeys];
            for (int i = 0; i < [valueAry count]; i++) {
                NSString *value = [valueAry objectAtIndex:i];
                if (i == 0) {
                    [valueStr appendFormat:@"%@=?",value];
                }else {
                    [valueStr appendFormat:@", %@=?",value];
                }
                [argums addObject:valueDict[value]];
            }
            NSMutableString *keyStr = [NSMutableString string];
            NSArray *keyAry = [dict allKeys];
            for (int i = 0; i < [keyAry count]; i++) {
                NSString *key = [keyAry objectAtIndex:i];
                if (i == 0) {
                    [keyStr appendFormat:@"%@=?",key];
                } else {
                    [keyStr appendFormat:@" AND %@=?",key];
                }
                [argums addObject:dict[key]];
            }
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
// 清空表格
- (void)clearTableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithString:@"DELETE FROM "];
    [sqlStr appendString:tableName];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isSucClear = [db executeUpdate:sqlStr];
        if (callBack) {
            dispatch_async(dispatch_get_main_queue(), ^{callBack(isSucClear);});
        }
    }];
}
// 删除表格
- (void)deleteTableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack
{
    NSMutableString *sqlStr = [NSMutableString stringWithString:@"DROP TABLE IF EXISTS "];
    [sqlStr appendString:tableName];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isSucDelete = [db executeUpdate:sqlStr];
        if (callBack) {
            dispatch_async(dispatch_get_main_queue(), ^{callBack(isSucDelete);});
        }
    }];
}
@end
