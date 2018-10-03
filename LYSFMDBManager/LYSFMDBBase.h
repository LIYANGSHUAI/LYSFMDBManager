//
//  LYSFMDBBase.h
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FMDB/FMDB.h>
NS_ASSUME_NONNULL_BEGIN


/*
 * --- Documents 使用该路径放置关键数据，也就是不能通过App重新生成的数据。该路径可通过配置实现iTunes共享文件。可被iTunes备份。（现在保存在该路径下的文件还需要考虑iCloud同步),如数据库文件，或程序中浏览到的文件数据。如果进行备份会将此文件夹中的文件包括其中
 * --- Library 该路径下一般保存着用户配置文件。可创建子文件夹。可以用来放置您希望被备份但不希望被用户看到的数据。该路径下的文件夹，除Caches以外，都会被iTunes备份
 *     -- Caches 存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
 *     -- Preferences 存储应用的默认设置及状态信息
 * --- tmp 提供一个即时创建临时文件的地方
 */

@interface LYSFMDBBase : NSObject
@property(nonatomic, copy) NSString *filePath;
@property(nonatomic, strong, readonly) FMDatabaseQueue *queue;
@property(nonatomic, strong, readonly) NSDictionary<NSString *, NSString *> *columnDict;
// Documents
+ (NSString *)document;
// Library
+ (NSString *)library;
// Caches
+ (NSString *)caches;

/**
 初始化数据路径地址
 
 @param filePath 路径
 @return 返回LYSFMDBManager对象
 */
- (instancetype)initWithFilePath:(NSString *)filePath;


/**
 根据数据类型取数据

 @param resultSet 数据类
 @return 解析后的数据
 */
- (NSDictionary *)gotValueWithSet:(FMResultSet *)resultSet;
@end

NS_ASSUME_NONNULL_END
