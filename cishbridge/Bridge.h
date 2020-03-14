#ifndef Bridge_h
#define Bridge_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Bridge: NSObject
- (id)initWithHeapSize:(unsigned int)heapSize arguments:(NSArray<NSString*>*)args;
- (int)executeProgram:(NSString*)programSource;
@end

NS_ASSUME_NONNULL_END

#endif
