/**
 * libwlocate - WLAN-based location service
 * Copyright (C) 2010 Oxygenic/VWP virtual_worlds(at)gmx.de
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef LIBWLOCATE_H
#define LIBWLOCATE_H

#if defined __GNUC__ && !defined ENV_LINUX && !defined ENV_QNX
 #define ENV_LINUX
#endif

#ifndef WLOC_EXT_API
 #ifdef ENV_LINUX
  #define WLOC_EXT_API extern
 #endif

 #ifdef ENV_QNX
  #define WLOC_EXT_API extern
 #endif

#endif

#ifndef __cplusplus
 typedef unsigned char bool;
 #define false 0
 #define true  1
#endif

#ifdef ENV_QNX
 #include <stdint.h>
#endif

#define WLOC_MAX_NETWORKS 16

#pragma pack(1) // 1 byte alignment, calculation speed doesn't matters but data transfer sizes

// internally used communication structures and defines ======================================================================
struct wloc_req
{
   unsigned char version,length;
   unsigned char bssids[WLOC_MAX_NETWORKS][6];
   char          signal_off[WLOC_MAX_NETWORKS]; // no longer used in interface version 2 since signal strength does not provide any useful information for position calculation
   unsigned long cgiIP;
};

#define WLOC_RESULT_OK     1  // a position could be calculated
#define WLOC_RESULT_ERROR  2  // the location could not be retrieved
#define WLOC_RESULT_IERROR 3 // an internal error occured, no data are available

struct wloc_res
{
	char           version,length;
	char           result,iresult,quality;
	char           cres6,cres7,cres8;    // reserved variables
	int            lat,lon;
	short          ccode;
	unsigned short wres34,wres56,wres78; // reserved variables
};
// end of internally used communication structures and defines ================================================================



// public defines and function definitions ====================================================================================
#define WLOC_OK               0 // result is OK, location could be retrieved
#define WLOC_CONNECTION_ERROR 1 // could not send data to/receive data from server
#define WLOC_SERVER_ERROR     2// could not connect to server to get position data
#define WLOC_LOCATION_ERROR   3 // could not retrieve location, detected WLAN networks are unknown
#define WLOC_ERROR          100 // some other error

#ifdef __cplusplus
extern "C" 
{
#endif
  /**
   * This function retrieves the current geographic position of a system, the returned
   * position values can be used directly within maps like OpenStreetMap or Google Earth
   * @param[out] lat the latitude of the geographic position
   * @param[out] lon the longitude of the geographic position
   * @param[out] quality the percentual quality of the returned position, the given result
   *             is as more exact as closer the quality value is to 100%, as smaller this
   *             value is as bigger is the possible maximum deviation between returned
   *             and the real position
   * @return only in case the returned value is equal WLOC_OK the values given back via the
   *             functions parameters can be used; in case an error occurred an error code
   *             WLOC_xxx is returned and the position and quality values given back are
   *             undefined and don't have to be used
   */
   WLOC_EXT_API int wloc_get_location_from(const char *domain,double *lat,double *lon,char *quality,short *ccode);
   
  /**
   * This function retrieves the current geographic position of a system using a selectable
   * source for retrieval of position. The returned position values can be used directly
   * within maps like OpenStreetMap or Google Earth
   * @param[in]  domain the domain name of the project to get the position from (e.g.
                 "openwifi.su")
   * @param[out] lat the latitude of the geographic position
   * @param[out] lon the longitude of the geographic position
   * @param[out] quality the percentual quality of the returned position, the given result
   *             is as more exact as closer the quality value is to 100%, as smaller this
   *             value is as bigger is the possible maximum deviation between returned
   *             and the real position
   * @return only in case the returned value is equal WLOC_OK the values given back via the
   *             functions parameters can be used; in case an error occurred an error code
   *             WLOC_xxx is returned and the position and quality values given back are
   *             undefined and don't have to be used
   */
   WLOC_EXT_API int wloc_get_location(double *lat,double *lon,char *quality,short *ccode);
   
   /**
    * This function is used internally on step before the geolocation is calculated. It
    * checks which WLAN networks are accessible at the moment with wich signal strength and
    * fills the request structure wloc_req with these data. So this function can be called
    * in order to check the number of available networks without performing any geolocation.
    * @param[out] request a structure of type wloc_req that is filled with the WLAN data;
    *             BSSID entries of this structure that are set to 00-00-00-00-00-00 are
    *             unused and do not contain valid WLAN information
    * @return the retruned value is equal to the number of WLAN networks that have been found,
    *             only in case it is greater than 0 the value given back via the functions
    *             parameter can be used, elsewhere the structures contents are undefined
    */
   WLOC_EXT_API int wloc_get_wlan_data(struct wloc_req *request);

   WLOC_EXT_API int get_position(const char *domain,const struct wloc_req *request,double *lat,double *lon,char *quality,short *ccode);
#ifdef __cplusplus
}
#endif

#endif

