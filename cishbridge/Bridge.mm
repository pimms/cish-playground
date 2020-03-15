#import <Foundation/Foundation.h>
#import "Bridge.h"

#include <vm/VirtualMachine.h>
#include <vm/ExecutionContext.h>
#include <ast/AstBuilder.h>
#include <ast/Ast.h>
#include <ast/AntlrContext.h>

#include "module/stdio/stdioModule.h"
#include "module/stdlib/stdlibModule.h"
#include "module/string/stringModule.h"

#include "StdoutHook.h"

@interface Bridge()
- (void)reset;
- (BOOL)buildAst:(NSString*)programSource;
- (cish::module::ModuleContext::Ptr)createModuleContext;
- (void)createVirtualMachine;
- (int)execute;
@end

@implementation Bridge {
    cish::vm::VmOptions vmOptions;
    cish::ast::Ast::Ptr ast;
    cish::vm::VirtualMachine *vm;
    StdoutHook *stdoutHook;
}


// MARK: - Public methods

- (id)initWithHeapSize:(unsigned int)heapSize arguments:(NSArray<NSString*>*)args {
    self = [super init];
    if (self) {
        [self reset];

        vmOptions.heapSize = heapSize;
        vmOptions.minAllocSize = 4;

        for (int i=0; i<args.count; i++) {
            NSString *arg = args[i];
            const char *cstr = [arg cStringUsingEncoding: NSASCIIStringEncoding];
            std::string cppstr(cstr);
            vmOptions.args.push_back(cppstr);
        }
    }

    return self;
}

- (int)executeProgram:(NSString*)programSource {
    [self reset];

    if (![self buildAst:programSource]) {
        return -1349;
    }

    [self createVirtualMachine];
    return [self execute];
}

// MARK: - Private methods

- (void)reset {
    ast = nullptr;

    if (vm != nullptr) {
        delete vm;
        vm = nullptr;
    }

    if (stdoutHook != nullptr) {
        delete stdoutHook;
        stdoutHook = nullptr;
    }
}

- (BOOL)buildAst:(NSString*)programSource {
    const char *cstr = [programSource cStringUsingEncoding: NSUTF8StringEncoding];
    std::string cppstr(cstr);

    cish::module::ModuleContext::Ptr moduleContext = [self createModuleContext];
    cish::ast::ParseContext::Ptr parseContext = cish::ast::ParseContext::parseSource(cppstr);
    cish::ast::AstBuilder builder(parseContext, std::move(moduleContext));

    try {
        ast = builder.buildAst();
        return YES;
    } catch (cish::Exception e) {
        std::cerr << e.userMessage() << std::endl;
    } catch (std::exception e) {
        std::cerr << e.what() << std::endl;
    } catch (...) {
        std::cerr << "unknown failure" << std::endl;
    }
    return NO;
}

- (cish::module::ModuleContext::Ptr)createModuleContext {
    cish::module::ModuleContext::Ptr moduleContext = cish::module::ModuleContext::create();
    moduleContext->addModule(cish::module::stdlib::buildModule());
    moduleContext->addModule(cish::module::stdio::buildModule());
    moduleContext->addModule(cish::module::string::buildModule());

    // Bools are natively handled in cish, so add an empty module for compat
    cish::module::Module::Ptr stdbool = cish::module::Module::create("stdbool.h");
    moduleContext->addModule(stdbool);

    return moduleContext;
}

- (void)createVirtualMachine {
    vm = new cish::vm::VirtualMachine(vmOptions, ast);

    stdoutHook = new StdoutHook();
    stdoutHook->setOutputCallback([self](const std::string &str) {
        const char *cstr = str.c_str();
        NSLog(@"stdout: %s\n", cstr);
    });
    vm->getExecutionContext()->setStdout(stdoutHook);
}

- (int)execute {
    vm->executeBlocking();

    auto err = vm->getRuntimeError();
    if (err != nullptr) {
        std::cerr << err->userMessage() << std::endl;
        return -1349;
    }

    return vm->getExitCode();
}

@end
