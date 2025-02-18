# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

MY_PN="${PN##python-}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="A non-validating SQL parser module for Python"
HOMEPAGE="https://github.com/andialbrecht/sqlparse"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${P#python-}

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD-2"

distutils_enable_sphinx docs/source
distutils_enable_tests pytest
