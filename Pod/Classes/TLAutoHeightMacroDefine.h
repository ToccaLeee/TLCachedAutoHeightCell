//
//  TLAutoHeightMacroDefine.h
//
//  Created by ToccaLee on 20/1/2016.
//  Copyright © 2016 ToccaLee. All rights reserved.
//

#import <objc/runtime.h>

#define TL_VALUE_PROPERTY_SETTER(name, setter, type, key)                               \
- (void)setter:(type)name {                                                             \
    objc_setAssociatedObject(self, key, @(name), OBJC_ASSOCIATION_ASSIGN);              \
}

#define TL_VALUE_PROPERTY_GETTER(name, protoType, aliasType, defaultValue, key)         \
- (aliasType)name {                                                                     \
    NSNumber *numberValue = objc_getAssociatedObject(self, key);                        \
    if (numberValue) {                                                                  \
        return [numberValue protoType##Value];                                          \
    } else {                                                                            \
        return defaultValue;                                                            \
    }                                                                                   \
}

#define TL_OBJECT_ASSOCIATE(name, setter, type, defaultValue, key)                      \
- (type)name {                                                                          \
    type object = objc_getAssociatedObject(self, key);                                  \
    if (object) {                                                                       \
        return object;                                                                  \
    } else {                                                                            \
        self.name = defaultValue;                                                       \
        return defaultValue;                                                            \
    }                                                                                   \
}                                                                                       \
                                                                                        \
- (void)setter:(type)name {                                                             \
    objc_setAssociatedObject(self, key, name, OBJC_ASSOCIATION_RETAIN);                 \
}

#define TL_BOOL_ASSOCIATE(name, setter, defaultValue, key)                              \
TL_VALUE_PROPERTY_GETTER(name, bool, BOOL, defaultValue, key)                           \
TL_VALUE_PROPERTY_SETTER(name, setter, BOOL, key)                                       \


#define TL_INT_ASSOCIATE(name, setter, aliasType, defaultValue, key)                    \
TL_VALUE_PROPERTY_GETTER(name, integer, aliasType, defaultValue, key)                   \
TL_VALUE_PROPERTY_SETTER(name, setter, aliasType, key)                                  \


#define TL_FLOAT_ASSOCIATE(name, setter, defaultValue, key)                             \
TL_VALUE_PROPERTY_GETTER(name, float, CGFloat, defaultValue, key)                       \
TL_VALUE_PROPERTY_SETTER(name, setter, CGFloat, key)                                    \


