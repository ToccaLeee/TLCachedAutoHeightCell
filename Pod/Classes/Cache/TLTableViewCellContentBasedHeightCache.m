//
//  TLTableViewCellContentBasedHeightCache.m
//
//  Created by ToccaLee on 20/8/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import "TLTableViewCellContentBasedHeightCache.h"
#import "TLTableViewCellCacheConstants.h"

static const NSUInteger kHashSubStringLength    = 2;
static const NSUInteger kContentStringMaxLength = 20;

#define HASH_STR_RANGE(totalLength, rate) NSMakeRange((totalLength - kHashSubStringLength) * rate , kHashSubStringLength)

@implementation TLTableViewCellContentBasedHeightCache

- (instancetype)init {
    if (self = [super init]) {
        _rowHeightCacheData = [NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSNumber *> *> new];
    }
    return self;
}

- (CGFloat)cachedHeightWithIdentifier:(NSString *)identifer modelKey:(id)modelKey heightAffectedProperties:(NSArray<id> *)properties {
    NSString *uniqueKey = [self uniqueKeyForModelKey:modelKey heightAffectedProperties:properties];
    NSNumber *floatNumber = self.rowHeightCacheData[identifer][uniqueKey];
    return (floatNumber != nil) ? floatNumber.floatValue : kAutoHeightCellHeightCacheAbsentValue;
}

- (void)cacheHeightForIdentifier:(NSString *)identifer modelKey:(id)modelKey heightAffectedProperties:(NSArray<id> *)properties height:(CGFloat)height {
    NSString *uniqueKey = [self uniqueKeyForModelKey:modelKey heightAffectedProperties:properties];
    if (!self.rowHeightCacheData[identifer]) {
        self.rowHeightCacheData[identifer] = [NSMutableDictionary<NSString *, NSNumber *> new];
    }
    self.rowHeightCacheData[identifer][uniqueKey] = @(height);
}

- (BOOL)hasCachedHeightForIdentifier:(NSString *)identifer modelKey:(id)modelKey heightAffectedProperties:(NSArray<id> *)properties {
    return [self cachedHeightWithIdentifier:identifer modelKey:modelKey heightAffectedProperties:properties] != kAutoHeightCellHeightCacheAbsentValue;
}

- (NSString *)uniqueKeyForModelKey:(id)modelKey heightAffectedProperties:(NSArray<id> *)properties {
    NSAssert(([modelKey isKindOfClass:[NSString class]] ||
              [modelKey isKindOfClass:[NSNumber class]]),  @"modelkey should be NSString or NSNumber type");
    NSMutableString *uniqueKey = @"".mutableCopy;
    if ([modelKey isKindOfClass:[NSString class]]) {
        [uniqueKey appendString:[NSString stringWithFormat:@"%@", modelKey]];
    } else if ([modelKey isKindOfClass:[NSNumber class]]) {
        [uniqueKey appendString:[NSString stringWithFormat:@"%f", ((NSNumber *)modelKey).floatValue]];
    }
    for (id property in properties) {
        [uniqueKey appendString:[self subKeyWithObject:property]];
    }
    return uniqueKey;
}

- (NSString *)subKeyWithObject:(id)object {
    NSAssert(([object isKindOfClass:[NSString class]] ||
              [object isKindOfClass:[NSNumber class]]),  @"property should be NSString or NSNumber type");
    NSMutableString *subKey = @"".mutableCopy;
    if ([object isKindOfClass:[NSString class]]) {
        NSString *objectString = object;
        NSUInteger stringLength = objectString.length;
        if (objectString.length > kContentStringMaxLength) {
            [subKey appendString:[NSString stringWithFormat:@"_%ld@", (unsigned long)objectString.length]];
            [subKey appendString:[objectString substringToIndex:kHashSubStringLength]];
            [subKey appendString:[objectString substringWithRange:HASH_STR_RANGE(stringLength, 0.25)]];
            [subKey appendString:[objectString substringWithRange:HASH_STR_RANGE(stringLength, 0.5)]];
            [subKey appendString:[objectString substringWithRange:HASH_STR_RANGE(stringLength, 0.75)]];
            [subKey appendString:[objectString substringFromIndex:stringLength - kHashSubStringLength - 1]];
        } else {
            [subKey appendString:objectString];
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        [subKey appendString:[NSString stringWithFormat:@"_%f", ((NSNumber *)object).floatValue]];
    }
    return subKey.copy;
}

@end
