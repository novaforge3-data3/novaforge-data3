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

#######################
Patch 
#######################

1- Patch classes of the original distribution
---------------------------------------------

replace the following files :
    org.sonar.db.DatabaseChecker.class  (change the minimal version number of mysql to make MariaDB compatible with Sonar 5.X)
    org.sonar.db.server.startup.RegisterPermissionTemplates.class (remove ANYONE permissions from the default template of permissions)


2 - Patch ruby files (REST services sonar) of the original distribution
-----------------------------------------------------------------------

In in the web module :

    add  membership_controller.rb file into the WEB-INF/app/controllers/api/ directory
    replace routes.rb file into the WEB-INF/config directory