fc = meson.get_compiler('fortran')
os = host_machine.system()

quiet = fc.get_supported_arguments(['-w', '-Wno-compare-reals', '-Wno-maybe-uninitialized'])

# -- stub for future > 7-D
# f08rank15 = fc.links('real, dimension(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1) :: x; end', name: 'f2008 rank 15')

#== find HDF5

# use_static = get_option('default_library') == 'static'
# NOTE: static: parameter is too strict for now. Works more reliably without this parameter
hdf5_inc = []

hdf5 = dependency('hdf5', language : 'fortran', required: false, disabler: true)
hdf5_ok = fc.links(files('../src/tests/test_minimal.f90'), dependencies: hdf5, name: 'HDF5')

if not hdf5_ok
message('HDF5 fallback find')
# falling back due to broken pkg-config, need to add cmake components to Meson
hdf5 = []
hdf5_root = get_option('hdf5_root')
if hdf5_root == ''
  hdf5_root = []
else
  hdf5_inc = include_directories(hdf5_root / 'include', hdf5_root/ 'include/shared')
endif

foreach l : ['hdf5_hl_fortran', 'hdf5hl_fortran', 'hdf5_hl', 'hdf5', 'szip', 'zlib']
  h = fc.find_library(l, dirs: hdf5_root / 'lib', required: false)
  if h.found()
    hdf5 += h
  endif
endforeach

hdf5_ok = fc.links(files('../src/tests/test_minimal.f90'), dependencies: hdf5, include_directories: hdf5_inc, name: 'HDF5')
endif

hdf5_libfiles = []
if not hdf5_ok and fc.get_id() == 'intel-cl'
  message('intel-cl fallback')
  # manual filenames due to bad libs from HDF Group
  hdf5 = []
  foreach l : ['hdf5_hl_fortran.lib', 'hdf5_fortran.lib', 'hdf5_hl.lib', 'hdf5.lib', 'szip.lib', 'zlib.lib']
    lib = hdf5_root / 'lib' / l
    hdf5_libfiles += lib
  endforeach
  hdf5_ok = true
endif

if meson.is_subproject()
  if not hdf5_ok
    hdf5 = disabler()
  endif
else
  assert(hdf5_ok, 'h5fortran requires HDF5 library')
endif
