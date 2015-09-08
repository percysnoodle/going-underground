// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to C360Breed.m instead.

#import "_C360Breed.h"

const struct C360BreedAttributes C360BreedAttributes = {
	.breedId = @"breedId",
	.isFullObject = @"isFullObject",
	.name = @"name",
	.size = @"size",
};

const struct C360BreedRelationships C360BreedRelationships = {
	.dogs = @"dogs",
};

const struct C360BreedFetchedProperties C360BreedFetchedProperties = {
};

@implementation C360BreedID
@end

@implementation _C360Breed

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Breed" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Breed";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Breed" inManagedObjectContext:moc_];
}

- (C360BreedID*)objectID {
	return (C360BreedID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"breedIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"breedId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isFullObjectValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isFullObject"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic breedId;



- (int64_t)breedIdValue {
	NSNumber *result = [self breedId];
	return [result longLongValue];
}

- (void)setBreedIdValue:(int64_t)value_ {
	[self setBreedId:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveBreedIdValue {
	NSNumber *result = [self primitiveBreedId];
	return [result longLongValue];
}

- (void)setPrimitiveBreedIdValue:(int64_t)value_ {
	[self setPrimitiveBreedId:[NSNumber numberWithLongLong:value_]];
}





@dynamic isFullObject;



- (BOOL)isFullObjectValue {
	NSNumber *result = [self isFullObject];
	return [result boolValue];
}

- (void)setIsFullObjectValue:(BOOL)value_ {
	[self setIsFullObject:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsFullObjectValue {
	NSNumber *result = [self primitiveIsFullObject];
	return [result boolValue];
}

- (void)setPrimitiveIsFullObjectValue:(BOOL)value_ {
	[self setPrimitiveIsFullObject:[NSNumber numberWithBool:value_]];
}





@dynamic name;






@dynamic size;






@dynamic dogs;

	
- (NSMutableSet*)dogsSet {
	[self willAccessValueForKey:@"dogs"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"dogs"];
  
	[self didAccessValueForKey:@"dogs"];
	return result;
}
	






@end
