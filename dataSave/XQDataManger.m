//
//  XQDataManger.m
//  dataSave
//
//  Created by Xia_Q on 16/6/16.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "XQDataManger.h"

static XQDataManger *_manger = nil;

@implementation XQDataManger{
    FMDatabase *_dataBase;//数据库管理的对象
}

//创建一个单例对象 来取得数据库管理类
+ (XQDataManger *)shareManger{
    static dispatch_once_t onceToken;
    static id shareManger;
    dispatch_once(&onceToken, ^{
        shareManger = [[self alloc] init];
    });
    return shareManger;
}

//初始化
-(id)init{
    
    if (self == [super init]) {
        //数据库放的地址
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/user.db"];
        NSLog(@"%@",path);
        
        _dataBase =[[FMDatabase alloc]initWithPath:path];

        [self createTableWithStr:@"create table if not exists user(id integer primary key autoincrement,name varchar(255),age integer,image blob);"];
        
    }
    return self;
}

//通过SQL语句创建表
- (void)createTableWithStr:(NSString *)sqlStr{
    //open  查看 你给路径下有没有这个db文件 没有则创建一个 然后再打开,有的话就直接打开
    BOOL isSueecss = [_dataBase open];
    if(isSueecss) {
        NSLog(@"数据库打开成功");
        //创建一张表
        //executeUpdate: 可以执行 增 删  改  创建表 （除了查询）
        //blob 二进制数据
        NSString *createSql = [NSString stringWithString:sqlStr];
        
        BOOL ret = [_dataBase executeUpdate:createSql];
        
        if(ret) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"error %@",_dataBase.lastErrorMessage);
        }
    } else {
        NSLog(@"数据库打开失败");
    }
    
    //关闭数据库
    [_dataBase close];

}

//通过model往数据库里面添加一条数据
- (void)insertDataWithModel:(UserModel *)model withTableName:(NSString *)tableName{
    
    BOOL ret =[_dataBase open];
    if (!ret) {
        NSLog(@"数据库打开失败");
        return;
    }
    
    if ([tableName isEqualToString:@"user"]) {
        //执行插入语句， ？代表占位符，可以不用管后面的数据类型
        NSString *insertSql = @"insert into user(name,age,image) values(?,?,?)";
        BOOL ret2 = [_dataBase executeUpdate:insertSql,model.nameString,model.ageString,model.imageData];
        
        if (!ret2) {
            NSLog(@"insert error %@",_dataBase.lastErrorMessage);
        }
    }
    
    
    [_dataBase close];
    
}

//通过主键来删除数据
- (void)deleteDataWithUserId:(NSInteger)userId withTableName:(NSString *)tableName {
    //打开数据库
    BOOL isSuccess = [_dataBase open];
    
    if(!isSuccess) {
        NSLog(@"数据库打开失败");
        return;
    }
    
    if ([tableName isEqualToString:@"user"]) {
        NSString *deleteSql = @"delete from user where id = ?";
        
        //基本类型 一定要转化为NSObject的子类
        //
        BOOL ret = [_dataBase executeUpdate:deleteSql,[NSNumber numberWithInteger:userId]];
        if(ret) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"delete error %@",_dataBase.lastErrorMessage);
        }

    }
    
    
    
    //数据库关闭
    [_dataBase close];

}

//通过主键来修改数据
- (void)updateDataWithModel:(UserModel *)model userId:(NSInteger)userId withTableName:(NSString *)tableName{

    //数据库打开
    BOOL isSuccess = [_dataBase open];
    
    if(!isSuccess) {
        NSLog(@"数据库打开失败");
        return;
    }
    
    if ([tableName isEqualToString:@"user"]) {
        //修改语句
        NSString *updateSql = @"update user set name = ?, age = ?, image = ? where id = ?";
        BOOL ret = [_dataBase executeUpdate:updateSql,model.nameString,model.ageString,model.imageData,[NSNumber numberWithInteger:userId]];
        if(!ret){
            NSLog(@"update error %@",_dataBase.lastErrorMessage);
        }
  
    }
    
    
    [_dataBase close];
    
}

//通过主键查找单条数据
- (UserModel *)selectDataWithUserId:(NSInteger)userID withTableName:(NSString *)tableName{

    BOOL isSuccess = [_dataBase open];
    
    if(!isSuccess) {
        NSLog(@"打开失败");
        return nil;
    }
    
    
    if ([tableName isEqualToString:@"user"]) {
        //查询的sql语句
        NSString *selectSql = @"select * from user where id = ?";
        //查询用executeQuery:  返回一个结果集FMResultSet
        FMResultSet *ret = [_dataBase executeQuery:selectSql,[NSNumber numberWithInteger:userID]];
        //next  会返回的从第一条数据遍历到最后一条
        //[ret next] 当前这条数据如果能取到 返回YES 否则返回NO
        
        UserModel * model = [[UserModel alloc] init];
        
        if ([ret next]) {
            //返回一个 1*n的矩阵  n代表你字段总数
            NSString *name = [ret stringForColumn:@"name"];
            NSInteger age = [ret intForColumn:@"age"];
            NSData *imageData = [ret dataForColumn:@"image"];
            
            model.nameString = name;
            model.ageString = [NSString stringWithFormat:@"%d",age];
            model.imageData = imageData;
            model.userID = [ret intForColumn:@"id"];
        }
        [_dataBase close];

        return model;

    }else{
        UserModel * model = [[UserModel alloc] init];
        [_dataBase close];

        return model;
    }
    

    
    
    
}

- (NSMutableArray *)selectDataWithUserAge:(NSString *)age withTableName:(NSString *)tableName{
    BOOL isSuccess = [_dataBase open];
    if(!isSuccess) {
        NSLog(@"打开失败");
        return nil;
    }
    NSMutableArray *backArr=[[NSMutableArray alloc]init];
    
    if ([tableName isEqualToString:@"user"]) {
        
        NSString *selectSql = @"select * from user where age = ?";
        //查询用executeQuery:  返回一个结果集FMResultSet
        FMResultSet *ret = [_dataBase executeQuery:selectSql,age];
        NSLog(@"%@",ret);
        
        while([ret next]) {
            
            UserModel *model =[[UserModel alloc]init];
            model.userID =[ret intForColumn:@"id"];
            model.nameString=[ret stringForColumn:@"name"];
            model.ageString=[NSString stringWithFormat:@"%d",[ret intForColumn:@"age"]];
            model.imageData=[ret dataForColumn:@"image"];
            [backArr addObject:model];
        }
    }
    
    
    [_dataBase close];
    return backArr;

}

//返回所有数据
- (NSArray *)returnAllUserWithTableName:(NSString *)tableName {
    BOOL isSuccess = [_dataBase open];
    
    if(!isSuccess) {
        NSLog(@"打开失败");
        return nil;
    }
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];

    if ([tableName isEqualToString:@"user"]) {
        //查询的sql语句
        NSString *selectSql = @"select * from user;";
        //查询用executeQuery:  返回一个结果集FMResultSet
        FMResultSet *ret = [_dataBase executeQuery:selectSql];
        //next  会返回的从第一条数据遍历到最后一条
        //[ret next] 当前这条数据如果能取到 返回YES 否则返回NO
        
        while ([ret next]) {
            //返回一个 1*n的矩阵  n代表你字段总数
            NSString *name = [ret stringForColumn:@"name"];
            NSInteger age = [ret intForColumn:@"age"];
            NSData *imageData = [ret dataForColumn:@"image"];
            
            UserModel * model = [[UserModel alloc] init];
            model.nameString = name;
            model.ageString = [NSString stringWithFormat:@"%d",age];
            model.imageData = imageData;
            model.userID = [ret intForColumn:@"id"];
            
            [modelArray addObject:model];
        }
    }
    
    
    [_dataBase close];
    
    return modelArray;

}



@end
