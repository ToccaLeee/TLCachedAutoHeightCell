//
//  UITableView+TLHeightCache.h
//
//  Created by ToccaLee on 25/8/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TLCellHeightCachePolicy) {
    TLCellHeightCachePolicyNone,
    TLCellHeightCachePolicyPosition,
    TLCellHeightCachePolicyContent
};

@class TLTableViewCellPositionBasedHeightCache, TLTableViewCellContentBasedHeightCache;

@interface UITableView (TLHeightCache)

@property (nonatomic, assign) TLCellHeightCachePolicy                 TL_heightCachePolicy;
@property (nonatomic, strong) TLTableViewCellPositionBasedHeightCache *TL_positionBasedCellHeightCache;
@property (nonatomic, strong) TLTableViewCellContentBasedHeightCache  *TL_contentBasedCellHeightCache;

@end
