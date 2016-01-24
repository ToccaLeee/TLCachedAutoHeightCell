//
//  TLTableViewCellContentBasedHeightCache.h
//
//  Created by ToccaLee on 20/8/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTableViewCellContentBasedHeightCache : NSObject

@property (nonatomic, strong, nonnull) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSNumber *> *> *rowHeightCacheData;

- (CGFloat)cachedHeightWithIdentifier:(nonnull NSString *)identifer
                             modelKey:(nonnull id)modelKey
             heightAffectedProperties:(nullable NSArray<id> *)properties;

- (void)cacheHeightForIdentifier:(nonnull NSString *)identifer
                        modelKey:(nonnull id)modelKey
        heightAffectedProperties:(nullable NSArray<id> *)properties
                          height:(CGFloat)height;

- (BOOL)hasCachedHeightForIdentifier:(nonnull NSString *)identifer
                            modelKey:(nonnull id)modelKey
            heightAffectedProperties:(nullable NSArray<id> *)properties;

@end
