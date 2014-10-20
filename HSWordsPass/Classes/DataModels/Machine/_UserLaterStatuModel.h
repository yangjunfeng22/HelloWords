// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to UserLaterStatuModel.h instead.

#import <CoreData/CoreData.h>


extern const struct UserLaterStatuModelAttributes {
	__unsafe_unretained NSString *bookID;
	__unsafe_unretained NSString *categoryID;
	__unsafe_unretained NSString *checkPointID;
	__unsafe_unretained NSString *nexCheckPointID;
	__unsafe_unretained NSString *timeStamp;
	__unsafe_unretained NSString *userID;
} UserLaterStatuModelAttributes;

extern const struct UserLaterStatuModelRelationships {
} UserLaterStatuModelRelationships;

extern const struct UserLaterStatuModelFetchedProperties {
} UserLaterStatuModelFetchedProperties;









@interface UserLaterStatuModelID : NSManagedObjectID {}
@end

@interface _UserLaterStatuModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserLaterStatuModelID*)objectID;





@property (nonatomic, strong) NSString* bookID;



//- (BOOL)validateBookID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* categoryID;



//- (BOOL)validateCategoryID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* checkPointID;



//- (BOOL)validateCheckPointID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* nexCheckPointID;



//- (BOOL)validateNexCheckPointID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* timeStamp;



@property float timeStampValue;
- (float)timeStampValue;
- (void)setTimeStampValue:(float)value_;

//- (BOOL)validateTimeStamp:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* userID;



//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;






@end

@interface _UserLaterStatuModel (CoreDataGeneratedAccessors)

@end

@interface _UserLaterStatuModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBookID;
- (void)setPrimitiveBookID:(NSString*)value;




- (NSString*)primitiveCategoryID;
- (void)setPrimitiveCategoryID:(NSString*)value;




- (NSString*)primitiveCheckPointID;
- (void)setPrimitiveCheckPointID:(NSString*)value;




- (NSString*)primitiveNexCheckPointID;
- (void)setPrimitiveNexCheckPointID:(NSString*)value;




- (NSNumber*)primitiveTimeStamp;
- (void)setPrimitiveTimeStamp:(NSNumber*)value;

- (float)primitiveTimeStampValue;
- (void)setPrimitiveTimeStampValue:(float)value_;




- (NSString*)primitiveUserID;
- (void)setPrimitiveUserID:(NSString*)value;




@end
