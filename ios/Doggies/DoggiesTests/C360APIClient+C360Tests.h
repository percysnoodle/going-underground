//
//  C360APIClient+C360Tests.h
//  Doggies
//
//  Created by Simon Booth on 26/08/2015.
//  Copyright (c) 2015 agbooth.com. All rights reserved.
//

#import "C360APIClient.h"

#define C360CountObjects(CLIENT, CLASS, EXPECTED_COUNT) { \
    NSError *countingError = nil; \
    __typeof__(EXPECTED_COUNT) countOfObjects = (__typeof__(EXPECTED_COUNT))[CLIENT countObjectsWithClass:[CLASS class] predicate:nil error:&countingError]; \
    XCTAssertNil(countingError, @"Got error %@", countingError); \
    XCTAssertTrue(countOfObjects == EXPECTED_COUNT, @"Got %zd objects, expected %zd", countOfObjects, EXPECTED_COUNT); \
}

#define C360CountObjectsWithPredicate(CLIENT, CLASS, EXPECTED_COUNT, PREDICATE_FORMAT, ...) { \
    NSError *countingError = nil; \
    NSPredicate *countingPredicate = [NSPredicate predicateWithFormat:PREDICATE_FORMAT, ## __VA_ARGS__]; \
    __typeof__(EXPECTED_COUNT) countOfObjects = (__typeof__(EXPECTED_COUNT))[CLIENT countObjectsWithClass:[CLASS class] predicate:countingPredicate error:&countingError]; \
    XCTAssertNil(countingError, @"Got error %@", countingError); \
    XCTAssertTrue(countOfObjects == EXPECTED_COUNT, @"Got %zd objects, expected %zd", countOfObjects, EXPECTED_COUNT); \
}

@interface C360APIClient (C360Tests)

@property (nonatomic, assign) BOOL isNetworkReachable;

- (NSUInteger)countObjectsWithClass:(Class)aClass predicate:(NSPredicate *)predicate error:(NSError **)outError;

@end
