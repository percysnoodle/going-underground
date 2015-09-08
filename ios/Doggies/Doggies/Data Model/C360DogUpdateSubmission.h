
#import "_C360DogUpdateSubmission.h"
#import <RestKit/RestKit.h>

@interface C360DogUpdateSubmission : _C360DogUpdateSubmission {}

+ (RKObjectMapping *)requestMappingForStore:(RKManagedObjectStore *)managedObjectStore;

@end
