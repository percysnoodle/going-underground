
#import "C360DogUpdateSubmission.h"
#import "C360Dog.h"

@implementation C360DogUpdateSubmission

+ (RKObjectMapping *)requestMappingForStore:(RKManagedObjectStore *)managedObjectStore
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"name"                   : @"name",
        @"breedId"                : @"breed_id",
        @"numberOfBottomsSniffed" : @"bottoms_sniffed",
        @"numberOfCatsChased"     : @"cats_chased",
        @"numberOfFacesLicked"    : @"faces_licked"
    }];
    
    return mapping;
}

- (void)submitToClient:(C360APIClient *)apiClient completion:(void (^)(void))completion
{
    if (self.dog.dogId)
    {
        [self submitToClient:apiClient submissionBlock:^(C360SuccessHandler successHandler, C360FailureHandler failureHandler) {
            
            NSString *path = [NSString stringWithFormat:@"/dogs/%@", self.dog.dogId];
            
            [apiClient.objectManager putObject:self path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                
                successHandler();
                
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                
                failureHandler(error);
                
            }];
            
        } completion:completion];
    }
    else
    {
        NSLog(@"Not sending update - owning object has not yet been created");
    }
}

@end
