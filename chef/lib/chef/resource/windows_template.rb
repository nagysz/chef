#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
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

require 'chef/resource/template'
require 'chef/provider/template'
require 'chef/mixin/windows_securable'

class Chef
  class Resource
    class WindowsTemplate < Chef::Resource::Template
      include Chef::Mixin::WindowsSecurable

      provides :template, :on_platforms => ["windows"]

      def initialize(name, run_context=nil)
        super
        @resource_name = :windows_template
        @inherits = nil
        @provider = Chef::Provider::Template
      end

    end
  end
end