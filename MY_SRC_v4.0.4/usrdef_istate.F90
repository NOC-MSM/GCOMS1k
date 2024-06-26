MODULE usrdef_istate
   !!======================================================================
   !!                   ***  MODULE  usrdef_istate   ***
   !!
   !!                     ===  GYRE configuration  ===
   !!
   !! User defined : set the initial state of a user configuration
   !!======================================================================
   !! History :  NEMO ! 2016-03  (S. Flavoni) Original code
   !!----------------------------------------------------------------------

   !!----------------------------------------------------------------------
   !!  usr_def_istate : initial state in Temperature and salinity
   !!----------------------------------------------------------------------
   USE par_oce        ! ocean space and time domain
   USE phycst         ! physical constants
   USE wet_dry        ! Wetting and drying
   USE dom_oce
   !
   USE in_out_manager ! I/O manager
   USE lib_mpp        ! MPP library
   
   IMPLICIT NONE
   PRIVATE

   PUBLIC   usr_def_istate   ! called in istate.F90

   !!----------------------------------------------------------------------
   !! NEMO/OPA 4.0 , NEMO Consortium (2016)
   !! $Id$ 
   !! Software governed by the CeCILL licence     (NEMOGCM/NEMO_CeCILL.txt)
   !!----------------------------------------------------------------------
CONTAINS
  
   SUBROUTINE usr_def_istate( pdept, ptmask, pts, pu, pv, pssh )
      !!----------------------------------------------------------------------
      !!                   ***  ROUTINE usr_def_istate  ***
      !! 
      !! ** Purpose :   Initialization of the dynamics and tracers
      !!                Here GYRE configuration example : (double gyre with rotated domain)
      !!
      !! ** Method  : - set temprature field
      !!              - set salinity   field
      !!----------------------------------------------------------------------
      REAL(wp), DIMENSION(jpi,jpj,jpk)     , INTENT(in   ) ::   pdept   ! depth of t-point               [m]
      REAL(wp), DIMENSION(jpi,jpj,jpk)     , INTENT(in   ) ::   ptmask  ! t-point ocean mask             [m]
      REAL(wp), DIMENSION(jpi,jpj,jpk,jpts), INTENT(  out) ::   pts     ! T & S fields      [Celsius ; g/kg]
      REAL(wp), DIMENSION(jpi,jpj,jpk)     , INTENT(  out) ::   pu      ! i-component of the velocity  [m/s] 
      REAL(wp), DIMENSION(jpi,jpj,jpk)     , INTENT(  out) ::   pv      ! j-component of the velocity  [m/s] 
      REAL(wp), DIMENSION(jpi,jpj)         , INTENT(  out) ::   pssh    ! sea-surface height
      !
      INTEGER :: ji, jj, jk  ! dummy loop indices
      !!----------------------------------------------------------------------
      !
      IF(lwp) WRITE(numout,*)
      IF(lwp) WRITE(numout,*) 'usr_def_istate : analytical definition of initial state '
      IF(lwp) WRITE(numout,*) '~~~~~~~~~~~~~~   Ocean at rest, with an horizontally uniform T and S profiles'
      !
      pu  (:,:,:) = 0._wp        ! ocean at rest
      pv  (:,:,:) = 0._wp
      pssh(:,:)   = 0._wp
      !
      DO jk = 1, jpk             ! horizontally uniform T & S profiles
         DO jj = 1, jpj
            DO ji = 1, jpi
               pts(ji,jj,jk,jp_tem) = 10.0* ptmask(ji,jj,jk)
               pts(ji,jj,jk,jp_sal) = 33.0 * ptmask(ji,jj,jk)
            END DO
         END DO
      END DO
      
! subtract the height of z=0 above the geoid (this allows z = 0 to be higher than all points that may become wet)   
!      if (ll_wd) then
      pssh(:,:) =  -ssh_ref

      !
      ! Apply minimum wetdepth criterion
      !
      do jj = 1,jpj
         do ji = 1,jpi
            IF( ht_0(ji,jj) + pssh(ji,jj)  < rn_wdmin1 ) THEN
               pssh(ji,jj) = ptmask(ji,jj,1)*( rn_wdmin1 - (ht_0(ji,jj)) )
            ENDIF
         end do
      end do
!      endif

      !   
   END SUBROUTINE usr_def_istate

   !!======================================================================
END MODULE usrdef_istate
