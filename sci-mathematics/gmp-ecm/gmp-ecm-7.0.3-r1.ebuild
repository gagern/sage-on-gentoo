# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="http://ecm.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/36043/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos ~ppc-macos ~x64-macos"
IUSE="+custom-tune gwnum -openmp cpu_flags_x86_sse2"

DEPEND="
	dev-libs/gmp:=
	!sci-mathematics/ecm
	gwnum? ( sci-mathematics/gwnum )"
RDEPEND="${DEPEND}"

# can't be both enabled
REQUIRED_USE="gwnum? ( !openmp )
	x86-macos? ( !custom-tune )"

PATCHES=(
	"${FILESDIR}"/ecm-7.0.3_config.patch
	)

S="${WORKDIR}"/ecm-${PV}

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare(){
	default

	eautoreconf
}

src_configure() {
	use gwnum && local myconf="--with-gwnum="${EPREFIX}"/usr/$(get_libdir)"
	# --enable-shellcmd is broken
	econf \
		$(use_enable openmp) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable custom-tune asm-redc) \
		${myconf}
}

src_test(){
	emake check
}
