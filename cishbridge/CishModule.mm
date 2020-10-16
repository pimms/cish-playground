#import <Foundation/Foundation.h>
#import "CishModule.h"
#import "CishModule+privateInit.h"

// MARK: - FunctionParameter

@interface FunctionParameter()
- (id)initWithName:(NSString*)name type:(NSString*)type;
@end

@implementation FunctionParameter
- (id)initWithName:(NSString*)name type:(NSString*)type {
    if (self = [super init]) {
        _name = name;
        _type = type;
    }

    return self;
}
@end

// MARK: - CishFunction

@interface CishFunction()
- (id)initFromFunction:(cish::module::Function::Ptr)function;
@end

@implementation CishFunction
- (id)initFromFunction:(cish::module::Function::Ptr)function {
    if (self = [super init]) {
        auto decl = function->getDeclaration();
        _returnType = [[NSString alloc] initWithCString:decl->returnType.getName() encoding:NSUTF8StringEncoding];
        _name = [[NSString alloc] initWithCString:decl->name.c_str() encoding:NSUTF8StringEncoding];

        NSMutableArray* params = [[NSMutableArray alloc] init];
        for (auto rawParam: decl->params) {
            NSString* name = [[NSString alloc] initWithCString:rawParam.name.c_str() encoding:NSUTF8StringEncoding];
            NSString* type = [[NSString alloc] initWithCString:rawParam.type.getName() encoding:NSUTF8StringEncoding];
            FunctionParameter* param = [[FunctionParameter alloc] initWithName:name type:type];
            [params addObject:param];
        }
        _parameters = params;
    }

    return self;
}
@end

// MARK: - CishModule

@implementation CishModule

- (id)initFromModule:(cish::module::Module::Ptr)module {
    if (self = [super init]) {
        _name = [NSString stringWithCString:module->getName().c_str() encoding:NSUTF8StringEncoding];

        NSMutableArray* functions = [[NSMutableArray alloc] init];
        for (auto rawFunction: module->getFunctions()) {
            CishFunction *function = [[CishFunction alloc] initFromFunction: rawFunction];
            [functions addObject:function];
        }

        _functions = functions;
    }
    return self;
}

@end
