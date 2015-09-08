// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to C360Breed.h instead.

#import <CoreData/CoreData.h>


extern const struct C360BreedAttributes {
	__unsafe_unretained NSString *breedId;
	__unsafe_unretained NSString *isFullObject;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *size;
} C360BreedAttributes;

extern const struct C360BreedRelationships {
	__unsafe_unretained NSString *dogs;
} C360BreedRelationships;

extern const struct C360BreedFetchedProperties {
} C360BreedFetchedProperties;

@class C360Dog;






@interface C360BreedID : NSManagedObjectID {}
@end

@interface _C360Breed : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (C360BreedID*)objectID;





@property (nonatomic, strong) NSNumber* breedId;



@property int64_t breedIdValue;
- (int64_t)breedIdValue;
- (void)setBreedIdValue:(int64_t)value_;

//- (BOOL)validateBreedId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isFullObject;



@property BOOL isFullObjectValue;
- (BOOL)isFullObjectValue;
- (void)setIsFullObjectValue:(BOOL)value_;

//- (BOOL)validateIsFullObject:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* size;



//- (BOOL)validateSize:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *dogs;

- (NSMutableSet*)dogsSet;





@end

@interface _C360Breed (CoreDataGeneratedAccessors)

- (void)addDogs:(NSSet*)value_;
- (void)removeDogs:(NSSet*)value_;
- (void)addDogsObject:(C360Dog*)value_;
- (void)removeDogsObject:(C360Dog*)value_;

@end

@interface _C360Breed (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveBreedId;
- (void)setPrimitiveBreedId:(NSNumber*)value;

- (int64_t)primitiveBreedIdValue;
- (void)setPrimitiveBreedIdValue:(int64_t)value_;




- (NSNumber*)primitiveIsFullObject;
- (void)setPrimitiveIsFullObject:(NSNumber*)value;

- (BOOL)primitiveIsFullObjectValue;
- (void)setPrimitiveIsFullObjectValue:(BOOL)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveSize;
- (void)setPrimitiveSize:(NSString*)value;





- (NSMutableSet*)primitiveDogs;
- (void)setPrimitiveDogs:(NSMutableSet*)value;


@end
