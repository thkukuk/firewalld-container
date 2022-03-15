#
# spec file for package firewalld-container
#
# Copyright (c) 2022 SUSE LLC
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via https://bugs.opensuse.org/
#


Name:           firewalld-container
Version:        20220315.1ca5159
Release:        0
Summary:        Supporting files for running firewalld in a container
License:        MIT, GPL-2.0-or-later
URL:            https://github.com/thkukuk/firewalld-container
Source:         firewalld-container-%{version}.tar.gz
BuildRequires:  firewalld
Conflicts:      firewalld
BuildArch:      noarch

%description
This package contains the DBUS and PolicyKit files and the systemd units
to run and use the firewalld container with the host OS dbus daemon and
PolicyKit.

%prep
%setup -q

%build

%install
mkdir -p %{buildroot}%{_distconfdir}/default
mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}%{_datadir}/dbus-1/system.d
mkdir -p %{buildroot}%{_datadir}/polkit-1/actions
mkdir -p %{buildroot}/srv/firewalld

# Copy dbus and PolicyKit files from firewalld
cp -av %{_datadir}/dbus-1/system.d/FirewallD.conf %{buildroot}%{_datadir}/dbus-1/system.d/
cp -av %{_datadir}/polkit-1/actions/org.fedoraproject.FirewallD1.* %{buildroot}%{_datadir}/polkit-1/actions

install -m 644 RPM/container-firewalld.default %{buildroot}%{_distconfdir}/default/container-firewalld
install -m 644 RPM/container-firewalld.service %{buildroot}%{_unitdir}/
install -m 644 RPM/container-firewalld-dbus.service %{buildroot}%{_unitdir}/

%pre
%service_add_pre container-firewalld.service container-firewalld-dbus.service

%post
%service_add_post container-firewalld.service container-firewalld-dbus.service

%preun
%service_del_preun container-firewalld.service container-firewalld-dbus.service

%postun
%service_del_postun container-firewalld.service container-firewalld-dbus.service

%files
%license LICENSE
%doc README.md
%{_distconfdir}/default/container-firewalld
%{_unitdir}/container-firewalld.service
%{_unitdir}/container-firewalld-dbus.service
%{_datadir}/dbus-1/system.d
%{_datadir}/polkit-1/actions
%dir /srv/firewalld

%changelog
