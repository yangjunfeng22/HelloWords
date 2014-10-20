// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SentenceTranslationModel.m instead.

#import "_SentenceTranslationModel.h"

const struct SentenceTranslationModelAttributes SentenceTranslationModelAttributes = {
	.chinese = @"chinese",
	.language = @"language",
	.sID = @"sID",
	.tID = @"tID",
};

const struct SentenceTranslationModelRelationships SentenceTranslationModelRelationships = {
};

const struct SentenceTranslationModelFetchedProperties SentenceTranslationModelFetchedProperties = {
};

@implementation SentenceTranslationModelID
@end

@implementation _SentenceTranslationModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SentenceTranslationModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SentenceTranslationModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SentenceTranslationModel" inManagedObjectContext:moc_];
}

- (SentenceTranslationModelID*)objectID {
	return (SentenceTranslationModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic chinese;






@dynamic language;






@dynamic sID;






@dynamic tID;











@end
