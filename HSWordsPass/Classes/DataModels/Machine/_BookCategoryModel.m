// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookCategoryModel.m instead.

#import "_BookCategoryModel.h"

const struct BookCategoryModelAttributes BookCategoryModelAttributes = {
	.cID = @"cID",
	.name = @"name",
	.picture = @"picture",
	.weight = @"weight",
};

const struct BookCategoryModelRelationships BookCategoryModelRelationships = {
};

const struct BookCategoryModelFetchedProperties BookCategoryModelFetchedProperties = {
};

@implementation BookCategoryModelID
@end

@implementation _BookCategoryModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BookCategoryModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BookCategoryModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BookCategoryModel" inManagedObjectContext:moc_];
}

- (BookCategoryModelID*)objectID {
	return (BookCategoryModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"weightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"weight"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic cID;






@dynamic name;






@dynamic picture;






@dynamic weight;



- (int32_t)weightValue {
	NSNumber *result = [self weight];
	return [result intValue];
}

- (void)setWeightValue:(int32_t)value_ {
	[self setWeight:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveWeightValue {
	NSNumber *result = [self primitiveWeight];
	return [result intValue];
}

- (void)setPrimitiveWeightValue:(int32_t)value_ {
	[self setPrimitiveWeight:[NSNumber numberWithInt:value_]];
}










@end
