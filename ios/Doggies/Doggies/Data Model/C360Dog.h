
#import "_C360Dog.h"
#import "C360APIClient.h"

@class C360Dog;

typedef void(^C360DogHandler)(C360Dog *dog);
typedef void(^C360SubmitDogHandler)(C360Dog *dog, BOOL submittedToServer);
typedef BOOL(^C360DogUpdateSubmissionConfigurationBlock)(C360DogUpdateSubmission *submission, NSError **outError);

typedef NS_ENUM(NSInteger, C360DogAPIEndpoint)
{
    C360DogAPIEndpointList,
    C360DogAPIEndpointFullObject,
    C360DogAPIEndpointInBreed
};

@interface C360Dog : _C360Dog

+ (void)fetchDogsFromSource:(C360ObjectSource)source
             usingAPIClient:(C360APIClient *)apiClient
             successHandler:(C360ArrayHandler)successHandler
             failureHandler:(C360FailureHandler)failureHandler;

+ (void)fetchDogWithId:(NSNumber *)dogId
            fromSource:(C360ObjectSource)source
        usingAPIClient:(C360APIClient *)apiClient
        successHandler:(C360DogHandler)successHandler
        failureHandler:(C360FailureHandler)failureHandler;

- (void)createUsingAPIClient:(C360APIClient *)apiClient
              successHandler:(C360SubmitDogHandler)successHandler
              failureHandler:(C360FailureHandler)failureHandler;

- (void)updateUsingAPIClient:(C360APIClient *)apiClient
          configurationBlock:(C360DogUpdateSubmissionConfigurationBlock)configurationBlock
              successHandler:(C360SubmitDogHandler)successHandler
              failureHandler:(C360FailureHandler)failureHandler;

- (void)deleteUsingAPIClient:(C360APIClient *)apiClient
              successHandler:(C360SubmitDogHandler)successHandler
              failureHandler:(C360FailureHandler)failureHandler;

+ (void)registerMappingsWithObjectManager:(RKObjectManager *)objectManager;

+ (RKObjectMapping *)requestMappingForStore:(RKManagedObjectStore *)managedObjectStore;
+ (RKObjectMapping *)responseMappingForStore:(RKManagedObjectStore *)managedObjectStore forAPIEndpoint:(C360DogAPIEndpoint)apiEndpoint;

+ (NSArray *)sortDescriptors;

@end
