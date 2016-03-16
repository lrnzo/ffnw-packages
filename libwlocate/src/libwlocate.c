/**
 * libwlocate - WLAN-based location service
 * Copyright (C) 2010-2014 Oxygenic/VWP virtual_worlds(at)gmx.de
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

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#ifndef ENV_WINDOWS
 #include <arpa/inet.h>
#else
 #define snprintf _snprintf
#endif

#include "libwlocate.h"
#include "connect.h"
#include "wlan.h"
#include "assert.h"
#include "errno.h"
#include "getbssid.h"


WLOC_EXT_API int get_position(const char *domain,const struct wloc_req *request,double *lat,double *lon,char *quality,short *ccode)
{
   int             sock=0,ret,i;
   char            head[500+1];
   char            data[500+1];
   char            responseOK=0;
   int*            ownBssid;

   ownBssid = getMeshBssid();

   setlocale(LC_ALL,"C");
   sock=tcp_connect_to(domain);
   if (sock<=0)
   {
      printf("Connect error %d\n",errno);
      return WLOC_SERVER_ERROR;
   }
   tcp_set_blocking(sock,0); // set to non-blocking, we do not want to wait endless for a dead connection
  
   data[0]=0;
   for (i=0; i<WLOC_MAX_NETWORKS; i++)
   {
      if (request->bssids[i][0]+request->bssids[i][1]+request->bssids[i][2]+request->bssids[i][3]+request->bssids[i][4]+request->bssids[i][5]>0)
      {
          //Skip MESH BSSID: 02:CA:FF:EE:BA:BF
          if(   request->bssids[i][0] == ownBssid[0]
             && request->bssids[i][1] == ownBssid[1]
             && request->bssids[i][2] == ownBssid[2]
             && request->bssids[i][3] == ownBssid[3]
             && request->bssids[i][4] == ownBssid[4]
             && request->bssids[i][5] == ownBssid[5]){

                //SKIP

          }
          else {
            snprintf(data + strlen(data), 500 - strlen(data),
                        "%02X%02X%02X%02X%02X%02X\r\n",
                        request->bssids[i][0],request->bssids[i][1],request->bssids[i][2],
                        request->bssids[i][3],request->bssids[i][4],request->bssids[i][5]);
          }
      }
   }
   snprintf(head,500,
            "POST /getpos.php HTTP/1.0\r\nHost: %s\r\nContent-type: application/x-www-form-urlencoded, *.*\r\nContent-length: %d\r\n\r\n",
            domain,strlen(data));
   ret=tcp_send(sock,head,strlen(head),5000);
   ret+=tcp_send(sock,data,strlen(data),5000);
   if (ret<(int)(strlen(head)+strlen(data)))
   {
      tcp_closesocket(sock);
      return WLOC_CONNECTION_ERROR;
   }
   
   data[0]=0;
   for (;;)
   {
      ret=tcp_recv(sock,head,500,NULL,100);
      if (ret>0)
      {
         char *pos;
         int   dataFound=0;

         snprintf(data,500,"%s%s",data,head);
         if (strstr(data,"\r\n"))
         {
            // one line received at least so check response code
            if (!responseOK)
            {
               if (!strstr(data,"200 OK"))
               {
                  printf("Error: %s\n",data);
                  tcp_closesocket(sock);
                  return WLOC_SERVER_ERROR;
               }
               responseOK=1;
            }
            if (strstr(data,"result=0"))
            {
               tcp_closesocket(sock);
               return WLOC_LOCATION_ERROR;
            }
            pos=strstr(data,"quality=");
            if (pos);
            {
               pos+=8;
               *quality=atoi(pos);
               dataFound|=0x0001;
            }
            pos=strstr(data,"lat=");
            if (pos);
            {
               pos+=4;
               *lat=atof(pos);
               if (*lat!=0.0) dataFound|=0x0002;
            }
            pos=strstr(data,"lon=");
            if (pos);
            {
               pos+=4;
               *lon=atof(pos);
               if (*lon!=0.0) dataFound|=0x0004;
            }
            if ((dataFound & 0x0007)==0x0007) break; // all required data received
         }
      }
   }
   
   tcp_closesocket(sock);
   
   // this should never happen, the server should send quality values in range 0..99 only
//   assert((*quality>=0) && (*quality<=99));
   if (*quality<0) *quality=0;
   else if (*quality>99) *quality=99;
   // end of this should never happen
   
   *ccode=-1;
   return WLOC_OK;
}


/** please refer to libwlocate.h for a description of this function! */
WLOC_EXT_API int wloc_get_location(double *lat,double *lon,char *quality,short *ccode)
{
   return wloc_get_location_from("openwlanmap.org",lat,lon,quality,ccode);
}


/** please refer to libwlocate.h for a description of this function! */
WLOC_EXT_API int wloc_get_location_from(const char *domain,double *lat,double *lon,char *quality,short *ccode)
{
#ifdef ENV_LINUX
   int sock,i,j;
#endif
   struct wloc_req request;
   int             ret=0;

   memset((char*)&request,0,sizeof(struct wloc_req));
//#ifdef ENV_LINUX
   // for Linux we have some special handling because only root has full access to the WLAN-hardware:
   // there a wlocd-daemon may run with root privileges, so we try to connect to it and receive the
   // BSSID data from there. Only in case this fails the way via iwtools is used 
   //sock=tcp_connect_to("localhost");
/*   if (sock>0)
   {
   	ret=tcp_recv(sock,(char*)&request,sizeof(struct wloc_req),NULL,7500);
   	tcp_closesocket(sock);
   	if (ret==sizeof(struct wloc_req))
   	{
   		ret=0;
   		for (i=0; i<WLOC_MAX_NETWORKS; i++)
   		{
   			if (request.bssids[i][0]+request.bssids[i][1]+request.bssids[i][2]+
   			    request.bssids[i][3]+request.bssids[i][4]+request.bssids[i][5]>0) ret++;
   		}
   	}
   }*/
/*#else
   ret=0;   
#endif
   if (ret==0)
   {*/
      if (wloc_get_wlan_data(&request)<2)
      {
         wloc_get_wlan_data(&request); // try two times in case the device was currently used or could not find all networks
         // in case of no success request localisation without WLAN data
      }
//   }
//   for (i=0; i<WLOC_MAX_NETWORKS; i++)
//    printf("BSSID: %02X:%02X:%02X:%02X:%02X:%02X Signal: %d\n",request.bssids[i][0] & 0xFF,request.bssids[i][1] & 0xFF,request.bssids[i][2] & 0xFF,
//                                                               request.bssids[i][3] & 0xFF,request.bssids[i][4] & 0xFF,request.bssids[i][5] & 0xFF,request.signal[i]);
   return get_position(domain,&request,lat,lon,quality,ccode);
}
