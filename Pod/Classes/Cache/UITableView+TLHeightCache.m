//
//  UITableView+TLHeightCache.m
//
//  Created by ToccaLee on 25/8/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import "UITableView+TLHeightCache.h"
#import "TLTableViewCellPositionBasedHeightCache.h"
#import "TLTableViewCellContentBasedHeightCache.h"
#import "TLAutoHeightMacroDefine.h"

static char *const kPositionBasedCellHeightCacheKey  = "TLPositionBasedCellHeightCacheKey";
static char *const kContentBasedCellHeightCacheKey   = "TLContentBasedCellHeightCacheKey";
static char *const kCachePolicyKey                   = "TLCachePolicyKey";

@implementation UITableView (TLHeightCache)

TL_OBJECT_ASSOCIATE(TL_positionBasedCellHeightCache,
                    setTL_positionBasedCellHeightCache,
                    TLTableViewCellPositionBasedHeightCache *,
                    [TLTableViewCellPositionBasedHeightCache new],
                    kPositionBasedCellHeightCacheKey)

TL_OBJECT_ASSOCIATE(TL_contentBasedCellHeightCache,
                    setTL_contentBasedCellHeightCache,
                    TLTableViewCellContentBasedHeightCache *,
                    [TLTableViewCellContentBasedHeightCache new],
                    kContentBasedCellHeightCacheKey)

TL_INT_ASSOCIATE(TL_heightCachePolicy,
                 setTL_heightCachePolicy,
                 TLCellHeightCachePolicy,
                 TLCellHeightCachePolicyNone,
                 kCachePolicyKey)

@end
