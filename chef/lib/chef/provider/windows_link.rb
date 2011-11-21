#
# Author:: Mark Mzyk (<mmzyk@opscode.com>)
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

require 'chef/config'
require 'chef/log'
require 'chef/mixin/shell_out'
require 'chef/resource/link'
require 'chef/provider'
require 'chef/win32/file'

class Chef
  class Provider
    class WindowsLink < Chef::Provider
      include Chef::Mixin::ShellOut

      def negative_complement(big)
        if big > 1073741823 # Fixnum max
          big -= (2**32) # diminished radix wrap to negative
        end
        big
      end

      private :negative_complement

      def load_current_resource
        @current_resource = Chef::Resource::Link.new(@new_resource.name)
        @current_resource.target_file(@new_resource.target_file)
        @current_resource.link_type(@new_resource.link_type)
        if @new_resource.link_type == :symbolic
          if ::File.exists?(@current_resource.target_file) && Chef::Win32::File.symlink?(@current_resource.target_file)
            @current_resource.to(
              ::File.expand_path(Chef::Win32::File.readlink(@current_resource.target_file))
            )
            #cstats = ::File.lstat(@current_resource.target_file)
            #@current_resource.owner(cstats.uid)
            #@current_resource.group(cstats.gid)
          else
            @current_resource.to("")
          end
        elsif @new_resource.link_type == :hard
          if ::File.exists?(@current_resource.target_file) && ::File.exists?(@new_resource.to)
            @current_resource.to(@new_resource.to)
          else
            @current_resource.to("")
          end
        end
        @current_resource
      end

      # Compare the ownership of a symlink.  Returns true if they are the same, false if they are not.
      def compare_owner
        return false if @new_resource.owner.nil?

        @set_user_id = case @new_resource.owner
                       when /^\d+$/, Integer
                         @new_resource.owner.to_i
                       else
                         # This raises an ArgumentError if you can't find the user
                         Etc.getpwnam(@new_resource.owner).uid
                       end

        @set_user_id == @current_resource.owner
      end

      # Set the ownership on the symlink, assuming it is not set correctly already.
      def set_owner
        unless compare_owner
          @set_user_id = negative_complement(@set_user_id)
          ::File.lchown(@set_user_id, nil, @new_resource.target_file)
          Chef::Log.info("#{@new_resource} owner changed to #{@set_user_id}")
          @new_resource.updated_by_last_action(true)
        end
      end

      # Compares the group of a symlink.  Returns true if they are the same, false if they are not.
      def compare_group
        return false if @new_resource.group.nil?

        @set_group_id = case @new_resource.group
                        when /^\d+$/, Integer
                          @new_resource.group.to_i
                        else
                          Etc.getgrnam(@new_resource.group).gid
                        end

        @set_group_id == @current_resource.group
      end

      def set_group
        unless compare_group
          @set_group_id = negative_complement(@set_group_id)
          ::File.lchown(nil, @set_group_id, @new_resource.target_file)
          Chef::Log.info("#{@new_resource} group changed to #{@set_group_id}")
          @new_resource.updated_by_last_action(true)
        end
      end

      def action_create
        if @current_resource.to != ::File.expand_path(@new_resource.to, @new_resource.target_file)
          if @new_resource.link_type == :symbolic
            unless (Chef::Win32::File.symlink?(@new_resource.target_file) && Chef::Win32::File.readlink(@new_resource.target_file) == @new_resource.to)
              if Chef::Win32::File.symlink?(@new_resource.target_file) || ::File.exist?(@new_resource.target_file)
                ::File.unlink(@new_resource.target_file)
              end
              Chef::Win32::File.symlink(@new_resource.to, @new_resource.target_file)
              Chef::Log.debug("#{@new_resource} created #{@new_resource.link_type} link from #{@new_resource.to} -> #{@new_resource.target_file}")
              Chef::Log.info("#{@new_resource} created")
            end
          elsif @new_resource.link_type == :hard
            Chef::Win32::File.link(@new_resource.to, @new_resource.target_file)
            Chef::Log.debug("#{@new_resource} created #{@new_resource.link_type} link from #{@new_resource.to} -> #{@new_resource.target_file}")
            Chef::Log.info("#{@new_resource} created")
          end
          @new_resource.updated_by_last_action(true)
        end

        #if @new_resource.link_type == :symbolic
        #  set_owner unless @new_resource.owner.nil?
        #  set_group unless @new_resource.group.nil?
        #end
      end

      def action_delete
        if @new_resource.link_type == :symbolic
          if Chef::Win32::File.symlink?(@new_resource.target_file)
            ::File.delete(@new_resource.target_file)
            Chef::Log.info("#{@new_resource} deleted")
            @new_resource.updated_by_last_action(true)
          elsif ::File.exists?(@new_resource.target_file)
            raise Chef::Exceptions::Link, "Cannot delete #{@new_resource} at #{@new_resource.target_file}! Not a symbolic link."
          end
        elsif @new_resource.link_type == :hard
          if ::File.exists?(@new_resource.target_file)
            ::File.delete(@new_resource.target_file)
            Chef::Log.info("#{@new_resource} deleted")
            @new_resource.updated_by_last_action(true)
          else
            raise Chef::Exceptions::Link, "Cannot delete #{@new_resource} at #{@new_resource.target_file}! Not a hard link."
          end
        end
      end
    end
  end
end
