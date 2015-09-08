
#import "_C360PendingSubmission.h"
#import "C360APIClient.h"

extern NSString * const C360PendingSubmissionErrorDomain;

@interface C360PendingSubmission : _C360PendingSubmission

- (NSError *)lastSubmissionAsError;
- (BOOL)prepareForSubmission:(NSError **)outError;
- (void)submitToClient:(C360APIClient *)apiClient completion:(void(^)(void))completion;
- (void)submitToClient:(C360APIClient *)apiClient submissionBlock:(void(^)(C360SuccessHandler successHandler, C360FailureHandler failureHandler))submissionBlock completion:(void (^)(void))completion;

+ (NSArray *)sortDescriptors;

@end
