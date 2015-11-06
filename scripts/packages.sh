#!/bin/bash
while [[ $# > 1 ]]
do
  key="$1"
  case $key in
    -b|--build)
      build="$2"
      shift
      ;;
    *)
      # unknown option
      ;;
  esac
  shift
done

#update system
zypper -n update

#remove if existing, otherwise phython-devel and other install will raise a conflict
zypper -n remove patterns-openSUSE-minimal_base-conflicts

if [ "$build" = true ] || [ ! -e /vagrant/*.rpm ]; then

  #install required packages
  zypper -n install wget telnet nano ant apache2-mod_perl createrepo expect gcc-c++ gpgme inst-source-utils java-1_7_0-openjdk java-1_7_0-openjdk-devel kernel-default-devel kernel-source kiwi-desc-isoboot kiwi-desc-oemboot kiwi-desc-vmxboot kiwi-templates libtool openssh-fips perl-Config-General perl-Tk python-libxml2 python-py python-requests setools-libs python-setools qemu regexp rpm-build sshpass sysstat unixODBC xfsprogs xml-commons-jaxp-1.3-apis zlib-devel git git-core glib2-devel libgcrypt-devel libgpg-error-devel libopenssl-devel libuuid-devel libxml2-devel pam-devel pcre-devel perl-Error python-devel readline-devel subversion xmlstarlet xz-devel libpcrecpp0 libpcreposix0 ca-certificates-cacert p7zip python-iniparse python-gpgme yum keepalived

  #add repos
  zypper addrepo -k -t rpm-md -n suse-13.2-scalpel4k http://download.opensuse.org/repositories/home:/scalpel4k/openSUSE_13.2 suse-13.2-scalpel4k
  zypper addrepo -k -t rpm-md -n suse-13.1-cesarizu http://download.opensuse.org/repositories/home:/cesarizu/openSUSE_13.1 suse-13.1-cesarizu
  zypper addrepo -k -t rpm-md -n suse-13.2-seife http://download.opensuse.org/repositories/home:/seife:/testing/openSUSE_13.2 suse-13.2-seife
  zypper addrepo -k -t rpm-md -n suse-13.2-python http://download.opensuse.org/repositories/devel:/languages:/python/openSUSE_13.2 suse-13.2-python
  zypper addrepo -k -t rpm-md -n suse-13.2-monitoring http://download.opensuse.org/repositories/server:/monitoring/openSUSE_13.2 suse-13.2-monitoring
  zypper addrepo -k -t rpm-md -n suse-13.2-network_utilities http://download.opensuse.org/repositories/network:utilities/openSUSE_13.2 suse-13.2-network_utilities

  #refresh repos
  zypper --gpg-auto-import-keys -n refresh

  #install ndisc6
  zypper -n install -r suse-13.2-network_utilities ndisc6

  #install maven and disable repo
  zypper -n install -r suse-13.1-cesarizu apache-maven
  zypper modifyrepo -d suse-13.1-cesarizu

  #install monitoring packages and disable repo
  zypper -n install -r suse-13.2-monitoring atop GeoIP-data libGeoIP1 GeoIP
  zypper modifyrepo -d suse-13.2-monitoring

  #install sipcalcand disable repo
  zypper -n install -r suse-13.2-seife sipcalc
  zypper modifyrepo -d suse-13.2-seife

  #install python-cjson and disable repo
  zypper -n install -r suse-13.2-python python-cjson
  zypper modifyrepo -d suse-13.2-python

  #install gradle and disable repo
  zypper -n install -r suse-13.2-scalpel4k gradle
  zypper modifyrepo -d suse-13.2-scalpel4k
else
  zypper -n install patch gcc-c++ pcre-devel libopenssl-devel keepalived make telnet java-1_7_0-openjdk java-1_7_0-openjdk-devel openssh-fips

  zypper addrepo -k -t rpm-md -n suse-13.2-seife http://download.opensuse.org/repositories/home:/seife:/testing/openSUSE_13.2 suse-13.2-seife
  zypper --gpg-auto-import-keys -n refresh

  #install sipcalcand disable repo
  zypper -n install -r suse-13.2-seife sipcalc
  zypper modifyrepo -d suse-13.2-seife
fi
