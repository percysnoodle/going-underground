
#import "C360DogCreationSubmission.h"
#import "C360Dog.h"

@implementation C360DogCreationSubmission

- (void)submitToClient:(C360APIClient *)apiClient completion:(void (^)(void))completion
{
    [self submitToClient:apiClient submissionBlock:^(C360SuccessHandler successHandler, C360FailureHandler failureHandler) {
        
        NSString *path = @"/dogs";
        
        [apiClient.objectManager postObject:self.dog path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            
            successHandler();
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            
            failureHandler(error);
            
        }];
        
    } completion:completion];
}

@end
