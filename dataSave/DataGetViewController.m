//
//  DataGetViewController.m
//  dataSave
//
//  Created by Xia_Q on 16/6/21.
//  Copyright © 2016年 X. All rights reserved.
//

#import "DataGetViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "XQDataManger.h"


@interface DataGetViewController ()

@end

@implementation DataGetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_userModel) {
        _name.text = _userModel.nameString;
        _age.text = _userModel.ageString;
        _image.image =[UIImage imageWithData:_userModel.imageData];
    }

    
    // Do any additional setup after loading the view from its nib.
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sureAdd:(id)sender {
    
    if (_userModel) {
        _userModel.nameString =_name.text;
        _userModel.ageString=_age.text;
        _userModel.imageData = UIImagePNGRepresentation(_image.image);
        //通过userID修改数据库的值
        [[XQDataManger shareManger]updateDataWithModel:_userModel userId:_userModel.userID withTableName:@"user"];
        //通知界面刷新
        [_delegate updateFinsh];
    }else{
        if(_name.text.length == 0 || _age.text.length == 0 || _image.image == nil) {
            NSLog(@"信息填写不全");
            return;
        }
        //添加界面
        UserModel *model = [[UserModel alloc] init];
        
        model.nameString = _name.text;
        model.ageString = _age.text;
        model.imageData = UIImagePNGRepresentation(_image.image);
        
        //写入数据库
        [[XQDataManger shareManger] insertDataWithModel:model withTableName:@"user"];
        
        //通知delegate 去增加一个数据
        [_delegate addFinshWithModel:model];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


//调用本地相册
- (IBAction)imageTouch:(id)sender {
    
    NSLog(@"123");
    
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    pick.delegate = self;
    pick.allowsEditing = YES;
    //本地相册
    pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:pick animated:YES completion:^{
        
    }];
    
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    //移除界面
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

//点击choose选择某张图片的时候触发
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //媒体文件
    NSString *sourceType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([sourceType isEqualToString:(NSString *)kUTTypeImage]) {
        //取到图片资源
        //取到被编辑的图片
        UIImage *image  = [info objectForKey:UIImagePickerControllerEditedImage];
        _image.image=image;
        
    }
    
    //移除界面
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

@end
