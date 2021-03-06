module test_scalar

use, intrinsic :: iso_fortran_env, only: real32, real64, int32, stderr=>error_unit
use hdf5, only: HSIZE_T
use h5fortran, only: hdf5_file

implicit none (type, external)

contains

subroutine test_scalar_rw(path)
!! create a new HDF5 file
type(hdf5_file) :: h5f
character(*), intent(in) :: path
real(real32), allocatable :: rr1(:)
real(real32) :: rt, r1(4)
integer(int32) :: it, i1(4)
integer(int32), allocatable :: i1t(:)
integer(HSIZE_T), allocatable :: dims(:)

integer :: i

do i = 1,size(i1)
  i1(i) = i
enddo

r1 = i1

call h5f%initialize(path//'/test.h5', status='new',action='w')
!! scalar tests
call h5f%write('/scalar_int', 42_int32)
call h5f%write('/scalar_real', 42._real32)
call h5f%write('/real1',r1)
call h5f%write('/ai1', i1)
call h5f%finalize()

call h5f%initialize(path//'/test.h5', status='old',action='r')
call h5f%read('/scalar_int', it)
call h5f%read('/scalar_real', rt)
if (.not.(rt==it .and. it==42)) then
  write(stderr,*) it,'/=',rt
  error stop 'scalar real / int: not equal 42'
endif

call h5f%shape('/real1',dims)
allocate(rr1(dims(1)))
call h5f%read('/real1',rr1)
if (.not.all(r1 == rr1)) error stop 'real 1-D: read does not match write'

call h5f%shape('/ai1',dims)
allocate(i1t(dims(1)))
call h5f%read('/ai1',i1t)
if (.not.all(i1==i1t)) error stop 'integer 1-D: read does not match write'

if (.not. h5f%filename == path//'/test.h5') then
  write(stderr,*) h5f%filename // ' mismatch filename'
  error stop
endif

call h5f%finalize()

end subroutine test_scalar_rw

end module test_scalar
