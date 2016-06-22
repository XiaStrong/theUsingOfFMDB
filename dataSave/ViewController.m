//
//  ViewController.m
//  dataSave
//
//  Created by Xia_Q on 16/6/16.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "ViewController.h"
#import "XQDataManger.h"
#import "UserCell.h"
#import "DataGetViewController.h"
#import "SearchViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,DataGetViewControllerDelegate>
{
    NSMutableArray *dataArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 40, 30);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];

    
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(0, 0, 40, 30);
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"查" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithCustomView:btn1];

    
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItemClick)];
    
    self.navigationItem.rightBarButtonItems = @[item,item1];
    
    dataArr=[[NSMutableArray alloc]init];
    
    _myTab.delegate=self;
    _myTab.dataSource=self;
    
    //这是一个子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //如果数据量大取数据是一个耗时的过程 应该在子线程去执行这个操作，避免主线程阻塞
        [dataArr removeAllObjects];
        //取得所有的数据
        NSArray *array = [[XQDataManger shareManger] returnAllUserWithTableName:@"user"];
        //将数据添加进数据源
        [dataArr addObjectsFromArray:array];
        //主线程去刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myTab reloadData];
        });
    });

    
    
}


//查
-(void)search{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *svc =[storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:svc animated:YES];

    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DataGetViewController *dvc=[[DataGetViewController alloc]init];
    UserModel *model =dataArr[indexPath.row];
    dvc.userModel=model;
    dvc.delegate=self;
    [self.navigationController pushViewController:dvc animated:YES];
    
}

//删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UserModel *model=dataArr[indexPath.row];
        [[XQDataManger shareManger]deleteDataWithUserId:model.userID withTableName:@"user"];
        [dataArr removeObjectAtIndex:indexPath.row];
        [_myTab deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//可删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *str =@"UserCell";
    UserCell *cell =[tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"UserCell" owner:self options:nil]lastObject];
    }
    UserModel *model =dataArr[indexPath.row];
    [cell updateWihhModel:model];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


-(void)addBtnTouch{
    DataGetViewController *dvc=[[DataGetViewController alloc]init];
    dvc.delegate=self;
    [self.navigationController pushViewController:dvc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DetailVC delegate
- (void)addFinshWithModel:(UserModel *)model
{
    [dataArr addObject:model];
    [_myTab reloadData];
}

- (void)updateFinsh
{
    [_myTab reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
