//
//  CHECTableDataSourceDelegate.m
//  CHECShoppingCart
//
//  Created by CH on 16/2/19.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "CHECTableDataSourceDelegate.h"
#import "UITableViewCell+CHECExtension.h"
#import "CHECBaseViewModel.h"
#import "CHECShoppingCartModel.h"
#import "CHECStoreHeaderView.h"
#import "CHECShoppingCartVM.h"

@interface CHECTableDataSourceDelegate ()

@property (nonatomic, strong) NSArray *cellIdentifierArray;
@property (nonatomic, strong) DidSelectCellBlock didSelectCellBlock;
@property (nonatomic, strong) CHECBaseViewModel *viewModel;

@end

@implementation CHECTableDataSourceDelegate

- (NSArray *)cellIdentifierArray
{
    if (!_cellIdentifierArray)
    {
        _cellIdentifierArray = [NSArray array];
    }
    return _cellIdentifierArray;
}

- (id)initWithViewModel:(CHECBaseViewModel *)viewModel
   cellIdentifiersArray:(NSArray *)cellIdentifiersArray
         didSelectBlock:(DidSelectCellBlock)didselectBlock
{
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        self.cellIdentifierArray = cellIdentifiersArray;
        self.didSelectCellBlock = didselectBlock;
    }
    
    return self ;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return ((NSArray *)self.viewModel.dataArray[indexPath.section])[indexPath.row];
}

- (void)handleDataSourceAndDelegateWithTableView:(UITableView *)tableView
{
    
    tableView.dataSource = self;
    tableView.delegate   = self;
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    for (int i = 0; i < self.cellIdentifierArray.count; ++i) {
        [UITableViewCell registerWithTableView:tableView cellClass:[((NSDictionary *)self.cellIdentifierArray[i]) allValues][0] reuseIdentifier:[((NSDictionary *)self.cellIdentifierArray[i]) allKeys][0]];
    }
    
    [self.viewModel getDataSuccessHandler:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kSCUpdateSelectNotification object:nil];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath] ;
    
    UITableViewCell *cell = nil;
    if ([item isKindOfClass:[CHECShoppingCartModel class]]) {
        if ([((CHECShoppingCartModel *)item).goodsType isEqualToString:@"3"]) {
            cell = [tableView dequeueReusableCellWithIdentifier:[((NSDictionary *)self.cellIdentifierArray[1]) allKeys][0] forIndexPath:indexPath];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[((NSDictionary *)self.cellIdentifierArray[0]) allKeys][0] forIndexPath:indexPath];
        }
        
        [cell configureWithTableCell:cell customObject:item indexPath:indexPath];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    if ([item isKindOfClass:[CHECShoppingCartModel class]]) {
        if ([((CHECShoppingCartModel *)item).goodsType isEqualToString:@"3"]) {
            return kSCSectionHeaderViewHeight;
        }
        else if (((CHECShoppingCartModel *)item).canSelect)
        {
            return kSCNormalCellHeight;
        }
        else
        {
            return kSCUnselectedCellHeight;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.viewModel isKindOfClass:[CHECShoppingCartVM class]]) {
        return kSCSectionHeaderViewHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    if ([self.viewModel isKindOfClass:[CHECShoppingCartVM class]]) {
        headerView = [[CHECStoreHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSCSectionHeaderViewHeight)];
        [headerView setTag:section];
        id item = [self itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        if ([item isKindOfClass:[CHECShoppingCartModel class]]) {
            [((CHECStoreHeaderView *)headerView).storeTitle setText:((CHECShoppingCartModel *)item).storeName];
            
            __block BOOL sectionAllSelected = YES;
            NSArray *sectionData = self.viewModel.dataArray[section];
            [sectionData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (((CHECShoppingCartModel *)obj).canSelect && !((CHECShoppingCartModel *)obj).selected) {
                    sectionAllSelected = NO;
                    *stop = YES;
                }
            }];
            
            [((CHECStoreHeaderView *)headerView).selectButton setSelected:sectionAllSelected];
        }
    }
    
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id item = [self itemAtIndexPath:indexPath];
    self.didSelectCellBlock(indexPath, item);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSCDeleteItemNotification object:self userInfo:@{@"indexPath" : indexPath}];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.viewModel isKindOfClass:[CHECShoppingCartVM class]]) {
        id item = [self itemAtIndexPath:indexPath];
        if ([item isKindOfClass:[CHECShoppingCartModel class]]) {
            if (((CHECShoppingCartModel *)item).canSelect) {
                return YES;
            }
        }
    }
    return NO;
}

@end
