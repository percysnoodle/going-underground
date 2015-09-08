// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to C360DogCreationSubmission.h instead.

#import <CoreData/CoreData.h>
#import "C360PendingSubmission.h"

extern const struct C360DogCreationSubmissionAttributes {
} C360DogCreationSubmissionAttributes;

extern const struct C360DogCreationSubmissionRelationships {
	__unsafe_unretained NSString *dog;
} C360DogCreationSubmissionRelationships;

extern const struct C360DogCreationSubmissionFetchedProperties {
} C360DogCreationSubmissionFetchedProperties;

@class C360Dog;


@interface C360DogCreationSubmissionID : NSManagedObjectID {}
@end

@interface _C360DogCreationSubmission : C360PendingSubmission {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (C360DogCreationSubmissionID*)objectID;





@property (nonatomic, strong) C360Dog *dog;

//- (BOOL)validateDog:(id*)value_ error:(NSError**)error_;





@end

@interface _C360DogCreationSubmission (CoreDataGeneratedAccessors)

@end

@interface _C360DogCreationSubmission (CoreDataGeneratedPrimitiveAccessors)



- (C360Dog*)primitiveDog;
- (void)setPrimitiveDog:(C360Dog*)value;


@end
