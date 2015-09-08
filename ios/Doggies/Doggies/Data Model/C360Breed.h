
#import "_C360Breed.h"
#import "C360APIClient.h"

@class C360Breed;

typedef void(^C360BreedHandler)(C360Breed *breed);

typedef NS_ENUM(NSInteger, C360BreedAPIEndpoint)
{
    C360BreedAPIEndpointList,
    C360BreedAPIEndpointFullObject
};

@interface C360Breed : _C360Breed

+ (void)fetchBreedsFromSource:(C360ObjectSource)source
               usingAPIClient:(C360APIClient *)apiClient
               successHandler:(C360ArrayHandler)successHandler
               failureHandler:(C360FailureHandler)failureHandler;

+ (void)fetchBreedWithId:(NSNumber *)breedId
              fromSource:(C360ObjectSource)source
               usingAPIClient:(C360APIClient *)apiClient
               successHandler:(C360BreedHandler)successHandler
               failureHandler:(C360FailureHandler)failureHandler;

+ (void)registerMappingsWithObjectManager:(RKObjectManager *)objectManager;
+ (RKObjectMapping *)responseMappingForStore:(RKManagedObjectStore *)managedObjectStore
                              forAPIEndpoint:(C360BreedAPIEndpoint)apiEndpoint;

@end
