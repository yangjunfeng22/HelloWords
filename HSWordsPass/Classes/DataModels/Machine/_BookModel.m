// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookModel.m instead.

#import "_BookModel.h"

const struct BookModelAttributes BookModelAttributes = {
	.bID = @"bID",
	.cID = @"cID",
	.name = @"name",
	.picture = @"picture",
	.showTone = @"showTone",
	.version = @"version",
	.wCount = @"wCount",
	.weight = @"weight",
};

const struct BookModelRelationships BookModelRelationships = {
};

const struct BookModelFetchedProperties BookModelFetchedProperties = {
};

@implementation BookModelID
@end

@implementation _BookModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BookModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BookModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BookModel" inManagedObjectContext:moc_];
}

- (BookModelID*)objectID {
	return (BookModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"showToneValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"showTone"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"wCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"wCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"weightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"weight"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic bID;






@dynamic cID;






@dynamic name;






@dynamic picture;






@dynamic showTone;



- (BOOL)showToneValue {
	NSNumber *result = [self showTone];
	return [result boolValue];
}

- (void)setShowToneValue:(BOOL)value_ {
	[self setShowTone:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveShowToneValue {
	NSNumber *result = [self primitiveShowTone];
	return [result boolValue];
}

- (void)setPrimitiveShowToneValue:(BOOL)value_ {
	[self setPrimitiveShowTone:[NSNumber numberWithBool:value_]];
}





@dynamic version;






@dynamic wCount;



- (int32_t)wCountValue {
	NSNumber *result = [self wCount];
	return [result intValue];
}

- (void)setWCountValue:(int32_t)value_ {
	[self setWCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveWCountValue {
	NSNumber *result = [self primitiveWCount];
	return [result intValue];
}

- (void)setPrimitiveWCountValue:(int32_t)value_ {
	[self setPrimitiveWCount:[NSNumber numberWithInt:value_]];
}





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
