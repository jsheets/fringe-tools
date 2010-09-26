/*
 *  FFTAnalytics.h
 *  FringeTools
 *
 *  Created by John Sheets on 9/25/10.
 *  Copyright 2010 FourFringe. All rights reserved.
 *
 */

#import "FFTGlobal.h"

#ifndef API_KEY
#error Must define analytics API_KEY
#endif

/**
 * Analytics Macros
 *
 * START_ANALYTICS
 * END_ANALYTICS
 * 
 * EVENT_ANALYTICS(eventName)
 * EVENT_ANALYTICS_START_CUSTOM(eventName, params)        --> param events only on Flurry Analytics
 *
 * EVENT_ANALYTICS_START(eventName)                       --> timed events only on Pinch Media
 * EVENT_ANALYTICS_END(eventName)
 * 
 * REPORT_ERROR_TO_ANALYTICS(errorName, errorMessage, e)  --> error logs only on Flurry Analytics
 */


// 
// Declare Pinch Media macros.
// 
#if defined(USE_PINCH_MEDIA)
#import "Beacon.h"

#define ANALYTICS_NAME @"PinchMedia"
#define START_ANALYTICS \
  FFTInfo(@"Initializing PinchMedia.");\
  [Beacon initAndStartBeaconWithApplicationCode:API_KEY useCoreLocation:YES useOnlyWiFi:NO];

#define END_ANALYTICS [Beacon endBeacon];

#define EVENT_ANALYTICS(eventName)\
  FFTInfo(@"PINCHMEDIA: Event '%@'.", eventName);\
  [[Beacon shared] startSubBeaconWithName:eventName timeSession:NO];

#define EVENT_ANALYTICS_START(eventName)\
  FFTInfo(@"PINCHMEDIA: Timed event '%@'.", eventName);\
  [[Beacon shared] startSubBeaconWithName:eventName timeSession:YES];

#define EVENT_ANALYTICS_START_CUSTOM(eventName, params)\
  FFTInfo(@"PINCHMEDIA: Custom event '%@' (params not supported: %@).", eventName, params);\
  [[Beacon shared] startSubBeaconWithName:eventName timeSession:NO];

#define EVENT_ANALYTICS_END(eventName)\
  FFTInfo(@"PINCHMEDIA: End of timed event '%@'.", eventName);\
  [[Beacon shared] endSubBeaconWithName:eventName];

#define REPORT_ERROR_TO_ANALYTICS(errorName, errorMessage, e)\
  FFTInfo(@"PINCHMEDIA: Error Reporting not supported: '%@' (%@) - %@", errorName, errorMessage, e);

#endif


// 
// Declare Flurry Analytics macros.
// 
#if defined(USE_FLURRY)
#import "FlurryAPI.h"

#define ANALYTICS_NAME @"Flurry Analytics"
#define START_ANALYTICS \
  FFTInfo(@"Initializing Flurry Analytics.");\
  [FlurryAPI startSession: API_KEY];\
  [FlurryAPI setSessionReportsOnCloseEnabled:YES];

#define END_ANALYTICS

#define EVENT_ANALYTICS(eventName)\
  FFTInfo(@"FLURRY: Event '%@'.", eventName);\
  [FlurryAPI logEvent:eventName];

#define EVENT_ANALYTICS_START(eventName)\
  FFTInfo(@"FLURRY: Event '%@' (timed events not supported).", eventName);\
  [FlurryAPI logEvent:eventName];

#define EVENT_ANALYTICS_START_CUSTOM(eventName, params)\
  FFTInfo(@"FLURRY: Event with params '%@' %@.", eventName, params);\
  [FlurryAPI logEvent:eventName withParameters:params];

#define EVENT_ANALYTICS_END(eventName)

#define REPORT_ERROR_TO_ANALYTICS(errorName, errorMessage, e)\
  FFTInfo(@"FLURRY: Error Reported: '%@' (%@) - %@", errorName, errorMessage, e);\
  [FlurryAPI logError:errorName message:errorMessage exception:e];

#endif


// 
// Declare Localytics macros.
// 
#if defined(USE_LOCALYTICS)
#import "LocalyticsSession.h"

#define ANALYTICS_NAME @"Localytics"
#define START_ANALYTICS \
  FFTInfo(@"Initializing Localytics.");\
  [[LocalyticsSession sharedLocalyticsSession] startSession:API_KEY];

#define END_ANALYTICS \
  [[LocalyticsSession sharedLocalyticsSession] close];\
  [[LocalyticsSession sharedLocalyticsSession] upload];

#define EVENT_ANALYTICS(eventName)\
  FFTInfo(@"LOCALYTICS: Event '%@'.", eventName);\
  [[LocalyticsSession sharedLocalyticsSession] tagEvent:eventName];

#define EVENT_ANALYTICS_START(eventName)\
  FFTInfo(@"LOCALYTICS: Event '%@' (timed events not supported).", eventName);\
  [[LocalyticsSession sharedLocalyticsSession] tagEvent:eventName];

#define EVENT_ANALYTICS_START_CUSTOM(eventName, params)\
  FFTInfo(@"LOCALYTICS: Event with params '%@' %@.", eventName, params);\
  [[LocalyticsSession sharedLocalyticsSession] tagEvent:eventName attributes:params];

#define EVENT_ANALYTICS_END(eventName)

#define REPORT_ERROR_TO_ANALYTICS(errorName, errorMessage, e)\
  FFTInfo(@"LOCALYTICS: Error Reporting not supported: '%@' (%@) - %@", errorName, errorMessage, e);

#endif


// 
// Blank out definitions if neither framework is enabled.
// 
#if !defined(USE_PINCH_MEDIA) && !defined(USE_FLURRY) && !defined(USE_LOCALYTICS)
#define START_ANALYTICS\
  FFTInfo(@"No analytics frameworks enabled.");

#define END_ANALYTICS

#define EVENT_ANALYTICS(eventName)\
  FFTInfo(@"No-op analytics for event: '%@'.", eventName);

#define EVENT_ANALYTICS_START(eventName)\
  FFTInfo(@"No-op analytics for timed event: '%@'.", eventName);

#define EVENT_ANALYTICS_START_CUSTOM(eventName, params)\
  FFTInfo(@"No-op analytics for custom event: '%@' %@.", eventName, params);

#define EVENT_ANALYTICS_END(eventName)\
  FFTInfo(@"No-op analytics for timed event completion: '%@'.", eventName);

#define REPORT_ERROR_TO_ANALYTICS(errorName, errorMessage, e)\
  FFTInfo(@"No-op analytics for Error Reporting: '%@' (%@) - %@", errorName, errorMessage, e);

#endif
