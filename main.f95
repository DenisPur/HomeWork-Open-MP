program main
use const
use task
    implicit none
    real(mp), allocatable :: A(:,:)
    integer :: n, x1, y1, x2, y2

    open(1, file = './data.dat')
    read(1,'(2x, i12)') n
    allocate( A(n,n) )

    call GetMaxCoordinates(A, x1, y1, x2, y2)

    write(*,*) x1, y1, new_line('c'), x2, y2

end program
