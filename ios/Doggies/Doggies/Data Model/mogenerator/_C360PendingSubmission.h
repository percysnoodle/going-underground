// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to C360PendingSubmission.h instead.

#import <CoreData/CoreData.h>


extern const struct C360PendingSubmissionAttributes {
	__unsafe_unretained NSString *createdAtTimestamp;
	__unsafe_unretained NSString *isUnrecoverable;
	__unsafe_unretained NSString *lastSubmissionLocalizedDescription;
	__unsafe_unretained NSString *lastSubmissionTimestamp;
	__unsafe_unretained NSString *numberOfErrors;
} C360PendingSubmissionAttributes;

extern const struct C360PendingSubmissionRelationships {
} C360PendingSubmissionRelationships;

extern const struct C360PendingSubmissionFetchedProperties {
} C360PendingSubmissionFetchedProperties;








@interface C360PendingSubmissionID : NSManagedObjectID {}
@end

@interface _C360PendingSubmission : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (C360PendingSubmissionID*)objectID;





@property (nonatomic, strong) NSNumber* createdAtTimestamp;



@property double createdAtTimestampValue;
- (double)createdAtTimestampValue;
- (void)setCreatedAtTimestampValue:(double)value_;

//- (BOOL)validateCreatedAtTimestamp:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isUnrecoverable;



@property BOOL isUnrecoverableValue;
- (BOOL)isUnrecoverableValue;
- (void)setIsUnrecoverableValue:(BOOL)value_;

//- (BOOL)validateIsUnrecoverable:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lastSubmissionLocalizedDescription;



//- (BOOL)validateLastSubmissionLocalizedDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lastSubmissionTimestamp;



@property double lastSubmissionTimestampValue;
- (double)lastSubmissionTimestampValue;
- (void)setLastSubmissionTimestampValue:(double)value_;

//- (BOOL)validateLastSubmissionTimestamp:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* numberOfErrors;



@property int16_t numberOfErrorsValue;
- (int16_t)numberOfErrorsValue;
- (void)setNumberOfErrorsValue:(int16_t)value_;

//- (BOOL)validateNumberOfErrors:(id*)value_ error:(NSError**)error_;






@end

@interface _C360PendingSubmission (CoreDataGeneratedAccessors)

@end

@interface _C360PendingSubmission (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCreatedAtTimestamp;
- (void)setPrimitiveCreatedAtTimestamp:(NSNumber*)value;

- (double)primitiveCreatedAtTimestampValue;
- (void)setPrimitiveCreatedAtTimestampValue:(double)value_;




- (NSNumber*)primitiveIsUnrecoverable;
- (void)setPrimitiveIsUnrecoverable:(NSNumber*)value;

- (BOOL)primitiveIsUnrecoverableValue;
- (void)setPrimitiveIsUnrecoverableValue:(BOOL)value_;




- (NSString*)primitiveLastSubmissionLocalizedDescription;
- (void)setPrimitiveLastSubmissionLocalizedDescription:(NSString*)value;




- (NSNumber*)primitiveLastSubmissionTimestamp;
- (void)setPrimitiveLastSubmissionTimestamp:(NSNumber*)value;

- (double)primitiveLastSubmissionTimestampValue;
- (void)setPrimitiveLastSubmissionTimestampValue:(double)value_;




- (NSNumber*)primitiveNumberOfErrors;
- (void)setPrimitiveNumberOfErrors:(NSNumber*)value;

- (int16_t)primitiveNumberOfErrorsValue;
- (void)setPrimitiveNumberOfErrorsValue:(int16_t)value_;




@end
