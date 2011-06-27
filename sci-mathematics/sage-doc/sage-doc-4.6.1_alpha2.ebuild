# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils versionator

#MY_P="sage-${PV}"
#MY_P_HTML="sage-${PV}-doc-html"
#MY_P_PDF="sage-${PV}-doc-pdf"
# sage-4.6 for now
SAGE_PV=$(replace_version_separator 3 '.')
MY_P="sage-${SAGE_PV}"
PVOLD="4.6"
MY_P_HTML="sage-${PVOLD}-doc-html"
MY_P_PDF="sage-${PVOLD}-doc-pdf"


DESCRIPTION="Documentation, tutorials and help files for Sage"
HOMEPAGE="http://www.sagemath.org/"
#SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> sage-${PV}.tar.bz2
#	http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/3-1-1/Singular-3-1-1-4-share.tar.gz
#	html? ( http://www.sagemath.org/doc-bz2/${MY_P_HTML}.tar.bz2 -> sage-doc-html-${PV}.tar.bz2 )
#	pdf? ( http://www.sagemath.org/doc-bz2/${MY_P_PDF}.tar.bz2 -> sage-doc-pdf-${PV}.tar.bz2 )"
SRC_URI="http://sage.math.washington.edu/home/release/${MY_P}/${MY_P}/spkg/standard/${MY_P}.spkg -> sage-${PV}.tar.bz2
	http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/3-1-1/Singular-3-1-1-4-share.tar.gz
	html? ( http://www.sagemath.org/doc-bz2/${MY_P_HTML}.tar.bz2 -> sage-doc-html-${PVOLD}.tar.bz2 )
	pdf? ( http://www.sagemath.org/doc-bz2/${MY_P_PDF}.tar.bz2 -> sage-doc-pdf-${PVOLD}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="html pdf"

RESTRICT="mirror"

# TODO: depend on sage-baselayout (creates sage-main directory) ?
DEPEND=""
RDEPEND=">=dev-python/sphinx-1.0.4"

S="${WORKDIR}/${MY_P}/doc"

src_install() {
	# install missing directories to satisfy builder.py test
	dodir /usr/share/sage/devel/sage-main/doc/output/doctrees/en/tutorial || die
	dodir /usr/share/sage/devel/sage-main/doc/en/tutorial/templates || die
	dodir /usr/share/sage/devel/sage-main/doc/en/tutorial/static || die

	# TODO: check if all of these files are needed
	rm -rf output || die "failed to remove useless files"
	insinto /usr/share/sage/devel/sage-main/doc
	doins -r * || die
	doins "${WORKDIR}"/Singular/3-1-1/info/singular.hlp || die

	if use html ; then
		cd "${WORKDIR}"/${MY_P_HTML}
		insinto /usr/share/sage/devel/sage-main/doc/output/html
		doins -r * || die
	fi

	if use pdf ; then
		cd "${WORKDIR}"/${MY_P_PDF}
		insinto /usr/share/sage/devel/sage-main/doc/output/pdf
		doins -r * || die
	fi
}

pkg_postinst() {
	if ! use html ; then
		ewarn "You haven't requested the html documentation."
		ewarn "The html version of the sage manual won't be available in the sage notebook."
	fi
}
