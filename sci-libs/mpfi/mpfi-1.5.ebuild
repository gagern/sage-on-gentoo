# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools-utils

DESCRIPTION="A multiple precision interval arithmetic library based on MPFR"
HOMEPAGE="http://perso.ens-lyon.fr/nathalie.revol/software.html"
SRC_URI="https://gforge.inria.fr/frs/download.php/27346/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.1.2
	>=dev-libs/mpfr-2.4"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS )
