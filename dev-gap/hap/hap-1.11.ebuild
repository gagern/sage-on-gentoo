# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Homological Algebra Programming"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
SRC_URI="http://www.gap-system.org/pub/gap/gap4/tar.bz2/packages/${PN}${PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.7.8"
RDEPEND="${DEPEND}
	dev-gap/polycyclic
	dev-gap/crystcat"

S="${WORKDIR}"/Hap${PV}

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${PN}"
	doins -r doc lib pdfdoc test
	doins *.g boolean

	dodoc README.HAP
}

pkg_postinst(){
	elog "Some optional functions, require the following"
	elog "dependencies to be installed at runtime:"
	elog ""
	elog "sci-mathematics/polymake"
	elog "media-gfx/graphviz"
}
