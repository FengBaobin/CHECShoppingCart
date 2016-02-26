//
//  CHECShoppingCartModel.h
//  CHECShoppingCart
//
//  Created by CH on 16/2/18.
//  Copyright © 2016年 CH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHECShoppingCartModel : NSObject

// 店铺名
@property (nonatomic, strong) NSString *storeName;
// 商品名
@property (nonatomic, strong) NSString *goodsName;
// 商品缩略图url
@property (nonatomic, strong) NSString *goodsImageUrl;
// 商品价格
@property (nonatomic, strong) NSString *goodsPrice;
// 商品数量
@property (nonatomic, assign) NSInteger goodsQuantity;
// 商品类型，0:普通商品，1:带有赠品，2:赠品，3:优惠套装类型，4:优惠套装商品
@property (nonatomic, strong) NSString *goodsType;
// 商品是否被选择（在商品不能被选择的情况下，限定为不被选择）
@property (nonatomic, assign) BOOL selected;
// 商品是否能被选择
@property (nonatomic, assign) BOOL canSelect;

@end
