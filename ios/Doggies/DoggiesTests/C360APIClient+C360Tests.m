//
//  C360APIClient+C360Tests.m
//  Doggies
//
//  Created by Simon Booth on 26/08/2015.
//  Copyright (c) 2015 agbooth.com. All rights reserved.
//

#import "C360APIClient+C360Tests.h"

static BOOL C360TestsIsNetworkReachable;

@implementation C360APIClient (C360Tests)

- (BOOL)isNetworkReachable
{
    return C360TestsIsNetworkReachable;
}

- (void)setIsNetworkReachable:(BOOL)isNetworkReachable
{
    C360TestsIsNetworkReachable = isNetworkReachable;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (NSUInteger)countObjectsWithClass:(Class)aClass predicate:(NSPredicate *)predicate error:(NSError **)outError
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[(id)aClass entityName]];
    fetchRequest.predicate = predicate;
    NSArray *results = [self.objectManager.managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:outError];
    return [results count];
}

@end
