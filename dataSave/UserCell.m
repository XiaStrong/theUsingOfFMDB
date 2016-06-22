//
//  UserCell.m
//  dataSave
//
//  Created by Xia_Q on 16/6/21.
//  Copyright © 2016年 X. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)updateWihhModel:(UserModel *)model{
    _image.image=[UIImage imageWithData:model.imageData];
    _name.text=[NSString stringWithString:model.nameString];
    _age.text=[NSString stringWithString:model.ageString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
