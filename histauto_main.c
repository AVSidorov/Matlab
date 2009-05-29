/*
 * MATLAB Compiler: 3.0
 * Date: Mon Jun 26 03:29:21 2006
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-m" "-W" "main" "-L"
 * "C" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "Histauto.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "libmatlb.h"
#include "histauto.h"
#include "libmmfile.h"

extern _mex_information _main_info;

static mexFunctionTableEntry function_table[1]
  = { { "histauto", mlxHistauto, 1, 1, &_local_function_table_histauto } };

static _mexInitTermTableEntry init_term_table[2]
  = { { libmmfileInitialize, libmmfileTerminate },
      { InitializeModule_histauto, TerminateModule_histauto } };

_mex_information _main_info
  = { 1, 1, function_table, 0, NULL, 0, NULL, 2, init_term_table };

/*
 * The function "main" is a Compiler-generated main wrapper, suitable for
 * building a stand-alone application.  It calls a library function to perform
 * initialization, call the main function, and perform library termination.
 */
int main(int argc, const char * * argv) {
    return mclMain(argc, argv, mlxHistauto, 1, &_main_info);
}
