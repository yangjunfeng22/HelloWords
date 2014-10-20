// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookCategoryTransModel.m instead.

#import "_BookCategoryTransModel.h"

const struct BookCategoryTransModelAttributes BookCategoryTransModelAttributes = {
	.cID = @"cID",
	.language = @"language",
	.name = @"name",
	.tID = @"tID",
};

const struct BookCategoryTransModelRelationships BookCategoryTransModelRelationships = {
};

const struct BookCategoryTransModelFetchedProperties BookCategoryTransModelFetchedProperties = {
};

@implementation BookCategoryTransModelID
@end

@implementation _BookCategoryTransModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BookCategoryTransModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BookCategoryTransModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BookCategoryTransModel" inManagedObjectContext:moc_];
}

- (BookCategoryTransModelID*)objectID {
	return (BookCategoryTransModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic cID;






@dynamic language;






@dynamic name;






@dynamic tID;











@end
