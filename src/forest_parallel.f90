module forest_parallel
!------------------------------------------------------------------------------
!   Module for fitting and predicting on a random forest classifier using
!       parallel computing.
!   Author: Bertram Ieong
!------------------------------------------------------------------------------

use utils
use tree_utils
use sort_utils
use impurity_measures
use classification

implicit none


contains


subroutine bootstrap(Y, X, numsamps, Y_boot, X_boot)
    ! Returns a bootstrapped sample of the data.

    ! --- Declare Variables ---
    ! --- Input/Output Variables ---
    integer, intent(in) :: Y(:)
    real(dp), intent(in) :: X(:,:)
    integer, intent(in) :: numsamps
    integer, intent(out) :: Y_boot(numsamps)
    real(dp), allocatable, intent(out) :: X_boot(:,:)

    ! Private Variables
    real(dp) :: randarr(numsamps)
    integer :: rand_obs_num(numsamps)
    integer :: N, P
    integer :: i

    ! Debugging variables
    character(len=50) :: fmt
    logical, parameter :: verbose = .true.


    ! --- setup ---
    ! Get data size
    N = size(X,1)
    P = size(X,2)

    if(N /= size(Y)) stop "Data dimensions do not match."

    ! allocate memory to allocatable arrays
    allocate(X_boot(numsamps,P))


    ! --- create bootstrapped sample ---
    call random_seed()  ! TODO: look into making this more random
    call random_number(randarr)

    rand_obs_num = 1 + int(randarr * ((N - 1) + 1))  ! get array of random integers in [1,N]

    do i=1,numsamps
        Y_boot(i) = Y(rand_obs_num(i))
        X_boot(i,:) = X(rand_obs_num(i),:)
    enddo

    if(verbose .and. P==1) then
        fmt = '(i5, f10.5, i5, f10.5)'
        do i=1,N
            print fmt, Y(i), X(i,1), Y_boot(i), X_boot(i,1)
        enddo
    endif

end subroutine



function grow_forest(Y, X, min_node_obs, max_depth, numsamps, numvars, numboots) result(fittedforest)
    ! --- Declare Variables ---
    ! --- Input/Output Variables ---
    integer, intent(in) :: Y(:)
    real(dp), intent(in) :: X(:,:)
    integer, intent(in) :: min_node_obs, max_depth
    integer, intent(in) :: numsamps, numvars, numboots
    type (node) :: fittedforest(numboots)

    ! Private Variables
    integer :: N, P
    integer :: treenum

    integer :: Y_boot(numsamps)
    real(dp), allocatable :: X_boot(:,:)
    logical, allocatable :: variables_selected(:)
    integer :: variables_selected_nums(numvars)
    real(dp), allocatable :: randarr(:)

    integer :: i, j, idx


    ! --- setup ---
    ! Get data size
    N = size(X,1)
    P = size(X,2)

    ! input checks
    if(N /= size(Y))    stop "Data dimensions do not match."
    if(min_node_obs<=0) stop
    if(max_depth<0)     stop
    if(numsamps<=0)     stop
    if(numvars<=0)      stop
    if(numboots<=0)     stop

    ! allocate memory to allocatable arrays
    allocate(X_boot(numsamps,P))
    allocate(variables_selected(P))
    allocate(randarr(P))


    ! --- grow forest ---
    do treenum=1,numboots
        ! -- randomly select variables for this tree without replacement --
        ! draw indices of variables without replacement that can be split on
        call random_seed()  ! TODO: look into making this more random
        call random_number(randarr)

        do i=1,numvars
            idx = minloc(randarr, dim=1)
            variables_selected_nums(i) = idx
            randarr(idx) = huge(1_dp)
        enddo

        ! turn this list of indices into a logical array
        variables_selected = .false.
        do j=1,P
            variables_selected(variables_selected_nums(j)) = .true.
        enddo

        ! -- create bootstrapped data --
        call bootstrap(Y, X, numsamps, Y_boot, X_boot)

        ! -- fit tree to the bootstrapped data and select variables --
        fittedforest(treenum) = grow(Y_boot, X_boot, min_node_obs, max_depth, &
            opt_splittable=variables_selected)
    enddo

end function



function test_bootstrap_01() result(exitflag)
    integer :: exitflag


    exitflag = -1

    print *, " "
    print *, "---------- Running Test Function test_bootstrap_01 -------------------"


    print *, "Test successful if test executed without error."

    exitflag = 0

end function



end module forest_parallel