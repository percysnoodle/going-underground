
#import "C360DogDeletionSubmission.h"
#import "C360Dog.h"

@implementation C360DogDeletionSubmission

- (void)submitToClient:(C360APIClient *)apiClient completion:(void (^)(void))completion
{
    if (self.dog.dogId)
    {
        [self submitToClient:apiClient submissionBlock:^(C360SuccessHandler successHandler, C360FailureHandler failureHandler) {
            
            NSString *path = [NSString stringWithFormat:@"/dogs/%@", self.dog.dogId];
            
            [apiClient.objectManager deleteObject:self.dog path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                
                successHandler();
                
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                
                failureHandler(error);
                
            }];
            
        } completion:completion];
    }
    else
    {
        // Dog hasn't been created, so just delete it locally.
        // The calling code is expecting us to make a network
        // request, so let's do this asynchronously.
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Deleting our owner will cascade down to us, so keep hold of the MOC
            NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
            
            [managedObjectContext deleteObject:self.dog];
            
            NSError *error = nil;
            if (![managedObjectContext saveToPersistentStore:&error])
            {
                NSLog(@"Error deleting dog: %@", error);
            }
            
            completion();
            
        });
    }
}

@end
