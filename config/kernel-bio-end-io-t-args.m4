dnl #
dnl # 2.6.24 API change
dnl # Size argument dropped from bio_endio and bi_end_io, because the
dnl # bi_end_io is only called once now when the request is complete.
dnl # There is no longer any need for a size argument.  This also means
dnl # that partial IO's are no longer possibe and the end_io callback
dnl # should not check bi->bi_size.  Finally, the return type was updated
dnl # to void.
dnl #
AC_DEFUN([ZFS_AC_KERNEL_BIO_END_IO_T_ARGS], [
	AC_MSG_CHECKING([whether bio_end_io_t wants 2 args])
	tmp_flags="$EXTRA_KCFLAGS"
	EXTRA_KCFLAGS="-Werror"
	ZFS_LINUX_TRY_COMPILE([
		#include <linux/bio.h>
	],[
		void (*wanted_end_io)(struct bio *, int) = NULL;
		bio_end_io_t *local_end_io;

		local_end_io = wanted_end_io;
	],[
		AC_MSG_RESULT(yes)
		AC_DEFINE(HAVE_2ARGS_BIO_END_IO_T, 1,
		          [bio_end_io_t wants 2 args])
	],[
		AC_MSG_RESULT(no)
	])
	EXTRA_KCFLAGS="$tmp_flags"
])
