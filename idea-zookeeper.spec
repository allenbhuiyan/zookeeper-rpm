############################################################################
#
# Apache Zookeeper
#
############################################################################

Summary       : Zookeeper Server
Name          : comcast-idea-zookeeper
Version       : 3.4.6
Release       : 1
License       : Apache License v2
Group         : Development/Tools
URL           : https://gitlab.sys.comcast.net/idea-rpms/comcast-idea-zookeeper
Packager      : Comcast IDEA
Vendor        : Apache Foundation
Source0       : http://www.us.apache.org/dist/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
Patch0        : 0001-Removed-Carriage-Return-at-the-end-of-data-directory.patch
Patch1        : 0002-issue-4-Isolate-config-and-logs-from-app-platform.patch
BuildRoot     : %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
Provides      : zookeeper = %{version}
Autoprov      : 0
Requires      : comcast-idea-java-7-oracle
Prefix        : /app/platform/zookeeper
BuildArch     : noarch

# Don't compress or strip executables and libraries
%define __os_install_post %{nil}

%description
ZooKeeper is a centralized service for maintaining configuration information,
naming, providing distributed synchronization, and providing group services.
All of these kinds of services are used in some form or another by distributed
applications. Each time they are implemented there is a lot of work that goes
into fixing the bugs and race conditions that are inevitable. Because of the
difficulty of implementing these kinds of services, applications initially
usually skimp on them ,which make them brittle in the presence of change and
difficult to manage. Even when done correctly, different implementations of
these services lead to management complexity when the applications are
deployed.

%prep
%setup -n zookeeper-%{version}
%patch0 -p1
%patch1 -p1

%install
%{__rm} -rf %{buildroot}
%{__mkdir_p} %{buildroot}%{prefix}
%{__install} -m 755 -d %{buildroot}%{prefix}/bin
%{__install} -m 755 -d %{buildroot}%{prefix}/lib
%{__install} -m 755 bin/*.sh %{buildroot}%{prefix}/bin
%{__install} -m 644 lib/*.jar lib/*LICENSE* %{buildroot}%{prefix}/lib
%{__install} -m 644 CHANGES.txt LICENSE.txt %{buildroot}%{prefix}
%{__install} -m 755 dist-maven/zookeeper-3.4.6.jar %{buildroot}%{prefix}

%clean
%{__rm} -rf %{buildroot}

%pre
umask 0022

# Add the "mradmin" user
/usr/sbin/useradd -c "MrAdmin" \
  -s /sbin/nologin -r mradmin 2> /dev/null

# Create platform directory
[ -d /app/platform ] || mkdir -p /app/platform

%files
%defattr(-,mradmin,mradmin)
%{prefix}

%changelog
* Wed Oct 15 2014 Sergey Matochkin <Sergey_Matochkin@cable.comcast.com> - 3.4.6-1
- Zookeeper 3.4.6 release 1
- Fixed #4: Isolate config and logs from /app/platform
- Fixed #3: Carriage return at the end of data directory name
- Fixed #1: Stripped source code, C libraries and examples.
- Fixed #2: Minor/cosmetic

* Fri Sep 19 2014 Nicholas Beenham <Nicholas_Beenham@cable.comcast.com> - 3.4.6-0
- Initial Build Zookeeper 3.4.6-0
