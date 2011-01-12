//
//  FFTLogging.h
//  FringeTools
//
//  Created by John Sheets on 9/25/10.
//  Copyright 2010 MobileMethod, LLC. All rights reserved.
//
// MIT License
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#ifdef VERBOSE_LOG_STATEMENTS
#define _FFT_LOG(log_type, ...) NSLog(@"[%@] %s (line:%d)\n --> %@", log_type, __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define _FFT_LOG(log_type, ...) CFShow([NSString stringWithFormat: \
  @"[%@] %s (line:%d) --> %@", log_type, __PRETTY_FUNCTION__, __LINE__, \
    [NSString stringWithFormat:__VA_ARGS__]])
#endif

#ifdef FFT_LOG_ALL
#define FFT_LOG_ERROR
#define FFT_LOG_CRITICAL
#define FFT_LOG_INFO
#define FFT_LOG_DEBUG
#endif

#ifdef FFT_LOG_DEFAULT
#define FFT_LOG_ERROR
#define FFT_LOG_CRITICAL
#endif

#ifdef FFT_LOG_ERROR
#define FFTError(...) _FFT_LOG(@"ERROR", __VA_ARGS__)
#else
#define FFTError(...)
#endif

#ifdef FFT_LOG_CRITICAL
#define FFTCritical(...) _FFT_LOG(@"CRITICAL", __VA_ARGS__)
#else
#define FFTCritical(...)
#endif

#ifdef FFT_LOG_INFO
#define FFTInfo(...) _FFT_LOG(@"INFO", __VA_ARGS__)
#else
#define FFTInfo(...)
#endif

#ifdef FFT_LOG_DEBUG
#define FFTDebug(...) _FFT_LOG(@"DEBUG", __VA_ARGS__)
#else
#define FFTDebug(...)
#endif

#ifdef FFT_LOG_TRACE
#define FFTTrace(...) _FFT_LOG(@"TRACE", __VA_ARGS__)
#else
#define FFTTrace(...)
#endif
