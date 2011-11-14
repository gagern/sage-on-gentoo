# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools-utils flag-o-matic

MY_P="lib${P}"

DESCRIPTION="fpLLL contains several algorithms on lattices"
HOMEPAGE="http://perso.ens-lyon.fr/damien.stehle/"
SRC_URI="http://perso.ens-lyon.fr/xavier.pujol/fplll/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.2.0
	>=dev-libs/mpfr-2.3.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS NEWS README )
PATCHES=( "${FILESDIR}"/${PN}-3.1.1-installation.patch )

src_prepare() {
	# -O3 hangs up the compiler. See issue #66 at
	# https://github.com/cschwan/sage-on-gentoo/issues/66
	replace-flags -O3 -O2

	autotools-utils_src_prepare
	eautoreconf

	# Replace deprecated gmp functions which are removed with mpir-1.3.0
	sed -i "s:mpz_div_2exp:mpz_tdiv_q_2exp:g" src/nr.cpp src/util.h \
		|| die "failed to patch depracated gmp function calls"
}
