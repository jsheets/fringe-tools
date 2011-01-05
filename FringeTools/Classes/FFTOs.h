//
//  FFTOs.h
//  FringeTools
//
//  Created by John Sheets on 12/24/10.
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

//
// Assign OS version macros:
//  1 - Supported (new enough)
//  0 - Not Supported (too old)
// -1 - Undefined (e.g. iOS for a Mac SDK)
//

// From Availability.h
//
//#define __MAC_10_0      1000
//#define __MAC_10_1      1010
//#define __MAC_10_2      1020
//#define __MAC_10_3      1030
//#define __MAC_10_4      1040
//#define __MAC_10_5      1050
//#define __MAC_10_6      1060
//#define __MAC_NA        9999   /* not available */

// Define macros for all included Mac OS versions:
//   FFT_MAC_OSX_10_6
//   FFT_MAC_OSX_10_5
//   FFT_MAC_OSX_10_4
#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
#  define FFT_MAC_OSX          1
#  define FFT_OS_NAME @"Mac OS X"

// All FFT_MAC_OSX_* macros default to 0.
#  if MAC_OS_X_VERSION_MIN_REQUIRED >= 1060
#    define FFT_MAC_OSX_10_6   1
#  endif
#  if MAC_OS_X_VERSION_MIN_REQUIRED >= 1050
#    define FFT_MAC_OSX_10_5   1
#  endif
#  if MAC_OS_X_VERSION_MIN_REQUIRED >= 1040
#    define FFT_MAC_OSX_10_4   1
#  endif

// Set all iOS macros to -1 (undefined)
#define FFT_IOS_4_2   -1
#define FFT_IOS_4_1   -1
#define FFT_IOS_4_0   -1
#define FFT_IOS_3_2   -1
#define FFT_IOS_3_1   -1
#define FFT_IOS_3_0   -1

#endif


// From Availability.h
//
//#define __IPHONE_2_0     20000
//#define __IPHONE_2_1     20100
//#define __IPHONE_2_2     20200
//#define __IPHONE_3_0     30000
//#define __IPHONE_3_1     30100
//#define __IPHONE_3_2     30200
//#define __IPHONE_4_0     40000
//#define __IPHONE_4_1     40100
//#define __IPHONE_4_2     40200
//#define __IPHONE_NA      99999  /* not available */

// Define macros for all included iOS versions:
//   FFT_IOS_4_2
//   FFT_IOS_4_1
//   FFT_IOS_4_0
//   FFT_IOS_3_2
//   FFT_IOS_3_1
//   FFT_IOS_3_0
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
#  define FFT_IOS         1
#  define FFT_OS_NAME @"iOS"

// All FFT_IOS_* macros default to 0.
#  if __IPHONE_OS_VERSION_MIN_REQUIRED >= 40200
#    define FFT_IOS_4_2   1
#  endif
#  if __IPHONE_OS_VERSION_MIN_REQUIRED >= 40100
#    define FFT_IOS_4_1   1
#  endif
#  if __IPHONE_OS_VERSION_MIN_REQUIRED >= 40000
#    define FFT_IOS_4_0   1
#  endif
#  if __IPHONE_OS_VERSION_MIN_REQUIRED >= 30200
#    define FFT_IOS_3_2   1
#  endif
#  if __IPHONE_OS_VERSION_MIN_REQUIRED >= 30100
#    define FFT_IOS_3_1   1
#  endif
#  if __IPHONE_OS_VERSION_MIN_REQUIRED >= 30000
#    define FFT_IOS_3_0   1
#  else
// We shouldn't be doing this, should we?
#    error Detected iOS 2.2 or lower
#  endif

// Set all Mac OS X macros to -1 (undefined)
#define FFT_MAC_OSX_10_6   -1
#define FFT_MAC_OSX_10_5   -1
#define FFT_MAC_OSX_10_4   -1

#endif

// Enable to show compile-time warnings for the current architecture
#ifdef FFT_ARCH_CHECK
#  if defined(FFT_MAC_OSX)
#    ifdef FFT_MAC_OSX_10_6
#      warning Mac OS X 10.6
#    elif FFT_MAC_OSX_10_5
#      warning Mac OS X 10.5
#    elif FFT_MAC_OSX_10_4
#      warning Mac OS X 10.4
#    else
#      warning Unknown Mac Architecture
#    endif
#  elif defined(FFT_IOS)
#    ifdef FFT_IOS_4_2
#      warning iOS 4.2
#    elif FFT_IOS_4_1
#      warning iOS 4.1
#    elif FFT_IOS_4_0
#      warning iOS 4.0
#    elif FFT_IOS_3_2
#      warning iOS 3.2
#    elif FFT_IOS_3_1
#      warning iOS 3.1
#    elif FFT_IOS_3_0
#      warning iOS 3.0
#    else
#      warning Unknown iOS Architecture
#    endif
#  else
#     warning Unknown Architecture not Mac or iOS
#  endif
#endif

//
// Functionality detection macros.
//

// NSXMLParserDelegate is present in Mac OS X 10.6+ and iOS 4.0+.
#if (FFT_MAC_OSX_10_6 == 1) || (FFT_IOS_4_0 == 1)
#define HAS_NSXMLParserDelegate
#endif
