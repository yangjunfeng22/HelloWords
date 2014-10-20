// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookTranslationModel.h instead.

#import <CoreData/CoreData.h>


extern const struct BookTranslationModelAttributes {
	__unsafe_unretained NSString *bID;
	__unsafe_unretained NSString *language;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *tID;
} BookTranslationModelAttributes;

extern const struct BookTranslationModelRelationships {
} BookTranslationModelRelationships;

extern const struct BookTranslationModelFetchedProperties {
} BookTranslationModelFetchedProperties;







@interface BookTranslationModelID : NSManagedObjectID {}
@end

@interface _BookTranslationModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BookTranslationModelID*)objectID;





@property (nonatomic, strong) NSString* bID;



//- (BOOL)validateBID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* language;



//- (BOOL)validateLanguage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tID;



//- (BOOL)validateTID:(id*)value_ error:(NSError**)error_;






@end

@interface _BookTranslationModel (CoreDataGeneratedAccessors)

@end

@interface _BookTranslationModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBID;
- (void)setPrimitiveBID:(NSString*)value;




- (NSString*)primitiveLanguage;
- (void)setPrimitiveLanguage:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveTID;
- (void)setPrimitiveTID:(NSString*)value;




@end
