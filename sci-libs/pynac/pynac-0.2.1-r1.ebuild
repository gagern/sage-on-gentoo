# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
SUPPORT_PYTHON_ABIS="1"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit python multilib

SAGE_P="sage-4.6"

DESCRIPTION="A modified version of GiNaC that replaces the dependency on CLN by Python"
HOMEPAGE="http://pynac.sagemath.org/"
SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_P}/${SAGE_P}/spkg/standard/${P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RESTRICT="mirror"

CDEPEND="virtual/python"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${P}/src"

DOCS=( AUTHORS NEWS README )

src_configure() {
	do_configure() {
		econf --libdir=$(python_get_libdir)/lib-dynload "$@"
	}
	python_execute_function -s do_configure --disable-static
}

src_install() {
	python_src_install pkgconfigdir=$(get_libdir)/pkgconfig
}
