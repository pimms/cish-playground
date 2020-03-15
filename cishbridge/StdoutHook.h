#ifndef StdoutStream_h
#define StdoutStream_h

#include <vm/IStream.h>
#include <functional>

typedef std::function<void(const std::string&)> StdoutCallback;

class StdoutHook: public cish::vm::IStream {
public:
    StdoutHook();
    ~StdoutHook();

    void write(const std::string &str) override;
    void setOutputCallback(StdoutCallback callback);

private:
    StdoutCallback _callback;
};

#endif /* StdoutStream_h */
