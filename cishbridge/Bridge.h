#ifndef Bridge_h
#define Bridge_h

#import <Foundation/Foundation.h>
#import "CishModule.h"

NS_ASSUME_NONNULL_BEGIN

@class Bridge;

@protocol BridgeDelegate
- (void)bridge:(Bridge*)bridge stdoutWasAppended:(NSString*)string;
@end

@interface Bridge: NSObject
@property (nonatomic, weak) id<BridgeDelegate> delegate;
- (id)initWithHeapSize:(unsigned int)heapSize arguments:(NSArray<NSString*>*)args;
- (int)executeProgram:(NSString*)programSource;
- (NSArray<CishModule*>*)cishModules;
@end

NS_ASSUME_NONNULL_END

#endif
