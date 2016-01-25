//
//  UITableView+TLHeightCache.h
//
//  Created by ToccaLee on 25/8/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TLCellHeightCachePolicy) {
    TLCellHeightCachePolicyNone,        // None cell height cache
    TLCellHeightCachePolicyPosition,    // Position (NSIndexPah) based cache
    TLCellHeightCachePolicyContent      // Content  (modelkey & properties) based cache
};

@class TLTableViewCellPositionBasedHeightCache, TLTableViewCellContentBasedHeightCache;

@interface UITableView (TLHeightCache)

// The cache policy used to cache cell height

@property (nonatomic, assign) TLCellHeightCachePolicy                 TL_heightCachePolicy;

// The position based cache

@property (nonatomic, strong) TLTableViewCellPositionBasedHeightCache *TL_positionBasedCellHeightCache;

// The content based cache

@property (nonatomic, strong) TLTableViewCellContentBasedHeightCache  *TL_contentBasedCellHeightCache;

@end
