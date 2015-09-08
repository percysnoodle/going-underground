// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to C360DogCreationSubmission.m instead.

#import "_C360DogCreationSubmission.h"

const struct C360DogCreationSubmissionAttributes C360DogCreationSubmissionAttributes = {
};

const struct C360DogCreationSubmissionRelationships C360DogCreationSubmissionRelationships = {
	.dog = @"dog",
};

const struct C360DogCreationSubmissionFetchedProperties C360DogCreationSubmissionFetchedProperties = {
};

@implementation C360DogCreationSubmissionID
@end

@implementation _C360DogCreationSubmission

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DogCreationSubmission" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DogCreationSubmission";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DogCreationSubmission" inManagedObjectContext:moc_];
}

- (C360DogCreationSubmissionID*)objectID {
	return (C360DogCreationSubmissionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic dog;

	






@end
