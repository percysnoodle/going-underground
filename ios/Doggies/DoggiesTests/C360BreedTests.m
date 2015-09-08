//
//  DoggiesTests.m
//  DoggiesTests
//
//  Created by Simon Booth on 31/05/2015.
//  Copyright (c) 2015 agbooth.com. All rights reserved.
//

#import "C360APIClient.h"
#import "C360Breed.h"

#import "C360APIClient+C360Tests.h"
#import "C360URLMocker.h"

#import <XCTest/XCTest.h>

@interface C360BreedTests : XCTestCase

@property (nonatomic, strong) C360APIClient *apiClient;

@end

@implementation C360BreedTests

- (void)setUp
{
    NSURL *baseURL = [NSURL URLWithString:@"https://no-such-server.local"];
    
    NSString *fileName = @"test.db";
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *storePath = [documentsURL.path stringByAppendingPathComponent:fileName];
    
    [[NSFileManager defaultManager] removeItemAtPath:storePath error:nil];
    
    self.apiClient = [[C360APIClient alloc] initWithBaseURL:baseURL fileName:fileName];
    self.apiClient.isNetworkReachable = YES;
    
    NSBundle *bundle = [NSBundle bundleForClass:[C360URLMocker class]];
    [C360URLMocker setUpWithBundle:bundle];
}

- (void)tearDown
{
    [C360URLMocker tearDown];
}

#pragma mark - Fetching a list of breeds

- (NSArray *)fetchBreedsWhileOffline
{
    __block NSArray *breeds = nil;
    
    XCTestExpectation *fetchExpectation = [self expectationWithDescription:@"The fetch should succeed"];
    
    [C360URLMocker mockMethod:@"GET" path:@"/breeds" callback:^BOOL(C360URLMocker *mocker, NSURLRequest *request) {
        
        XCTFail(@"The HTTP request should not be made");
        
        return NO;
        
    }];
    
    [C360Breed fetchBreedsFromSource:C360AnySource usingAPIClient:self.apiClient successHandler:^(NSArray *array) {
        
        breeds = array;
        [fetchExpectation fulfill];
        
    } failureHandler:^(NSError *error) {
        
        XCTFail(@"Failed to fetch breeds with error: %@", error);
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    [C360URLMocker unmockMethod:@"GET" path:@"/breeds"];
    
    return breeds;
}

- (NSArray *)fetchBreedsWithFileName:(NSString *)fileName
{
    __block NSArray *breeds = nil;
    
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"The HTTP request should be made"];
    XCTestExpectation *fetchExpectation = [self expectationWithDescription:@"The fetch should succeed"];
    
    [C360URLMocker mockMethod:@"GET" path:@"/breeds" callback:^BOOL(C360URLMocker *mocker, NSURLRequest *request) {
        
        [mocker serveMockResponseWithStatusCode:200 fileName:fileName forRequest:request];
        [requestExpectation fulfill];
        return YES;
        
    }];
    
    [C360Breed fetchBreedsFromSource:C360AnySource usingAPIClient:self.apiClient successHandler:^(NSArray *array) {
        
        breeds = array;
        [fetchExpectation fulfill];
        
    } failureHandler:^(NSError *error) {
        
        XCTFail(@"Failed to fetch breeds with error: %@", error);
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    [C360URLMocker unmockMethod:@"GET" path:@"/breeds"];
    
    return breeds;
}

- (void)testFetchBreedsStoresInCoreData
{
    C360CountObjects(self.apiClient, [C360Breed class], 0);
    
    // If we fetch all the breeds, we should have them all in the DB.
    NSArray *breeds1 = [self fetchBreedsWithFileName:@"breeds.json"];
    C360CountObjects(self.apiClient, [C360Breed class], 8);
    
    // If we fetch the same set, we shouldn't have any duplicates.
    NSArray *breeds2 = [self fetchBreedsWithFileName:@"breeds.json"];
    C360CountObjects(self.apiClient, [C360Breed class], 8);
    
    // They should be the same objects, not a new set
    XCTAssertEqualObjects(breeds1, breeds2);
    
    // If we fetch a smaller set, we should have a subset remaining.
    [self fetchBreedsWithFileName:@"breedsMediumOnly.json"];
    C360CountObjects(self.apiClient, [C360Breed class], 4);
}

- (void)testFetchBreedsWhenOffline
{
    C360CountObjects(self.apiClient, [C360Breed class], 0);
    
    // If we fetch the breeds while offline, we shouldn't have any.
    self.apiClient.isNetworkReachable = NO;
    NSArray *breeds0 = [self fetchBreedsWhileOffline];
    C360CountObjects(self.apiClient, [C360Breed class], 0);
    
    XCTAssertEqualObjects(breeds0, @[]);
    
    // If we fetch them online, we should.
    self.apiClient.isNetworkReachable = YES;
    NSArray *breeds1 = [self fetchBreedsWithFileName:@"breeds.json"];
    C360CountObjects(self.apiClient, [C360Breed class], 8);
    
    // If we now fetch them while offline, we should get the same set
    self.apiClient.isNetworkReachable = NO;
    NSArray *breeds2 = [self fetchBreedsWhileOffline];
    C360CountObjects(self.apiClient, [C360Breed class], 8);
    
    XCTAssertEqualObjects(breeds1, breeds2);
}

@end
