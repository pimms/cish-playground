#ifndef CishModule_privateInit_h
#define CishModule_privateInit_h

#import "CishModule.h"

#include <module/ModuleContext.h>
#include <module/Module.h>
#include <module/Function.h>

@interface CishModule()
- (id)initFromModule:(cish::module::Module::Ptr)module;
@end

#endif
