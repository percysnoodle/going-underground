
#import "C360Dog.h"
#import "C360DogCreationSubmission.h"
#import "C360DogUpdateSubmission.h"
#import "C360DogDeletionSubmission.h"

@implementation C360Dog

+ (NSArray *)sortDescriptors
{
    return @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)] ];
}

+ (void)fetchDogsFromSource:(C360ObjectSource)source
             usingAPIClient:(C360APIClient *)apiClient
             successHandler:(C360ArrayHandler)successHandler
             failureHandler:(C360FailureHandler)failureHandler
{
    [apiClient fetchArrayFromSource:source
                         serverPath:@"/dogs"
                   serverParameters:nil
                      serverKeyPath:@"dogs"
                 coreDataEntityName:[self entityName]
                  coreDataPredicate:nil
            coreDataSortDescriptors:[self sortDescriptors]
                     successHandler:successHandler
                     failureHandler:failureHandler];
}

+ (NSPredicate *)predicateForDogWithId:(NSNumber *)dogId
{
    return [NSPredicate predicateWithFormat:@"dogId == %@", dogId];
}

+ (void)fetchDogWithId:(NSNumber *)dogId
            fromSource:(C360ObjectSource)source
        usingAPIClient:(C360APIClient *)apiClient
        successHandler:(C360DogHandler)successHandler
        failureHandler:(C360FailureHandler)failureHandler
{
    NSString *path = [NSString stringWithFormat:@"/dogs/%@", dogId];
    
    [apiClient fetchObjectFromSource:source
                          serverPath:path
                    serverParameters:nil
                       serverKeyPath:@"dog"
                  coreDataEntityName:[self entityName]
                   coreDataPredicate:[self predicateForDogWithId:dogId]
                      successHandler:successHandler
                      failureHandler:failureHandler];
}

- (void)createUsingAPIClient:(C360APIClient *)apiClient
              successHandler:(C360SubmitDogHandler)successHandler
              failureHandler:(C360FailureHandler)failureHandler
{
    [apiClient enqueueSubmissionForObject:self submissionEntityName:[C360DogCreationSubmission entityName] existingSubmissionBlock:^C360PendingSubmission *{
        
        return self.pendingCreationSubmission;
        
    } configurationBlock:^BOOL(id submission, NSError **outError) {
        
        self.pendingCreationSubmission = submission;
        return YES;
        
    } objectShouldExistAfterSubmission:YES successHandler:successHandler failureHandler:failureHandler];
}

- (void)updateUsingAPIClient:(C360APIClient *)apiClient
          configurationBlock:(C360DogUpdateSubmissionConfigurationBlock)configurationBlock
              successHandler:(C360SubmitDogHandler)successHandler
              failureHandler:(C360FailureHandler)failureHandler
{
    [apiClient enqueueSubmissionForObject:self submissionEntityName:[C360DogUpdateSubmission entityName] existingSubmissionBlock:^C360PendingSubmission *{
        
        return self.pendingUpdateSubmission;
        
    } configurationBlock:^BOOL(id submission, NSError **outError) {
        
        self.pendingUpdateSubmission = submission;
        return configurationBlock(submission, outError);
        
    }  objectShouldExistAfterSubmission:YES successHandler:successHandler failureHandler:failureHandler];
}

- (void)deleteUsingAPIClient:(C360APIClient *)apiClient successHandler:(C360SubmitDogHandler)successHandler failureHandler:(C360FailureHandler)failureHandler
{
    [apiClient enqueueSubmissionForObject:self submissionEntityName:[C360DogDeletionSubmission entityName] existingSubmissionBlock:^C360PendingSubmission *{
        
        return self.pendingDeletionSubmission;
        
    } configurationBlock:^BOOL(id submission, NSError **outError) {
        
        self.pendingDeletionSubmission = submission;
        return YES;
        
    }  objectShouldExistAfterSubmission:NO successHandler:successHandler failureHandler:failureHandler];
}

#pragma mark - RestKit setup

+ (RKObjectMapping *)requestMappingForStore:(RKManagedObjectStore *)managedObjectStore
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"name"                   : @"name",
        @"numberOfBottomsSniffed" : @"bottoms_sniffed",
        @"numberOfCatsChased"     : @"cats_chased",
        @"numberOfFacesLicked"    : @"faces_licked"
    }];
    
    return mapping;
}

+ (RKObjectMapping *)responseMappingForStore:(RKManagedObjectStore *)managedObjectStore
                              forAPIEndpoint:(C360DogAPIEndpoint)apiEndpoint
{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:[self entityName] inManagedObjectStore:managedObjectStore];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"id"              : @"dogId",
        @"name"            : @"name",
        @"bottoms_sniffed" : @"numberOfBottomsSniffed",
        @"cats_chased"     : @"numberOfCatsChased",
        @"faces_licked"    : @"numberOfFacesLicked"
    }];
    
    if (apiEndpoint == C360DogAPIEndpointInBreed)
    {
        [mapping addAttributeMappingsFromDictionary:@{
            @"@parent.id"   : @"breedId",
            @"@parent.name" : @"breedName"
        }];
    }
    else
    {
        [mapping addAttributeMappingsFromDictionary:@{
            @"breed_id"   : @"breedId",
            @"breed_name" : @"breedName"
        }];
    }
    
    mapping.identificationAttributes = @[ @"dogId" ];
    
    if (apiEndpoint == C360DogAPIEndpointFullObject)
    {
        mapping.assignsDefaultValueForMissingAttributes = YES;
    }
    
    return mapping;
}

+ (void)registerMappingsWithObjectManager:(RKObjectManager *)objectManager
{
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKObjectMapping *listMapping = [self responseMappingForStore:objectManager.managedObjectStore
                                                  forAPIEndpoint:C360DogAPIEndpointList];
    
    [objectManager addResponseDescriptor:
     [RKResponseDescriptor responseDescriptorWithMapping:listMapping
                                                  method:RKRequestMethodGET
                                             pathPattern:@"/dogs"
                                                 keyPath:@"dogs"
                                             statusCodes:statusCodes]
    ];
    
    [objectManager addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
        
        if ([[RKPathMatcher pathMatcherWithPath:URL.path] matchesPattern:@"/dogs" tokenizeQueryStrings:nil parsedArguments:nil])
        {
            return [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
        }
        
        return nil;
        
    }];
    
    RKObjectMapping *fullObjectMapping = [self responseMappingForStore:objectManager.managedObjectStore
                                                        forAPIEndpoint:C360DogAPIEndpointFullObject];
    
    [objectManager addResponseDescriptor:
     [RKResponseDescriptor responseDescriptorWithMapping:fullObjectMapping
                                                  method:RKRequestMethodGET
                                             pathPattern:@"/dogs/:dogId"
                                                 keyPath:@"dog"
                                             statusCodes:statusCodes]
     ];
    
    [objectManager addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
        
        NSDictionary *arguments;
        if ([[RKPathMatcher pathMatcherWithPath:URL.path] matchesPattern:@"/dogs/:dogId" tokenizeQueryStrings:NO parsedArguments:&arguments])
        {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
            fetchRequest.predicate = [self predicateForDogWithId:arguments[@"dogId"]];
            return fetchRequest;
        }
        
        return nil;
        
    }];
    
    RKObjectMapping *createMapping = [self requestMappingForStore:objectManager.managedObjectStore];
    
    [objectManager addRequestDescriptor:
     [RKRequestDescriptor requestDescriptorWithMapping:createMapping
                                           objectClass:[self class]
                                           rootKeyPath:@"dog"
                                                method:RKRequestMethodPOST]
     ];
    
    [objectManager addResponseDescriptor:
     [RKResponseDescriptor responseDescriptorWithMapping:fullObjectMapping
                                                  method:RKRequestMethodPOST
                                             pathPattern:@"/dogs"
                                                 keyPath:@"dog"
                                             statusCodes:statusCodes]
     ];
    
    
    RKObjectMapping *updateMapping = [C360DogUpdateSubmission requestMappingForStore:objectManager.managedObjectStore];
    
    [objectManager addRequestDescriptor:
     [RKRequestDescriptor requestDescriptorWithMapping:updateMapping
                                           objectClass:[C360DogUpdateSubmission class]
                                           rootKeyPath:@"dog"
                                                method:RKRequestMethodPUT]
     ];
    
    [objectManager addResponseDescriptor:
     [RKResponseDescriptor responseDescriptorWithMapping:fullObjectMapping
                                                  method:RKRequestMethodPUT
                                             pathPattern:@"/dogs/:dogId"
                                                 keyPath:@"dog"
                                             statusCodes:statusCodes]
     ];
    
    RKObjectMapping *deleteMapping = [C360Dog requestMappingForStore:objectManager.managedObjectStore];
    
    [objectManager addRequestDescriptor:
     [RKRequestDescriptor requestDescriptorWithMapping:deleteMapping
                                           objectClass:[C360Dog class]
                                           rootKeyPath:@"dog"
                                                method:RKRequestMethodDELETE]
    ];
    
    [objectManager addResponseDescriptor:
     [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping requestMapping]
                                                  method:RKRequestMethodDELETE
                                             pathPattern:nil
                                                 keyPath:nil
                                             statusCodes:statusCodes]
    ];
}

@end
