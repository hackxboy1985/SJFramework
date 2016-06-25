//
//  NSMutableArray+WeakReferences.m
//  FetionUtil
//
//  Created by Born on 14-3-17.
//  Copyright (c) 2014年 FetionUtil. All rights reserved.
//

#import "NSMutableArray+WeakReferences.h"

// No-ops for non-retaining objects.
static const void * __TTRetainNoOp( CFAllocatorRef allocator, const void * value ) { return value; }
static void __TTReleaseNoOp( CFAllocatorRef allocator, const void * value ) { }


@implementation NSMutableArray (WeakReferences)

+ (id)noRetainingArray
{
    return [self noRetainingArrayWithCapacity:0];
}

+ (id)noRetainingArrayWithCapacity:(NSUInteger)capacity
{
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = __TTRetainNoOp;
    callbacks.release = __TTReleaseNoOp;
    return (__bridge_transfer NSMutableArray*)CFArrayCreateMutable(nil, capacity, &callbacks);
}

+ (id)noRetainingArrayWithArray:(NSArray*)array
{
    NSMutableArray* weakArray = [self noRetainingArrayWithCapacity:0];
    [weakArray addObjectsFromArray:array];
    return weakArray;
}
@end

@implementation NSMutableDictionary (WeakReferences)

+ (id)noRetainingDictionary
{
    return [self noRetainingDictionaryWithCapacity:0];
}

+ (id)noRetainingDictionaryWithCapacity:(NSUInteger)capacity
{
    CFDictionaryKeyCallBacks keyCallbacks = kCFTypeDictionaryKeyCallBacks;
    CFDictionaryValueCallBacks callbacks = kCFTypeDictionaryValueCallBacks;
    callbacks.retain = __TTRetainNoOp;
    callbacks.release = __TTReleaseNoOp;
    return (__bridge_transfer NSMutableDictionary*)CFDictionaryCreateMutable(nil, 0, &keyCallbacks, &callbacks);
}

@end