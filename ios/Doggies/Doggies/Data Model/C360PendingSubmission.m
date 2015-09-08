#import "C360PendingSubmission.h"
#import "C360APIClient.h"

#define kC360PendingSubmissionErrorThreshold 3

NSString * const C360PendingSubmissionErrorDomain = @"C360PendingSubmissionErrorDomain";

@implementation C360PendingSubmission

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    double timestamp = [NSDate timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970;
    [self setPrimitiveValue:@(timestamp) forKey:@"createdAtTimestamp"];
}

+ (NSArray *)sortDescriptors
{
    return @[ [NSSortDescriptor sortDescriptorWithKey:@"createdAtTimestamp" ascending:YES] ];
}

- (BOOL)prepareForSubmission:(NSError **)outError
{
    self.lastSubmissionLocalizedDescription = nil;
    self.lastSubmissionTimestamp = nil;
    self.numberOfErrors = @0;
    self.isUnrecoverable = @NO;
    
    NSError *error = nil;
    BOOL success = [self.managedObjectContext obtainPermanentIDsForObjects:@[self] error:&error] &&
                   [self.managedObjectContext saveToPersistentStore:&error];
    
    if (outError) *outError = error;
    return success;
}

- (void)submitToClient:(C360APIClient *)apiClient completion:(void (^)(void))completion
{
    [NSException raise:NSInternalInconsistencyException format:@"-[%@ %@] is not implemented", NSStringFromClass(self.class), NSStringFromSelector(_cmd)];
}

- (void)submitToClient:(C360APIClient *)apiClient submissionBlock:(void(^)(C360SuccessHandler successHandler, C360FailureHandler failureHandler))submissionBlock completion:(void (^)(void))completion
{
    NSError *outerError = nil;
    self.lastSubmissionTimestamp = @([NSDate timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970);
    
    if ([self.managedObjectContext saveToPersistentStore:&outerError] && submissionBlock)
    {
        NSManagedObjectContext *mainContext = apiClient.objectManager.managedObjectStore.mainQueueManagedObjectContext;
        
        submissionBlock(^{
            
            [mainContext performBlock:^{
                
                NSError *innerError = nil;
                C360PendingSubmission *mainSelf = (C360PendingSubmission *)[mainContext existingObjectWithID:[self objectID] error:&innerError];
                
                if (!innerError)
                {
                    [mainContext deleteObject:mainSelf];
                    [mainContext saveToPersistentStore:&innerError];
                }
                
                if (innerError) NSLog(@"Submission succeed but core data returned error %@", innerError);
                if (completion) completion();
                
            }];
            
        }, ^(NSError *serverError) {
            
            [mainContext performBlock:^{
                
                NSError *innerError = nil;
                C360PendingSubmission *mainSelf = (C360PendingSubmission *)[mainContext existingObjectWithID:[self objectID] error:&innerError];
                
                if (!innerError)
                {
                    mainSelf.lastSubmissionLocalizedDescription = serverError.localizedDescription;
                    mainSelf.numberOfErrors = @([mainSelf.numberOfErrors integerValue] + 1);
                    mainSelf.isUnrecoverable = @([self errorIsUnrecoverable:serverError]);
                    [mainContext saveToPersistentStore:&innerError];
                }
                
                if (innerError) NSLog(@"Submission failed and core data returned error %@", innerError);
                if (completion) completion();
                
            }];
            
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

- (NSError *)lastSubmissionAsError
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if (self.lastSubmissionLocalizedDescription)
    {
        userInfo[NSLocalizedDescriptionKey] = self.lastSubmissionLocalizedDescription;
    }
    
    return [NSError errorWithDomain:C360PendingSubmissionErrorDomain code:0 userInfo:userInfo];
}

- (BOOL)errorIsUnrecoverable:(NSError *)error
{
    if ([self.numberOfErrors integerValue] > kC360PendingSubmissionErrorThreshold)
    {
        return YES;
    }
    
    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    NSInteger statusCode = response.statusCode;
    
    if ((statusCode >= 400) && (statusCode < 500))
    {
        return YES;
    }
    
    return NO;
}

@end
