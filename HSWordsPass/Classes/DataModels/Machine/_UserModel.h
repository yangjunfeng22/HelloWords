// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to UserModel.h instead.

#import <CoreData/CoreData.h>


extern const struct UserModelAttributes {
	__unsafe_unretained NSString *canMove;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *enabled;
	__unsafe_unretained NSString *laterLogin;
	__unsafe_unretained NSString *level;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *logined;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *nick;
	__unsafe_unretained NSString *picture;
	__unsafe_unretained NSString *userID;
} UserModelAttributes;

extern const struct UserModelRelationships {
} UserModelRelationships;

extern const struct UserModelFetchedProperties {
} UserModelFetchedProperties;














@interface UserModelID : NSManagedObjectID {}
@end

@interface _UserModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserModelID*)objectID;





@property (nonatomic, strong) NSNumber* canMove;



@property BOOL canMoveValue;
- (BOOL)canMoveValue;
- (void)setCanMoveValue:(BOOL)value_;

//- (BOOL)validateCanMove:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* enabled;



@property BOOL enabledValue;
- (BOOL)enabledValue;
- (void)setEnabledValue:(BOOL)value_;

//- (BOOL)validateEnabled:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* laterLogin;



@property int32_t laterLoginValue;
- (int32_t)laterLoginValue;
- (void)setLaterLoginValue:(int32_t)value_;

//- (BOOL)validateLaterLogin:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* level;



//- (BOOL)validateLevel:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* location;



//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* logined;



@property BOOL loginedValue;
- (BOOL)loginedValue;
- (void)setLoginedValue:(BOOL)value_;

//- (BOOL)validateLogined:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* nick;



//- (BOOL)validateNick:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* picture;



//- (BOOL)validatePicture:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* userID;



//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;






@end

@interface _UserModel (CoreDataGeneratedAccessors)

@end

@interface _UserModel (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCanMove;
- (void)setPrimitiveCanMove:(NSNumber*)value;

- (BOOL)primitiveCanMoveValue;
- (void)setPrimitiveCanMoveValue:(BOOL)value_;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSNumber*)primitiveEnabled;
- (void)setPrimitiveEnabled:(NSNumber*)value;

- (BOOL)primitiveEnabledValue;
- (void)setPrimitiveEnabledValue:(BOOL)value_;




- (NSNumber*)primitiveLaterLogin;
- (void)setPrimitiveLaterLogin:(NSNumber*)value;

- (int32_t)primitiveLaterLoginValue;
- (void)setPrimitiveLaterLoginValue:(int32_t)value_;




- (NSString*)primitiveLevel;
- (void)setPrimitiveLevel:(NSString*)value;




- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;




- (NSNumber*)primitiveLogined;
- (void)setPrimitiveLogined:(NSNumber*)value;

- (BOOL)primitiveLoginedValue;
- (void)setPrimitiveLoginedValue:(BOOL)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveNick;
- (void)setPrimitiveNick:(NSString*)value;




- (NSString*)primitivePicture;
- (void)setPrimitivePicture:(NSString*)value;




- (NSString*)primitiveUserID;
- (void)setPrimitiveUserID:(NSString*)value;




@end
