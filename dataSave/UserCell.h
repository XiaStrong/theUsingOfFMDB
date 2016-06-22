//
//  UserCell.h
//  dataSave
//
//  Created by Xia_Q on 16/6/21.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *age;


-(void)updateWihhModel:(UserModel *)model;


@end
