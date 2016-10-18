%define gcc_glibc_version gcc-%{grte_gcc_version}-%{grte_basename}
%define base_summary Intel SPMD Program Compiler %{crosstool_ispc_version} for %{grte_root} with %{gcc_glibc_version}
Summary: %{base_summary}
Name: %{grte_basename}-crosstool%{crosstool_version}-ispc-%{crosstool_ispc_version}
Version: %{crosstool_rpmver}
Release: %{crosstool_rpmrel}
License:  BSD 3-Clause from Intel, University of Illinois/NCSA for LLVM, GEORGIA TECH RESEARCH CORPORATION for the PTX parser, BSD 2-Clause from James Tursa for half precision floating point code.
Group: Development/Languages
Packager: Release Engineer <%{maintainer_email}>
AutoReqProv: no

BuildRoot: %{_tmppath}/%{name}-buildroot

# Create debuginfo unless disable_debuginfo is defined.
%define make_debuginfo %{?disable_debuginfo:""}%{!?disable_debuginfo:"t"}
%define debug_cflags %{?disable_debuginfo:""}%{!?disable_debuginfo:"-g"}

# Remove BuildRoot in %clean unless keep_buildroot is defined.
%define remove_buildroot %{?keep_buildroot:""}%{!?keep_buildroot:"t"}

# Enable bootstrapping unless disable_bootstrap is defined.
%define bootstrap_config_arg %{?disable_bootstrap:"--disable-bootstrap"}%{!?disable_bootstrap:""}

%description
Intel SPMD Program Compiler (ISPC) %{crosstool_ispc_version} to work with %{grte_basename}, git commit @commit %{ispc_git_commit}


%prep

%define crosstool_top /usr/crosstool/%{crosstool_version}
%define target_top %{crosstool_top}/%{gcc_glibc_version}
%define grte_top %{grte_root}

%build
export PATH="%{grte_top}/bin:%{grte_top}/sbin:$PATH"

rm -rf $RPM_BUILD_DIR
WORK_DIR="$RPM_BUILD_DIR/$RPM_PACKAGE_NAME-$RPM_PACKAGE_VERSION"

# TARGET=x86_64-unknown-linux-gnu
# PREFIX="$RPM_BUILD_ROOT%{target_top}/x86"
# Make gold the default linker
mkdir -p ${WORK_DIR}/ispc-build
cp -r %{_sourcedir}/ispc ${WORK_DIR}/ispc-build
cd ${WORK_DIR}/ispc-build/ispc

git apply %{_sourcedir}/ispc-d4a8afd.patch
pwd
ls
export LLVM_HOME=/usr/crosstool/v2/%{gcc_glibc_version}/x86
export PATH=${PATH}:${LLVM_HOME}/bin

LLVM_HOME=${LLVM_HOME} PATH=${PATH}:${LLVM_HOME}/bin make

%install

WORK_DIR="$RPM_BUILD_DIR/$RPM_PACKAGE_NAME-$RPM_PACKAGE_VERSION"
PREFIX="$RPM_BUILD_ROOT%{target_top}/x86"

mkdir -p ${PREFIX}/bin
cp ${WORK_DIR}/ispc-build/ispc/ispc ${PREFIX}/bin/ispc

%clean

%files
%defattr(-,root,root)
%{target_top}/x86/bin/ispc

%changelog
* Mon Oct 17 2016 Release Engineer <%{maintainer_email}>
- ISPC ${crosstool_ispc_version} from git commit  %{ispc_git_commit}
