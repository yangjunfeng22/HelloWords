// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookTranslationModel.m instead.

#import "_BookTranslationModel.h"

const struct BookTranslationModelAttributes BookTranslationModelAttributes = {
	.bID = @"bID",
	.language = @"language",
	.name = @"name",
	.tID = @"tID",
};

const struct BookTranslationModelRelationships BookTranslationModelRelationships = {
};

const struct BookTranslationModelFetchedProperties BookTranslationModelFetchedProperties = {
};

@implementation BookTranslationModelID
@end

@implementation _BookTranslationModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BookTranslationModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BookTranslationModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BookTranslationModel" inManagedObjectContext:moc_];
}

- (BookTranslationModelID*)objectID {
	return (BookTranslationModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic bID;






@dynamic language;






@dynamic name;






@dynamic tID;











@end
