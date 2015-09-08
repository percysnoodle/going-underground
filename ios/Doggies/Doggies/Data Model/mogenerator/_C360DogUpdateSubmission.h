// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to C360DogUpdateSubmission.h instead.

#import <CoreData/CoreData.h>
#import "C360PendingSubmission.h"

extern const struct C360DogUpdateSubmissionAttributes {
	__unsafe_unretained NSString *breedId;
	__unsafe_unretained NSString *breedName;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *numberOfBottomsSniffed;
	__unsafe_unretained NSString *numberOfCatsChased;
	__unsafe_unretained NSString *numberOfFacesLicked;
} C360DogUpdateSubmissionAttributes;

extern const struct C360DogUpdateSubmissionRelationships {
	__unsafe_unretained NSString *dog;
} C360DogUpdateSubmissionRelationships;

extern const struct C360DogUpdateSubmissionFetchedProperties {
} C360DogUpdateSubmissionFetchedProperties;

@class C360Dog;








@interface C360DogUpdateSubmissionID : NSManagedObjectID {}
@end

@interface _C360DogUpdateSubmission : C360PendingSubmission {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (C360DogUpdateSubmissionID*)objectID;





@property (nonatomic, strong) NSNumber* breedId;



@property int64_t breedIdValue;
- (int64_t)breedIdValue;
- (void)setBreedIdValue:(int64_t)value_;

//- (BOOL)validateBreedId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* breedName;



//- (BOOL)validateBreedName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* numberOfBottomsSniffed;



@property int64_t numberOfBottomsSniffedValue;
- (int64_t)numberOfBottomsSniffedValue;
- (void)setNumberOfBottomsSniffedValue:(int64_t)value_;

//- (BOOL)validateNumberOfBottomsSniffed:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* numberOfCatsChased;



@property int64_t numberOfCatsChasedValue;
- (int64_t)numberOfCatsChasedValue;
- (void)setNumberOfCatsChasedValue:(int64_t)value_;

//- (BOOL)validateNumberOfCatsChased:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* numberOfFacesLicked;



@property int64_t numberOfFacesLickedValue;
- (int64_t)numberOfFacesLickedValue;
- (void)setNumberOfFacesLickedValue:(int64_t)value_;

//- (BOOL)validateNumberOfFacesLicked:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) C360Dog *dog;

//- (BOOL)validateDog:(id*)value_ error:(NSError**)error_;





@end

@interface _C360DogUpdateSubmission (CoreDataGeneratedAccessors)

@end

@interface _C360DogUpdateSubmission (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveBreedId;
- (void)setPrimitiveBreedId:(NSNumber*)value;

- (int64_t)primitiveBreedIdValue;
- (void)setPrimitiveBreedIdValue:(int64_t)value_;




- (NSString*)primitiveBreedName;
- (void)setPrimitiveBreedName:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveNumberOfBottomsSniffed;
- (void)setPrimitiveNumberOfBottomsSniffed:(NSNumber*)value;

- (int64_t)primitiveNumberOfBottomsSniffedValue;
- (void)setPrimitiveNumberOfBottomsSniffedValue:(int64_t)value_;




- (NSNumber*)primitiveNumberOfCatsChased;
- (void)setPrimitiveNumberOfCatsChased:(NSNumber*)value;

- (int64_t)primitiveNumberOfCatsChasedValue;
- (void)setPrimitiveNumberOfCatsChasedValue:(int64_t)value_;




- (NSNumber*)primitiveNumberOfFacesLicked;
- (void)setPrimitiveNumberOfFacesLicked:(NSNumber*)value;

- (int64_t)primitiveNumberOfFacesLickedValue;
- (void)setPrimitiveNumberOfFacesLickedValue:(int64_t)value_;





- (C360Dog*)primitiveDog;
- (void)setPrimitiveDog:(C360Dog*)value;


@end
