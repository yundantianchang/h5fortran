test_minimal = executable('test_minimal',
  sources: ['test_minimal.f90'],
  include_directories: hdf5_inc,
  fortran_args: hdf5_libfiles,
  dependencies: hdf5_interface)
test('minimal', test_minimal,
  args: meson.current_build_dir(),
  suite: 'h5basic',
  timeout: 10)

test_error = executable('test_error',
  sources: ['test_error.f90'],
  include_directories: hdf5_inc,
  fortran_args: hdf5_libfiles,
  dependencies: hdf5_interface)
test('errors', test_error,
  args: meson.current_build_dir(),
  suite: 'h5basic',
  timeout: 10)


testh5 = executable('test_hdf5',
  sources: ['test_hdf5_ifc.f90'],
  include_directories: hdf5_inc,
  fortran_args: [hdf5_libfiles, quiet],
  dependencies: hdf5_interface)
test('h5interface', testh5,
  args: meson.current_build_dir(),
  is_parallel: false,
  suite: 'h5basic',
  timeout: 15)

shapes = executable('shapes_hdf5',
  sources: ['test_shape.f90'],
  include_directories: hdf5_inc,
  fortran_args: [hdf5_libfiles, quiet],
  dependencies: hdf5_interface)

testfn = meson.current_build_dir()/'p5.h5'

test('Shapes', shapes,
  args: [testfn,'/group69/flux_node'],
  is_parallel: false,
  suite: 'h5basic',
  priority: -100,
  timeout: 15)

if get_option('test_shaky')
python = find_program('python')

test('CheckShapes', python,
  args: [files('test_shape.py'), testfn, '/group69/flux_node'],
  is_parallel: false,
  suite: 'h5shaky',
  priority: -100,
  timeout: 30)
endif