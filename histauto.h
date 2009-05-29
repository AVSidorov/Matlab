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

#ifndef __histauto_h
#define __histauto_h 1

#ifdef __cplusplus
extern "C" {
#endif

#include "libmatlb.h"

extern void InitializeModule_histauto(void);
extern void TerminateModule_histauto(void);
extern _mexLocalFunctionTable _local_function_table_histauto;

extern mxArray * mlfHistauto(mxArray * FileName);
extern void mlxHistauto(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#ifdef __cplusplus
}
#endif

#endif
