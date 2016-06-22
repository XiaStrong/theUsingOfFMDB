//
//  UserModel.h
//  dataSave
//
//  Created by Xia_Q on 16/6/21.
//  Copyright © 2016年 X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic,strong) NSString *nameString;//名称
@property (nonatomic,strong) NSString *ageString;//年龄
@property (nonatomic,strong) NSData *imageData;//图片二进制数据
@property (nonatomic,assign) NSInteger userID;//主键

@end
