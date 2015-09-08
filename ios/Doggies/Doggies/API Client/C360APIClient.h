//
//  C360APIClient.h
//  Doggies
//
//  Created by Simon Booth on 31/05/2015.
//  Copyright (c) 2015 agbooth.com. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <RestKit/RestKit.h>

@class C360PendingSubmission;

typedef NS_ENUM(NSInteger, C360ObjectSource)
{
    C360CoreDataSource,
    C360AnySource,
    C360AnySourcePreferablyCoreData
};

typedef void(^C360ObjectHandler)(id object);
typedef void(^C360ArrayHandler)(NSArray *array);
typedef void(^C360FailureHandler)(NSError *error);
typedef void(^C360SuccessHandler)(void);

typedef C360PendingSubmission *(^C360ExistingSubmissionBlock)();
typedef BOOL(^C360SubmissionConfigurationBlock)(id submission, NSError **outError);
typedef void(^C360SubmitHandler)(id object, BOOL submittedToServer);

extern NSString * const C360APIClientErrorDomain;
extern NSString * const C360APIClientErrorObjectKey;

@protocol C360FullObject

@property (nonatomic, strong) NSNumber *isFullObject;

@end

@interface C360APIClient : NSObject

@property (nonatomic, strong, readonly) RKObjectManager *objectManager;
- (id)initWithBaseURL:(NSURL *)baseURL fileName:(NSString *)fileName;

- (void)waitForReadiness:(void(^)(void))completion;

#pragma mark - Fetching arrays

- (void)fetchArrayFromSource:(C360ObjectSource)source
                 serverBlock:(void(^)(C360ArrayHandler, C360FailureHandler))serverBlock
               coreDataBlock:(void(^)(C360ArrayHandler, C360FailureHandler))coreDataBlock
              successHandler:(C360ArrayHandler)successHandler
              failureHandler:(C360FailureHandler)failureHandler;

- (void)fetchArrayFromServerWithPath:(NSString *)path
                          parameters:(NSDictionary *)parameters
                             keyPath:(NSString *)keyPath
                      successHandler:(C360ArrayHandler)successHandler
                      failureHandler:(C360FailureHandler)failureHandler;

- (void)fetchArrayFromCoreDataWithEntityName:(NSString *)entityName
                                   predicate:(NSPredicate *)predicate
                             sortDescriptors:(NSArray *)sortDescriptors
                              successHandler:(C360ArrayHandler)successHandler
                              failureHandler:(C360FailureHandler)failureHandler;

- (void)fetchArrayFromSource:(C360ObjectSource)source
                  serverPath:(NSString *)serverPath
            serverParameters:(NSDictionary *)serverParameters
               serverKeyPath:(NSString *)serverKeyPath
          coreDataEntityName:(NSString *)coreDataEntityName
           coreDataPredicate:(NSPredicate *)coreDataPredicate
     coreDataSortDescriptors:(NSArray *)coreDataSortDescriptors
              successHandler:(C360ArrayHandler)successHandler
              failureHandler:(C360FailureHandler)failureHandler;

#pragma mark - Fetching single objects

- (void)fetchObjectFromSource:(C360ObjectSource)source
                  serverBlock:(void(^)(C360ObjectHandler, C360FailureHandler))serverBlock
                coreDataBlock:(void(^)(C360ObjectHandler, C360FailureHandler))coreDataBlock
               successHandler:(C360ObjectHandler)successHandler
               failureHandler:(C360FailureHandler)failureHandler;

- (void)fetchObjectFromServerWithPath:(NSString *)path
                           parameters:(NSDictionary *)parameters
                              keyPath:(NSString *)keyPath
                       successHandler:(C360ObjectHandler)successHandler
                       failureHandler:(C360FailureHandler)failureHandler;

- (void)fetchObjectFromCoreDataWithEntityName:(NSString *)entityName
                                    predicate:(NSPredicate *)predicate
                               successHandler:(C360ObjectHandler)successHandler
                               failureHandler:(C360FailureHandler)failureHandler;

- (void)fetchObjectFromSource:(C360ObjectSource)source
                   serverPath:(NSString *)serverPath
             serverParameters:(NSDictionary *)serverParameters
                serverKeyPath:(NSString *)serverKeyPath
           coreDataEntityName:(NSString *)coreDataEntityName
            coreDataPredicate:(NSPredicate *)coreDataPredicate
               successHandler:(C360ObjectHandler)successHandler
               failureHandler:(C360FailureHandler)failureHandler;

#pragma mark - Submitting

- (void)enqueueSubmissionForObject:(NSManagedObject *)object
              submissionEntityName:(NSString *)submissionEntityName
           existingSubmissionBlock:(C360ExistingSubmissionBlock)existingSubmissionBlock
                configurationBlock:(C360SubmissionConfigurationBlock)configurationBlock
  objectShouldExistAfterSubmission:(BOOL)objectShouldExistAfterSubmission
                    successHandler:(C360SubmitHandler)successHandler
                    failureHandler:(C360FailureHandler)failureHandler;

@end
