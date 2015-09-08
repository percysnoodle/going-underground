
#import "C360Breed.h"
#import "C360Dog.h"

@implementation C360Breed

+ (NSArray *)sortDescriptors
{
    return @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)] ];
}

+ (void)fetchBreedsFromSource:(C360ObjectSource)source
               usingAPIClient:(C360APIClient *)apiClient
               successHandler:(C360ArrayHandler)successHandler
               failureHandler:(C360FailureHandler)failureHandler
{
    [apiClient fetchArrayFromSource:source
                         serverPath:@"/breeds"
                   serverParameters:nil
                      serverKeyPath:@"breeds"
                 coreDataEntityName:[self entityName]
                  coreDataPredicate:nil
            coreDataSortDescriptors:[self sortDescriptors]
                     successHandler:successHandler
                     failureHandler:failureHandler];
}

+ (NSPredicate *)predicateForBreedWithId:(NSNumber *)breedId
{   
    return [NSPredicate predicateWithFormat:@"breedId == %@", breedId];
}

+ (void)fetchBreedWithId:(NSNumber *)breedId
              fromSource:(C360ObjectSource)source
          usingAPIClient:(C360APIClient *)apiClient
          successHandler:(C360BreedHandler)successHandler
          failureHandler:(C360FailureHandler)failureHandler
{
    NSString *path = [NSString stringWithFormat:@"/breeds/%@", breedId];
    
    [apiClient fetchObjectFromSource:source
                          serverPath:path
                    serverParameters:nil
                       serverKeyPath:@"breed"
                  coreDataEntityName:[self entityName]
                   coreDataPredicate:[self predicateForBreedWithId:breedId]
                     successHandler:successHandler
                     failureHandler:failureHandler];
}

#pragma mark - RestKit setup

+ (RKObjectMapping *)responseMappingForStore:(RKManagedObjectStore *)managedObjectStore
                              forAPIEndpoint:(C360BreedAPIEndpoint)apiEndpoint
{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:[self entityName] inManagedObjectStore:managedObjectStore];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"id"   : @"breedId",
        @"name" : @"name",
        @"size" : @"size"
    }];
    
    RKObjectMapping *dogsMapping = [C360Dog responseMappingForStore:managedObjectStore
                                                     forAPIEndpoint:C360DogAPIEndpointInBreed];
                                    
    [mapping addRelationshipMappingWithSourceKeyPath:@"dogs" mapping:dogsMapping];
    
    mapping.identificationAttributes = @[ @"breedId" ];
    
    if (apiEndpoint == C360BreedAPIEndpointFullObject)
    {
        mapping.assignsDefaultValueForMissingAttributes = YES;
        mapping.assignsNilForMissingRelationships = YES;
    }
    
    return mapping;
}

+ (void)registerMappingsWithObjectManager:(RKObjectManager *)objectManager
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKObjectMapping *listMapping = [self responseMappingForStore:objectManager.managedObjectStore
                                                  forAPIEndpoint:C360BreedAPIEndpointList];
    
    [objectManager addResponseDescriptor:
     [RKResponseDescriptor responseDescriptorWithMapping:listMapping
                                                  method:RKRequestMethodGET
                                             pathPattern:@"/breeds"
                                                 keyPath:@"breeds"
                                             statusCodes:statusCodes]
    ];
    
    [objectManager addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
        
        if ([[RKPathMatcher pathMatcherWithPath:URL.path] matchesPattern:@"/breeds" tokenizeQueryStrings:nil parsedArguments:nil])
        {
            return [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
        }
        
        return nil;
        
    }];
    
    RKObjectMapping *fullObjectMapping = [self responseMappingForStore:objectManager.managedObjectStore
                                                        forAPIEndpoint:C360BreedAPIEndpointFullObject];
    
    [objectManager addResponseDescriptor:
     [RKResponseDescriptor responseDescriptorWithMapping:fullObjectMapping
                                                  method:RKRequestMethodGET
                                             pathPattern:@"/breeds/:breedId"
                                                 keyPath:@"breed"
                                             statusCodes:statusCodes]
     ];
    
    [objectManager addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
        
        NSDictionary *arguments;
        if ([[RKPathMatcher pathMatcherWithPath:URL.path] matchesPattern:@"/breeds/:breedId" tokenizeQueryStrings:NO parsedArguments:&arguments])
        {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
            fetchRequest.predicate = [self predicateForBreedWithId:arguments[@"breedId"]];
            return fetchRequest;
        }
        
        return nil;
        
    }];
}

@end
