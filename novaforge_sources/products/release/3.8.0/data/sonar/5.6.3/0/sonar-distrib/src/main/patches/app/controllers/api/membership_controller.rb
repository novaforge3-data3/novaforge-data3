#
# NovaForge(TM) is a web-based forge offering a Collaborative Development and
# Project Management Environment.
#
# Copyright (C) 2007-2012  BULL SAS
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/.
#

require "json"

class Api::MembershipController < Api::RestController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :update ]

  before_filter :admin_required, :only => [ :update ]

  #
  # POST http://<hostname>:<port>/api/membership/update_permissions?project=com.mycompany.app:junitmavenexample&forgeprojectid=projtest
  #
  def update
    # project : nom du projet sonar, provient de Jenkins
    # forgeprojectid : id du projet NF, provient de Jenkins
    if params.has_key?(:project)
      begin
        project = Project.find(:first, :conditions => ['kee=? AND scope=? AND qualifier=?', params[:project], "PRJ", "TRK"])
        if !project.nil?
          roles = ["admin", "user", "codeviewer"]
          for role in roles
            concatgroup = params[:forgeprojectid].to_s+"_"+role
            group = Group.find(:first, :conditions => ['name=?', concatgroup])
            if !group.nil?
              grouproleuser = GroupRole.find(:first, :conditions => ["group_id=? and resource_id=? and role=?", group.id, project.id, 'user'])
              if grouproleuser.nil?
                GroupRole.create(:resource_id => project.id, :role => 'user', :group_id => group.id)
              end
              if !(role == "user")
                grouprolecodeviewer = GroupRole.find(:first, :conditions => ["group_id=? and resource_id=? and role=?", group.id, project.id, 'codeviewer'])
                if grouprolecodeviewer.nil?
                  GroupRole.create(:resource_id => project.id, :role => 'codeviewer', :group_id => group.id)
                end

                if role == "admin"
                  grouproleadmin = GroupRole.find(:first, :conditions => ["group_id=? and resource_id=? and role=?", group.id, project.id, 'admin'])
                  if grouproleadmin.nil?
                    GroupRole.create(:resource_id => project.id, :role => 'admin', :group_id => group.id)
                  end
                end
              end
            end
          end
          rest_status_ok
        else
          rest_status_ko('Unable to find project : it does not exist', 400)
        end
      rescue
        rest_status_ko('Update problem', 400)
      end
    end
  end
end
