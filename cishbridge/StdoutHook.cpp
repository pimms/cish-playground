#include "StdoutHook.h"

StdoutHook::StdoutHook():
    _callback([](const std::string &str) { printf("%s", str.c_str()); })
{}

StdoutHook::~StdoutHook()
{

}

void StdoutHook::write(const std::string &str)
{
    _callback(str);
}

void StdoutHook::setOutputCallback(StdoutCallback callback)
{
    _callback = callback;
}
