//
//  FFTOs.h
//  FringeTools
//
//  Created by John Sheets on 12/24/10.
//  Copyright 2010 MobileMethod, LLC. All rights reserved.
//

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
#ifdef MAC_OS_X_VERSION_MIN_REQUIRED
#  define FFT_MAC_OSX          1

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
#ifdef IPHONE_OS_VERSION_MIN_REQUIRED
#  define FFT_IOS         1

// All FFT_IOS_* macros default to 0.
#  if IPHONE_OS_VERSION_MIN_REQUIRED >= 40200
#    define FFT_IOS_4_2   1
#  endif
#  if IPHONE_OS_VERSION_MIN_REQUIRED >= 40100
#    define FFT_IOS_4_1   1
#  endif
#  if IPHONE_OS_VERSION_MIN_REQUIRED >= 40000
#    define FFT_IOS_4_0   1
#  endif
#  if IPHONE_OS_VERSION_MIN_REQUIRED >= 30200
#    define FFT_IOS_3_2   1
#  endif
#  if IPHONE_OS_VERSION_MIN_REQUIRED >= 30100
#    define FFT_IOS_3_1   1
#  endif
#  if IPHONE_OS_VERSION_MIN_REQUIRED >= 30000
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


//
// Functionality detection macros.
//

// NSXMLParserDelegate is present in Mac OS X 10.6+ and iOS 4.0+.
#if (FFT_MAC_OSX_10_6 == 1) || (FFT_IOS_4_0 == 1)
#define HAS_NSXMLParserDelegate
#endif
