// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to C360DogDeletionSubmission.h instead.

#import <CoreData/CoreData.h>
#import "C360PendingSubmission.h"

extern const struct C360DogDeletionSubmissionAttributes {
} C360DogDeletionSubmissionAttributes;

extern const struct C360DogDeletionSubmissionRelationships {
	__unsafe_unretained NSString *dog;
} C360DogDeletionSubmissionRelationships;

extern const struct C360DogDeletionSubmissionFetchedProperties {
} C360DogDeletionSubmissionFetchedProperties;

@class C360Dog;


@interface C360DogDeletionSubmissionID : NSManagedObjectID {}
@end

@interface _C360DogDeletionSubmission : C360PendingSubmission {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (C360DogDeletionSubmissionID*)objectID;





@property (nonatomic, strong) C360Dog *dog;

//- (BOOL)validateDog:(id*)value_ error:(NSError**)error_;





@end

@interface _C360DogDeletionSubmission (CoreDataGeneratedAccessors)

@end

@interface _C360DogDeletionSubmission (CoreDataGeneratedPrimitiveAccessors)



- (C360Dog*)primitiveDog;
- (void)setPrimitiveDog:(C360Dog*)value;


@end
