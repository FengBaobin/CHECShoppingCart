//
//  CHECShoppingCartVC.m
//  CHECShoppingCart
//
//  Created by CH on 16/2/18.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "CHECShoppingCartVC.h"
#import "CHECTableDataSourceDelegate.h"
#import "CHECShoppingCartVM.h"
#import "CHECGoodsTableCell.h"
#import "CHECSuitTableCell.h"

static NSString *const GoodsTableCellIdentifier = @"GoodsTableCellIdentifier";
static NSString *const SuitTableCellIdentifier = @"SuitTableCellIdentifier";

@interface CHECShoppingCartVC ()

@end

@implementation CHECShoppingCartVC

#pragma mark - ****
#pragma mark - -----View LifeCycle-----

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车MVVM";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicked:)];
    
    CHECShoppingCartVM *viewModel = [CHECShoppingCartVM new];
    viewModel.viewController = self;
    self.tableView.tableHandler = [[CHECTableDataSourceDelegate alloc] initWithViewModel:viewModel cellIdentifiersArray:@[@{GoodsTableCellIdentifier : [CHECGoodsTableCell class]}, @{SuitTableCellIdentifier : [CHECSuitTableCell class]}] didSelectBlock:^(NSIndexPath *indexPath, id item) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ****
#pragma mark - -----Event response-----

- (void)rightBarButtonClicked:(UIBarButtonItem *)item
{
    if (self.footerView.editing) {
        self.footerView.editing = NO;
        [item setTitle:@"编辑"];
    }
    else
    {
        self.footerView.editing = YES;
        [item setTitle:@"完成"];
    }
}

#pragma mark - ****
#pragma mark - -----Getter-----

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kSCFooterViewHeight) style:UITableViewStyleGrouped];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    
    return _tableView;
}

- (CHECShoppingCartFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[CHECShoppingCartFooterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenWidth, kSCFooterViewHeight)];
    }
    
    return _footerView;
}

@end
