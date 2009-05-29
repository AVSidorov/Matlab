/*
 * MATLAB Compiler: 3.0
 * Date: Mon Jun 26 03:29:21 2006
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-m" "-W" "main" "-L"
 * "C" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "Histauto.m" 
 */
#include "histauto.h"
#include "mwservices.h"
#include "libmatlbm.h"
#include "libmmfile.h"

static double _array1_[2] = { 10.0, 1000.0 };
static mxArray * _mxarray0_;
static mxArray * _mxarray2_;
static mxArray * _mxarray3_;
static mxArray * _mxarray4_;
static mxArray * _mxarray5_;
static mxArray * _mxarray6_;
static mxArray * _mxarray7_;
static mxArray * _mxarray8_;
static mxArray * _mxarray9_;
static mxArray * _mxarray10_;

static mxChar _array12_[1] = { 'r' };
static mxArray * _mxarray11_;
static mxArray * _mxarray13_;

static mxChar _array15_[2] = { '%', 'g' };
static mxArray * _mxarray14_;
static mxArray * _mxarray16_;
static mxArray * _mxarray17_;
static mxArray * _mxarray18_;
static mxArray * _mxarray19_;
static mxArray * _mxarray20_;
static mxArray * _mxarray21_;
static mxArray * _mxarray22_;
static mxArray * _mxarray23_;
static mxArray * _mxarray24_;
static mxArray * _mxarray25_;

static mxChar _array27_[23] = { '-', '-', '-', '-', '-', '-', '-', '-',
                                '-', '-', '-', '-', '-', '-', '-', '-',
                                '-', '-', '-', '-', '-', 0x005c, 'n' };
static mxArray * _mxarray26_;

static mxChar _array29_[70] = { 'P', 'e', 'a', 'k', 's', ' ', 'a', 'r', 'e',
                                ' ', 's', 'e', 'l', 'e', 'c', 't', 'e', 'd',
                                ' ', 'w', 'i', 't', 'h', 'i', 'n', ' ', 'p',
                                'r', 'e', 'c', 'e', 'e', 'd', 'i', 'n', 'g',
                                ' ', 'i', 'n', 't', 'e', 'r', 'v', 'a', 'l',
                                ' ', 'f', 'r', 'o', 'm', ' ', '%', '6', '.',
                                '4', 'f', ' ', 't', 'o', ' ', '%', '6', '.',
                                '4', 'f', ' ', 'u', 's', 0x005c, 'n' };
static mxArray * _mxarray28_;

static mxChar _array31_[30] = { 'T', 'h', 'e', ' ', 'n', 'u', 'm', 'b',
                                'e', 'r', ' ', 'o', 'f', ' ', 'p', 'e',
                                'a', 'k', 's', ' ', '=', ' ', ' ', '%',
                                '5', '.', '0', 'f', 0x005c, 'n' };
static mxArray * _mxarray30_;

static mxChar _array33_[33] = { 'T', 'h', 'e', ' ', 'p', 'e', 'r', 'i', 'o',
                                'd', ' ', 'o', 'f', ' ', 'p', 'e', 'a', 'k',
                                's', ' ', '=', ' ', ' ', '%', '6', '.', '4',
                                'f', ' ', 'm', 's', 0x005c, 'n' };
static mxArray * _mxarray32_;
static mxArray * _mxarray34_;

static mxChar _array36_[59] = { 'R', 'e', 's', 'o', 'l', 'u', 't', 'i', 'o',
                                'n', ' ', 'i', 'n', ' ', 't', 'h', 'e', ' ',
                                'p', 'e', 'a', 'k', ' ', 'a', 'm', 'p', 'l',
                                'i', 't', 'u', 'd', 'e', ' ', 'h', 'i', 's',
                                't', 'o', 'g', 'r', 'a', 'm', '=', ' ', ' ',
                                '%', '3', '.', '3', 'f', ' ', 'c', 'o', 'u',
                                'n', 't', 's', 0x005c, 'n' };
static mxArray * _mxarray35_;

static mxChar _array38_[54] = { 'R', 'e', 's', 'o', 'l', 'u', 't', 'i',
                                'o', 'n', ' ', 'i', 'n', ' ', 't', 'h',
                                'e', ' ', 'p', 'e', 'a', 'k', ' ', 'i',
                                'n', 't', 'e', 'r', 'v', 'a', 'l', ' ',
                                'h', 'i', 's', 't', 'o', 'g', 'r', 'a',
                                'm', '=', ' ', ' ', '%', '3', '.', '3',
                                'f', ' ', 'u', 's', 0x005c, 'n' };
static mxArray * _mxarray37_;

static mxChar _array40_[55] = { 'E', 'x', 'p', 'e', 'c', 't', 'e', 'd',
                                ' ', 'n', 'u', 'm', 'b', 'e', 'r', ' ',
                                'o', 'f', ' ', 'd', 'o', 'u', 'b', 'l',
                                'e', ' ', 'p', 'e', 'a', 'k', 's', ' ',
                                'f', 'o', 'r', ' ', '0', '.', '0', '2',
                                '5', ' ', 'u', 's', ' ', '=', ' ', '%',
                                '3', '.', '3', 'f', ' ', 0x005c, 'n' };
static mxArray * _mxarray39_;

static mxChar _array42_[55] = { 'E', 'x', 'p', 'e', 'c', 't', 'e', 'd',
                                ' ', 'n', 'u', 'm', 'b', 'e', 'r', ' ',
                                'o', 'f', ' ', 'd', 'o', 'u', 'b', 'l',
                                'e', ' ', 'p', 'e', 'a', 'k', 's', ' ',
                                'f', 'o', 'r', ' ', '%', '5', '.', '3',
                                'f', ' ', 'u', 's', ' ', '=', ' ', '%',
                                '5', '.', '3', 'f', ' ', 0x005c, 'n' };
static mxArray * _mxarray41_;

static mxChar _array44_[55] = { 'E', 'x', 'p', 'e', 'c', 't', 'e', 'd',
                                ' ', 'n', 'u', 'm', 'b', 'e', 'r', ' ',
                                'o', 'f', ' ', 't', 'r', 'i', 'p', 'l',
                                'e', ' ', 'p', 'e', 'a', 'k', 's', ' ',
                                'f', 'o', 'r', ' ', '%', '5', '.', '3',
                                'f', ' ', 'u', 's', ' ', '=', ' ', '%',
                                '5', '.', '3', 'f', ' ', 0x005c, 'n' };
static mxArray * _mxarray43_;

static mxChar _array46_[23] = { '=', '=', '=', '=', '=', '=', '=', '=',
                                '=', '=', '=', '=', '=', '=', '=', '=',
                                '=', '=', '=', '=', '=', 0x005c, 'n' };
static mxArray * _mxarray45_;

static mxChar _array48_[4] = { 'p', 'e', 'a', 'k' };
static mxArray * _mxarray47_;

static mxChar _array50_[1] = { 'A' };
static mxArray * _mxarray49_;

static mxChar _array52_[1] = { '.' };
static mxArray * _mxarray51_;

static mxChar _array54_[2] = { 'A', 'v' };
static mxArray * _mxarray53_;

static mxChar _array56_[5] = { '%', '3', '.', '1', 'f' };
static mxArray * _mxarray55_;

static mxChar _array58_[3] = { 'm', 's', '.' };
static mxArray * _mxarray57_;

static mxChar _array60_[1] = { 'C' };
static mxArray * _mxarray59_;

static mxChar _array62_[6] = { 'A', 'm', 'p', 'l', 'A', 'v' };
static mxArray * _mxarray61_;

static mxChar _array64_[6] = { 'm', 's', '.', 'd', 'a', 't' };
static mxArray * _mxarray63_;

static mxChar _array66_[7] = { 'C', 'h', 'a', 'r', 'g', 'A', 'v' };
static mxArray * _mxarray65_;

static mxChar _array68_[1] = { 'S' };
static mxArray * _mxarray67_;

static mxChar _array70_[1] = { 'w' };
static mxArray * _mxarray69_;

static mxChar _array72_[7] = { 'A', 'm', 'p', 'l', ' ', ' ', ' ' };
static mxArray * _mxarray71_;

static mxChar _array74_[4] = { ' ', 'k', 'e', 'V' };
static mxArray * _mxarray73_;

static mxChar _array76_[2] = { ' ', 'N' };
static mxArray * _mxarray75_;

static mxChar _array78_[5] = { '%', '5', '.', '2', 'f' };
static mxArray * _mxarray77_;

static mxChar _array80_[5] = { 'm', 's', ' ', 'd', 'N' };
static mxArray * _mxarray79_;

static mxChar _array82_[2] = { 0x005c, 'n' };
static mxArray * _mxarray81_;

static mxChar _array84_[6] = { '%', '7', '.', '2', 'f', ' ' };
static mxArray * _mxarray83_;

static mxChar _array86_[18] = { '%', '7', '.', '2', 'f', ' ', '%', '3', '.',
                                '0', 'f', ' ', '%', '5', '.', '2', 'f', ' ' };
static mxArray * _mxarray85_;

static mxChar _array88_[7] = { 'C', 'h', 'a', 'r', 'g', 'e', ' ' };
static mxArray * _mxarray87_;

void InitializeModule_histauto(void) {
    _mxarray0_ = mclInitializeDoubleVector(1, 2, _array1_);
    _mxarray2_ = mclInitializeDouble(.03);
    _mxarray3_ = mclInitializeDouble(.4);
    _mxarray4_ = mclInitializeDouble(.02);
    _mxarray5_ = mclInitializeDouble(20.0);
    _mxarray6_ = mclInitializeDouble(4096.0);
    _mxarray7_ = mclInitializeDouble(.1);
    _mxarray8_ = mclInitializeDouble(30.0);
    _mxarray9_ = mclInitializeDouble(.025);
    _mxarray10_ = mclInitializeCharVector(0, 0, (mxChar *)NULL);
    _mxarray11_ = mclInitializeString(1, _array12_);
    _mxarray13_ = mclInitializeDoubleVector(0, 0, (double *)NULL);
    _mxarray14_ = mclInitializeString(2, _array15_);
    _mxarray16_ = mclInitializeDouble(8.0);
    _mxarray17_ = mclInitializeDouble(1.0);
    _mxarray18_ = mclInitializeDouble(2.0);
    _mxarray19_ = mclInitializeDouble(3.0);
    _mxarray20_ = mclInitializeDouble(14600.0);
    _mxarray21_ = mclInitializeDouble(5.0);
    _mxarray22_ = mclInitializeDouble(6.0);
    _mxarray23_ = mclInitializeDouble(5246.0);
    _mxarray24_ = mclInitializeDouble(0.0);
    _mxarray25_ = mclInitializeDouble(-1.0);
    _mxarray26_ = mclInitializeString(23, _array27_);
    _mxarray28_ = mclInitializeString(70, _array29_);
    _mxarray30_ = mclInitializeString(30, _array31_);
    _mxarray32_ = mclInitializeString(33, _array33_);
    _mxarray34_ = mclInitializeDouble(1000.0);
    _mxarray35_ = mclInitializeString(59, _array36_);
    _mxarray37_ = mclInitializeString(54, _array38_);
    _mxarray39_ = mclInitializeString(55, _array40_);
    _mxarray41_ = mclInitializeString(55, _array42_);
    _mxarray43_ = mclInitializeString(55, _array44_);
    _mxarray45_ = mclInitializeString(23, _array46_);
    _mxarray47_ = mclInitializeString(4, _array48_);
    _mxarray49_ = mclInitializeString(1, _array50_);
    _mxarray51_ = mclInitializeString(1, _array52_);
    _mxarray53_ = mclInitializeString(2, _array54_);
    _mxarray55_ = mclInitializeString(5, _array56_);
    _mxarray57_ = mclInitializeString(3, _array58_);
    _mxarray59_ = mclInitializeString(1, _array60_);
    _mxarray61_ = mclInitializeString(6, _array62_);
    _mxarray63_ = mclInitializeString(6, _array64_);
    _mxarray65_ = mclInitializeString(7, _array66_);
    _mxarray67_ = mclInitializeString(1, _array68_);
    _mxarray69_ = mclInitializeString(1, _array70_);
    _mxarray71_ = mclInitializeString(7, _array72_);
    _mxarray73_ = mclInitializeString(4, _array74_);
    _mxarray75_ = mclInitializeString(2, _array76_);
    _mxarray77_ = mclInitializeString(5, _array78_);
    _mxarray79_ = mclInitializeString(5, _array80_);
    _mxarray81_ = mclInitializeString(2, _array82_);
    _mxarray83_ = mclInitializeString(6, _array84_);
    _mxarray85_ = mclInitializeString(18, _array86_);
    _mxarray87_ = mclInitializeString(7, _array88_);
}

void TerminateModule_histauto(void) {
    mxDestroyArray(_mxarray87_);
    mxDestroyArray(_mxarray85_);
    mxDestroyArray(_mxarray83_);
    mxDestroyArray(_mxarray81_);
    mxDestroyArray(_mxarray79_);
    mxDestroyArray(_mxarray77_);
    mxDestroyArray(_mxarray75_);
    mxDestroyArray(_mxarray73_);
    mxDestroyArray(_mxarray71_);
    mxDestroyArray(_mxarray69_);
    mxDestroyArray(_mxarray67_);
    mxDestroyArray(_mxarray65_);
    mxDestroyArray(_mxarray63_);
    mxDestroyArray(_mxarray61_);
    mxDestroyArray(_mxarray59_);
    mxDestroyArray(_mxarray57_);
    mxDestroyArray(_mxarray55_);
    mxDestroyArray(_mxarray53_);
    mxDestroyArray(_mxarray51_);
    mxDestroyArray(_mxarray49_);
    mxDestroyArray(_mxarray47_);
    mxDestroyArray(_mxarray45_);
    mxDestroyArray(_mxarray43_);
    mxDestroyArray(_mxarray41_);
    mxDestroyArray(_mxarray39_);
    mxDestroyArray(_mxarray37_);
    mxDestroyArray(_mxarray35_);
    mxDestroyArray(_mxarray34_);
    mxDestroyArray(_mxarray32_);
    mxDestroyArray(_mxarray30_);
    mxDestroyArray(_mxarray28_);
    mxDestroyArray(_mxarray26_);
    mxDestroyArray(_mxarray25_);
    mxDestroyArray(_mxarray24_);
    mxDestroyArray(_mxarray23_);
    mxDestroyArray(_mxarray22_);
    mxDestroyArray(_mxarray21_);
    mxDestroyArray(_mxarray20_);
    mxDestroyArray(_mxarray19_);
    mxDestroyArray(_mxarray18_);
    mxDestroyArray(_mxarray17_);
    mxDestroyArray(_mxarray16_);
    mxDestroyArray(_mxarray14_);
    mxDestroyArray(_mxarray13_);
    mxDestroyArray(_mxarray11_);
    mxDestroyArray(_mxarray10_);
    mxDestroyArray(_mxarray9_);
    mxDestroyArray(_mxarray8_);
    mxDestroyArray(_mxarray7_);
    mxDestroyArray(_mxarray6_);
    mxDestroyArray(_mxarray5_);
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray3_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * Mhistauto(int nargout_, mxArray * FileName);

_mexLocalFunctionTable _local_function_table_histauto
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfHistauto" contains the normal interface for the "histauto"
 * M-function from file "e:\scn\efield\matlab\histauto.m" (lines 1-196). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
mxArray * mlfHistauto(mxArray * FileName) {
    int nargout = 1;
    mxArray * HistA = NULL;
    mlfEnterNewContext(0, 1, FileName);
    HistA = Mhistauto(nargout, FileName);
    mlfRestorePreviousContext(0, 1, FileName);
    return mlfReturnValue(HistA);
}

/*
 * The function "mlxHistauto" contains the feval interface for the "histauto"
 * M-function from file "e:\scn\efield\matlab\histauto.m" (lines 1-196). The
 * feval function calls the implementation version of histauto through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxHistauto(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: histauto Line: 1 Column:"
            " 1 The function \"histauto\" was called with m"
            "ore than the declared number of outputs (1)."),
          NULL);
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: histauto Line: 1 Column:"
            " 1 The function \"histauto\" was called with m"
            "ore than the declared number of inputs (1)."),
          NULL);
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 1 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 1; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 1, mprhs[0]);
    mplhs[0] = Mhistauto(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}

/*
 * The function "Mhistauto" is the implementation version of the "histauto"
 * M-function from file "e:\scn\efield\matlab\histauto.m" (lines 1-196). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function HistA=Histauto(FileName);
 */
static mxArray * Mhistauto(int nargout_, mxArray * FileName) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_histauto);
    mxArray * HistA = NULL;
    mxArray * HeadOfFile = NULL;
    mxArray * HistCFile = NULL;
    mxArray * HistAFile = NULL;
    mxArray * HistP = NULL;
    mxArray * HistIntervalP = NULL;
    mxArray * PeakPRange = NULL;
    mxArray * MinP = NULL;
    mxArray * MaxP = NULL;
    mxArray * MeanP = NULL;
    mxArray * Poisson = NULL;
    mxArray * test = NULL;
    mxArray * ZeroBool = NULL;
    mxArray * HistT = NULL;
    mxArray * HistIntervalT = NULL;
    mxArray * PeakTRange = NULL;
    mxArray * MinT = NULL;
    mxArray * MaxT = NULL;
    mxArray * HistCh = NULL;
    mxArray * HistNCh = NULL;
    mxArray * HistIntervalCh = NULL;
    mxArray * PeakChRange = NULL;
    mxArray * MinCh = NULL;
    mxArray * MaxCh = NULL;
    mxArray * MaxChN = NULL;
    mxArray * HistBool = NULL;
    mxArray * i = NULL;
    mxArray * HistNA = NULL;
    mxArray * HistIntervalA = NULL;
    mxArray * PeakAmplRange = NULL;
    mxArray * MinAmpl = NULL;
    mxArray * MaxAmpl = NULL;
    mxArray * MaxAmplN = NULL;
    mxArray * InsideInterval = NULL;
    mxArray * n = NULL;
    mxArray * PreccedInterv = NULL;
    mxArray * OutLimits = NULL;
    mxArray * CenterOfInterval = NULL;
    mxArray * EndInterval = NULL;
    mxArray * StartInterval = NULL;
    mxArray * TimeSpectralIntervalNum = NULL;
    mxArray * TimeSpectralInterval = NULL;
    mxArray * MaxSignal = NULL;
    mxArray * MaxAmp = NULL;
    mxArray * NPeaks = NULL;
    mxArray * MaxTime = NULL;
    mxArray * MinTime = NULL;
    mxArray * Period = NULL;
    mxArray * peaks = NULL;
    mxArray * line = NULL;
    mxArray * fid = NULL;
    mxArray * ans = NULL;
    mxArray * HistFolder = NULL;
    mxArray * tau = NULL;
    mxArray * HistInterval = NULL;
    mxArray * AveragN = NULL;
    mxArray * MaxCombined = NULL;
    mxArray * MinInterval = NULL;
    mxArray * MinAmp = NULL;
    mxArray * MaxDuration = NULL;
    mxArray * MinDuration = NULL;
    mxArray * MaxFront = NULL;
    mxArray * MinFront = NULL;
    mxArray * SelectedInterval = NULL;
    mxArray * IntervalBool = NULL;
    mclCopyArray(&FileName);
    /*
     * % HistA=Hist(FileName);  makes histograms from a peak file.
     * 
     * IntervalBool=false; % if IntervalBool then select only peaks within the SelectedInterval
     */
    mlfAssign(&IntervalBool, mlfFalse(NULL));
    /*
     * SelectedInterval=[10,1000]; % selected peaks within this preceeding interval.  
     */
    mlfAssign(&SelectedInterval, _mxarray0_);
    /*
     * 
     * MinFront=0.03;    % minimal front edge of peaks, us
     */
    mlfAssign(&MinFront, _mxarray2_);
    /*
     * MaxFront=0.4;     % maximal front edge of peaks, us
     */
    mlfAssign(&MaxFront, _mxarray3_);
    /*
     * MinDuration=0.02; % minimal peak duration, us. Shorter peaks are eliminated 
     */
    mlfAssign(&MinDuration, _mxarray4_);
    /*
     * MaxDuration=20.0; % maximal peak duration, us. Longer peaks are eliminated. 
     */
    mlfAssign(&MaxDuration, _mxarray5_);
    /*
     * 
     * MinAmp=4096;      % Minimal peak amplitude 
     */
    mlfAssign(&MinAmp, _mxarray6_);
    /*
     * MinInterval=0.1;  % minimum peak-to-peak interval,  us
     */
    mlfAssign(&MinInterval, _mxarray7_);
    /*
     * MaxCombined=30;   % maximum combined peaks allowed for MinInterval
     */
    mlfAssign(&MaxCombined, _mxarray8_);
    /*
     * AveragN=20;       % Averaged number of peaks in histogram interval  
     */
    mlfAssign(&AveragN, _mxarray5_);
    /*
     * HistInterval=20;  % count interval for amplitude and cahrge histograms
     */
    mlfAssign(&HistInterval, _mxarray5_);
    /*
     * tau=0.025;        % us digitizing time
     */
    mlfAssign(&tau, _mxarray9_);
    /*
     * HistFolder='';
     */
    mlfAssign(&HistFolder, _mxarray10_);
    /*
     * 
     * tic;
     */
    mlfTic();
    /*
     * if isstr(FileName) 
     */
    if (mlfTobool(mlfIsstr(mclVa(FileName, "FileName")))) {
        /*
         * fid = fopen(FileName, 'r');
         */
        mlfAssign(
          &fid,
          mlfFopen(NULL, NULL, mclVa(FileName, "FileName"), _mxarray11_, NULL));
        /*
         * line = fgetl(fid);
         */
        mlfAssign(&line, mlfFgetl(mclVv(fid, "fid")));
        /*
         * peaks=[]; 
         */
        mlfAssign(&peaks, _mxarray13_);
        /*
         * while not(feof(fid))
         */
        while (mlfTobool(mclNot(mlfFeof(mclVv(fid, "fid"))))) {
            /*
             * peaks=[peaks; fscanf(fid,'%g',8)'];
             */
            mlfAssign(
              &peaks,
              mlfVertcat(
                mclVv(peaks, "peaks"),
                mlfCtranspose(
                  mlfFscanf(NULL, mclVv(fid, "fid"), _mxarray14_, _mxarray16_)),
                NULL));
        /*
         * end; 
         */
        }
        /*
         * fclose(fid); 
         */
        mclAssignAns(&ans, mlfFclose(mclVv(fid, "fid")));
    /*
     * else  
     */
    } else {
        /*
         * peaks=FileName;  
         */
        mlfAssign(&peaks, mclVa(FileName, "FileName"));
    /*
     * end; 
     */
    }
    /*
     * Period=peaks(end,3); 
     */
    mlfAssign(
      &Period,
      mclArrayRef2(
        mclVv(peaks, "peaks"),
        mlfEnd(mclVv(peaks, "peaks"), _mxarray17_, _mxarray18_),
        _mxarray19_));
    /*
     * MinTime=14600;
     */
    mlfAssign(&MinTime, _mxarray20_);
    /*
     * peaks(:,1:2)=peaks(:,1:2)+MinTime; 
     */
    mclArrayAssign2(
      &peaks,
      mclPlus(
        mclArrayRef2(
          mclVv(peaks, "peaks"),
          mlfCreateColonIndex(),
          mlfColon(_mxarray17_, _mxarray18_, NULL)),
        mclVv(MinTime, "MinTime")),
      mlfCreateColonIndex(),
      mlfColon(_mxarray17_, _mxarray18_, NULL));
    /*
     * MaxTime=peaks(end,1);
     */
    mlfAssign(
      &MaxTime,
      mclArrayRef2(
        mclVv(peaks, "peaks"),
        mlfEnd(mclVv(peaks, "peaks"), _mxarray17_, _mxarray18_),
        _mxarray17_));
    /*
     * NPeaks=size(peaks,1);
     */
    mlfAssign(
      &NPeaks,
      mlfSize(mclValueVarargout(), mclVv(peaks, "peaks"), _mxarray17_));
    /*
     * MaxAmp=max(max(peaks(:,5)),max(peaks(:,6)));
     */
    mlfAssign(
      &MaxAmp,
      mlfMax(
        NULL,
        mlfMax(
          NULL,
          mclArrayRef2(
            mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray21_),
          NULL,
          NULL),
        mlfMax(
          NULL,
          mclArrayRef2(
            mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray22_),
          NULL,
          NULL),
        NULL));
    /*
     * MaxSignal = MaxAmp;
     */
    mlfAssign(&MaxSignal, mclVv(MaxAmp, "MaxAmp"));
    /*
     * MaxAmp=MaxSignal; MaxTime=peaks(end,1);
     */
    mlfAssign(&MaxAmp, mclVv(MaxSignal, "MaxSignal"));
    mlfAssign(
      &MaxTime,
      mclArrayRef2(
        mclVv(peaks, "peaks"),
        mlfEnd(mclVv(peaks, "peaks"), _mxarray17_, _mxarray18_),
        _mxarray17_));
    /*
     * TimeSpectralInterval=5246;
     */
    mlfAssign(&TimeSpectralInterval, _mxarray23_);
    /*
     * TimeSpectralIntervalNum=fix((peaks(end,1)-peaks(1,1))/TimeSpectralInterval)+1; 
     */
    mlfAssign(
      &TimeSpectralIntervalNum,
      mclPlus(
        mlfFix(
          mclMrdivide(
            mclMinus(
              mclArrayRef2(
                mclVv(peaks, "peaks"),
                mlfEnd(mclVv(peaks, "peaks"), _mxarray17_, _mxarray18_),
                _mxarray17_),
              mclIntArrayRef2(mclVv(peaks, "peaks"), 1, 1)),
            mclVv(TimeSpectralInterval, "TimeSpectralInterval"))),
        _mxarray17_));
    /*
     * 
     * StartInterval=MinTime:TimeSpectralInterval:MinTime+(TimeSpectralIntervalNum-1)*TimeSpectralInterval; 
     */
    mlfAssign(
      &StartInterval,
      mlfColon(
        mclVv(MinTime, "MinTime"),
        mclVv(TimeSpectralInterval, "TimeSpectralInterval"),
        mclPlus(
          mclVv(MinTime, "MinTime"),
          mclMtimes(
            mclMinus(
              mclVv(TimeSpectralIntervalNum, "TimeSpectralIntervalNum"),
              _mxarray17_),
            mclVv(TimeSpectralInterval, "TimeSpectralInterval")))));
    /*
     * EndInterval=StartInterval+TimeSpectralInterval; 
     */
    mlfAssign(
      &EndInterval,
      mclPlus(
        mclVv(StartInterval, "StartInterval"),
        mclVv(TimeSpectralInterval, "TimeSpectralInterval")));
    /*
     * EndInterval(end)=min(EndInterval(end),peaks(end,2)); 
     */
    mclArrayAssign1(
      &EndInterval,
      mlfMin(
        NULL,
        mclArrayRef1(
          mclVv(EndInterval, "EndInterval"),
          mlfEnd(mclVv(EndInterval, "EndInterval"), _mxarray17_, _mxarray17_)),
        mclArrayRef2(
          mclVv(peaks, "peaks"),
          mlfEnd(mclVv(peaks, "peaks"), _mxarray17_, _mxarray18_),
          _mxarray18_),
        NULL),
      mlfEnd(mclVv(EndInterval, "EndInterval"), _mxarray17_, _mxarray17_));
    /*
     * CenterOfInterval=(StartInterval+EndInterval)/2; 
     */
    mlfAssign(
      &CenterOfInterval,
      mclMrdivide(
        mclPlus(
          mclVv(StartInterval, "StartInterval"),
          mclVv(EndInterval, "EndInterval")),
        _mxarray18_));
    /*
     * 
     * OutLimits=(peaks(:,1)>MaxTime)|(peaks(:,1)<MinTime)|peaks(:,5)>MaxAmp;  
     */
    mlfAssign(
      &OutLimits,
      mclOr(
        mclOr(
          mclGt(
            mclArrayRef2(
              mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray17_),
            mclVv(MaxTime, "MaxTime")),
          mclLt(
            mclArrayRef2(
              mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray17_),
            mclVv(MinTime, "MinTime"))),
        mclGt(
          mclArrayRef2(
            mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray21_),
          mclVv(MaxAmp, "MaxAmp"))));
    /*
     * peaks(OutLimits,:)=[]; 
     */
    mlfIndexDelete(
      &peaks, "(?,?)", mclVv(OutLimits, "OutLimits"), mlfCreateColonIndex());
    /*
     * if IntervalBool
     */
    if (mlfTobool(mclVv(IntervalBool, "IntervalBool"))) {
        /*
         * OutLimits=[]; 
         */
        mlfAssign(&OutLimits, _mxarray13_);
        /*
         * PreccedInterv=circshift(peaks(:,3),1); 
         */
        mlfAssign(
          &PreccedInterv,
          mlfCircshift(
            mclArrayRef2(
              mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray19_),
            _mxarray17_));
        /*
         * OutLimits=(PreccedInterv<SelectedInterval(1))|(PreccedInterv>SelectedInterval(2)); 
         */
        mlfAssign(
          &OutLimits,
          mclOr(
            mclLt(
              mclVv(PreccedInterv, "PreccedInterv"),
              mclIntArrayRef1(mclVv(SelectedInterval, "SelectedInterval"), 1)),
            mclGt(
              mclVv(PreccedInterv, "PreccedInterv"),
              mclIntArrayRef1(
                mclVv(SelectedInterval, "SelectedInterval"), 2))));
        /*
         * peaks(OutLimits,:)=[];     
         */
        mlfIndexDelete(
          &peaks,
          "(?,?)",
          mclVv(OutLimits, "OutLimits"),
          mlfCreateColonIndex());
    /*
     * end;     
     */
    }
    /*
     * 
     * 
     * for n=1:TimeSpectralIntervalNum
     */
    {
        int v_ = mclForIntStart(1);
        int e_
          = mclForIntEnd(
              mclVv(TimeSpectralIntervalNum, "TimeSpectralIntervalNum"));
        if (v_ > e_) {
            mlfAssign(&n, _mxarray13_);
        } else {
            /*
             * InsideInterval(:,n)=(peaks(:,1)>=StartInterval(n))&(peaks(:,1)<=EndInterval(n));
             * end; 
             */
            for (; ; ) {
                mclArrayAssign2(
                  &InsideInterval,
                  mclAnd(
                    mclGe(
                      mclArrayRef2(
                        mclVv(peaks, "peaks"),
                        mlfCreateColonIndex(),
                        _mxarray17_),
                      mclIntArrayRef1(
                        mclVv(StartInterval, "StartInterval"), v_)),
                    mclLe(
                      mclArrayRef2(
                        mclVv(peaks, "peaks"),
                        mlfCreateColonIndex(),
                        _mxarray17_),
                      mclIntArrayRef1(mclVv(EndInterval, "EndInterval"), v_))),
                  mlfCreateColonIndex(),
                  mlfScalar(v_));
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&n, mlfScalar(v_));
        }
    }
    /*
     * 
     * %NPeaks=size(peaks,1);
     * MaxAmp=max(max(peaks(:,5)),max(peaks(:,6)));
     */
    mlfAssign(
      &MaxAmp,
      mlfMax(
        NULL,
        mlfMax(
          NULL,
          mclArrayRef2(
            mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray21_),
          NULL,
          NULL),
        mlfMax(
          NULL,
          mclArrayRef2(
            mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray22_),
          NULL,
          NULL),
        NULL));
    /*
     * 
     * %peak amplitude histogram
     * MaxAmplN=0; 
     */
    mlfAssign(&MaxAmplN, _mxarray24_);
    /*
     * MaxAmpl=max(peaks(:,5));
     */
    mlfAssign(
      &MaxAmpl,
      mlfMax(
        NULL,
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray21_),
        NULL,
        NULL));
    /*
     * MinAmpl=0; %min(peaks(:,4));
     */
    mlfAssign(&MinAmpl, _mxarray24_);
    /*
     * PeakAmplRange=MaxAmpl-MinAmpl; 
     */
    mlfAssign(
      &PeakAmplRange,
      mclMinus(mclVv(MaxAmpl, "MaxAmpl"), mclVv(MinAmpl, "MinAmpl")));
    /*
     * HistIntervalA=HistInterval; %   =PeakAmplRange/HistNA;       % interval for amplitudes
     */
    mlfAssign(&HistIntervalA, mclVv(HistInterval, "HistInterval"));
    /*
     * HistNA=fix(PeakAmplRange/HistIntervalA)+1;  %HistNA=fix(NPeaks/AveragN);  
     */
    mlfAssign(
      &HistNA,
      mclPlus(
        mlfFix(
          mclMrdivide(
            mclVv(PeakAmplRange, "PeakAmplRange"),
            mclVv(HistIntervalA, "HistIntervalA"))),
        _mxarray17_));
    /*
     * if HistNA==0; HistNA=1; end;     % the number of intervals     
     */
    if (mclEqBool(mclVv(HistNA, "HistNA"), _mxarray24_)) {
        mlfAssign(&HistNA, _mxarray17_);
    }
    /*
     * for i=1:HistNA HistA(i,1)=MinAmpl+(i-0.5)*HistIntervalA; end; 
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVv(HistNA, "HistNA"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray13_);
        } else {
            for (; ; ) {
                mclIntArrayAssign2(
                  &HistA,
                  mclPlus(
                    mclVv(MinAmpl, "MinAmpl"),
                    mclMtimes(
                      mlfScalar(svDoubleScalarMinus((double) v_, .5)),
                      mclVv(HistIntervalA, "HistIntervalA"))),
                  v_,
                  1);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * for n=1:TimeSpectralIntervalNum  
     */
    {
        int v_ = mclForIntStart(1);
        int e_
          = mclForIntEnd(
              mclVv(TimeSpectralIntervalNum, "TimeSpectralIntervalNum"));
        if (v_ > e_) {
            mlfAssign(&n, _mxarray13_);
        } else {
            /*
             * for i=1:HistNA
             * HistBool=(peaks(InsideInterval(:,n),5)<HistA(i,1)+HistIntervalA/2)&...
             * (peaks(InsideInterval(:,n),5)>=HistA(i,1)-HistIntervalA/2);
             * HistA(i,2*n)=size(peaks(HistBool,1),1);  %peak aplitude
             * HistA(i,2*n+1)=sqrt(HistA(i,2*n));   %peak aplitude error
             * MaxAmplN=max(MaxAmplN,HistA(i,2*n));
             * end;
             * %    ZeroBool=HistA(:,2)==0; 
             * %    HistA(ZeroBool,:)=[]; 
             * end; 
             */
            for (; ; ) {
                int v_0 = mclForIntStart(1);
                int e_0 = mclForIntEnd(mclVv(HistNA, "HistNA"));
                if (v_0 > e_0) {
                    mlfAssign(&i, _mxarray13_);
                } else {
                    for (; ; ) {
                        mlfAssign(
                          &HistBool,
                          mclAnd(
                            mclLt(
                              mclArrayRef2(
                                mclVv(peaks, "peaks"),
                                mclArrayRef2(
                                  mclVv(InsideInterval, "InsideInterval"),
                                  mlfCreateColonIndex(),
                                  mlfScalar(v_)),
                                _mxarray21_),
                              mclPlus(
                                mclIntArrayRef2(mclVv(HistA, "HistA"), v_0, 1),
                                mclMrdivide(
                                  mclVv(HistIntervalA, "HistIntervalA"),
                                  _mxarray18_))),
                            mclGe(
                              mclArrayRef2(
                                mclVv(peaks, "peaks"),
                                mclArrayRef2(
                                  mclVv(InsideInterval, "InsideInterval"),
                                  mlfCreateColonIndex(),
                                  mlfScalar(v_)),
                                _mxarray21_),
                              mclMinus(
                                mclIntArrayRef2(mclVv(HistA, "HistA"), v_0, 1),
                                mclMrdivide(
                                  mclVv(HistIntervalA, "HistIntervalA"),
                                  _mxarray18_)))));
                        mclArrayAssign2(
                          &HistA,
                          mlfSize(
                            mclValueVarargout(),
                            mclArrayRef2(
                              mclVv(peaks, "peaks"),
                              mclVv(HistBool, "HistBool"),
                              _mxarray17_),
                            _mxarray17_),
                          mlfScalar(v_0),
                          mlfScalar(svDoubleScalarTimes(2.0, (double) v_)));
                        mclArrayAssign2(
                          &HistA,
                          mlfSqrt(
                            mclArrayRef2(
                              mclVv(HistA, "HistA"),
                              mlfScalar(v_0),
                              mlfScalar(
                                svDoubleScalarTimes(2.0, (double) v_)))),
                          mlfScalar(v_0),
                          mlfScalar(
                            svDoubleScalarPlus(
                              svDoubleScalarTimes(2.0, (double) v_), 1.0)));
                        mlfAssign(
                          &MaxAmplN,
                          mlfMax(
                            NULL,
                            mclVv(MaxAmplN, "MaxAmplN"),
                            mclArrayRef2(
                              mclVv(HistA, "HistA"),
                              mlfScalar(v_0),
                              mlfScalar(svDoubleScalarTimes(2.0, (double) v_))),
                            NULL));
                        if (v_0 == e_0) {
                            break;
                        }
                        ++v_0;
                    }
                    mlfAssign(&i, mlfScalar(v_0));
                }
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&n, mlfScalar(v_));
        }
    }
    /*
     * 
     * %peak 'charge'  histogram
     * MaxChN=0; 
     */
    mlfAssign(&MaxChN, _mxarray24_);
    /*
     * MaxCh=max(peaks(:,6));
     */
    mlfAssign(
      &MaxCh,
      mlfMax(
        NULL,
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray22_),
        NULL,
        NULL));
    /*
     * MinCh=0; %min(peaks(:,4));
     */
    mlfAssign(&MinCh, _mxarray24_);
    /*
     * PeakChRange=MaxAmpl-MinAmpl; 
     */
    mlfAssign(
      &PeakChRange,
      mclMinus(mclVv(MaxAmpl, "MaxAmpl"), mclVv(MinAmpl, "MinAmpl")));
    /*
     * HistIntervalCh=HistInterval;
     */
    mlfAssign(&HistIntervalCh, mclVv(HistInterval, "HistInterval"));
    /*
     * HistNCh=fix(PeakChRange/HistIntervalCh)+1;
     */
    mlfAssign(
      &HistNCh,
      mclPlus(
        mlfFix(
          mclMrdivide(
            mclVv(PeakChRange, "PeakChRange"),
            mclVv(HistIntervalCh, "HistIntervalCh"))),
        _mxarray17_));
    /*
     * if HistNCh==0; HistNCh=1; end;     % the number of intervals     
     */
    if (mclEqBool(mclVv(HistNCh, "HistNCh"), _mxarray24_)) {
        mlfAssign(&HistNCh, _mxarray17_);
    }
    /*
     * for i=1:HistNCh HistCh(i,1)=MinCh+(i-0.5)*HistIntervalCh; end; 
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVv(HistNCh, "HistNCh"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray13_);
        } else {
            for (; ; ) {
                mclIntArrayAssign2(
                  &HistCh,
                  mclPlus(
                    mclVv(MinCh, "MinCh"),
                    mclMtimes(
                      mlfScalar(svDoubleScalarMinus((double) v_, .5)),
                      mclVv(HistIntervalCh, "HistIntervalCh"))),
                  v_,
                  1);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * 
     * for n=1:TimeSpectralIntervalNum  
     */
    {
        int v_ = mclForIntStart(1);
        int e_
          = mclForIntEnd(
              mclVv(TimeSpectralIntervalNum, "TimeSpectralIntervalNum"));
        if (v_ > e_) {
            mlfAssign(&n, _mxarray13_);
        } else {
            /*
             * for i=1:HistNCh
             * HistBool=(peaks(InsideInterval(:,n),6)<HistCh(i,1)+HistIntervalCh/2)&...
             * (peaks(InsideInterval(:,n),6)>=HistCh(i,1)-HistIntervalCh/2);
             * HistCh(i,2*n)=size(peaks(HistBool,1),1);  %peak aplitude
             * HistCh(i,2*n+1)=sqrt(HistCh(i,2*n));   %peak aplitude error
             * MaxChN=max(MaxChN,HistCh(i,2*n));
             * end;
             * %    ZeroBool=HistA(:,2)==0; 
             * %    HistA(ZeroBool,:)=[]; 
             * end; 
             */
            for (; ; ) {
                int v_1 = mclForIntStart(1);
                int e_1 = mclForIntEnd(mclVv(HistNCh, "HistNCh"));
                if (v_1 > e_1) {
                    mlfAssign(&i, _mxarray13_);
                } else {
                    for (; ; ) {
                        mlfAssign(
                          &HistBool,
                          mclAnd(
                            mclLt(
                              mclArrayRef2(
                                mclVv(peaks, "peaks"),
                                mclArrayRef2(
                                  mclVv(InsideInterval, "InsideInterval"),
                                  mlfCreateColonIndex(),
                                  mlfScalar(v_)),
                                _mxarray22_),
                              mclPlus(
                                mclIntArrayRef2(
                                  mclVv(HistCh, "HistCh"), v_1, 1),
                                mclMrdivide(
                                  mclVv(HistIntervalCh, "HistIntervalCh"),
                                  _mxarray18_))),
                            mclGe(
                              mclArrayRef2(
                                mclVv(peaks, "peaks"),
                                mclArrayRef2(
                                  mclVv(InsideInterval, "InsideInterval"),
                                  mlfCreateColonIndex(),
                                  mlfScalar(v_)),
                                _mxarray22_),
                              mclMinus(
                                mclIntArrayRef2(
                                  mclVv(HistCh, "HistCh"), v_1, 1),
                                mclMrdivide(
                                  mclVv(HistIntervalCh, "HistIntervalCh"),
                                  _mxarray18_)))));
                        mclArrayAssign2(
                          &HistCh,
                          mlfSize(
                            mclValueVarargout(),
                            mclArrayRef2(
                              mclVv(peaks, "peaks"),
                              mclVv(HistBool, "HistBool"),
                              _mxarray17_),
                            _mxarray17_),
                          mlfScalar(v_1),
                          mlfScalar(svDoubleScalarTimes(2.0, (double) v_)));
                        mclArrayAssign2(
                          &HistCh,
                          mlfSqrt(
                            mclArrayRef2(
                              mclVv(HistCh, "HistCh"),
                              mlfScalar(v_1),
                              mlfScalar(
                                svDoubleScalarTimes(2.0, (double) v_)))),
                          mlfScalar(v_1),
                          mlfScalar(
                            svDoubleScalarPlus(
                              svDoubleScalarTimes(2.0, (double) v_), 1.0)));
                        mlfAssign(
                          &MaxChN,
                          mlfMax(
                            NULL,
                            mclVv(MaxChN, "MaxChN"),
                            mclArrayRef2(
                              mclVv(HistCh, "HistCh"),
                              mlfScalar(v_1),
                              mlfScalar(svDoubleScalarTimes(2.0, (double) v_))),
                            NULL));
                        if (v_1 == e_1) {
                            break;
                        }
                        ++v_1;
                    }
                    mlfAssign(&i, mlfScalar(v_1));
                }
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&n, mlfScalar(v_));
        }
    }
    /*
     * 
     * 
     * 
     * %peak interval histogram
     * MaxT=max(peaks(:,3));
     */
    mlfAssign(
      &MaxT,
      mlfMax(
        NULL,
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray19_),
        NULL,
        NULL));
    /*
     * MinT=min(peaks(:,3));
     */
    mlfAssign(
      &MinT,
      mlfMin(
        NULL,
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray19_),
        NULL,
        NULL));
    /*
     * PeakTRange=MaxT-MinT; 
     */
    mlfAssign(&PeakTRange, mclMinus(mclVv(MaxT, "MaxT"), mclVv(MinT, "MinT")));
    /*
     * HistIntervalT=PeakTRange/HistNA;          % interval for T
     */
    mlfAssign(
      &HistIntervalT,
      mclMrdivide(mclVv(PeakTRange, "PeakTRange"), mclVv(HistNA, "HistNA")));
    /*
     * for i=1:HistNA
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVv(HistNA, "HistNA"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray13_);
        } else {
            /*
             * HistT(i,1)=MinT+(i-0.5)*HistIntervalT; 
             * HistBool=(peaks(:,3)<HistT(i,1)+HistIntervalT/2)&...
             * (peaks(:,3)>=HistT(i,1)-HistIntervalT/2);
             * HistT(i,2)=size(peaks(HistBool,1),1);    %peak-to-peak intervals    
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign2(
                  &HistT,
                  mclPlus(
                    mclVv(MinT, "MinT"),
                    mclMtimes(
                      mlfScalar(svDoubleScalarMinus((double) v_, .5)),
                      mclVv(HistIntervalT, "HistIntervalT"))),
                  v_,
                  1);
                mlfAssign(
                  &HistBool,
                  mclAnd(
                    mclLt(
                      mclArrayRef2(
                        mclVv(peaks, "peaks"),
                        mlfCreateColonIndex(),
                        _mxarray19_),
                      mclPlus(
                        mclIntArrayRef2(mclVv(HistT, "HistT"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalT, "HistIntervalT"), _mxarray18_))),
                    mclGe(
                      mclArrayRef2(
                        mclVv(peaks, "peaks"),
                        mlfCreateColonIndex(),
                        _mxarray19_),
                      mclMinus(
                        mclIntArrayRef2(mclVv(HistT, "HistT"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalT, "HistIntervalT"),
                          _mxarray18_)))));
                mclIntArrayAssign2(
                  &HistT,
                  mlfSize(
                    mclValueVarargout(),
                    mclArrayRef2(
                      mclVv(peaks, "peaks"),
                      mclVv(HistBool, "HistBool"),
                      _mxarray17_),
                    _mxarray17_),
                  v_,
                  2);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * ZeroBool=HistT(:,2)==0; 
     */
    mlfAssign(
      &ZeroBool,
      mclEq(
        mclArrayRef2(mclVv(HistT, "HistT"), mlfCreateColonIndex(), _mxarray18_),
        _mxarray24_));
    /*
     * HistT(ZeroBool,:)=[];
     */
    mlfIndexDelete(
      &HistT, "(?,?)", mclVv(ZeroBool, "ZeroBool"), mlfCreateColonIndex());
    /*
     * 
     * 
     * %Poisson interval distribution
     * test=rand(NPeaks,1)*(peaks(end,1)-peaks(1,1));
     */
    mlfAssign(
      &test,
      mclMtimes(
        mlfNRand(1, mclVv(NPeaks, "NPeaks"), _mxarray17_, NULL),
        mclMinus(
          mclArrayRef2(
            mclVv(peaks, "peaks"),
            mlfEnd(mclVv(peaks, "peaks"), _mxarray17_, _mxarray18_),
            _mxarray17_),
          mclIntArrayRef2(mclVv(peaks, "peaks"), 1, 1))));
    /*
     * Poisson=sort(test); 
     */
    mlfAssign(&Poisson, mlfSort(NULL, mclVv(test, "test"), NULL));
    /*
     * Poisson=circshift(Poisson,-1)-Poisson;
     */
    mlfAssign(
      &Poisson,
      mclMinus(
        mlfCircshift(mclVv(Poisson, "Poisson"), _mxarray25_),
        mclVv(Poisson, "Poisson")));
    /*
     * MeanP=mean(Poisson(1:end-1));
     */
    mlfAssign(
      &MeanP,
      mlfMean(
        mclArrayRef1(
          mclVv(Poisson, "Poisson"),
          mlfColon(
            _mxarray17_,
            mclMinus(
              mlfEnd(mclVv(Poisson, "Poisson"), _mxarray17_, _mxarray17_),
              _mxarray17_),
            NULL)),
        NULL));
    /*
     * Poisson(end)=MeanP; 
     */
    mclArrayAssign1(
      &Poisson,
      mclVv(MeanP, "MeanP"),
      mlfEnd(mclVv(Poisson, "Poisson"), _mxarray17_, _mxarray17_));
    /*
     * MaxP=max(Poisson);
     */
    mlfAssign(&MaxP, mlfMax(NULL, mclVv(Poisson, "Poisson"), NULL, NULL));
    /*
     * MinP=min(Poisson);
     */
    mlfAssign(&MinP, mlfMin(NULL, mclVv(Poisson, "Poisson"), NULL, NULL));
    /*
     * PeakPRange=MaxP-MinP; 
     */
    mlfAssign(&PeakPRange, mclMinus(mclVv(MaxP, "MaxP"), mclVv(MinP, "MinP")));
    /*
     * HistIntervalP=HistIntervalT;                   % interval for T
     */
    mlfAssign(&HistIntervalP, mclVv(HistIntervalT, "HistIntervalT"));
    /*
     * for i=1:HistNA
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVv(HistNA, "HistNA"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray13_);
        } else {
            /*
             * HistP(i,1)=MinP+(i-0.5)*HistIntervalP; 
             * HistBool=(Poisson<HistP(i,1)+HistIntervalP/2)&...
             * (Poisson>=HistP(i,1)-HistIntervalP/2);
             * HistP(i,2)=size(Poisson(HistBool),1);           %peak-to-peak intervals
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign2(
                  &HistP,
                  mclPlus(
                    mclVv(MinP, "MinP"),
                    mclMtimes(
                      mlfScalar(svDoubleScalarMinus((double) v_, .5)),
                      mclVv(HistIntervalP, "HistIntervalP"))),
                  v_,
                  1);
                mlfAssign(
                  &HistBool,
                  mclAnd(
                    mclLt(
                      mclVv(Poisson, "Poisson"),
                      mclPlus(
                        mclIntArrayRef2(mclVv(HistP, "HistP"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalP, "HistIntervalP"), _mxarray18_))),
                    mclGe(
                      mclVv(Poisson, "Poisson"),
                      mclMinus(
                        mclIntArrayRef2(mclVv(HistP, "HistP"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalP, "HistIntervalP"),
                          _mxarray18_)))));
                mclIntArrayAssign2(
                  &HistP,
                  mlfSize(
                    mclValueVarargout(),
                    mclArrayRef1(
                      mclVv(Poisson, "Poisson"), mclVv(HistBool, "HistBool")),
                    _mxarray17_),
                  v_,
                  2);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * 
     * 
     * 
     * fprintf('---------------------\n');                
     */
    mclAssignAns(&ans, mlfNFprintf(0, _mxarray26_, NULL));
    /*
     * if IntervalBool 
     */
    if (mlfTobool(mclVv(IntervalBool, "IntervalBool"))) {
        /*
         * fprintf('Peaks are selected within preceeding interval from %6.4f to %6.4f us\n',SelectedInterval(1), SelectedInterval(2));
         */
        mclAssignAns(
          &ans,
          mlfNFprintf(
            0,
            _mxarray28_,
            mclIntArrayRef1(mclVv(SelectedInterval, "SelectedInterval"), 1),
            mclIntArrayRef1(mclVv(SelectedInterval, "SelectedInterval"), 2),
            NULL));
    /*
     * end; 
     */
    }
    /*
     * fprintf('The number of peaks =  %5.0f\n', NPeaks);
     */
    mclAssignAns(
      &ans, mlfNFprintf(0, _mxarray30_, mclVv(NPeaks, "NPeaks"), NULL));
    /*
     * fprintf('The period of peaks =  %6.4f ms\n', Period/1000);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(
        0,
        _mxarray32_,
        mclMrdivide(mclVv(Period, "Period"), _mxarray34_),
        NULL));
    /*
     * fprintf('Resolution in the peak amplitude histogram=  %3.3f counts\n', HistIntervalA);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(0, _mxarray35_, mclVv(HistIntervalA, "HistIntervalA"), NULL));
    /*
     * fprintf('Resolution in the peak interval histogram=  %3.3f us\n', HistIntervalT);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(0, _mxarray37_, mclVv(HistIntervalT, "HistIntervalT"), NULL));
    /*
     * fprintf('Expected number of double peaks for 0.025 us = %3.3f \n', NPeaks*0.025/Period);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(
        0,
        _mxarray39_,
        mclMrdivide(
          mclMtimes(mclVv(NPeaks, "NPeaks"), _mxarray9_),
          mclVv(Period, "Period")),
        NULL));
    /*
     * fprintf('Expected number of double peaks for %5.3f us = %5.3f \n', MinInterval, NPeaks*MinInterval/Period);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(
        0,
        _mxarray41_,
        mclVv(MinInterval, "MinInterval"),
        mclMrdivide(
          mclMtimes(mclVv(NPeaks, "NPeaks"), mclVv(MinInterval, "MinInterval")),
          mclVv(Period, "Period")),
        NULL));
    /*
     * %fprintf('Detected number of double peaks for %5.3f us = %5.3f \n', MinInterval, size(find(peaks(:,end)==2)));
     * fprintf('Expected number of triple peaks for %5.3f us = %5.3f \n', MinInterval, NPeaks*(MinInterval/Period)^2/2);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(
        0,
        _mxarray43_,
        mclVv(MinInterval, "MinInterval"),
        mclMrdivide(
          mclMtimes(
            mclVv(NPeaks, "NPeaks"),
            mclMpower(
              mclMrdivide(
                mclVv(MinInterval, "MinInterval"), mclVv(Period, "Period")),
              _mxarray18_)),
          _mxarray18_),
        NULL));
    /*
     * %fprintf('Detected number of triple peaks for %5.3f us = %5.3f \n', MinInterval, size(find(peaks(:,end)==2)));
     * %fprintf('The selected number of double peaks for %5.3f us = %3.0f \n', MinInterval, DoublePeakNum);
     * %fprintf('The selected number of triple peaks for %5.3f us = %3.0f \n', MinInterval, TriplePeakNum);
     * fprintf('=====================\n');                
     */
    mclAssignAns(&ans, mlfNFprintf(0, _mxarray45_, NULL));
    /*
     * 
     * if isstr(FileName) 
     */
    if (mlfTobool(mlfIsstr(mclVa(FileName, "FileName")))) {
        /*
         * HistAFile=[HistFolder,strrep(FileName,'peak','A')]; 
         */
        mlfAssign(
          &HistAFile,
          mlfHorzcat(
            mclVv(HistFolder, "HistFolder"),
            mlfStrrep(mclVa(FileName, "FileName"), _mxarray47_, _mxarray49_),
            NULL));
        /*
         * HistAFile=strrep(HistAFile,'.',['Av',num2str(TimeSpectralInterval/1000,'%3.1f'),'ms.']); 
         */
        mlfAssign(
          &HistAFile,
          mlfStrrep(
            mclVv(HistAFile, "HistAFile"),
            _mxarray51_,
            mlfHorzcat(
              _mxarray53_,
              mlfNum2str(
                mclMrdivide(
                  mclVv(TimeSpectralInterval, "TimeSpectralInterval"),
                  _mxarray34_),
                _mxarray55_),
              _mxarray57_,
              NULL)));
        /*
         * HistCFile=[HistFolder,strrep(FileName,'peak','C')]; 
         */
        mlfAssign(
          &HistCFile,
          mlfHorzcat(
            mclVv(HistFolder, "HistFolder"),
            mlfStrrep(mclVa(FileName, "FileName"), _mxarray47_, _mxarray59_),
            NULL));
        /*
         * HistCFile=strrep(HistCFile,'.',['Av',num2str(TimeSpectralInterval/1000,'%3.1f'),'ms.']); 
         */
        mlfAssign(
          &HistCFile,
          mlfStrrep(
            mclVv(HistCFile, "HistCFile"),
            _mxarray51_,
            mlfHorzcat(
              _mxarray53_,
              mlfNum2str(
                mclMrdivide(
                  mclVv(TimeSpectralInterval, "TimeSpectralInterval"),
                  _mxarray34_),
                _mxarray55_),
              _mxarray57_,
              NULL)));
    /*
     * else 
     */
    } else {
        /*
         * HistAFile=['AmplAv',num2str(TimeSpectralInterval/1000,'%3.1f'),'ms.dat'];     
         */
        mlfAssign(
          &HistAFile,
          mlfHorzcat(
            _mxarray61_,
            mlfNum2str(
              mclMrdivide(
                mclVv(TimeSpectralInterval, "TimeSpectralInterval"),
                _mxarray34_),
              _mxarray55_),
            _mxarray63_,
            NULL));
        /*
         * HistCFile=['ChargAv',num2str(TimeSpectralInterval/1000,'%3.1f'),'ms.dat'];     
         */
        mlfAssign(
          &HistCFile,
          mlfHorzcat(
            _mxarray65_,
            mlfNum2str(
              mclMrdivide(
                mclVv(TimeSpectralInterval, "TimeSpectralInterval"),
                _mxarray34_),
              _mxarray55_),
            _mxarray63_,
            NULL));
    /*
     * end; 
     */
    }
    /*
     * if IntervalBool 
     */
    if (mlfTobool(mclVv(IntervalBool, "IntervalBool"))) {
        /*
         * HistAFile=strrep(HistAFile,HistFolder,[HistFolder,'S']);
         */
        mlfAssign(
          &HistAFile,
          mlfStrrep(
            mclVv(HistAFile, "HistAFile"),
            mclVv(HistFolder, "HistFolder"),
            mlfHorzcat(mclVv(HistFolder, "HistFolder"), _mxarray67_, NULL)));
        /*
         * HistCFile=strrep(HistCFile,HistFolder,[HistFolder,'S']);    
         */
        mlfAssign(
          &HistCFile,
          mlfStrrep(
            mclVv(HistCFile, "HistCFile"),
            mclVv(HistFolder, "HistFolder"),
            mlfHorzcat(mclVv(HistFolder, "HistFolder"), _mxarray67_, NULL)));
    /*
     * end; 
     */
    }
    /*
     * fid=fopen(HistAFile,'w'); 
     */
    mlfAssign(
      &fid,
      mlfFopen(NULL, NULL, mclVv(HistAFile, "HistAFile"), _mxarray69_, NULL));
    /*
     * HeadOfFile='Ampl   '; 
     */
    mlfAssign(&HeadOfFile, _mxarray71_);
    /*
     * for n=1:TimeSpectralIntervalNum HeadOfFile=[HeadOfFile,' keV',num2str(n), ' N', num2str(CenterOfInterval(n)/1000,'%5.2f'),'ms dN',num2str(n)]; end; 
     */
    {
        int v_ = mclForIntStart(1);
        int e_
          = mclForIntEnd(
              mclVv(TimeSpectralIntervalNum, "TimeSpectralIntervalNum"));
        if (v_ > e_) {
            mlfAssign(&n, _mxarray13_);
        } else {
            for (; ; ) {
                mlfAssign(
                  &HeadOfFile,
                  mlfHorzcat(
                    mclVv(HeadOfFile, "HeadOfFile"),
                    _mxarray73_,
                    mlfNum2str(mlfScalar(v_), NULL),
                    _mxarray75_,
                    mlfNum2str(
                      mclMrdivide(
                        mclIntArrayRef1(
                          mclVv(CenterOfInterval, "CenterOfInterval"), v_),
                        _mxarray34_),
                      _mxarray77_),
                    _mxarray79_,
                    mlfNum2str(mlfScalar(v_), NULL),
                    NULL));
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&n, mlfScalar(v_));
        }
    }
    /*
     * HeadOfFile=[HeadOfFile,'\n'];    
     */
    mlfAssign(
      &HeadOfFile,
      mlfHorzcat(mclVv(HeadOfFile, "HeadOfFile"), _mxarray81_, NULL));
    /*
     * fprintf(fid,HeadOfFile);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(0, mclVv(fid, "fid"), mclVv(HeadOfFile, "HeadOfFile"), NULL));
    /*
     * for i=1:HistNA 
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVv(HistNA, "HistNA"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray13_);
        } else {
            /*
             * fprintf(fid,'%7.2f ' ,HistA(i,1));
             * for n=1:TimeSpectralIntervalNum  fprintf(fid,'%7.2f %3.0f %5.2f ' ,HistA(i,1), HistA(i,2*n:2*n+1));  end; 
             * fprintf(fid,'\n');    
             * end;  
             */
            for (; ; ) {
                mclAssignAns(
                  &ans,
                  mlfNFprintf(
                    0,
                    mclVv(fid, "fid"),
                    _mxarray83_,
                    mclIntArrayRef2(mclVv(HistA, "HistA"), v_, 1),
                    NULL));
                {
                    int v_2 = mclForIntStart(1);
                    int e_2
                      = mclForIntEnd(
                          mclVv(
                            TimeSpectralIntervalNum,
                            "TimeSpectralIntervalNum"));
                    if (v_2 > e_2) {
                        mlfAssign(&n, _mxarray13_);
                    } else {
                        for (; ; ) {
                            mclAssignAns(
                              &ans,
                              mlfNFprintf(
                                0,
                                mclVv(fid, "fid"),
                                _mxarray85_,
                                mclIntArrayRef2(mclVv(HistA, "HistA"), v_, 1),
                                mclArrayRef2(
                                  mclVv(HistA, "HistA"),
                                  mlfScalar(v_),
                                  mlfColon(
                                    mlfScalar(
                                      svDoubleScalarTimes(2.0, (double) v_2)),
                                    mlfScalar(
                                      svDoubleScalarPlus(
                                        svDoubleScalarTimes(2.0, (double) v_2),
                                        1.0)),
                                    NULL)),
                                NULL));
                            if (v_2 == e_2) {
                                break;
                            }
                            ++v_2;
                        }
                        mlfAssign(&n, mlfScalar(v_2));
                    }
                }
                mclAssignAns(
                  &ans, mlfNFprintf(0, mclVv(fid, "fid"), _mxarray81_, NULL));
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * fclose(fid);
     */
    mclAssignAns(&ans, mlfFclose(mclVv(fid, "fid")));
    /*
     * 
     * fid=fopen(HistCFile,'w'); 
     */
    mlfAssign(
      &fid,
      mlfFopen(NULL, NULL, mclVv(HistCFile, "HistCFile"), _mxarray69_, NULL));
    /*
     * HeadOfFile='Charge '; 
     */
    mlfAssign(&HeadOfFile, _mxarray87_);
    /*
     * for n=1:TimeSpectralIntervalNum HeadOfFile=[HeadOfFile,' keV',num2str(n), ' N', num2str(CenterOfInterval(n)/1000,'%5.2f'),'ms dN',num2str(n)]; end; 
     */
    {
        int v_ = mclForIntStart(1);
        int e_
          = mclForIntEnd(
              mclVv(TimeSpectralIntervalNum, "TimeSpectralIntervalNum"));
        if (v_ > e_) {
            mlfAssign(&n, _mxarray13_);
        } else {
            for (; ; ) {
                mlfAssign(
                  &HeadOfFile,
                  mlfHorzcat(
                    mclVv(HeadOfFile, "HeadOfFile"),
                    _mxarray73_,
                    mlfNum2str(mlfScalar(v_), NULL),
                    _mxarray75_,
                    mlfNum2str(
                      mclMrdivide(
                        mclIntArrayRef1(
                          mclVv(CenterOfInterval, "CenterOfInterval"), v_),
                        _mxarray34_),
                      _mxarray77_),
                    _mxarray79_,
                    mlfNum2str(mlfScalar(v_), NULL),
                    NULL));
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&n, mlfScalar(v_));
        }
    }
    /*
     * HeadOfFile=[HeadOfFile,'\n'];    
     */
    mlfAssign(
      &HeadOfFile,
      mlfHorzcat(mclVv(HeadOfFile, "HeadOfFile"), _mxarray81_, NULL));
    /*
     * fprintf(fid,HeadOfFile);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(0, mclVv(fid, "fid"), mclVv(HeadOfFile, "HeadOfFile"), NULL));
    /*
     * for i=1:HistNCh 
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVv(HistNCh, "HistNCh"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray13_);
        } else {
            /*
             * fprintf(fid,'%7.2f ' ,HistCh(i,1));
             * for n=1:TimeSpectralIntervalNum  fprintf(fid,'%7.2f %3.0f %5.2f ',HistCh(i,1),HistCh(i,2*n:2*n+1));  end; 
             * fprintf(fid,'\n');    
             * end;  
             */
            for (; ; ) {
                mclAssignAns(
                  &ans,
                  mlfNFprintf(
                    0,
                    mclVv(fid, "fid"),
                    _mxarray83_,
                    mclIntArrayRef2(mclVv(HistCh, "HistCh"), v_, 1),
                    NULL));
                {
                    int v_3 = mclForIntStart(1);
                    int e_3
                      = mclForIntEnd(
                          mclVv(
                            TimeSpectralIntervalNum,
                            "TimeSpectralIntervalNum"));
                    if (v_3 > e_3) {
                        mlfAssign(&n, _mxarray13_);
                    } else {
                        for (; ; ) {
                            mclAssignAns(
                              &ans,
                              mlfNFprintf(
                                0,
                                mclVv(fid, "fid"),
                                _mxarray85_,
                                mclIntArrayRef2(mclVv(HistCh, "HistCh"), v_, 1),
                                mclArrayRef2(
                                  mclVv(HistCh, "HistCh"),
                                  mlfScalar(v_),
                                  mlfColon(
                                    mlfScalar(
                                      svDoubleScalarTimes(2.0, (double) v_3)),
                                    mlfScalar(
                                      svDoubleScalarPlus(
                                        svDoubleScalarTimes(2.0, (double) v_3),
                                        1.0)),
                                    NULL)),
                                NULL));
                            if (v_3 == e_3) {
                                break;
                            }
                            ++v_3;
                        }
                        mlfAssign(&n, mlfScalar(v_3));
                    }
                }
                mclAssignAns(
                  &ans, mlfNFprintf(0, mclVv(fid, "fid"), _mxarray81_, NULL));
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * fclose(fid);
     */
    mclAssignAns(&ans, mlfFclose(mclVv(fid, "fid")));
    mclValidateOutput(HistA, 1, nargout_, "HistA", "histauto");
    mxDestroyArray(IntervalBool);
    mxDestroyArray(SelectedInterval);
    mxDestroyArray(MinFront);
    mxDestroyArray(MaxFront);
    mxDestroyArray(MinDuration);
    mxDestroyArray(MaxDuration);
    mxDestroyArray(MinAmp);
    mxDestroyArray(MinInterval);
    mxDestroyArray(MaxCombined);
    mxDestroyArray(AveragN);
    mxDestroyArray(HistInterval);
    mxDestroyArray(tau);
    mxDestroyArray(HistFolder);
    mxDestroyArray(ans);
    mxDestroyArray(fid);
    mxDestroyArray(line);
    mxDestroyArray(peaks);
    mxDestroyArray(Period);
    mxDestroyArray(MinTime);
    mxDestroyArray(MaxTime);
    mxDestroyArray(NPeaks);
    mxDestroyArray(MaxAmp);
    mxDestroyArray(MaxSignal);
    mxDestroyArray(TimeSpectralInterval);
    mxDestroyArray(TimeSpectralIntervalNum);
    mxDestroyArray(StartInterval);
    mxDestroyArray(EndInterval);
    mxDestroyArray(CenterOfInterval);
    mxDestroyArray(OutLimits);
    mxDestroyArray(PreccedInterv);
    mxDestroyArray(n);
    mxDestroyArray(InsideInterval);
    mxDestroyArray(MaxAmplN);
    mxDestroyArray(MaxAmpl);
    mxDestroyArray(MinAmpl);
    mxDestroyArray(PeakAmplRange);
    mxDestroyArray(HistIntervalA);
    mxDestroyArray(HistNA);
    mxDestroyArray(i);
    mxDestroyArray(HistBool);
    mxDestroyArray(MaxChN);
    mxDestroyArray(MaxCh);
    mxDestroyArray(MinCh);
    mxDestroyArray(PeakChRange);
    mxDestroyArray(HistIntervalCh);
    mxDestroyArray(HistNCh);
    mxDestroyArray(HistCh);
    mxDestroyArray(MaxT);
    mxDestroyArray(MinT);
    mxDestroyArray(PeakTRange);
    mxDestroyArray(HistIntervalT);
    mxDestroyArray(HistT);
    mxDestroyArray(ZeroBool);
    mxDestroyArray(test);
    mxDestroyArray(Poisson);
    mxDestroyArray(MeanP);
    mxDestroyArray(MaxP);
    mxDestroyArray(MinP);
    mxDestroyArray(PeakPRange);
    mxDestroyArray(HistIntervalP);
    mxDestroyArray(HistP);
    mxDestroyArray(HistAFile);
    mxDestroyArray(HistCFile);
    mxDestroyArray(HeadOfFile);
    mxDestroyArray(FileName);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return HistA;
}
