//
//  C360APIClient.m
//  Doggies
//
//  Created by Simon Booth on 31/05/2015.
//  Copyright (c) 2015 agbooth.com. All rights reserved.
//

#import "C360APIClient.h"
#import "C360PendingSubmission.h"

#import "C360Breed.h"
#import "C360Dog.h"

NSString * const C360APIClientErrorDomain = @"C360APIClientErrorDomain";
NSString * const C360APIClientErrorObjectKey = @"object";

typedef NS_ENUM(NSInteger, C360APIClientErrorCode)
{
    C360APIClientErrorCodePartialObject,
    C360APIClientErrorCodeNoSuchObject,
    C360APIClientErrorCodeSubmissionFailed
};

@interface C360APIClient ()

@property (nonatomic, strong, readonly) dispatch_semaphore_t networkReachabilitySemaphore;

@property (nonatomic, strong, readonly) NSLock *purgeLock;

@end

@implementation C360APIClient

- (id)initWithBaseURL:(NSURL *)baseURL fileName:(NSString *)fileName
{
    self = [super init];
    if (self)
    {
        _purgeLock = [[NSLock alloc] init];
        
        _networkReachabilitySemaphore = dispatch_semaphore_create(0);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        
        _objectManager = [RKObjectManager managerWithBaseURL:baseURL];
        _objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
        
        NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
        
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *storePath = [documentsURL.path stringByAppendingPathComponent:fileName];
        
        NSError *error = nil;
        [managedObjectStore addSQLitePersistentStoreAtPath:storePath
                                    fromSeedDatabaseAtPath:nil
                                         withConfiguration:nil
                                                   options:nil
                                                     error:&error];
        
        if (error)
        {
            [NSException raise:NSGenericException format:@"Error adding store: %@", error];
        }
        else
        {
            _objectManager.managedObjectStore = managedObjectStore;
            [managedObjectStore createManagedObjectContexts];
            
            [C360Breed registerMappingsWithObjectManager:self.objectManager];
            [C360Dog registerMappingsWithObjectManager:self.objectManager];
        }
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Reachability

- (BOOL)isNetworkReachable
{
    return self.objectManager.HTTPClient.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi
        || self.objectManager.HTTPClient.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN;
}

- (void)networkReachabilityDidChange:(NSNotification *)notification
{
    dispatch_semaphore_signal(self.networkReachabilitySemaphore);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self purgePendingSubmissions];
        
    });
}

- (void)waitForReadiness:(void(^)(void))completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        __weak AFHTTPClient *httpClient = self.objectManager.HTTPClient;
        
        if (httpClient.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown)
        {
            dispatch_semaphore_wait(self.networkReachabilitySemaphore, DISPATCH_TIME_FOREVER);
        }
        
        [self purgePendingSubmissions];
        
        dispatch_async(dispatch_get_main_queue(), completion);
    });
}

#pragma mark - Fetching arrays

- (void)fetchArrayFromSource:(C360ObjectSource)source
                 serverBlock:(void(^)(C360ArrayHandler, C360FailureHandler))serverBlock
               coreDataBlock:(void(^)(C360ArrayHandler, C360FailureHandler))coreDataBlock
              successHandler:(C360ArrayHandler)successHandler
              failureHandler:(C360FailureHandler)failureHandler
{
    switch (source)
    {
        case C360CoreDataSource:
        {
            coreDataBlock(successHandler, failureHandler);
            break;
        }
        
        case C360AnySource:
        {
            [self waitForReadiness:^{
                
                if ([self isNetworkReachable])
                {
                    serverBlock(^(NSArray *serverArray) {
                        
                        coreDataBlock(successHandler, failureHandler);
                        
                    }, ^(NSError *serverError) {
                        
                        coreDataBlock(^(NSArray *coreDataArray){
                            
                            if (coreDataArray.count > 0) successHandler(coreDataArray);
                            else failureHandler(serverError);
                            
                        }, ^(NSError *coreDataError){
                            
                            failureHandler(serverError);
                            
                        });
                        
                    });
                }
                else
                {
                    coreDataBlock(successHandler, failureHandler);
                }
                
            }];
            break;
        }
            
        case C360AnySourcePreferablyCoreData:
        {
            coreDataBlock(^(NSArray *coreDataArray){
                
                if (coreDataArray.count > 0)
                {
                    successHandler(coreDataArray);
                }
                else
                {
                    [self waitForReadiness:^{
                        
                        if ([self isNetworkReachable])
                        {
                            serverBlock(^(NSArray *serverArray){
                                coreDataBlock(successHandler, failureHandler);
                            }, failureHandler);
                        }
                        else
                        {
                            successHandler(coreDataArray);
                        }
                        
                    }];
                }
                
            }, ^(NSError *coreDataError){
                
                serverBlock(successHandler, failureHandler);
                
            });
            break;
        }
    }
}

- (void)fetchArrayFromServerWithPath:(NSString *)path
                          parameters:(NSDictionary *)parameters
                             keyPath:(NSString *)keyPath
                      successHandler:(C360ArrayHandler)successHandler
                      failureHandler:(C360FailureHandler)failureHandler
{
    [self.objectManager getObjectsAtPath:path parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        
        NSArray *serverArray = [[mappingResult dictionary] valueForKeyPath:keyPath];
        if ([serverArray isKindOfClass:[NSArray class]])
        {
            successHandler(serverArray);
        }
        else
        {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
            failureHandler(error);
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error){
       
        if (!operation.isCancelled)
        {
            failureHandler(error);
        }
        
    }];
}

- (void)fetchArrayFromCoreDataWithEntityName:(NSString *)entityName
                                   predicate:(NSPredicate *)predicate
                             sortDescriptors:(NSArray *)sortDescriptors
                              successHandler:(C360ArrayHandler)successHandler
                              failureHandler:(C360FailureHandler)failureHandler
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = sortDescriptors;
    
    NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetchRequest completionBlock:^(NSAsynchronousFetchResult *result){
        
        successHandler(result.finalResult);
        
    }];
    
    NSManagedObjectContext *foregroundContext = [self.objectManager.managedObjectStore mainQueueManagedObjectContext];
    NSError *error = nil;
    
    if (![foregroundContext executeRequest:asynchronousFetchRequest error:&error])
    {
        failureHandler(error);
    }
}

- (void)fetchArrayFromSource:(C360ObjectSource)source
                  serverPath:(NSString *)serverPath
            serverParameters:(NSDictionary *)serverParameters
               serverKeyPath:(NSString *)serverKeyPath
          coreDataEntityName:(NSString *)coreDataEntityName
           coreDataPredicate:(NSPredicate *)coreDataPredicate
     coreDataSortDescriptors:(NSArray *)coreDataSortDescriptors
              successHandler:(C360ArrayHandler)successHandler
              failureHandler:(C360FailureHandler)failureHandler
{
    [self fetchArrayFromSource:source serverBlock:^(C360ArrayHandler serverSuccessHandler, C360FailureHandler serverFailureHandler){
        
        [self fetchArrayFromServerWithPath:serverPath
                                parameters:serverParameters
                                   keyPath:serverKeyPath
                            successHandler:serverSuccessHandler
                            failureHandler:serverFailureHandler];
        
    } coreDataBlock:^(C360ArrayHandler coreDataSuccessHandler, C360FailureHandler coreDataFailureHandler){
        
        [self fetchArrayFromCoreDataWithEntityName:coreDataEntityName
                                         predicate:coreDataPredicate
                                   sortDescriptors:coreDataSortDescriptors
                                    successHandler:coreDataSuccessHandler
                                    failureHandler:coreDataFailureHandler];
        
    } successHandler:successHandler failureHandler:failureHandler];
}


#pragma mark - Fetching single objects

- (void)fetchObjectFromSource:(C360ObjectSource)source
                  serverBlock:(void(^)(C360ObjectHandler, C360FailureHandler))serverBlock
                coreDataBlock:(void(^)(C360ObjectHandler, C360FailureHandler))coreDataBlock
               successHandler:(C360ObjectHandler)successHandler
               failureHandler:(C360FailureHandler)failureHandler
{
    switch (source)
    {
        case C360CoreDataSource:
        {
            coreDataBlock(successHandler, failureHandler);
            break;
        }
            
        case C360AnySource:
        {
            [self waitForReadiness:^{
                if ([self isNetworkReachable])
                {
                    serverBlock(^(id serverObject) {
                        coreDataBlock(successHandler, failureHandler);
                    }, ^(NSError *serverError) {
                        coreDataBlock(^(id coreDataObject){
                            if (coreDataObject) successHandler(coreDataObject);
                            else failureHandler(serverError);
                        }, ^(NSError *coreDataError){
                            failureHandler(serverError);
                        });
                    });
                }
                else
                {
                    coreDataBlock(successHandler, failureHandler);
                }
            }];
            break;
        }
            
        case C360AnySourcePreferablyCoreData:
        {
            coreDataBlock(^(id coreDataObject){
                if (coreDataObject)
                {
                    successHandler(coreDataObject);
                }
                else
                {
                    [self waitForReadiness:^{
                        if ([self isNetworkReachable])
                        {
                            serverBlock(successHandler, failureHandler);
                        }
                        else
                        {
                            successHandler(coreDataObject);
                        }
                    }];
                }
            }, ^(NSError *coreDataError){
                serverBlock(successHandler, failureHandler);
            });
            break;
        }
    }
}

- (void)fetchObjectFromServerWithPath:(NSString *)path
                           parameters:(NSDictionary *)parameters
                              keyPath:(NSString *)keyPath
                       successHandler:(C360ObjectHandler)successHandler
                       failureHandler:(C360FailureHandler)failureHandler
{
    [self.objectManager getObjectsAtPath:path parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        
        id serverObject = [[mappingResult dictionary] valueForKeyPath:keyPath];
        if (serverObject)
        {
            NSError *error = nil;
            
            if ([serverObject respondsToSelector:@selector(setIsFullObject:)])
            {
                [serverObject setIsFullObject:@YES];
                [[serverObject managedObjectContext] save:&error];
            }
            
            if (error) failureHandler(error);
            else successHandler(serverObject);
        }
        else
        {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
            failureHandler(error);
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error){
        
        if (!operation.isCancelled)
        {
            failureHandler(error);
        }
        
    }];
}

- (void)fetchObjectFromCoreDataWithEntityName:(NSString *)entityName
                                    predicate:(NSPredicate *)predicate
                               successHandler:(C360ObjectHandler)successHandler
                               failureHandler:(C360FailureHandler)failureHandler
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = predicate;
    
    NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetchRequest completionBlock:^(NSAsynchronousFetchResult *result){
        
        id object = result.finalResult.firstObject;
        
        if (!object)
        {
            NSError *error = [NSError errorWithDomain:C360APIClientErrorDomain code:C360APIClientErrorCodeNoSuchObject userInfo:@{
                                                                                                                                  
                NSLocalizedDescriptionKey : @"The object could not be found."
                                                                                                                                  
            }];
            
            failureHandler(error);
        }
        else if ([object respondsToSelector:@selector(isFullObject)] && ![[object isFullObject] boolValue])
        {
            NSError *error = [NSError errorWithDomain:C360APIClientErrorDomain code:C360APIClientErrorCodeNoSuchObject userInfo:@{
                                                                                                                                  
                NSLocalizedDescriptionKey : @"The object could not be fully fetched."
                                                                                                                                  
            }];
            
            failureHandler(error);
        }
        else
        {
            successHandler(object);
        }
        
    }];
    
    NSManagedObjectContext *foregroundContext = [self.objectManager.managedObjectStore mainQueueManagedObjectContext];
    NSError *error = nil;
    
    if (![foregroundContext executeRequest:asynchronousFetchRequest error:&error])
    {
        failureHandler(error);
    }
}

- (void)fetchObjectFromSource:(C360ObjectSource)source
                   serverPath:(NSString *)serverPath
             serverParameters:(NSDictionary *)serverParameters
                serverKeyPath:(NSString *)serverKeyPath
           coreDataEntityName:(NSString *)coreDataEntityName
            coreDataPredicate:(NSPredicate *)coreDataPredicate
               successHandler:(C360ObjectHandler)successHandler
               failureHandler:(C360FailureHandler)failureHandler
{
    [self fetchObjectFromSource:source serverBlock:^(C360ObjectHandler serverSuccessHandler, C360FailureHandler serverFailureHandler){
        
        [self fetchObjectFromServerWithPath:serverPath
                                 parameters:serverParameters
                                    keyPath:serverKeyPath
                             successHandler:serverSuccessHandler
                             failureHandler:serverFailureHandler];
        
    } coreDataBlock:^(C360ObjectHandler coreDataSuccessHandler, C360FailureHandler coreDataFailureHandler){
        
        [self fetchObjectFromCoreDataWithEntityName:coreDataEntityName
                                          predicate:coreDataPredicate
                                     successHandler:coreDataSuccessHandler
                                     failureHandler:coreDataFailureHandler];
        
    } successHandler:successHandler failureHandler:failureHandler];
}

#pragma mark - Submitting

- (void)enqueueSubmissionForObject:(NSManagedObject *)object
              submissionEntityName:(NSString *)submissionEntityName
           existingSubmissionBlock:(C360ExistingSubmissionBlock)existingSubmissionBlock
                configurationBlock:(C360SubmissionConfigurationBlock)configurationBlock
  objectShouldExistAfterSubmission:(BOOL)objectShouldExistAfterSubmission
                    successHandler:(C360SubmitHandler)successHandler
                    failureHandler:(C360FailureHandler)failureHandler
{
    NSError *error = nil;
    C360PendingSubmission *submission = [self prepareSubmissionForObject:object
                                                    submissionEntityName:submissionEntityName
                                                 existingSubmissionBlock:existingSubmissionBlock
                                                      configurationBlock:configurationBlock
                                                                   error:&error];
    
    if (submission)
    {
        [self waitForReadiness:^{
            
            [self examinePendingSubmission:submission
                                 forObject:object
          objectShouldExistAfterSubmission:objectShouldExistAfterSubmission
                            successHandler:successHandler
                            failureHandler:failureHandler];
            
        }];
    }
    else
    {
        failureHandler(error);
    }
}

- (C360PendingSubmission *)prepareSubmissionForObject:(NSManagedObject *)object
                                 submissionEntityName:(NSString *)submissionEntityName
                              existingSubmissionBlock:(C360ExistingSubmissionBlock)existingSubmissionBlock
                                   configurationBlock:(C360SubmissionConfigurationBlock)configurationBlock
                                                error:(NSError **)outError
{
    NSError *error = nil;
    C360PendingSubmission *submission = nil;
    NSManagedObjectContext *managedObjectContext = [self.objectManager.managedObjectStore mainQueueManagedObjectContext];
    
        BOOL submissionAlreadyExisted = NO;
        
        if ([managedObjectContext obtainPermanentIDsForObjects:@[ object ] error:&error])
        {
            if (existingSubmissionBlock)
            {
                submission = existingSubmissionBlock();
            }
            
            if (submission)
            {
                submissionAlreadyExisted = YES;
            }
            else
            {
                submission = [NSEntityDescription insertNewObjectForEntityForName:submissionEntityName
                                                           inManagedObjectContext:managedObjectContext];
                
                [managedObjectContext obtainPermanentIDsForObjects:@[ submission ] error:&error];
            }
        }
        
        if (configurationBlock && !error)
        {
            BOOL configured = configurationBlock(submission, &error);
            if (!configured && !error)
            {
                [NSException raise:NSInternalInconsistencyException format:@"configuration block failed but no error was set"];
            }
        }
        
        if (!error)
        {
            [submission prepareForSubmission:&error];
        }
    
        if (!error)
        {
            [submission.managedObjectContext saveToPersistentStore:&error];
        }
        
        if (error && submission && !submissionAlreadyExisted)
        {
            [submission.managedObjectContext deleteObject:submission];
            [submission.managedObjectContext saveToPersistentStore:nil];
            submission = nil;
        }
    
    if (outError) *outError = error;
    return submission;
}

- (void)examinePendingSubmission:(C360PendingSubmission *)submission
                       forObject:(NSManagedObject *)object
objectShouldExistAfterSubmission:(BOOL)objectShouldExistAfterSubmission
                  successHandler:(C360SubmitHandler)successHandler
                  failureHandler:(C360FailureHandler)failureHandler
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self.objectManager.managedObjectStore mainQueueManagedObjectContext];
    
    [managedObjectContext refreshObject:object mergeChanges:YES];
    [managedObjectContext refreshObject:submission mergeChanges:YES];
    
    if ((object.managedObjectContext != nil) || !objectShouldExistAfterSubmission)
    {
        if (submission.managedObjectContext == nil) // i.e. the submission succeeded and was deleted
        {
            successHandler(object, YES);
        }
        else if (submission.isUnrecoverable.boolValue == NO)
        {
            // Either the request failed or was never made.  But we succeeded in creating the pending submission,
            // so this is still technically a success. We pass submittedToServer = NO to represent this.
            successHandler(object, NO);
        }
        else
        {
            // Something went so badly wrong that we can't fix it.  We should let the user know.
            error = [submission lastSubmissionAsError];
        }
    }
    else
    {
        error = [NSError errorWithDomain:C360APIClientErrorDomain code:C360APIClientErrorCodeSubmissionFailed userInfo:@{
                                                                                                                         
            NSLocalizedDescriptionKey : @"The object did not exist after the submission completed",
            C360APIClientErrorObjectKey : object ?: [NSNull null]
            
        }];
    }
    
    if (error)
    {
        failureHandler(error);
    }
}

- (void)purgePendingSubmissions
{
    if (![self isNetworkReachable])
    {
        return;
    }
    
    [self.purgeLock lock];
    
    __block NSError *error = nil;
    
    NSManagedObjectContext *foregroundContext = [self.objectManager.managedObjectStore mainQueueManagedObjectContext];
    NSManagedObjectContext *backgroundContext = [self.objectManager.managedObjectStore newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO];

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[C360PendingSubmission entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isUnrecoverable == %@", @NO];
    fetchRequest.resultType = NSManagedObjectIDResultType;
    fetchRequest.sortDescriptors = [C360PendingSubmission sortDescriptors];
    
    __block NSArray *pendingSubmissionObjectIDs = nil;
    
    [backgroundContext performBlockAndWait:^{
        pendingSubmissionObjectIDs = [backgroundContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    if (!error)
    {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        for (NSManagedObjectID *objectID in pendingSubmissionObjectIDs)
        {
            // To prevent a deadlock in RestKit, we have to make a trip to the main thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                
                C360PendingSubmission *submission = (C360PendingSubmission *)[foregroundContext existingObjectWithID:objectID error:&error];
            
                if (submission)
                {
                    [submission submitToClient:self completion:^{
                        dispatch_semaphore_signal(semaphore);
                    }];
                }
                else
                {
                    dispatch_semaphore_signal(semaphore);
                }
                
            });
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
        }
    }
    
    [self.purgeLock unlock];
}

@end
