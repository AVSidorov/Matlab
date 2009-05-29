/*
 * MATLAB Compiler: 3.0
 * Date: Mon Jun 26 03:29:51 2006
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-m" "-W" "main" "-L"
 * "C" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "Peaks3auto.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __peaks3auto_h
#define __peaks3auto_h 1

#ifdef __cplusplus
extern "C" {
#endif

#include "libmatlb.h"

extern void InitializeModule_peaks3auto(void);
extern void TerminateModule_peaks3auto(void);
extern _mexLocalFunctionTable _local_function_table_peaks3auto;

extern mxArray * mlfPeaks3auto(mxArray * * HistA,
                               mxArray * FileName,
                               mxArray * Dialog,
                               mxArray * MaxSignal);
extern void mlxPeaks3auto(int nlhs,
                          mxArray * plhs[],
                          int nrhs,
                          mxArray * prhs[]);

#ifdef __cplusplus
}
#endif

#endif
