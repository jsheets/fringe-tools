/*
 *  FFTLogging.h
 *  FringeTools
 *
 *  Created by John Sheets on 9/25/10.
 *  Copyright 2010 MobileMethod, LLC. All rights reserved.
 *
 */

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
