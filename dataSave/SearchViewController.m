//
//  SearchViewController.m
//  dataSave
//
//  Created by Xia_Q on 16/6/22.
//  Copyright © 2016年 X. All rights reserved.
//

#import "SearchViewController.h"
#import "XQDataManger.h"
#import "UserCell.h"
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArr;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArr=[[NSMutableArray alloc]init];
    _mySearchBar.delegate=self;
    _mySearchBar.placeholder = @"请输入需要搜索的年龄";
    _showTab.delegate=self;
    _showTab.dataSource=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [dataArr removeAllObjects];
    if (_mySearchBar.text.length==0) {
        NSLog(@"请输入搜索内容");
    }else{
        NSLog(@"搜索中");
        dataArr =[NSMutableArray arrayWithArray:[[XQDataManger shareManger]selectDataWithUserAge:_mySearchBar.text withTableName:@"user"]];
        [_showTab reloadData];
    }
    
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


@end
