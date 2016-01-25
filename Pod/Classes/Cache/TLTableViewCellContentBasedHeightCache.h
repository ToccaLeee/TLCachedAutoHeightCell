//
//  TLTableViewCellContentBasedHeightCache.h
//
//  Created by ToccaLee on 20/8/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTableViewCellContentBasedHeightCache : NSObject

@property (nonatomic, strong, nonnull) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSNumber *> *> *rowHeightCacheData;

/**
 *  @brief Get the cached cell height by identifer & modelKey & heightAffectedProperties:
 *
 *  @param identifier Cell reusable identifier
 *
 *  @param modelKey The cell's model data's primary key
 *
 *  @param properties The properties that will affect cell's height, will be hashed and used for checking content's modification
 *
 */


- (CGFloat)cachedHeightWithIdentifier:(nonnull NSString *)identifer
                             modelKey:(nonnull id)modelKey
             heightAffectedProperties:(nullable NSArray<id> *)properties;

/**
 *  @brief Cache cell height by identifer & modelKey & heightAffectedProperties:
 *
 *  @param identifier Cell reusable identifier
 *
 *  @param modelKey The cell's model data's primary key
 *
 *  @param properties The properties that will affect cell's height, will be hashed and used for checking content's modification
 *
 *  @param height The cell's height that will be cached
 *
 */

- (void)cacheHeightForIdentifier:(nonnull NSString *)identifer
                        modelKey:(nonnull id)modelKey
        heightAffectedProperties:(nullable NSArray<id> *)properties
                          height:(CGFloat)height;

/**
 *  @brief Check the cache has cell's height
 *
 *  @param identifier Cell reusable identifier
 *
 *  @param properties The properties that will affect cell's height, will be hashed and used for checking content's modification
 *
 */

- (BOOL)hasCachedHeightForIdentifier:(nonnull NSString *)identifer
                            modelKey:(nonnull id)modelKey
            heightAffectedProperties:(nullable NSArray<id> *)properties;

@end
