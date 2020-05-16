module task
use const
use omp_lib
implicit none
contains

subroutine GetMaxCoordinates(A, mx1, my1, mx2, my2)
    real(mp), intent(in), dimension(:,:) :: A
    real(mp), dimension(:), allocatable :: current_column, max_sum
    real(mp) :: current_sum
    integer(4), intent(out) :: mx1, my1, mx2, my2
    integer(4), dimension(:), allocatable :: x1, y1, x2, y2
    integer(4) :: n, m, L, R, Up, Down, i

    m = size(A, dim = 1) 
    n = size(A, dim = 2) 

    write(*,'(a, i7, i7)') '#', m, n

    allocate(current_column(m), max_sum(n))
    allocate(x1(n), x2(n), y1(n), y2(n))

    !$omp parallel
    !$omp do private(current_column, current_sum, R, Up, Down)
    do L = 1, n
        current_column = A(:, L)

        x1(L) = 1
        y1(L) = L
        x2(L) = 1
        y2(L) = L
        max_sum(L) = A(1, L)

        do R = L, n
            if (R > L) then
                current_column = current_column + A(:, R)
            endif 

            call FindMaxInArray(current_column, current_sum, Up, Down)

            if (current_sum > max_sum(L)) then
                max_sum(L) = current_sum
                x1(L) = Up
                x2(L) = Down
                y1(L) = L
                y2(L) = R
            endif
        end do
    end do
    !$omp end do
    !$omp end parallel

    ! write(*,*) '# ms', max_sum
    ! write(*,*) '# x1', x1
    ! write(*,*) '# y1', y1
    ! write(*,*) '# x2', x2
    ! write(*,*) '# y2', y2

    ! write(*,*) '# maxloc:', maxloc(max_sum)
    i = maxloc(max_sum, dim = 1)
    mx1 = x1(i)
    my1 = y1(i)
    mx2 = x2(i)
    my2 = y2(i)

    deallocate(current_column, max_sum, x1, x2, y1, y2)
end subroutine


subroutine FindMaxInArray(A, Summ, Up, Down)
    real(mp), intent(in), dimension(:) :: A
    integer(4), intent(out) :: Up, Down
    real(mp), intent(out) :: Summ
    real(mp) :: cur_sum
    integer(4) :: minus_pos, i

    Summ = A(1)
    Up = 1
    Down = 1
    cur_sum = 0
    minus_pos = 0

    do i = 1, size(A)
        cur_sum = cur_sum + A(i)
        if (cur_sum > Summ) then
            Summ = cur_sum
            Up = minus_pos + 1
            Down = i
        endif
        
        if (cur_sum < 0) then
            cur_sum = 0
            minus_pos = i
        endif
    enddo
end subroutine

end module
