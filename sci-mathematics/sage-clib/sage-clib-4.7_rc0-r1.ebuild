# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="3.* *-jython"
inherit eutils python scons-utils versionator multilib

MY_P="sage-$(replace_version_separator 2 '.')"

DESCRIPTION="Sage's C library"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://sage.math.washington.edu/home/release/${MY_P}/${MY_P}/spkg/standard/${MY_P}.spkg -> sage-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RESTRICT="mirror"

DEPEND="dev-libs/gmp[-nocxx]
	>=dev-libs/ntl-5.5.2
	=sci-libs/pynac-0.2.1-r1
	>=sci-mathematics/pari-2.4.3-r1
	>=sci-mathematics/polybori-0.7[sage]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/c_lib"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.6-importenv.patch
	epatch "${FILESDIR}"/${PN}-4.5.3-fix-undefined-symbols-warning.patch

	sed -i "s:mpir.h:gmp.h:" src/memory.c

	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i "s:-Wl,-soname,libcsage.so:-install_name ${EPREFIX}/usr/$(get_libdir)/libcsage.dylib:" \
			SConstruct
	fi

	# Use pari-2.4
	sed -i "s:pari/:pari24/:" include/convert.h || die "failed to use pari2.4 headers"

	python_execute_function libcsage_src_prepare
}

libcsage_src_prepare() {
	local BUILDDIR="${S}-${PYTHON_ABI}"
	mkdir "${BUILDDIR}" || die
	cp -r "${S}"/{include,src,SConstruct} "${BUILDDIR}"/ || die "copy failed"
	sed -i "s:python2.6:python${PYTHON_ABI}:g" "${BUILDDIR}"/SConstruct
}

src_compile() {
	python_execute_function -s libcsage_src_compile
}

libcsage_src_compile() {
	# build libcsage.so
	tc-export CC CXX
	SAGE_LOCAL="${EPREFIX}"/usr UNAME=$(uname) escons || die
}

src_install() {
	insinto /usr/include/csage
	doins include/*.h || die
	python_execute_function -s libcsage_src_install
}

libcsage_src_install() {
	insinto "$(python_get_libdir)/lib-dynload"
	insopts -m0755
	doins libcsage$(get_libname) || die
}
