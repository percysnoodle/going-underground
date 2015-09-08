// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to C360Dog.h instead.

#import <CoreData/CoreData.h>


extern const struct C360DogAttributes {
	__unsafe_unretained NSString *breedId;
	__unsafe_unretained NSString *breedName;
	__unsafe_unretained NSString *dogId;
	__unsafe_unretained NSString *isFullObject;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *numberOfBottomsSniffed;
	__unsafe_unretained NSString *numberOfCatsChased;
	__unsafe_unretained NSString *numberOfFacesLicked;
} C360DogAttributes;

extern const struct C360DogRelationships {
	__unsafe_unretained NSString *breed;
	__unsafe_unretained NSString *pendingCreationSubmission;
	__unsafe_unretained NSString *pendingDeletionSubmission;
	__unsafe_unretained NSString *pendingUpdateSubmission;
} C360DogRelationships;

extern const struct C360DogFetchedProperties {
} C360DogFetchedProperties;

@class C360Breed;
@class C360DogCreationSubmission;
@class C360DogDeletionSubmission;
@class C360DogUpdateSubmission;










@interface C360DogID : NSManagedObjectID {}
@end

@interface _C360Dog : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (C360DogID*)objectID;





@property (nonatomic, strong) NSNumber* breedId;



@property int64_t breedIdValue;
- (int64_t)breedIdValue;
- (void)setBreedIdValue:(int64_t)value_;

//- (BOOL)validateBreedId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* breedName;



//- (BOOL)validateBreedName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* dogId;



@property int64_t dogIdValue;
- (int64_t)dogIdValue;
- (void)setDogIdValue:(int64_t)value_;

//- (BOOL)validateDogId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isFullObject;



@property BOOL isFullObjectValue;
- (BOOL)isFullObjectValue;
- (void)setIsFullObjectValue:(BOOL)value_;

//- (BOOL)validateIsFullObject:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) C360Breed *breed;

//- (BOOL)validateBreed:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) C360DogCreationSubmission *pendingCreationSubmission;

//- (BOOL)validatePendingCreationSubmission:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) C360DogDeletionSubmission *pendingDeletionSubmission;

//- (BOOL)validatePendingDeletionSubmission:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) C360DogUpdateSubmission *pendingUpdateSubmission;

//- (BOOL)validatePendingUpdateSubmission:(id*)value_ error:(NSError**)error_;





@end

@interface _C360Dog (CoreDataGeneratedAccessors)

@end

@interface _C360Dog (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveBreedId;
- (void)setPrimitiveBreedId:(NSNumber*)value;

- (int64_t)primitiveBreedIdValue;
- (void)setPrimitiveBreedIdValue:(int64_t)value_;




- (NSString*)primitiveBreedName;
- (void)setPrimitiveBreedName:(NSString*)value;




- (NSNumber*)primitiveDogId;
- (void)setPrimitiveDogId:(NSNumber*)value;

- (int64_t)primitiveDogIdValue;
- (void)setPrimitiveDogIdValue:(int64_t)value_;




- (NSNumber*)primitiveIsFullObject;
- (void)setPrimitiveIsFullObject:(NSNumber*)value;

- (BOOL)primitiveIsFullObjectValue;
- (void)setPrimitiveIsFullObjectValue:(BOOL)value_;




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





- (C360Breed*)primitiveBreed;
- (void)setPrimitiveBreed:(C360Breed*)value;



- (C360DogCreationSubmission*)primitivePendingCreationSubmission;
- (void)setPrimitivePendingCreationSubmission:(C360DogCreationSubmission*)value;



- (C360DogDeletionSubmission*)primitivePendingDeletionSubmission;
- (void)setPrimitivePendingDeletionSubmission:(C360DogDeletionSubmission*)value;



- (C360DogUpdateSubmission*)primitivePendingUpdateSubmission;
- (void)setPrimitivePendingUpdateSubmission:(C360DogUpdateSubmission*)value;


@end
