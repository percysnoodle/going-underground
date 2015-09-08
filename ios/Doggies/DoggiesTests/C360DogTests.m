//
//  DoggiesTests.m
//  DoggiesTests
//
//  Created by Simon Booth on 31/05/2015.
//  Copyright (c) 2015 agbooth.com. All rights reserved.
//

#import "C360APIClient.h"
#import "C360Dog.h"
#import "C360DogCreationSubmission.h"
#import "C360DogUpdateSubmission.h"
#import "C360DogDeletionSubmission.h"

#import "C360APIClient+C360Tests.h"
#import "C360URLMocker.h"

#import <XCTest/XCTest.h>

@interface C360DogTests : XCTestCase

@property (nonatomic, strong) C360APIClient *apiClient;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation C360DogTests

- (void)setUp
{
    NSURL *baseURL = [NSURL URLWithString:@"https://no-such-server.local"];
    
    NSString *fileName = @"test.db";
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *storePath = [documentsURL.path stringByAppendingPathComponent:fileName];
    
    [[NSFileManager defaultManager] removeItemAtPath:storePath error:nil];
    
    self.apiClient = [[C360APIClient alloc] initWithBaseURL:baseURL fileName:fileName];
    self.apiClient.isNetworkReachable = YES;
    
    self.managedObjectContext = self.apiClient.objectManager.managedObjectStore.mainQueueManagedObjectContext;
    
    NSBundle *bundle = [NSBundle bundleForClass:[C360URLMocker class]];
    [C360URLMocker setUpWithBundle:bundle];
}

- (void)tearDown
{
    self.apiClient = nil;
    self.managedObjectContext = nil;
    
    [C360URLMocker tearDown];
}

- (void)waitforReadiness
{
    XCTestExpectation *readinessExpectation = [self expectationWithDescription:@"The API client should be ready"];
    
    [self.apiClient waitForReadiness:^{
        
        [readinessExpectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark - Fetching a list of dogs

- (NSArray *)fetchDogsWhileOffline
{
    __block NSArray *dogs = nil;
    
    XCTestExpectation *fetchExpectation = [self expectationWithDescription:@"The fetch should succeed"];
    
    [C360URLMocker mockMethod:@"GET" path:@"/dogs" callback:^BOOL(C360URLMocker *mocker, NSURLRequest *request) {
        
        XCTFail(@"The HTTP request should not be made");
        
        return NO;
        
    }];
    
    [C360Dog fetchDogsFromSource:C360AnySource usingAPIClient:self.apiClient successHandler:^(NSArray *fetchedArray) {
        
        dogs = fetchedArray;
        [fetchExpectation fulfill];
        
    } failureHandler:^(NSError *error) {
        
        XCTFail(@"Failed to fetch dogs with error: %@", error);
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    [C360URLMocker unmockMethod:@"GET" path:@"/dogs"];
    
    return dogs;
}

- (NSArray *)fetchDogsWithFileName:(NSString *)fileName
{
    __block NSArray *dogs = nil;
    
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"The HTTP request should be made"];
    XCTestExpectation *fetchExpectation = [self expectationWithDescription:@"The fetch should succeed"];
    
    [C360URLMocker mockMethod:@"GET" path:@"/dogs" callback:^BOOL(C360URLMocker *mocker, NSURLRequest *request) {
        
        [mocker serveMockResponseWithStatusCode:200 fileName:fileName forRequest:request];
        [requestExpectation fulfill];
        return YES;
        
    }];
    
    [C360Dog fetchDogsFromSource:C360AnySource usingAPIClient:self.apiClient successHandler:^(NSArray *fetchedArray) {
        
        dogs = fetchedArray;
        [fetchExpectation fulfill];
        
    } failureHandler:^(NSError *error) {
        
        XCTFail(@"Failed to fetch dogs with error: %@", error);
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    [C360URLMocker unmockMethod:@"GET" path:@"/dogs"];
    
    return dogs;
}

- (void)testFetchDogsStoresInCoreData
{
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    // If we fetch all the dogs, we should have them all in the DB.
    NSArray *dogs1 = [self fetchDogsWithFileName:@"dogs.json"];
    C360CountObjects(self.apiClient, [C360Dog class], 15);
    
    // If we fetch the same set, we shouldn't have any duplicates.
    NSArray *dogs2 = [self fetchDogsWithFileName:@"dogs.json"];
    C360CountObjects(self.apiClient, [C360Dog class], 15);
    
    // They should be the same objects, not a new set
    XCTAssertEqualObjects(dogs1, dogs2);
    
    // If we fetch a smaller set, we should have a subset remaining.
    NSArray *boxers = [self fetchDogsWithFileName:@"dogsBoxersOnly.json"];
    C360CountObjects(self.apiClient, [C360Dog class], 5);
    
    // If we fetch a non-overlapping set, we should have just the new dogs.
    NSArray *spaniels = [self fetchDogsWithFileName:@"dogsSpanielsOnly.json"];
    C360CountObjects(self.apiClient, [C360Dog class], 4);
    
    XCTAssertNil([spaniels firstObjectCommonWithArray:boxers]);
    
    // If we fetch an empty set, we shouldn't have any dogs :-(
    [self fetchDogsWithFileName:@"dogsEmpty.json"];
    C360CountObjects(self.apiClient, [C360Dog class], 0);
}

- (void)testFetchDogsWhenOffline
{
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    // If we fetch the dogs while offline, we shouldn't have any.
    self.apiClient.isNetworkReachable = NO;
    NSArray *dogs0 = [self fetchDogsWhileOffline];
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    XCTAssertEqualObjects(dogs0, @[]);
    
    // If we fetch them online, we should.
    self.apiClient.isNetworkReachable = YES;
    NSArray *dogs1 = [self fetchDogsWithFileName:@"dogs.json"];
    C360CountObjects(self.apiClient, [C360Dog class], 15);
    
    // If we now fetch them while offline, we should get the same set
    self.apiClient.isNetworkReachable = NO;
    NSArray *dogs2 = [self fetchDogsWhileOffline];
    C360CountObjects(self.apiClient, [C360Dog class], 15);
    
    XCTAssertEqualObjects(dogs1, dogs2);
}

#pragma mark - Fetching a single dog

- (C360Dog *)fetchDogWhileOfflineWithId:(NSNumber *)dogId expectSuccess:(BOOL)expectSuccess
{
    __block C360Dog *dog = nil;
    
    NSString *path = [NSString stringWithFormat:@"/dogs/%@", dogId];
    
    XCTestExpectation *fetchExpectation = nil;
    
    if (expectSuccess)
    {
        fetchExpectation = [self expectationWithDescription:@"The fetch should succeed"];
    }
    else
    {
        fetchExpectation = [self expectationWithDescription:@"The fetch should fail"];
    }
    
    [C360URLMocker mockMethod:@"GET" path:path callback:^BOOL(C360URLMocker *mocker, NSURLRequest *request) {
        
        XCTFail(@"The HTTP request should not be made");
        
        return NO;
        
    }];
    
    [C360Dog fetchDogWithId:dogId fromSource:C360AnySource usingAPIClient:self.apiClient successHandler:^(C360Dog *fetchedDog) {
        
        dog = fetchedDog;
        
        if (expectSuccess)
        {
            [fetchExpectation fulfill];
        }
        else
        {
            XCTFail();
        }
        
    } failureHandler:^(NSError *error) {
        
        if (expectSuccess)
        {
            XCTFail();
        }
        else
        {
            [fetchExpectation fulfill];
        }
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    [C360URLMocker unmockMethod:@"GET" path:path];
    
    return dog;
}

- (C360Dog *)fetchDogWithId:(NSNumber *)dogId fileName:(NSString *)fileName
{
    __block C360Dog *dog = nil;
    
    NSString *path = [NSString stringWithFormat:@"/dogs/%@", dogId];
    
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"The HTTP request should be made"];
    XCTestExpectation *fetchExpectation = [self expectationWithDescription:@"The fetch should succeed"];
    
    [C360URLMocker mockMethod:@"GET" path:path callback:^BOOL(C360URLMocker *mocker, NSURLRequest *request) {
        
        [mocker serveMockResponseWithStatusCode:200 fileName:fileName forRequest:request];
        [requestExpectation fulfill];
        return YES;
        
    }];
    
    [C360Dog fetchDogWithId:dogId fromSource:C360AnySource usingAPIClient:self.apiClient successHandler:^(C360Dog *fetchedDog) {
        
        dog = fetchedDog;
        [fetchExpectation fulfill];
        
    } failureHandler:^(NSError *error) {
        
        XCTFail(@"Failed to fetch dog with error: %@", error);
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    [C360URLMocker unmockMethod:@"GET" path:path];
    
    return dog;
}

- (void)testFetchDogStoresInCoreData
{
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    NSNumber *bonnieDogId = @1070320720;
    NSNumber *poppyDogId = @245508281;
    
    // If we fetch Bonnie, she should be in the database
    C360Dog *bonnie1 = [self fetchDogWithId:bonnieDogId fileName:@"bonnie.json"];
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    
    // If we fetch her again, we shouldn't have any duplicates.
    C360Dog *bonnie2 = [self fetchDogWithId:bonnieDogId fileName:@"bonnie.json"];
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    
    // They should be the same objects
    XCTAssertEqualObjects(bonnie1, bonnie2);
    
    // If we fetch Poppy, we should have both dogs in the database
    [self fetchDogWithId:poppyDogId fileName:@"poppy.json"];
    C360CountObjects(self.apiClient, [C360Dog class], 2);
}

- (void)testFetchDogWhenOffline
{
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    NSNumber *bonnieDogId = @1070320720;
    
    // If we fetch Bonnie while offline, we shouldn't get her back
    self.apiClient.isNetworkReachable = NO;
    [self fetchDogWhileOfflineWithId:bonnieDogId expectSuccess:NO];
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    // If we fetch all dogs from the database while online,
    // but then fetch Bonnie while offline, we still shouldn't get her back.
    self.apiClient.isNetworkReachable = YES;
    NSArray *dogs = [self fetchDogsWithFileName:@"dogs.json"];
    C360CountObjects(self.apiClient, [C360Dog class], 15);
    
    self.apiClient.isNetworkReachable = NO;
    [self fetchDogWhileOfflineWithId:bonnieDogId expectSuccess:NO];
    C360CountObjects(self.apiClient, [C360Dog class], 15);
    
    // If we fetch her while online, we should get here back,
    // and we should get back one of the objects from earlier.
    self.apiClient.isNetworkReachable = YES;
    C360Dog *bonnie1 = [self fetchDogWithId:bonnieDogId fileName:@"bonnie.json"];
    C360CountObjects(self.apiClient, [C360Dog class], 15);
    
    XCTAssertTrue([dogs containsObject:bonnie1]);
    
    // If we now fetch her when online, we should get her back.
    self.apiClient.isNetworkReachable = NO;
    C360Dog *bonnie2 = [self fetchDogWhileOfflineWithId:bonnieDogId expectSuccess:YES];
    C360CountObjects(self.apiClient, [C360Dog class], 15);
    
    XCTAssertEqualObjects(bonnie1, bonnie2);
}

#pragma mark - Creating a dog

- (void)createDogWhileOffline:(C360Dog *)dog
{
    XCTestExpectation *createExpectation = [self expectationWithDescription:@"The creation should succeed"];
    
    [C360URLMocker mockMethod:@"POST" path:@"/dogs" callback:^BOOL(C360URLMocker *mocker, NSURLRequest *request) {
        
        XCTFail(@"The HTTP request should not be made");
        
        return NO;
        
    }];
    
    [dog createUsingAPIClient:self.apiClient successHandler:^(C360Dog *dog, BOOL submittedToServer) {
        
        [createExpectation fulfill];
        
    } failureHandler:^(NSError *error) {
        
        XCTFail();
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    [C360URLMocker unmockMethod:@"POST" path:@"/dogs"];
}

- (void)createDog:(C360Dog *)dog statusCode:(NSInteger)statusCode fileName:(NSString *)fileName evaluateRequest:(void(^)(id json))evaluateRequest expectSuccess:(BOOL)expectSuccess
{
    [self mockDogCreationWithStatusCode:statusCode fileName:fileName evaluateRequest:evaluateRequest];
    
    NSString *expectationDescription = [NSString stringWithFormat:@"The create should %@", expectSuccess ? @"succeed" : @"fail"];
    XCTestExpectation *createExpectation = [self expectationWithDescription:expectationDescription];
    
    [dog createUsingAPIClient:self.apiClient successHandler:^(C360Dog *dog, BOOL submittedToServer) {
        
        if (expectSuccess)
        {
            [createExpectation fulfill];
        }
        else
        {
            XCTFail(@"Unexpected success while creating dog");
        }
        
    } failureHandler:^(NSError *error) {
        
        if (expectSuccess)
        {
            XCTFail(@"Failed to create dog with error: %@", error);
        }
        else
        {
            [createExpectation fulfill];
        }
        
    }];
    
    [self expectDogCreation];
}

- (void)mockDogCreationWithStatusCode:(NSInteger)statusCode fileName:(NSString *)fileName evaluateRequest:(void(^)(id json))evaluateRequest
{
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"The HTTP request should be made"];
    
    [C360URLMocker mockMethod:@"POST" path:@"/dogs" callback:^BOOL(C360URLMocker *mocker, NSURLRequest *request) {
        
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:NSJSONReadingAllowFragments error:&error];
        
        if (error)
        {
            XCTFail(@"Failed parse json with error: %@", error);
        }
        else
        {
            evaluateRequest(json);
        }
        
        [mocker serveMockResponseWithStatusCode:statusCode fileName:fileName forRequest:request];
        [requestExpectation fulfill];
        return YES;
        
    }];
}

- (void)expectDogCreation
{
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    [C360URLMocker unmockMethod:@"POST" path:@"/dogs"];
}

- (void)testCreateDog
{
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    C360Dog *dog = [C360Dog insertInManagedObjectContext:self.apiClient.objectManager.managedObjectStore.mainQueueManagedObjectContext];
    
    NSString *dogName = @"Test dog name";
    dog.name = dogName;
    
    NSNumber *bottomsSniffed = @1;
    dog.numberOfBottomsSniffed = bottomsSniffed;
    
    NSNumber *catsChased = @2;
    dog.numberOfCatsChased = catsChased;
    
    NSNumber *facesLicked = @4;
    dog.numberOfFacesLicked = facesLicked;
    
    XCTAssertNil(dog.dogId);
    
    // If we create the dog, we should post off the details that we have set.
    [self createDog:dog statusCode:200 fileName:@"bonnie.json" evaluateRequest:^(id json) {
        
        NSString *jsonDogName = [json valueForKeyPath:@"dog.name"];
        XCTAssertEqualObjects(jsonDogName, dogName);
        
        NSNumber *jsonBottomsSniffed = [json valueForKeyPath:@"dog.bottoms_sniffed"];
        XCTAssertEqualObjects(jsonBottomsSniffed, bottomsSniffed);
        
        NSNumber *jsonCatsChased = [json valueForKeyPath:@"dog.cats_chased"];
        XCTAssertEqualObjects(jsonCatsChased, catsChased);
        
        NSNumber *jsonfFacesLicked = [json valueForKeyPath:@"dog.faces_licked"];
        XCTAssertEqualObjects(jsonfFacesLicked, facesLicked);
        
    } expectSuccess:YES];
    
    [self waitforReadiness];
    
    // The attributes should be overwritten with the ones from the server
    XCTAssertNotNil(dog.dogId);
    XCTAssertEqualObjects(dog.name, @"Bonnie");
    
    // The submission should be deleted
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    C360CountObjects(self.apiClient, [C360DogCreationSubmission class], 0);
}

- (void)testCreateDogWhenOffline
{
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    C360Dog *dog = [C360Dog insertInManagedObjectContext:self.apiClient.objectManager.managedObjectStore.mainQueueManagedObjectContext];
    
    NSString *dogName = @"Test dog name";
    dog.name = dogName;
    
    NSNumber *bottomsSniffed = @1;
    dog.numberOfBottomsSniffed = bottomsSniffed;
    
    NSNumber *catsChased = @2;
    dog.numberOfCatsChased = catsChased;
    
    NSNumber *facesLicked = @4;
    dog.numberOfFacesLicked = facesLicked;
    
    XCTAssertNil(dog.dogId);
    
    // If we create the dog when offline, nothing about the dog should change
    self.apiClient.isNetworkReachable = NO;
    [self createDogWhileOffline:dog];
    
    XCTAssertEqualObjects(dog.name, dogName);
    XCTAssertEqualObjects(dog.numberOfBottomsSniffed, bottomsSniffed);
    XCTAssertEqualObjects(dog.numberOfCatsChased, catsChased);
    XCTAssertEqualObjects(dog.numberOfFacesLicked, facesLicked);
    
    // There should be a creation submission, and it should be recoverable
    
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    C360CountObjects(self.apiClient, [C360DogCreationSubmission class], 1);
    
    XCTAssertEqualObjects(dog.pendingCreationSubmission.isUnrecoverable, @NO);
    
    // If we go online, the creation should be submitted
    // We should post off the details that we have set.
    [self mockDogCreationWithStatusCode:200 fileName:@"bonnie.json" evaluateRequest:^(id json) {
        
        NSString *jsonDogName = [json valueForKeyPath:@"dog.name"];
        XCTAssertEqualObjects(jsonDogName, dogName);
        
        NSNumber *jsonBottomsSniffed = [json valueForKeyPath:@"dog.bottoms_sniffed"];
        XCTAssertEqualObjects(jsonBottomsSniffed, bottomsSniffed);
        
        NSNumber *jsonCatsChased = [json valueForKeyPath:@"dog.cats_chased"];
        XCTAssertEqualObjects(jsonCatsChased, catsChased);
        
        NSNumber *jsonfFacesLicked = [json valueForKeyPath:@"dog.faces_licked"];
        XCTAssertEqualObjects(jsonfFacesLicked, facesLicked);
        
    }];
    
    self.apiClient.isNetworkReachable = YES;
    
    [self expectDogCreation];
    [self waitforReadiness];
    
    // The attributes should be overwritten with the ones from the server
    XCTAssertNotNil(dog.dogId);
    XCTAssertEqualObjects(dog.name, @"Bonnie");
    
    // The submission should be deleted
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    C360CountObjects(self.apiClient, [C360DogCreationSubmission class], 0);
}

- (void)testCreateDogForbiddenIsUnrecoverable
{
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    C360Dog *dog = [C360Dog insertInManagedObjectContext:self.apiClient.objectManager.managedObjectStore.mainQueueManagedObjectContext];
    
    NSString *dogName = @"Test dog name";
    dog.name = dogName;
    
    NSNumber *bottomsSniffed = @1;
    dog.numberOfBottomsSniffed = bottomsSniffed;
    
    NSNumber *catsChased = @2;
    dog.numberOfCatsChased = catsChased;
    
    NSNumber *facesLicked = @4;
    dog.numberOfFacesLicked = facesLicked;
    
    XCTAssertNil(dog.dogId);
    
    // If we create the dog and it is forbidden, nothing about the dog should change
    [self createDog:dog statusCode:403 fileName:@"forbidden.json" evaluateRequest:^(id json) {
        
        NSString *jsonDogName = [json valueForKeyPath:@"dog.name"];
        XCTAssertEqualObjects(jsonDogName, dogName);
        
        NSNumber *jsonBottomsSniffed = [json valueForKeyPath:@"dog.bottoms_sniffed"];
        XCTAssertEqualObjects(jsonBottomsSniffed, bottomsSniffed);
        
        NSNumber *jsonCatsChased = [json valueForKeyPath:@"dog.cats_chased"];
        XCTAssertEqualObjects(jsonCatsChased, catsChased);
        
        NSNumber *jsonfFacesLicked = [json valueForKeyPath:@"dog.faces_licked"];
        XCTAssertEqualObjects(jsonfFacesLicked, facesLicked);
        
    } expectSuccess:NO];
    
    XCTAssertEqualObjects(dog.name, dogName);
    XCTAssertEqualObjects(dog.numberOfBottomsSniffed, bottomsSniffed);
    XCTAssertEqualObjects(dog.numberOfCatsChased, catsChased);
    XCTAssertEqualObjects(dog.numberOfFacesLicked, facesLicked);
    
    // There should be a creation submission, and it should be unrecoverable
    
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    C360CountObjects(self.apiClient, [C360DogCreationSubmission class], 1);
    
    XCTAssertEqualObjects(dog.pendingCreationSubmission.isUnrecoverable, @YES);
    
    // If purge the pending submission pipeline, nothing should happen
    [self waitforReadiness];
    
    XCTAssertEqualObjects(dog.name, dogName);
    XCTAssertEqualObjects(dog.numberOfBottomsSniffed, bottomsSniffed);
    XCTAssertEqualObjects(dog.numberOfCatsChased, catsChased);
    XCTAssertEqualObjects(dog.numberOfFacesLicked, facesLicked);
    
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    C360CountObjects(self.apiClient, [C360DogCreationSubmission class], 1);
    
    XCTAssertEqualObjects(dog.pendingCreationSubmission.isUnrecoverable, @YES);
}

#pragma mark - Updating a dog

- (void)updateDogWhileOffline:(C360Dog *)dog configurationBlock:(C360DogUpdateSubmissionConfigurationBlock)configurationBlock
{
    XCTestExpectation *updateExpectation = [self expectationWithDescription:@"The update should succeed"];
    
    [C360URLMocker mockMethod:@"POST" path:@"/dogs" callback:^BOOL(C360URLMocker *mocker, NSURLRequest *request) {
        
        XCTFail(@"The HTTP request should not be made");
        
        return NO;
        
    }];
    
    [dog updateUsingAPIClient:self.apiClient configurationBlock:configurationBlock successHandler:^(C360Dog *dog, BOOL submittedToServer) {
        
        [updateExpectation fulfill];
        
    } failureHandler:^(NSError *error) {
        
        XCTFail();
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    [C360URLMocker unmockMethod:@"POST" path:@"/dogs"];
}

- (void)updateDog:(C360Dog *)dog configurationBlock:(C360DogUpdateSubmissionConfigurationBlock)configurationBlock statusCode:(NSInteger)statusCode fileName:(NSString *)fileName evaluateRequest:(void(^)(id json))evaluateRequest expectSuccess:(BOOL)expectSuccess
{
    [self mockDogUpdate:dog statusCode:statusCode fileName:fileName evaluateRequest:evaluateRequest];
    
    NSString *expectationDescription = [NSString stringWithFormat:@"The update should %@", expectSuccess ? @"succeed" : @"fail"];
    XCTestExpectation *updateExpectation = [self expectationWithDescription:expectationDescription];
    
    [dog updateUsingAPIClient:self.apiClient configurationBlock:configurationBlock successHandler:^(C360Dog *dog, BOOL submittedToServer) {
        
        if (expectSuccess)
        {
            [updateExpectation fulfill];
        }
        else
        {
            XCTFail(@"Unexpected success while updating dog");
        }
        
    } failureHandler:^(NSError *error) {
        
        if (expectSuccess)
        {
            XCTFail(@"Failed to update dog with error: %@", error);
        }
        else
        {
            [updateExpectation fulfill];
        }
        
    }];
    
    [self expectDogUpdate:dog];
}

- (void)mockDogUpdate:(C360Dog *)dog statusCode:(NSInteger)statusCode fileName:(NSString *)fileName evaluateRequest:(void(^)(id json))evaluateRequest
{
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"The HTTP request should be made"];
    
    NSString *path = [NSString stringWithFormat:@"/dogs/%@", dog.dogId];
    
    [C360URLMocker mockMethod:@"PUT" path:path callback:^BOOL(C360URLMocker *mocker, NSURLRequest *request) {
        
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:NSJSONReadingAllowFragments error:&error];
        
        if (error)
        {
            XCTFail(@"Failed parse json with error: %@", error);
        }
        else
        {
            evaluateRequest(json);
        }
        
        [mocker serveMockResponseWithStatusCode:statusCode fileName:fileName forRequest:request];
        [requestExpectation fulfill];
        return YES;
        
    }];
}

- (void)expectDogUpdate:(C360Dog *)dog
{
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    NSString *path = [NSString stringWithFormat:@"/dogs/%@", dog.dogId];
    [C360URLMocker unmockMethod:@"PUT" path:path];
}

- (void)testUpdateDog
{
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    C360Dog *dog = [C360Dog insertInManagedObjectContext:self.apiClient.objectManager.managedObjectStore.mainQueueManagedObjectContext];
    dog.dogId = @1070320720;
    
    NSString *dogName = @"Test dog name";
    NSNumber *bottomsSniffed = @1;
    NSNumber *catsChased = @2;
    NSNumber *facesLicked = @4;
    
    // If we update the dog, we should post off the details that we have set.
    [self updateDog:dog configurationBlock:^BOOL(C360DogUpdateSubmission *submission, NSError **outError) {
        
        submission.name = dogName;
        submission.numberOfBottomsSniffed = bottomsSniffed;
        submission.numberOfCatsChased = catsChased;
        submission.numberOfFacesLicked = facesLicked;
        
        return YES;
        
    } statusCode:200 fileName:@"bonnie.json" evaluateRequest:^(id json) {
        
        NSString *jsonDogName = [json valueForKeyPath:@"dog.name"];
        XCTAssertEqualObjects(jsonDogName, dogName);
        
        NSNumber *jsonBottomsSniffed = [json valueForKeyPath:@"dog.bottoms_sniffed"];
        XCTAssertEqualObjects(jsonBottomsSniffed, bottomsSniffed);
        
        NSNumber *jsonCatsChased = [json valueForKeyPath:@"dog.cats_chased"];
        XCTAssertEqualObjects(jsonCatsChased, catsChased);
        
        NSNumber *jsonfFacesLicked = [json valueForKeyPath:@"dog.faces_licked"];
        XCTAssertEqualObjects(jsonfFacesLicked, facesLicked);
        
    } expectSuccess:YES];
    
    [self waitforReadiness];
    
    // The attributes should be overwritten with the ones from the server
    XCTAssertEqualObjects(dog.name, @"Bonnie");
    
    // The submission should be deleted
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    C360CountObjects(self.apiClient, [C360DogUpdateSubmission class], 0);
}

- (void)testUpdateDogWhenOffline
{
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    C360Dog *dog = [C360Dog insertInManagedObjectContext:self.apiClient.objectManager.managedObjectStore.mainQueueManagedObjectContext];
    dog.dogId = @1070320720;
    
    NSString *dogName = @"Test dog name";
    NSNumber *bottomsSniffed = @1;
    NSNumber *catsChased = @2;
    NSNumber *facesLicked = @4;
    
    // If we update the dog when offline, nothing about the dog should change
    self.apiClient.isNetworkReachable = NO;
    [self updateDogWhileOffline:dog configurationBlock:^BOOL(C360DogUpdateSubmission *submission, NSError **outError) {
        
        submission.name = dogName;
        submission.numberOfBottomsSniffed = bottomsSniffed;
        submission.numberOfCatsChased = catsChased;
        submission.numberOfFacesLicked = facesLicked;
        
        return YES;
        
    }];
    
    // The update applies to the submission, not the dog
    XCTAssertNil(dog.name);
    XCTAssertEqualObjects(dog.numberOfBottomsSniffed, @0);
    XCTAssertEqualObjects(dog.numberOfCatsChased, @0);
    XCTAssertEqualObjects(dog.numberOfFacesLicked, @0);
    
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.name, dogName);
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.numberOfBottomsSniffed, bottomsSniffed);
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.numberOfCatsChased, catsChased);
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.numberOfFacesLicked, facesLicked);
    
    // There should be a update submission, and it should be recoverable
    
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    C360CountObjects(self.apiClient, [C360DogUpdateSubmission class], 1);
    
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.isUnrecoverable, @NO);
    
    // If we go online, the update should be submitted
    // We should post off the details that we have set.
    [self mockDogUpdate:dog statusCode:200 fileName:@"bonnie.json" evaluateRequest:^(id json) {
        
        NSString *jsonDogName = [json valueForKeyPath:@"dog.name"];
        XCTAssertEqualObjects(jsonDogName, dogName);
        
        NSNumber *jsonBottomsSniffed = [json valueForKeyPath:@"dog.bottoms_sniffed"];
        XCTAssertEqualObjects(jsonBottomsSniffed, bottomsSniffed);
        
        NSNumber *jsonCatsChased = [json valueForKeyPath:@"dog.cats_chased"];
        XCTAssertEqualObjects(jsonCatsChased, catsChased);
        
        NSNumber *jsonfFacesLicked = [json valueForKeyPath:@"dog.faces_licked"];
        XCTAssertEqualObjects(jsonfFacesLicked, facesLicked);
        
    }];
    
    self.apiClient.isNetworkReachable = YES;
    
    [self expectDogUpdate:dog];
    [self waitforReadiness];
    
    // The attributes should be overwritten with the ones from the server
    XCTAssertEqualObjects(dog.name, @"Bonnie");
    
    // The submission should be deleted
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    C360CountObjects(self.apiClient, [C360DogUpdateSubmission class], 0);
}

- (void)testUpdateDogForbiddenIsUnrecoverable
{
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    C360Dog *dog = [C360Dog insertInManagedObjectContext:self.apiClient.objectManager.managedObjectStore.mainQueueManagedObjectContext];
    dog.dogId = @1070320720;
    
    NSString *dogName = @"Test dog name";
    NSNumber *bottomsSniffed = @1;
    NSNumber *catsChased = @2;
    NSNumber *facesLicked = @4;
    
    // If we update the dog and it is forbidden, nothing about the dog should change
    [self updateDog:dog configurationBlock:^BOOL(C360DogUpdateSubmission *submission, NSError **outError) {
        
        submission.name = dogName;
        submission.numberOfBottomsSniffed = bottomsSniffed;
        submission.numberOfCatsChased = catsChased;
        submission.numberOfFacesLicked = facesLicked;
        
        return YES;
        
    } statusCode:403 fileName:@"forbidden.json" evaluateRequest:^(id json) {
        
        NSString *jsonDogName = [json valueForKeyPath:@"dog.name"];
        XCTAssertEqualObjects(jsonDogName, dogName);
        
        NSNumber *jsonBottomsSniffed = [json valueForKeyPath:@"dog.bottoms_sniffed"];
        XCTAssertEqualObjects(jsonBottomsSniffed, bottomsSniffed);
        
        NSNumber *jsonCatsChased = [json valueForKeyPath:@"dog.cats_chased"];
        XCTAssertEqualObjects(jsonCatsChased, catsChased);
        
        NSNumber *jsonfFacesLicked = [json valueForKeyPath:@"dog.faces_licked"];
        XCTAssertEqualObjects(jsonfFacesLicked, facesLicked);
        
    } expectSuccess:NO];
    
    // The update applies to the submission, not the dog
    XCTAssertNil(dog.name);
    XCTAssertEqualObjects(dog.numberOfBottomsSniffed, @0);
    XCTAssertEqualObjects(dog.numberOfCatsChased, @0);
    XCTAssertEqualObjects(dog.numberOfFacesLicked, @0);
    
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.name, dogName);
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.numberOfBottomsSniffed, bottomsSniffed);
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.numberOfCatsChased, catsChased);
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.numberOfFacesLicked, facesLicked);
    
    // There should be a update submission, and it should be unrecoverable
    
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    C360CountObjects(self.apiClient, [C360DogUpdateSubmission class], 1);
    
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.isUnrecoverable, @YES);
    
    // If purge the pending submission pipeline, nothing should happen
    [self waitforReadiness];
    
    // The update applies to the submission, not the dog
    XCTAssertNil(dog.name);
    XCTAssertEqualObjects(dog.numberOfBottomsSniffed, @0);
    XCTAssertEqualObjects(dog.numberOfCatsChased, @0);
    XCTAssertEqualObjects(dog.numberOfFacesLicked, @0);
    
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.name, dogName);
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.numberOfBottomsSniffed, bottomsSniffed);
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.numberOfCatsChased, catsChased);
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.numberOfFacesLicked, facesLicked);
    
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    C360CountObjects(self.apiClient, [C360DogUpdateSubmission class], 1);
    
    XCTAssertEqualObjects(dog.pendingUpdateSubmission.isUnrecoverable, @YES);
}

#pragma mark - Updating a dog

- (void)deleteDogWhileOffline:(C360Dog *)dog
{
    XCTestExpectation *deleteExpectation = [self expectationWithDescription:@"The delete should succeed"];
    
    [C360URLMocker mockMethod:@"POST" path:@"/dogs" callback:^BOOL(C360URLMocker *mocker, NSURLRequest *request) {
        
        XCTFail(@"The HTTP request should not be made");
        
        return NO;
        
    }];
    
    [dog deleteUsingAPIClient:self.apiClient successHandler:^(C360Dog *dog, BOOL submittedToServer) {
        
        [deleteExpectation fulfill];
        
    } failureHandler:^(NSError *error) {
        
        XCTFail();
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    [C360URLMocker unmockMethod:@"POST" path:@"/dogs"];
}

- (void)deleteDog:(C360Dog *)dog statusCode:(NSInteger)statusCode fileName:(NSString *)fileName expectSuccess:(BOOL)expectSuccess
{
    [self mockDogDelete:dog statusCode:statusCode fileName:fileName];
    
    NSString *expectationDescription = [NSString stringWithFormat:@"The delete should %@", expectSuccess ? @"succeed" : @"fail"];
    XCTestExpectation *deleteExpectation = [self expectationWithDescription:expectationDescription];
    
    [dog deleteUsingAPIClient:self.apiClient successHandler:^(C360Dog *dog, BOOL submittedToServer) {
        
        if (expectSuccess)
        {
            [deleteExpectation fulfill];
        }
        else
        {
            XCTFail(@"Unexpected success while updating dog");
        }
        
    } failureHandler:^(NSError *error) {
        
        if (expectSuccess)
        {
            XCTFail(@"Failed to delete dog with error: %@", error);
        }
        else
        {
            [deleteExpectation fulfill];
        }
        
    }];
    
    [self expectDogDelete:dog];
}

- (void)mockDogDelete:(C360Dog *)dog statusCode:(NSInteger)statusCode fileName:(NSString *)fileName
{
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"The HTTP request should be made"];
    
    NSString *path = [NSString stringWithFormat:@"/dogs/%@", dog.dogId];
    
    [C360URLMocker mockMethod:@"DELETE" path:path callback:^BOOL(C360URLMocker *mocker, NSURLRequest *request) {
        
        [mocker serveMockResponseWithStatusCode:statusCode fileName:fileName forRequest:request];
        [requestExpectation fulfill];
        return YES;
        
    }];
}

- (void)expectDogDelete:(C360Dog *)dog
{
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    NSString *path = [NSString stringWithFormat:@"/dogs/%@", dog.dogId];
    [C360URLMocker unmockMethod:@"DELETE" path:path];
}

- (void)testDeleteDog
{
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    C360Dog *dog = [C360Dog insertInManagedObjectContext:self.apiClient.objectManager.managedObjectStore.mainQueueManagedObjectContext];
    dog.dogId = @1070320720;
    
    // If we delete the dog, we should post off the details that we have set.
    [self deleteDog:dog statusCode:200 fileName:@"deleted.json" expectSuccess:YES];
    
    [self waitforReadiness];
    
    // The dog and submission should be deleted
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    C360CountObjects(self.apiClient, [C360DogDeletionSubmission class], 0);
}

- (void)testDeleteDogWhenOffline
{
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    C360Dog *dog = [C360Dog insertInManagedObjectContext:self.apiClient.objectManager.managedObjectStore.mainQueueManagedObjectContext];
    dog.dogId = @1070320720;
    
    // If we delete the dog when offline, nothing about the dog should change
    self.apiClient.isNetworkReachable = NO;
    [self deleteDogWhileOffline:dog];
    
    // There should be a delete submission, and it should be recoverable
    
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    C360CountObjects(self.apiClient, [C360DogDeletionSubmission class], 1);
    
    XCTAssertEqualObjects(dog.pendingDeletionSubmission.isUnrecoverable, @NO);
    
    // If we go online, the delete should be submitted
    // We should post off the details that we have set.
    [self mockDogDelete:dog statusCode:200 fileName:@"deleted.json"];
    
    self.apiClient.isNetworkReachable = YES;
    
    [self expectDogDelete:dog];
    [self waitforReadiness];
    
    // The dog and submission should be deleted
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    C360CountObjects(self.apiClient, [C360DogDeletionSubmission class], 0);
}

- (void)testDeleteDogForbiddenIsUnrecoverable
{
    C360CountObjects(self.apiClient, [C360Dog class], 0);
    
    C360Dog *dog = [C360Dog insertInManagedObjectContext:self.apiClient.objectManager.managedObjectStore.mainQueueManagedObjectContext];
    dog.dogId = @1070320720;
    
    // If we delete the dog and it is forbidden, nothing about the dog should change
    [self deleteDog:dog statusCode:403 fileName:@"forbidden.json" expectSuccess:NO];
    
    // There should be a delete submission, and it should be unrecoverable
    
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    C360CountObjects(self.apiClient, [C360DogDeletionSubmission class], 1);
    
    XCTAssertEqualObjects(dog.pendingDeletionSubmission.isUnrecoverable, @YES);
    
    // If purge the pending submission pipeline, nothing should happen
    [self waitforReadiness];
    
    C360CountObjects(self.apiClient, [C360Dog class], 1);
    C360CountObjects(self.apiClient, [C360DogDeletionSubmission class], 1);
    
    XCTAssertEqualObjects(dog.pendingDeletionSubmission.isUnrecoverable, @YES);
}

@end
