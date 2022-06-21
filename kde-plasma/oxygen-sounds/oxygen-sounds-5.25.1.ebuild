# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.94.0
QTMIN=5.15.4
inherit ecm kde.org

DESCRIPTION="Oxygen sound theme for the Plasma desktop"
HOMEPAGE="https://invent.kde.org/plasma/oxygen-sounds"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="!<kde-plasma/oxygen-5.24.80"
