# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils eutils flag-o-matic toolchain-funcs

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="http://m4ri.sagemath.org/"
#SRC_URI="mirror://sageupstream/lib${PN}/lib${P}.tar.bz2"
SRC_URI="http://m4ri.sagemath.org/downloads/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="debug openmp static-libs"

# TODO: tests do not compile since m4rie expects header already being installed
RESTRICT="mirror test"

DEPEND="~sci-libs/m4ri-${PV}[openmp?]"
RDEPEND="${DEPEND}"

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_configure() {
	myeconfargs=(
		$(use_enable debug)
		$(use_enable openmp)
	)

	autotools-utils_src_configure
}