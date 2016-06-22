//
//  XQDataManger.h
//  dataSave
//
//  Created by Xia_Q on 16/6/16.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "UserModel.h"

@interface XQDataManger : NSObject


//创建一个单例对象 来取得数据库管理类
+ (XQDataManger *)shareManger;

//按sql语言创建表格
- (void)createTableWithStr:(NSString *)sqlStr;

//通过model往数据库里面添加一条数据
- (void)insertDataWithModel:(UserModel *)model withTableName:(NSString *)tableName;

//通过主键来删除数据
- (void)deleteDataWithUserId:(NSInteger)userId withTableName:(NSString *)tableName;;

//通过主键来修改数据
- (void)updateDataWithModel:(UserModel *)model userId:(NSInteger)userId withTableName:(NSString *)tableName;;

//通过主键查找单条数据
- (UserModel *)selectDataWithUserId:(NSInteger)userID withTableName:(NSString *)tableName;;

//通过年龄查询相同年龄的数组
- (NSMutableArray *)selectDataWithUserAge:(NSString *)age withTableName:(NSString *)tableName;;

//返回所有数据
- (NSArray *)returnAllUserWithTableName:(NSString *)tableName;;




@end
