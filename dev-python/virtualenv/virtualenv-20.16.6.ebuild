# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Virtual Python Environment builder"
HOMEPAGE="
	https://virtualenv.pypa.io/en/stable/
	https://pypi.org/project/virtualenv/
	https://github.com/pypa/virtualenv/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
SLOT="0"

RDEPEND="
	>=dev-python/distlib-0.3.6[${PYTHON_USEDEP}]
	>=dev-python/filelock-3.4.1[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.4[${PYTHON_USEDEP}]
	>=dev-python/setuptools-63.2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
"
# coverage is used somehow magically in virtualenv, maybe it actually
# tests something useful
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		>=dev-python/pip-22.2.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-freezegun-0.4.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.6.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.1[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
	)
"

# (unpackaged deps)
#distutils_enable_sphinx docs \
#	dev-python/sphinx-argparse \
#	dev-python/sphinx_rtd_theme \
#	dev-python/towncrier
distutils_enable_tests pytest

src_configure() {
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

python_test() {
	local EPYTEST_DESELECT=(
		tests/unit/activation/test_xonsh.py
		tests/unit/seed/embed/test_bootstrap_link_via_app_data.py::test_seed_link_via_app_data
		tests/unit/create/test_creator.py::test_cross_major
		# tests failing without python2 installed
		"tests/unit/create/test_creator.py::test_py_pyc_missing[True-False]"
		"tests/unit/create/test_creator.py::test_py_pyc_missing[False-False]"
	)
	[[ ${EPYTHON} == pypy3 ]] && EPYTEST_DESELECT+=(
		'tests/unit/create/test_creator.py::test_create_no_seed[root-pypy3-posix-copies-isolated]'
		'tests/unit/create/test_creator.py::test_create_no_seed[root-pypy3-posix-copies-global]'
		'tests/unit/create/test_creator.py::test_create_no_seed[venv-pypy3-posix-copies-isolated]'
		'tests/unit/create/test_creator.py::test_create_no_seed[venv-pypy3-posix-copies-global]'
		'tests/unit/create/test_creator.py::test_create_no_seed[root-venv-copies-isolated]'
		'tests/unit/create/test_creator.py::test_create_no_seed[root-venv-copies-global]'
		'tests/unit/create/test_creator.py::test_create_no_seed[venv-venv-copies-isolated]'
		'tests/unit/create/test_creator.py::test_create_no_seed[venv-venv-copies-global]'
		'tests/unit/create/test_creator.py::test_zip_importer_can_import_setuptools'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7.9-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7.9--bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7.10-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7.10--bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7--bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3--bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7.9-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7.9--bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7.10-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7.10--bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7--bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3--bin-]'
	)
	[[ ${EPYTHON} == python3.11 ]] && EPYTEST_DESELECT+=(
		# TODO
		tests/unit/discovery/py_info/test_py_info.py::test_py_info_setuptools
		tests/unit/discovery/py_info/test_py_info.py::test_custom_venv_install_scheme_is_prefered
	)

	epytest
}

pkg_postinst() {
	elog "Please note that while virtualenv package no longer supports"
	elog "Python 2.7, you can still create py2.7 virtualenvs via:"
	elog "  $ virtualenv -p 2.7 ..."
}
