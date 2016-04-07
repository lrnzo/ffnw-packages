/**
 * libwlocate - WLAN-based location service
 * Copyright (C) 2010-2012 Oxygenic/VWP virtual_worlds(at)gmx.de
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
 * 
 * This code bases on the header files out of the WLAN-API from Moritz
 * Mertinkat. 
 */

#ifndef WLANAPI_CUST_H
#define WLANAPI_CUST_H

typedef struct
{
   LPWSTR wszGuid;
} INTF_KEY_ENTRY, *PINTF_KEY_ENTRY;

typedef struct 
{
   DWORD dwNumIntfs;
   PINTF_KEY_ENTRY pIntfs;
} INTFS_KEY_TABLE, *PINTFS_KEY_TABLE;

typedef DWORD (WINAPI *WZCEnumInterfacesFunction)(LPWSTR pSrvAddr, PINTFS_KEY_TABLE pIntfs);

typedef struct 
{
   DWORD   dwDataLen;
   LPBYTE  pData;
} RAW_DATA, *PRAW_DATA;

typedef struct
{
   LPWSTR wszGuid;
   LPWSTR wszDescr;
   ULONG ulMediaState;
   ULONG ulMediaType;
   ULONG ulPhysicalMediaType;
   INT nInfraMode;
   INT nAuthMode;
   INT nWepStatus;
   ULONG padding1[2];  // 16 chars on Windows XP SP3 or SP2 with WLAN Hotfix installed, 8 chars otherwise
   DWORD dwCtlFlags;
   DWORD dwCapabilities;
   RAW_DATA rdSSID;
   RAW_DATA rdBSSID;
   RAW_DATA rdBSSIDList;
   RAW_DATA rdStSSIDList;
   RAW_DATA rdCtrlData;
   BOOL bInitialized;
   ULONG padding2[64];  // for security reason ...
} INTF_ENTRY, *PINTF_ENTRY;

typedef DWORD (WINAPI *WZCQueryInterfaceFunction)(LPWSTR pSrvAddr, DWORD dwInFlags, PINTF_ENTRY pIntf, LPDWORD pdwOutFlags);

typedef wchar_t ADAPTER_NAME;
typedef wchar_t ADAPTER_DESCRIPTION;
typedef char AP_NAME;

#define ADAPTER_NAME_LENGTH        256
#define ADAPTER_DESCRIPTION_LENGTH 256
#define AP_NAME_LENGTH             256
#define INTF_DESCR         (0x00010000)
#define INTF_BSSIDLIST     (0x04000000)
#define INTF_LIST_SCAN     (0x08000000)

typedef UCHAR NDIS_802_11_MAC_ADDRESS[6];


typedef struct _ADAPTER_INFO 
{
    ADAPTER_NAME name[ADAPTER_NAME_LENGTH];
    ADAPTER_DESCRIPTION description[ADAPTER_DESCRIPTION_LENGTH];
} ADAPTER_INFO;

WZCEnumInterfacesFunction WZCEnumInterfaces;
WZCQueryInterfaceFunction WZCQueryInterface;

#endif
