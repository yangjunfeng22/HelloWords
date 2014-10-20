// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WordTranslationModel.m instead.

#import "_WordTranslationModel.h"

const struct WordTranslationModelAttributes WordTranslationModelAttributes = {
	.chinese = @"chinese",
	.language = @"language",
	.property = @"property",
	.tID = @"tID",
	.wID = @"wID",
};

const struct WordTranslationModelRelationships WordTranslationModelRelationships = {
};

const struct WordTranslationModelFetchedProperties WordTranslationModelFetchedProperties = {
};

@implementation WordTranslationModelID
@end

@implementation _WordTranslationModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WordTranslationModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WordTranslationModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WordTranslationModel" inManagedObjectContext:moc_];
}

- (WordTranslationModelID*)objectID {
	return (WordTranslationModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic chinese;






@dynamic language;






@dynamic property;






@dynamic tID;






@dynamic wID;











@end
