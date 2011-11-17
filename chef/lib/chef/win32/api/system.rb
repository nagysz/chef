#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright 2011 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/win32/api'

class Chef
  module Win32
    module API
      module System

        extend Chef::Win32::API

        # http://msdn.microsoft.com/en-us/library/ms724833(v=vs.85).aspx

        # Suite Masks
        # Microsoft BackOffice components are installed.
        VER_SUITE_BACKOFFICE = 0x00000004
        # Windows Server 2003, Web Edition is installed.
        VER_SUITE_BLADE = 0x00000400
        # Windows Server 2003, Compute Cluster Edition is installed.
        VER_SUITE_COMPUTE_SERVER = 0x00004000
        # Windows Server 2008 Datacenter, Windows Server 2003, Datacenter Edition, or Windows 2000 Datacenter Server is installed.
        VER_SUITE_DATACENTER = 0x00000080
        # Windows Server 2008 Enterprise, Windows Server 2003, Enterprise Edition, or Windows 2000 Advanced Server is installed. Refer to the Remarks section for more information about this bit flag.
        VER_SUITE_ENTERPRISE = 0x00000002
        # Windows XP Embedded is installed.
        VER_SUITE_EMBEDDEDNT = 0x00000040
        # Windows Vista Home Premium, Windows Vista Home Basic, or Windows XP Home Edition is installed.
        VER_SUITE_PERSONAL = 0x00000200
        # Remote Desktop is supported, but only one interactive session is supported. This value is set unless the system is running in application server mode.
        VER_SUITE_SINGLEUSERTS = 0x00000100
        # Microsoft Small Business Server was once installed on the system, but may have been upgraded to another version of Windows. Refer to the Remarks section for more information about this bit flag.
        VER_SUITE_SMALLBUSINESS = 0x00000001
        # Microsoft Small Business Server is installed with the restrictive client license in force. Refer to the Remarks section for more information about this bit flag.
        VER_SUITE_SMALLBUSINESS_RESTRICTED = 0x00000020
        # Windows Storage Server 2003 R2 or Windows Storage Server 2003is installed.
        VER_SUITE_STORAGE_SERVER = 0x00002000
        # Terminal Services is installed. This value is always set.
        # If VER_SUITE_TERMINAL is set but VER_SUITE_SINGLEUSERTS is not set, the system is running in application server mode.
        VER_SUITE_TERMINAL = 0x00000010
        # Windows Home Server is installed.
        VER_SUITE_WH_SERVER = 0x00008000

        # Product Type
        # The system is a domain controller and the operating system is Windows Server 2008 R2, Windows Server 2008, Windows Server 2003, or Windows 2000 Server.
        VER_NT_DOMAIN_CONTROLLER = 0x0000002
        # The operating system is Windows Server 2008 R2, Windows Server 2008, Windows Server 2003, or Windows 2000 Server.
        # Note that a server that is also a domain controller is reported as VER_NT_DOMAIN_CONTROLLER, not VER_NT_SERVER.
        VER_NT_SERVER = 0x0000003
        # The operating system is Windows 7, Windows Vista, Windows XP Professional, Windows XP Home Edition, or Windows 2000 Professional.
        VER_NT_WORKSTATION = 0x0000001

        # GetSystemMetrics
        # The build number if the system is Windows Server 2003 R2; otherwise, 0.
        SM_SERVERR2 = 89

        # http://msdn.microsoft.com/en-us/library/ms724358(v=vs.85).aspx
        # this is what it sounds like...when kittens die
        PRODUCT_TYPE = {
          0x00000006 => {:ms_const => 'PRODUCT_BUSINESS', :name => 'Business'},
          0x00000010 => {:ms_const => 'PRODUCT_BUSINESS_N', :name => 'Business N'},
          0x00000012 => {:ms_const => 'PRODUCT_CLUSTER_SERVER', :name => 'HPC Edition'},
          0x00000008 => {:ms_const => 'PRODUCT_DATACENTER_SERVER', :name => 'Server Datacenter (full installation)'},
          0x0000000C => {:ms_const => 'PRODUCT_DATACENTER_SERVER_CORE', :name => 'Server Datacenter (core installation)'},
          0x00000027 => {:ms_const => 'PRODUCT_DATACENTER_SERVER_CORE_V', :name => 'Server Datacenter without Hyper-V (core installation)'},
          0x00000025 => {:ms_const => 'PRODUCT_DATACENTER_SERVER_V', :name => 'Server Datacenter without Hyper-V (full installation)'},
          0x00000004 => {:ms_const => 'PRODUCT_ENTERPRISE', :name => 'Enterprise'},
          0x00000046 => {:ms_const => 'PRODUCT_ENTERPRISE_E', :name => 'Not supported'},
          0x0000001B => {:ms_const => 'PRODUCT_ENTERPRISE_N', :name => 'Enterprise N'},
          0x0000000A => {:ms_const => 'PRODUCT_ENTERPRISE_SERVER', :name => 'Server Enterprise (full installation)'},
          0x0000000E => {:ms_const => 'PRODUCT_ENTERPRISE_SERVER_CORE', :name => 'Server Enterprise (core installation)'},
          0x00000029 => {:ms_const => 'PRODUCT_ENTERPRISE_SERVER_CORE_V', :name => 'Server Enterprise without Hyper-V (core installation)'},
          0x0000000F => {:ms_const => 'PRODUCT_ENTERPRISE_SERVER_IA64', :name => 'Server Enterprise for Itanium-based Systems'},
          0x00000026 => {:ms_const => 'PRODUCT_ENTERPRISE_SERVER_V', :name => 'Server Enterprise without Hyper-V (full installation)'},
          0x00000002 => {:ms_const => 'PRODUCT_HOME_BASIC', :name => 'Home Basic'},
          0x00000043 => {:ms_const => 'PRODUCT_HOME_BASIC_E', :name => 'Not supported'},
          0x00000005 => {:ms_const => 'PRODUCT_HOME_BASIC_N', :name => 'Home Basic N'},
          0x00000003 => {:ms_const => 'PRODUCT_HOME_PREMIUM', :name => 'Home Premium'},
          0x00000044 => {:ms_const => 'PRODUCT_HOME_PREMIUM_E', :name => 'Not supported'},
          0x0000001A => {:ms_const => 'PRODUCT_HOME_PREMIUM_N', :name => 'Home Premium N'},
          0x0000002A => {:ms_const => 'PRODUCT_HYPERV', :name => 'Microsoft Hyper-V Server'},
          0x0000001E => {:ms_const => 'PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT', :name => 'Windows Essential Business Server Management Server'},
          0x00000020 => {:ms_const => 'PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING', :name => 'Windows Essential Business Server Messaging Server'},
          0x0000001F => {:ms_const => 'PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY', :name => 'Windows Essential Business Server Security Server'},
          0x00000030 => {:ms_const => 'PRODUCT_PROFESSIONAL', :name => 'Professional'},
          0x00000045 => {:ms_const => 'PRODUCT_PROFESSIONAL_E', :name => 'Not supported'},
          0x00000031 => {:ms_const => 'PRODUCT_PROFESSIONAL_N', :name => 'Professional N'},
          0x00000018 => {:ms_const => 'PRODUCT_SERVER_FOR_SMALLBUSINESS', :name => 'Windows Server 2008 for Windows Essential Server Solutions'},
          0x00000023 => {:ms_const => 'PRODUCT_SERVER_FOR_SMALLBUSINESS_V', :name => 'Windows Server 2008 without Hyper-V for Windows Essential Server Solutions'},
          0x00000021 => {:ms_const => 'PRODUCT_SERVER_FOUNDATION', :name => 'Server Foundation'},
          0x00000022 => {:ms_const => 'PRODUCT_HOME_PREMIUM_SERVER', :name => 'Windows Home Server 2011'},
          0x00000032 => {:ms_const => 'PRODUCT_SB_SOLUTION_SERVER', :name => 'Windows Small Business Server 2011 Essentials'},
          0x00000013 => {:ms_const => 'PRODUCT_HOME_SERVER', :name => 'Windows Storage Server 2008 R2 Essentials'},
          0x00000009 => {:ms_const => 'PRODUCT_SMALLBUSINESS_SERVER', :name => 'Windows Small Business Server'},
          0x00000038 => {:ms_const => 'PRODUCT_SOLUTION_EMBEDDEDSERVER', :name => 'Windows MultiPoint Server'},
          0x00000007 => {:ms_const => 'PRODUCT_STANDARD_SERVER', :name => 'Server Standard (full installation)'},
          0x0000000D => {:ms_const => 'PRODUCT_STANDARD_SERVER_CORE', :name => 'Server Standard (core installation)'},
          0x00000028 => {:ms_const => 'PRODUCT_STANDARD_SERVER_CORE_V', :name => 'Server Standard without Hyper-V (core installation)'},
          0x00000024 => {:ms_const => 'PRODUCT_STANDARD_SERVER_V', :name => 'Server Standard without Hyper-V (full installation)'},
          0x0000000B => {:ms_const => 'PRODUCT_STARTER', :name => 'Starter'},
          0x00000042 => {:ms_const => 'PRODUCT_STARTER_E', :name => 'Not supported'},
          0x0000002F => {:ms_const => 'PRODUCT_STARTER_N', :name => 'Starter N'},
          0x00000017 => {:ms_const => 'PRODUCT_STORAGE_ENTERPRISE_SERVER', :name => 'Storage Server Enterprise'},
          0x00000014 => {:ms_const => 'PRODUCT_STORAGE_EXPRESS_SERVER', :name => 'Storage Server Express'},
          0x00000015 => {:ms_const => 'PRODUCT_STORAGE_STANDARD_SERVER', :name => 'Storage Server Standard'},
          0x00000016 => {:ms_const => 'PRODUCT_STORAGE_WORKGROUP_SERVER', :name => 'Storage Server Workgroup'},
          0x00000000 => {:ms_const => 'PRODUCT_UNDEFINED', :name => 'An unknown product'},
          0x00000001 => {:ms_const => 'PRODUCT_ULTIMATE', :name => 'Ultimate'},
          0x00000047 => {:ms_const => 'PRODUCT_ULTIMATE_E', :name => 'Not supported'},
          0x0000001C => {:ms_const => 'PRODUCT_ULTIMATE_N', :name => 'Ultimate N'},
          0x00000011 => {:ms_const => 'PRODUCT_WEB_SERVER', :name => 'Web Server (full installation)'},
          0x0000001D => {:ms_const => 'PRODUCT_WEB_SERVER_CORE', :name => 'Web Server (core installation)'}
        }

        class OSVERSIONINFOEX < FFI::Struct
          layout :dw_os_version_info_size, :DWORD,
            :dw_major_version, :DWORD,
            :dw_minor_version, :DWORD,
            :dw_build_number, :DWORD,
            :dw_platform_id, :DWORD,
            :sz_csd_version, [:TCHAR, 128],
            :w_service_pack_major, :WORD,
            :w_service_pack_minor, :WORD,
            :w_suite_mask, :WORD,
            :w_product_type, :BYTE,
            :w_reserved, :BYTE,
        end

        def MAKEWORD(a, b)
          ((a & 0xff) | (b & 0xff)) << 8
        end

        def MAKELONG(a, b)
          ((a & 0xffff) | (b & 0xffff)) << 16
        end

        def LOWORD(l)
          l & 0xffff
        end

        def HIWORD(l)
          l >> 16
        end

        def LOBYTE(w)
          w & 0xff
        end

        def HIBYTE(w)
          w >> 8
        end

        ffi_lib 'user32', 'kernel32'
        ffi_convention :stdcall

=begin
DWORD WINAPI GetVersion(void);
=end
        attach_function :GetVersion, [], :DWORD

=begin
BOOL WINAPI GetVersionEx(
  __inout  LPOSVERSIONINFO lpVersionInfo
);
=end
        attach_function :GetVersionExW, [:pointer], :BOOL
        attach_function :GetVersionExA, [:pointer], :BOOL

=begin
BOOL WINAPI GetProductInfo(
  __in   DWORD dwOSMajorVersion,
  __in   DWORD dwOSMinorVersion,
  __in   DWORD dwSpMajorVersion,
  __in   DWORD dwSpMinorVersion,
  __out  PDWORD pdwReturnedProductType
);
=end
        attach_function :GetProductInfo, [:DWORD, :DWORD, :DWORD, :DWORD, :PDWORD], :BOOL

=begin
int WINAPI GetSystemMetrics(
  __in  int nIndex
);
=end
        attach_function :GetSystemMetrics, [:int], :int

      end
    end
  end
end