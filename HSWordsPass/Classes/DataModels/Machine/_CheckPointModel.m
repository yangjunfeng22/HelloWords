// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CheckPointModel.m instead.

#import "_CheckPointModel.h"

const struct CheckPointModelAttributes CheckPointModelAttributes = {
	.bID = @"bID",
	.cpID = @"cpID",
	.index = @"index",
	.name = @"name",
};

const struct CheckPointModelRelationships CheckPointModelRelationships = {
};

const struct CheckPointModelFetchedProperties CheckPointModelFetchedProperties = {
};

@implementation CheckPointModelID
@end

@implementation _CheckPointModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CheckPointModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CheckPointModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CheckPointModel" inManagedObjectContext:moc_];
}

- (CheckPointModelID*)objectID {
	return (CheckPointModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic bID;






@dynamic cpID;






@dynamic index;



- (int32_t)indexValue {
	NSNumber *result = [self index];
	return [result intValue];
}

- (void)setIndexValue:(int32_t)value_ {
	[self setIndex:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result intValue];
}

- (void)setPrimitiveIndexValue:(int32_t)value_ {
	[self setPrimitiveIndex:[NSNumber numberWithInt:value_]];
}





@dynamic name;











@end
