// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WordTranslationModel.h instead.

#import <CoreData/CoreData.h>


extern const struct WordTranslationModelAttributes {
	__unsafe_unretained NSString *chinese;
	__unsafe_unretained NSString *language;
	__unsafe_unretained NSString *property;
	__unsafe_unretained NSString *tID;
	__unsafe_unretained NSString *wID;
} WordTranslationModelAttributes;

extern const struct WordTranslationModelRelationships {
} WordTranslationModelRelationships;

extern const struct WordTranslationModelFetchedProperties {
} WordTranslationModelFetchedProperties;








@interface WordTranslationModelID : NSManagedObjectID {}
@end

@interface _WordTranslationModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WordTranslationModelID*)objectID;





@property (nonatomic, strong) NSString* chinese;



//- (BOOL)validateChinese:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* language;



//- (BOOL)validateLanguage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* property;



//- (BOOL)validateProperty:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tID;



//- (BOOL)validateTID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* wID;



//- (BOOL)validateWID:(id*)value_ error:(NSError**)error_;






@end

@interface _WordTranslationModel (CoreDataGeneratedAccessors)

@end

@interface _WordTranslationModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveChinese;
- (void)setPrimitiveChinese:(NSString*)value;




- (NSString*)primitiveLanguage;
- (void)setPrimitiveLanguage:(NSString*)value;




- (NSString*)primitiveProperty;
- (void)setPrimitiveProperty:(NSString*)value;




- (NSString*)primitiveTID;
- (void)setPrimitiveTID:(NSString*)value;




- (NSString*)primitiveWID;
- (void)setPrimitiveWID:(NSString*)value;




@end
