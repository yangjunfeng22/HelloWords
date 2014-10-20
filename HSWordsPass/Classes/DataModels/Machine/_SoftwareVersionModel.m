// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SoftwareVersionModel.m instead.

#import "_SoftwareVersionModel.h"

const struct SoftwareVersionModelAttributes SoftwareVersionModelAttributes = {
	.dbVersion = @"dbVersion",
	.launched = @"launched",
	.version = @"version",
};

const struct SoftwareVersionModelRelationships SoftwareVersionModelRelationships = {
};

const struct SoftwareVersionModelFetchedProperties SoftwareVersionModelFetchedProperties = {
};

@implementation SoftwareVersionModelID
@end

@implementation _SoftwareVersionModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SoftwareVersionModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SoftwareVersionModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SoftwareVersionModel" inManagedObjectContext:moc_];
}

- (SoftwareVersionModelID*)objectID {
	return (SoftwareVersionModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"launchedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"launched"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic dbVersion;






@dynamic launched;



- (BOOL)launchedValue {
	NSNumber *result = [self launched];
	return [result boolValue];
}

- (void)setLaunchedValue:(BOOL)value_ {
	[self setLaunched:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveLaunchedValue {
	NSNumber *result = [self primitiveLaunched];
	return [result boolValue];
}

- (void)setPrimitiveLaunchedValue:(BOOL)value_ {
	[self setPrimitiveLaunched:[NSNumber numberWithBool:value_]];
}





@dynamic version;











@end
