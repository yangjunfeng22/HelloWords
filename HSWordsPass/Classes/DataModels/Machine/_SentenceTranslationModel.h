// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SentenceTranslationModel.h instead.

#import <CoreData/CoreData.h>


extern const struct SentenceTranslationModelAttributes {
	__unsafe_unretained NSString *chinese;
	__unsafe_unretained NSString *language;
	__unsafe_unretained NSString *sID;
	__unsafe_unretained NSString *tID;
} SentenceTranslationModelAttributes;

extern const struct SentenceTranslationModelRelationships {
} SentenceTranslationModelRelationships;

extern const struct SentenceTranslationModelFetchedProperties {
} SentenceTranslationModelFetchedProperties;







@interface SentenceTranslationModelID : NSManagedObjectID {}
@end

@interface _SentenceTranslationModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SentenceTranslationModelID*)objectID;





@property (nonatomic, strong) NSString* chinese;



//- (BOOL)validateChinese:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* language;



//- (BOOL)validateLanguage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sID;



//- (BOOL)validateSID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tID;



//- (BOOL)validateTID:(id*)value_ error:(NSError**)error_;






@end

@interface _SentenceTranslationModel (CoreDataGeneratedAccessors)

@end

@interface _SentenceTranslationModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveChinese;
- (void)setPrimitiveChinese:(NSString*)value;




- (NSString*)primitiveLanguage;
- (void)setPrimitiveLanguage:(NSString*)value;




- (NSString*)primitiveSID;
- (void)setPrimitiveSID:(NSString*)value;




- (NSString*)primitiveTID;
- (void)setPrimitiveTID:(NSString*)value;




@end
