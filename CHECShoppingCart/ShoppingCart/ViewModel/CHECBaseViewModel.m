//
//  CHECBaseViewModel.m
//  CHECShoppingCart
//
//  Created by CH on 16/2/18.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "CHECBaseViewModel.h"

@implementation CHECBaseViewModel

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

+ (instancetype)viewModelWithViewController:(UIViewController *)viewController
{
    CHECBaseViewModel *vm = self.new;
    if (vm) {
        vm.viewController = viewController;
    }
    return vm;
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (void)getDataSuccessHandler:(void (^)())successHandler
{
}

- (void)vmAddObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:aName object:anObject];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:aName object:anObject];
}

- (void)vmRemoveObserver:(id)observer name:(NSString *)aName object:(id)anObject
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:aName object:anObject];
}

@end
