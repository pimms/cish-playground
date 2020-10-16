#ifndef CishModule_h
#define CishModule_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FunctionParameter: NSObject
@property (readonly) NSString* name;
@property (readonly) NSString* type;
@end

@interface CishFunction: NSObject
@property (readonly) NSString *returnType;
@property (readonly) NSString *name;
@property (readonly) NSArray<FunctionParameter*>* parameters;
@end

@interface CishModule: NSObject
@property (readonly) NSString *name;
@property (readonly) NSArray<CishFunction*>* functions;
@end

NS_ASSUME_NONNULL_END

#endif
