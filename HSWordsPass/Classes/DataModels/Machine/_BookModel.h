// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookModel.h instead.

#import <CoreData/CoreData.h>


extern const struct BookModelAttributes {
	__unsafe_unretained NSString *bID;
	__unsafe_unretained NSString *cID;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *picture;
	__unsafe_unretained NSString *showTone;
	__unsafe_unretained NSString *version;
	__unsafe_unretained NSString *wCount;
	__unsafe_unretained NSString *weight;
} BookModelAttributes;

extern const struct BookModelRelationships {
} BookModelRelationships;

extern const struct BookModelFetchedProperties {
} BookModelFetchedProperties;











@interface BookModelID : NSManagedObjectID {}
@end

@interface _BookModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BookModelID*)objectID;





@property (nonatomic, strong) NSString* bID;



//- (BOOL)validateBID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* cID;



//- (BOOL)validateCID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* picture;



//- (BOOL)validatePicture:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* showTone;



@property BOOL showToneValue;
- (BOOL)showToneValue;
- (void)setShowToneValue:(BOOL)value_;

//- (BOOL)validateShowTone:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* version;



//- (BOOL)validateVersion:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* wCount;



@property int32_t wCountValue;
- (int32_t)wCountValue;
- (void)setWCountValue:(int32_t)value_;

//- (BOOL)validateWCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* weight;



@property int32_t weightValue;
- (int32_t)weightValue;
- (void)setWeightValue:(int32_t)value_;

//- (BOOL)validateWeight:(id*)value_ error:(NSError**)error_;






@end

@interface _BookModel (CoreDataGeneratedAccessors)

@end

@interface _BookModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBID;
- (void)setPrimitiveBID:(NSString*)value;




- (NSString*)primitiveCID;
- (void)setPrimitiveCID:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitivePicture;
- (void)setPrimitivePicture:(NSString*)value;




- (NSNumber*)primitiveShowTone;
- (void)setPrimitiveShowTone:(NSNumber*)value;

- (BOOL)primitiveShowToneValue;
- (void)setPrimitiveShowToneValue:(BOOL)value_;




- (NSString*)primitiveVersion;
- (void)setPrimitiveVersion:(NSString*)value;




- (NSNumber*)primitiveWCount;
- (void)setPrimitiveWCount:(NSNumber*)value;

- (int32_t)primitiveWCountValue;
- (void)setPrimitiveWCountValue:(int32_t)value_;




- (NSNumber*)primitiveWeight;
- (void)setPrimitiveWeight:(NSNumber*)value;

- (int32_t)primitiveWeightValue;
- (void)setPrimitiveWeightValue:(int32_t)value_;




@end
