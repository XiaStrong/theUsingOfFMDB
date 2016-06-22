//
//  DataGetViewController.h
//  dataSave
//
//  Created by Xia_Q on 16/6/21.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserModel.h"
@protocol DataGetViewControllerDelegate <NSObject>

//增加界面保存按钮点击后通知delegate 刷新界面
- (void)addFinshWithModel:(UserModel *)model;
//修改界面修改完成
- (void)updateFinsh;

@end


@interface DataGetViewController : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,weak) id<DataGetViewControllerDelegate>delegate;

@property (nonatomic,strong) UserModel *userModel;//往修改界面传入的值

@property (nonatomic,assign) int index;//cell的indexPath.row
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *age;

- (IBAction)sureAdd:(id)sender;

- (IBAction)imageTouch:(id)sender;

@end
