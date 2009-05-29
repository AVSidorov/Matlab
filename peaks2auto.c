/*
 * MATLAB Compiler: 3.0
 * Date: Thu May 25 18:44:15 2006
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-m" "-W" "main" "-L"
 * "C" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "peaks2auto.m" 
 */
#include "peaks2auto.h"
#include "mwservices.h"
#include "libmatlbm.h"
#include "libmmfile.h"
static mxArray * _mxarray0_;
static mxArray * _mxarray1_;
static mxArray * _mxarray2_;
static mxArray * _mxarray3_;
static mxArray * _mxarray4_;
static mxArray * _mxarray5_;
static mxArray * _mxarray6_;
static mxArray * _mxarray7_;
static mxArray * _mxarray8_;
static mxArray * _mxarray9_;
static mxArray * _mxarray10_;
static mxArray * _mxarray11_;
static mxArray * _mxarray12_;
static mxArray * _mxarray13_;
static mxArray * _mxarray14_;
static mxArray * _mxarray15_;
static mxArray * _mxarray16_;
static mxArray * _mxarray17_;
static double _ieee_plusinf_;
static mxArray * _mxarray18_;

static mxChar _array20_[5] = { 'i', 'n', 't', '1', '6' };
static mxArray * _mxarray19_;

static mxChar _array22_[38] = { '%', '7', '.', '0', 'f', ' ', ' ', 'p',
                                'o', 'i', 'n', 't', 's', ' ', 'o', 'u',
                                't', ' ', 'o', 'f', ' ', 't', 'h', 'e',
                                ' ', 'A', 'D', 'C', ' ', 'r', 'a', 'n',
                                'g', 'e', ' ', ' ', 0x005c, 'n' };
static mxArray * _mxarray21_;
static mxArray * _mxarray23_;

static mxChar _array25_[73] = { 'L', 'o', 'a', 'd', 'i', 'n', 'g', ' ', 't',
                                'i', 'm', 'e', ' ', '=', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%', '7',
                                '.', '4', 'f', ' ', ' ', 's', 'e', 'c',
                                0x005c, 'n' };
static mxArray * _mxarray24_;

static mxChar _array27_[19] = { 'N', 'o', 'w', ' ', 'i', 's', ' ',
                                '%', '3', '.', '0', 'f', ' ', 'P',
                                'a', 's', 's', 0x005c, 'n' };
static mxArray * _mxarray26_;

static mxChar _array29_[73] = { 'M', 'e', 'a', 'n', ' ', 's', 'e', 'a', 'r',
                                'c', 'h', ' ', ' ', '=', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%', '7',
                                '.', '4', 'f', ' ', ' ', 's', 'e', 'c',
                                0x005c, 'n' };
static mxArray * _mxarray28_;

static mxChar _array31_[27] = { ' ', ' ', 'P', 'r', 'e', 'v', 'i',
                                'o', 'u', 's', ' ', 'm', 'e', 'a',
                                'n', ' ', ' ', ' ', '=', ' ', '%',
                                '6', '.', '4', 'f', 0x005c, 'n' };
static mxArray * _mxarray30_;

static mxChar _array33_[27] = { ' ', ' ', 'S', 't', 'a', 'n', 'd',
                                'a', 'r', 'd', ' ', 'd', 'e', 'v',
                                'i', 'a', 't', ' ', '=', ' ', '%',
                                '6', '.', '4', 'f', 0x005c, 'n' };
static mxArray * _mxarray32_;

static mxChar _array35_[26] = { ' ', ' ', 'f', 'i', 't', 't', 'i', 'n', 'g',
                                ' ', 'm', 'e', 'a', 'n', ' ', ' ', ' ', '=',
                                ' ', '%', '6', '.', '4', 'f', 0x005c, 'n' };
static mxArray * _mxarray34_;

static mxChar _array37_[35] = { ' ', ' ', 'f', 'i', 't', 't', 'i', 'n', 'g',
                                ' ', 's', 't', 'a', 'n', 'd', 'a', 'r', 'd',
                                ' ', 'd', 'e', 'v', 'i', 'a', 't', ' ', '=',
                                ' ', '%', '6', '.', '4', 'f', 0x005c, 'n' };
static mxArray * _mxarray36_;
static mxArray * _mxarray38_;

static mxChar _array40_[73] = { 'N', 'e', 'w', ' ', 'm', 'e', 'a', 'n', ' ',
                                's', 'e', 'a', 'r', 'c', 'h', ' ', ' ', '=',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%', '7',
                                '.', '4', 'f', ' ', ' ', 's', 'e', 'c',
                                0x005c, 'n' };
static mxArray * _mxarray39_;

static mxChar _array42_[31] = { ' ', ' ', 'N', 'e', 'w', ' ', 'm', 'e',
                                'a', 'n', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', '=', ' ',
                                '%', '6', '.', '4', 'f', 0x005c, 'n' };
static mxArray * _mxarray41_;

static mxChar _array44_[31] = { ' ', ' ', 'N', 'e', 'w', ' ', 's', 't',
                                'a', 'n', 'd', 'a', 'r', 'd', ' ', 'd',
                                'e', 'v', 'i', 'a', 't', ' ', '=', ' ',
                                '%', '6', '.', '4', 'f', 0x005c, 'n' };
static mxArray * _mxarray43_;

static mxChar _array46_[36] = { ' ', ' ', 'S', 'm', 'o', 'o', 't', 'h',
                                'e', 'd', ' ', 'm', 'e', 'a', 'n', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', '=', ' ', '%', '6', '.',
                                '4', 'f', 0x005c, 'n' };
static mxArray * _mxarray45_;

static mxChar _array48_[36] = { ' ', ' ', 'S', 'm', 'o', 'o', 't', 'h',
                                'e', 'd', ' ', 's', 't', 'a', 'n', 'd',
                                'a', 'r', 'd', ' ', 'd', 'e', 'v', 'i',
                                'a', 't', ' ', '=', ' ', '%', '6', '.',
                                '4', 'f', 0x005c, 'n' };
static mxArray * _mxarray47_;
static mxArray * _mxarray49_;

static mxChar _array51_[39] = { ' ', ' ', ' ', '%', '3', '.', '0', 'f',
                                ' ', ' ', ' ', ' ', 's', 'h', 'o', 'r',
                                't', ' ', 's', 'i', 'g', 'n', 'a', 'l',
                                's', ' ', 'a', 'r', 'e', ' ', 'r', 'e',
                                'm', 'o', 'v', 'e', 'd', 0x005c, 'n' };
static mxArray * _mxarray50_;

static mxChar _array53_[38] = { ' ', ' ', ' ', '%', '3', '.', '0', 'f',
                                ' ', ' ', ' ', ' ', 's', 'l', 'o', 'w',
                                ' ', 's', 'i', 'g', 'n', 'a', 'l', 's',
                                ' ', 'a', 'r', 'e', ' ', 'r', 'e', 'm',
                                'o', 'v', 'e', 'd', 0x005c, 'n' };
static mxArray * _mxarray52_;

static mxChar _array55_[39] = { ' ', ' ', ' ', '%', '3', '.', '0', 'f',
                                ' ', ' ', ' ', ' ', 's', 'm', 'a', 'l',
                                'l', ' ', 's', 'i', 'g', 'n', 'a', 'l',
                                's', ' ', 'a', 'r', 'e', ' ', 'r', 'e',
                                'm', 'o', 'v', 'e', 'd', 0x005c, 'n' };
static mxArray * _mxarray54_;

static mxChar _array57_[73] = { 'S', 'i', 'g', 'n', 'a', 'l', ' ', 'i', 'n',
                                't', 'e', 'r', 'v', 'a', 'l', 's', ' ', 's',
                                'e', 'a', 'r', 'c', 'h', ' ', ' ', '=', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%', '7',
                                '.', '4', 'f', ' ', ' ', 's', 'e', 'c',
                                0x005c, 'n' };
static mxArray * _mxarray56_;

static mxChar _array59_[73] = { 'P', 'e', 'a', 'k', ' ', 's', 'e', 'a', 'r',
                                'c', 'h', ' ', ' ', '=', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%', '7',
                                '.', '4', 'f', ' ', ' ', 's', 'e', 'c',
                                0x005c, 'n' };
static mxArray * _mxarray58_;

static mxChar _array61_[51] = { 'N', 'u', 'm', 'b', 'e', 'r', ' ', 'o', 'f',
                                ' ', 'p', 'e', 'a', 'k', 's', ' ', 'b', 'e',
                                'f', 'o', 'r', 'e', ' ', 'D', 'o', 'u', 'b',
                                'l', 'e', ' ', 'f', 'r', 'o', 'n', 't', ' ',
                                's', 'e', 'a', 'r', 'c', 'h', '=', ' ', '%',
                                '3', '.', '0', 'f', 0x005c, 'n' };
static mxArray * _mxarray60_;

static mxChar _array63_[56] = { 'N', 'u', 'm', 'b', 'e', 'r', ' ', 'o', 'f',
                                ' ', 'G', 'o', 'o', 'd', ' ', 'p', 'e', 'a',
                                'k', 's', ' ', 'b', 'e', 'f', 'o', 'r', 'e',
                                ' ', 'D', 'o', 'u', 'b', 'l', 'e', ' ', 'f',
                                'r', 'o', 'n', 't', ' ', 's', 'e', 'a', 'r',
                                'c', 'h', '=', ' ', '%', '3', '.', '0', 'f',
                                0x005c, 'n' };
static mxArray * _mxarray62_;
static mxArray * _mxarray64_;

static mxChar _array66_[73] = { 'D', 'o', 'u', 'b', 'l', 'e', ' ', 'F', 'r',
                                'o', 'n', 't', ' ', 's', 'e', 'a', 'r', 'c',
                                'h', ' ', ' ', '=', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%', '7',
                                '.', '4', 'f', ' ', ' ', 's', 'e', 'c',
                                0x005c, 'n' };
static mxArray * _mxarray65_;

static mxChar _array68_[44] = { 'N', 'u', 'm', 'b', 'e', 'r', ' ', 'o', 'f',
                                ' ', 'p', 'e', 'a', 'k', 's', ' ', 'w', 'i',
                                't', 'h', ' ', 'D', 'o', 'u', 'b', 'l', 'e',
                                ' ', 'f', 'r', 'o', 'n', 't', 's', ' ', '=',
                                ' ', '%', '3', '.', '0', 'f', 0x005c, 'n' };
static mxArray * _mxarray67_;
static mxArray * _mxarray69_;

static mxChar _array71_[73] = { 'S', 't', 'a', 'n', 'd', 'a', 'r', 'd', 'P',
                                'e', 'a', 'k', 's', ' ', ' ', 's', 'e', 'a',
                                'r', 'c', 'h', ' ', ' ', '=', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%', '7',
                                '.', '4', 'f', ' ', ' ', 's', 'e', 'c',
                                0x005c, 'n' };
static mxArray * _mxarray70_;

static mxChar _array73_[33] = { 'N', 'u', 'm', 'b', 'e', 'r', ' ', 'o', 'f',
                                ' ', 'S', 't', 'a', 'n', 'd', 'a', 'r', 'd',
                                'P', 'e', 'a', 'k', 's', ' ', '=', ' ', '%',
                                '3', '.', '0', 'f', 0x005c, 'n' };
static mxArray * _mxarray72_;

static double _array75_[10] = { -9.0, -8.0, -7.0, -6.0, -5.0,
                                -4.0, -3.0, -2.0, -1.0, 0.0 };
static mxArray * _mxarray74_;

static mxChar _array77_[73] = { 'S', 't', 'a', 'n', 'd', 'a', 'r', 'd', ' ',
                                'P', 'u', 'l', 's', 'e', ' ', 's', 'e', 'a',
                                'r', 'c', 'h', ' ', ' ', '=', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%', '7',
                                '.', '4', 'f', ' ', ' ', 's', 'e', 'c',
                                0x005c, 'n' };
static mxArray * _mxarray76_;

static mxChar _array79_[6] = { 's', 'p', 'l', 'i', 'n', 'e' };
static mxArray * _mxarray78_;
static mxArray * _mxarray80_;
static mxArray * _mxarray81_;
static mxArray * _mxarray82_;

static mxChar _array84_[73] = { 't', 'r', 'e', 'k', ' ', 'r', 'e', 'j', 'e',
                                'c', 't', 'i', 'o', 'n', ' ', ' ', '=', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%', '7',
                                '.', '4', 'f', ' ', ' ', 's', 'e', 'c',
                                0x005c, 'n' };
static mxArray * _mxarray83_;

static mxChar _array86_[23] = { '-', '-', '-', '-', '-', '-', '-', '-',
                                '-', '-', '-', '-', '-', '-', '-', '-',
                                '-', '-', '-', '-', '-', 0x005c, 'n' };
static mxArray * _mxarray85_;

static mxChar _array88_[25] = { 'P', 'e', 'a', 'k', ' ', 't', 'h', 'r', 'e',
                                's', 'h', 'o', 'l', 'd', ' ', '=', ' ', ' ',
                                '%', '3', '.', '3', 'f', 0x005c, 'n' };
static mxArray * _mxarray87_;

static mxChar _array90_[30] = { 'T', 'h', 'e', ' ', 'n', 'u', 'm', 'b',
                                'e', 'r', ' ', 'o', 'f', ' ', 'p', 'e',
                                'a', 'k', 's', ' ', '=', ' ', ' ', '%',
                                '5', '.', '0', 'f', 0x005c, 'n' };
static mxArray * _mxarray89_;

static mxChar _array92_[33] = { 'T', 'h', 'e', ' ', 'p', 'e', 'r', 'i', 'o',
                                'd', ' ', 'o', 'f', ' ', 'p', 'e', 'a', 'k',
                                's', ' ', '=', ' ', ' ', '%', '6', '.', '4',
                                'f', ' ', 'm', 's', 0x005c, 'n' };
static mxArray * _mxarray91_;
static mxArray * _mxarray93_;

static mxChar _array95_[59] = { 'R', 'e', 's', 'o', 'l', 'u', 't', 'i', 'o',
                                'n', ' ', 'i', 'n', ' ', 't', 'h', 'e', ' ',
                                'p', 'e', 'a', 'k', ' ', 'a', 'm', 'p', 'l',
                                'i', 't', 'u', 'd', 'e', ' ', 'h', 'i', 's',
                                't', 'o', 'g', 'r', 'a', 'm', '=', ' ', ' ',
                                '%', '3', '.', '3', 'f', ' ', 'c', 'o', 'u',
                                'n', 't', 's', 0x005c, 'n' };
static mxArray * _mxarray94_;

static mxChar _array97_[54] = { 'R', 'e', 's', 'o', 'l', 'u', 't', 'i',
                                'o', 'n', ' ', 'i', 'n', ' ', 't', 'h',
                                'e', ' ', 'p', 'e', 'a', 'k', ' ', 'i',
                                'n', 't', 'e', 'r', 'v', 'a', 'l', ' ',
                                'h', 'i', 's', 't', 'o', 'g', 'r', 'a',
                                'm', '=', ' ', ' ', '%', '3', '.', '3',
                                'f', ' ', 'u', 's', 0x005c, 'n' };
static mxArray * _mxarray96_;

static mxChar _array99_[55] = { 'E', 'x', 'p', 'e', 'c', 't', 'e', 'd',
                                ' ', 'n', 'u', 'm', 'b', 'e', 'r', ' ',
                                'o', 'f', ' ', 'd', 'o', 'u', 'b', 'l',
                                'e', ' ', 'p', 'e', 'a', 'k', 's', ' ',
                                'f', 'o', 'r', ' ', '0', '.', '0', '2',
                                '5', ' ', 'u', 's', ' ', '=', ' ', '%',
                                '3', '.', '3', 'f', ' ', 0x005c, 'n' };
static mxArray * _mxarray98_;

static mxChar _array101_[23] = { '=', '=', '=', '=', '=', '=', '=', '=',
                                 '=', '=', '=', '=', '=', '=', '=', '=',
                                 '=', '=', '=', '=', '=', 0x005c, 'n' };
static mxArray * _mxarray100_;

static mxChar _array103_[4] = { 'h', 'i', 's', 'A' };
static mxArray * _mxarray102_;

static mxChar _array105_[9] = { 'H', 'i', 's', 't', 'A', '.', 'd', 'a', 't' };
static mxArray * _mxarray104_;

static mxChar _array107_[1] = { 'w' };
static mxArray * _mxarray106_;

static mxChar _array109_[19] = { '%', '6', '.', '2', 'f', ' ', '%',
                                 '3', '.', '0', 'f', ' ', '%', '5',
                                 '.', '2', 'f', 0x005c, 'n' };
static mxArray * _mxarray108_;

static mxChar _array111_[4] = { 'h', 'i', 's', 'C' };
static mxArray * _mxarray110_;

static mxChar _array113_[9] = { 'H', 'i', 's', 't', 'C', '.', 'd', 'a', 't' };
static mxArray * _mxarray112_;

static mxChar _array115_[4] = { 'p', 'e', 'a', 'k' };
static mxArray * _mxarray114_;

static mxChar _array117_[9] = { 'p', 'e', 'a', 'k', 's', '.', 'd', 'a', 't' };
static mxArray * _mxarray116_;

static mxChar _array119_[71] = { 's', 't', 'a', 'r', 't', ' ', ' ', ' ', ' ',
                                 ' ', ' ', ' ', 'p', 'e', 'a', 'k', ' ', ' ',
                                 ' ', ' ', ' ', ' ', 'i', 'n', 't', 'e', 'r',
                                 'v', ' ', ' ', ' ', ' ', ' ', ' ', 'z', 'e',
                                 'r', 'o', ' ', ' ', 'a', 'm', 'p', 'l', ' ',
                                 ' ', ' ', ' ', 'c', 'h', 'a', 'r', 'g', 'e',
                                 ' ', 'd', 'u', 'r', 'a', 't', 'i', 'o', 'n',
                                 ' ', 'C', 'o', 'm', 'b', 'N', 0x005c, 'n' };
static mxArray * _mxarray118_;

static mxChar _array121_[52] = { '%', '1', '0', '.', '3', 'f', ' ', '%', '1',
                                 '0', '.', '3', 'f', ' ', '%', '9', '.', '3',
                                 'f', ' ', '%', '7', '.', '2', 'f', ' ', '%',
                                 '7', '.', '2', 'f', ' ', '%', '7', '.', '2',
                                 'f', ' ', '%', '5', '.', '3', 'f', ' ', '%',
                                 '2', '.', '0', 'f', ' ', 0x005c, 'n' };
static mxArray * _mxarray120_;

static mxChar _array123_[66] = { 'A', 'l', 'l', ' ', 't', 'i', 'm', 'e', '=',
                                 ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                 ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                 ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                 ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                 ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                 ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%', '7',
                                 '.', '3', 'f' };
static mxArray * _mxarray122_;

void InitializeModule_peaks2auto(void) {
    _mxarray0_ = mclInitializeDouble(0.0);
    _mxarray1_ = mclInitializeDouble(1.0);
    _mxarray2_ = mclInitializeDouble(.1);
    _mxarray3_ = mclInitializeDouble(2.0);
    _mxarray4_ = mclInitializeDouble(.05);
    _mxarray5_ = mclInitializeDouble(.15);
    _mxarray6_ = mclInitializeDouble(.8);
    _mxarray7_ = mclInitializeDouble(.95);
    _mxarray8_ = mclInitializeDouble(8.0);
    _mxarray9_ = mclInitializeDouble(30.0);
    _mxarray10_ = mclInitializeDouble(20.0);
    _mxarray11_ = mclInitializeDouble(.5);
    _mxarray12_ = mclInitializeDouble(1.6);
    _mxarray13_ = mclInitializeDouble(.025);
    _mxarray14_ = mclInitializeDouble(5.0);
    _mxarray15_ = mclInitializeDouble(4.0);
    _mxarray16_ = mclInitializeDouble(10.0);
    _mxarray17_ = mclInitializeDouble(4095.0);
    _ieee_plusinf_ = mclGetInf();
    _mxarray18_ = mclInitializeDouble(_ieee_plusinf_);
    _mxarray19_ = mclInitializeString(5, _array20_);
    _mxarray21_ = mclInitializeString(38, _array22_);
    _mxarray23_ = mclInitializeDoubleVector(0, 0, (double *)NULL);
    _mxarray24_ = mclInitializeString(73, _array25_);
    _mxarray26_ = mclInitializeString(19, _array27_);
    _mxarray28_ = mclInitializeString(73, _array29_);
    _mxarray30_ = mclInitializeString(27, _array31_);
    _mxarray32_ = mclInitializeString(27, _array33_);
    _mxarray34_ = mclInitializeString(26, _array35_);
    _mxarray36_ = mclInitializeString(35, _array37_);
    _mxarray38_ = mclInitializeDouble(2500.0);
    _mxarray39_ = mclInitializeString(73, _array40_);
    _mxarray41_ = mclInitializeString(31, _array42_);
    _mxarray43_ = mclInitializeString(31, _array44_);
    _mxarray45_ = mclInitializeString(36, _array46_);
    _mxarray47_ = mclInitializeString(36, _array48_);
    _mxarray49_ = mclInitializeDouble(-1.0);
    _mxarray50_ = mclInitializeString(39, _array51_);
    _mxarray52_ = mclInitializeString(38, _array53_);
    _mxarray54_ = mclInitializeString(39, _array55_);
    _mxarray56_ = mclInitializeString(73, _array57_);
    _mxarray58_ = mclInitializeString(73, _array59_);
    _mxarray60_ = mclInitializeString(51, _array61_);
    _mxarray62_ = mclInitializeString(56, _array63_);
    _mxarray64_ = mclInitializeDouble(1.5);
    _mxarray65_ = mclInitializeString(73, _array66_);
    _mxarray67_ = mclInitializeString(44, _array68_);
    _mxarray69_ = mclInitializeDouble(3.0);
    _mxarray70_ = mclInitializeString(73, _array71_);
    _mxarray72_ = mclInitializeString(33, _array73_);
    _mxarray74_ = mclInitializeDoubleVector(1, 10, _array75_);
    _mxarray76_ = mclInitializeString(73, _array77_);
    _mxarray78_ = mclInitializeString(6, _array79_);
    _mxarray80_ = mclInitializeDouble(-2.0);
    _mxarray81_ = mclInitializeDouble(6.0);
    _mxarray82_ = mclInitializeDouble(7.0);
    _mxarray83_ = mclInitializeString(73, _array84_);
    _mxarray85_ = mclInitializeString(23, _array86_);
    _mxarray87_ = mclInitializeString(25, _array88_);
    _mxarray89_ = mclInitializeString(30, _array90_);
    _mxarray91_ = mclInitializeString(33, _array92_);
    _mxarray93_ = mclInitializeDouble(1000.0);
    _mxarray94_ = mclInitializeString(59, _array95_);
    _mxarray96_ = mclInitializeString(54, _array97_);
    _mxarray98_ = mclInitializeString(55, _array99_);
    _mxarray100_ = mclInitializeString(23, _array101_);
    _mxarray102_ = mclInitializeString(4, _array103_);
    _mxarray104_ = mclInitializeString(9, _array105_);
    _mxarray106_ = mclInitializeString(1, _array107_);
    _mxarray108_ = mclInitializeString(19, _array109_);
    _mxarray110_ = mclInitializeString(4, _array111_);
    _mxarray112_ = mclInitializeString(9, _array113_);
    _mxarray114_ = mclInitializeString(4, _array115_);
    _mxarray116_ = mclInitializeString(9, _array117_);
    _mxarray118_ = mclInitializeString(71, _array119_);
    _mxarray120_ = mclInitializeString(52, _array121_);
    _mxarray122_ = mclInitializeString(66, _array123_);
}

void TerminateModule_peaks2auto(void) {
    mxDestroyArray(_mxarray122_);
    mxDestroyArray(_mxarray120_);
    mxDestroyArray(_mxarray118_);
    mxDestroyArray(_mxarray116_);
    mxDestroyArray(_mxarray114_);
    mxDestroyArray(_mxarray112_);
    mxDestroyArray(_mxarray110_);
    mxDestroyArray(_mxarray108_);
    mxDestroyArray(_mxarray106_);
    mxDestroyArray(_mxarray104_);
    mxDestroyArray(_mxarray102_);
    mxDestroyArray(_mxarray100_);
    mxDestroyArray(_mxarray98_);
    mxDestroyArray(_mxarray96_);
    mxDestroyArray(_mxarray94_);
    mxDestroyArray(_mxarray93_);
    mxDestroyArray(_mxarray91_);
    mxDestroyArray(_mxarray89_);
    mxDestroyArray(_mxarray87_);
    mxDestroyArray(_mxarray85_);
    mxDestroyArray(_mxarray83_);
    mxDestroyArray(_mxarray82_);
    mxDestroyArray(_mxarray81_);
    mxDestroyArray(_mxarray80_);
    mxDestroyArray(_mxarray78_);
    mxDestroyArray(_mxarray76_);
    mxDestroyArray(_mxarray74_);
    mxDestroyArray(_mxarray72_);
    mxDestroyArray(_mxarray70_);
    mxDestroyArray(_mxarray69_);
    mxDestroyArray(_mxarray67_);
    mxDestroyArray(_mxarray65_);
    mxDestroyArray(_mxarray64_);
    mxDestroyArray(_mxarray62_);
    mxDestroyArray(_mxarray60_);
    mxDestroyArray(_mxarray58_);
    mxDestroyArray(_mxarray56_);
    mxDestroyArray(_mxarray54_);
    mxDestroyArray(_mxarray52_);
    mxDestroyArray(_mxarray50_);
    mxDestroyArray(_mxarray49_);
    mxDestroyArray(_mxarray47_);
    mxDestroyArray(_mxarray45_);
    mxDestroyArray(_mxarray43_);
    mxDestroyArray(_mxarray41_);
    mxDestroyArray(_mxarray39_);
    mxDestroyArray(_mxarray38_);
    mxDestroyArray(_mxarray36_);
    mxDestroyArray(_mxarray34_);
    mxDestroyArray(_mxarray32_);
    mxDestroyArray(_mxarray30_);
    mxDestroyArray(_mxarray28_);
    mxDestroyArray(_mxarray26_);
    mxDestroyArray(_mxarray24_);
    mxDestroyArray(_mxarray23_);
    mxDestroyArray(_mxarray21_);
    mxDestroyArray(_mxarray19_);
    mxDestroyArray(_mxarray18_);
    mxDestroyArray(_mxarray17_);
    mxDestroyArray(_mxarray16_);
    mxDestroyArray(_mxarray15_);
    mxDestroyArray(_mxarray14_);
    mxDestroyArray(_mxarray13_);
    mxDestroyArray(_mxarray12_);
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
    mxDestroyArray(_mxarray1_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * mlfPeaks2auto_MeanSearch(mxArray * * StdVal,
                                          mxArray * * PP,
                                          mxArray * * Noise,
                                          mxArray * tr,
                                          mxArray * OverSt,
                                          mxArray * Noise_in,
                                          mxArray * Plot1,
                                          mxArray * Plot2,
                                          mxArray * trD);
static void mlxPeaks2auto_MeanSearch(int nlhs,
                                     mxArray * plhs[],
                                     int nrhs,
                                     mxArray * prhs[]);
static mxArray * Mpeaks2auto(mxArray * * HistA,
                             int nargout_,
                             mxArray * FileName,
                             mxArray * Dialog,
                             mxArray * MaxSignal);
static mxArray * Mpeaks2auto_MeanSearch(mxArray * * StdVal,
                                        mxArray * * PP,
                                        mxArray * * Noise,
                                        int nargout_,
                                        mxArray * tr,
                                        mxArray * OverSt,
                                        mxArray * Noise_in,
                                        mxArray * Plot1,
                                        mxArray * Plot2,
                                        mxArray * trD);

static mexFunctionTableEntry local_function_table_[1]
  = { { "MeanSearch", mlxPeaks2auto_MeanSearch, 6, 4, NULL } };

_mexLocalFunctionTable _local_function_table_peaks2auto
  = { 1, local_function_table_ };

/*
 * The function "mlfPeaks2auto" contains the normal interface for the
 * "peaks2auto" M-function from file "e:\scn\efield\matlab\peaks2auto.m" (lines
 * 1-696). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfPeaks2auto(mxArray * * HistA,
                        mxArray * FileName,
                        mxArray * Dialog,
                        mxArray * MaxSignal) {
    int nargout = 1;
    mxArray * peaks = NULL;
    mxArray * HistA__ = NULL;
    mlfEnterNewContext(1, 3, HistA, FileName, Dialog, MaxSignal);
    if (HistA != NULL) {
        ++nargout;
    }
    peaks = Mpeaks2auto(&HistA__, nargout, FileName, Dialog, MaxSignal);
    mlfRestorePreviousContext(1, 3, HistA, FileName, Dialog, MaxSignal);
    if (HistA != NULL) {
        mclCopyOutputArg(HistA, HistA__);
    } else {
        mxDestroyArray(HistA__);
    }
    return mlfReturnValue(peaks);
}

/*
 * The function "mlxPeaks2auto" contains the feval interface for the
 * "peaks2auto" M-function from file "e:\scn\efield\matlab\peaks2auto.m" (lines
 * 1-696). The feval function calls the implementation version of peaks2auto
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxPeaks2auto(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: peaks2auto Line: 1 Column:"
            " 1 The function \"peaks2auto\" was called with m"
            "ore than the declared number of outputs (2)."),
          NULL);
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: peaks2auto Line: 1 Column"
            ": 1 The function \"peaks2auto\" was called with"
            " more than the declared number of inputs (3)."),
          NULL);
    }
    for (i = 0; i < 2; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    mplhs[0] = Mpeaks2auto(&mplhs[1], nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfPeaks2auto_MeanSearch" contains the normal interface for
 * the "peaks2auto/MeanSearch" M-function from file
 * "e:\scn\efield\matlab\peaks2auto.m" (lines 696-747). This function processes
 * any input arguments and passes them to the implementation version of the
 * function, appearing above.
 */
static mxArray * mlfPeaks2auto_MeanSearch(mxArray * * StdVal,
                                          mxArray * * PP,
                                          mxArray * * Noise,
                                          mxArray * tr,
                                          mxArray * OverSt,
                                          mxArray * Noise_in,
                                          mxArray * Plot1,
                                          mxArray * Plot2,
                                          mxArray * trD) {
    int nargout = 1;
    mxArray * MeanVal = NULL;
    mxArray * StdVal__ = NULL;
    mxArray * PP__ = NULL;
    mxArray * Noise__ = NULL;
    mlfEnterNewContext(
      3, 6, StdVal, PP, Noise, tr, OverSt, Noise_in, Plot1, Plot2, trD);
    if (StdVal != NULL) {
        ++nargout;
    }
    if (PP != NULL) {
        ++nargout;
    }
    if (Noise != NULL) {
        ++nargout;
    }
    MeanVal
      = Mpeaks2auto_MeanSearch(
          &StdVal__,
          &PP__,
          &Noise__,
          nargout,
          tr,
          OverSt,
          Noise_in,
          Plot1,
          Plot2,
          trD);
    mlfRestorePreviousContext(
      3, 6, StdVal, PP, Noise, tr, OverSt, Noise_in, Plot1, Plot2, trD);
    if (StdVal != NULL) {
        mclCopyOutputArg(StdVal, StdVal__);
    } else {
        mxDestroyArray(StdVal__);
    }
    if (PP != NULL) {
        mclCopyOutputArg(PP, PP__);
    } else {
        mxDestroyArray(PP__);
    }
    if (Noise != NULL) {
        mclCopyOutputArg(Noise, Noise__);
    } else {
        mxDestroyArray(Noise__);
    }
    return mlfReturnValue(MeanVal);
}

/*
 * The function "mlxPeaks2auto_MeanSearch" contains the feval interface for the
 * "peaks2auto/MeanSearch" M-function from file
 * "e:\scn\efield\matlab\peaks2auto.m" (lines 696-747). The feval function
 * calls the implementation version of peaks2auto/MeanSearch through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
static void mlxPeaks2auto_MeanSearch(int nlhs,
                                     mxArray * plhs[],
                                     int nrhs,
                                     mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[4];
    int i;
    if (nlhs > 4) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: peaks2auto/MeanSearch Line: 696 Co"
            "lumn: 1 The function \"peaks2auto/MeanSearch\" was calle"
            "d with more than the declared number of outputs (4)."),
          NULL);
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: peaks2auto/MeanSearch Line: 696 C"
            "olumn: 1 The function \"peaks2auto/MeanSearch\" was cal"
            "led with more than the declared number of inputs (6)."),
          NULL);
    }
    for (i = 0; i < 4; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 6 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 6; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    mplhs[0]
      = Mpeaks2auto_MeanSearch(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5]);
    mlfRestorePreviousContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 4 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 4; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "Mpeaks2auto" is the implementation version of the "peaks2auto"
 * M-function from file "e:\scn\efield\matlab\peaks2auto.m" (lines 1-696). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [peaks,HistA]=Peaks2auto(FileName,Dialog,MaxSignal);
 */
static mxArray * Mpeaks2auto(mxArray * * HistA,
                             int nargout_,
                             mxArray * FileName,
                             mxArray * Dialog,
                             mxArray * MaxSignal) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_peaks2auto);
    int nargin_ = mclNargin(3, FileName, Dialog, MaxSignal, NULL);
    mxArray * peaks = NULL;
    mxArray * PeakFile = NULL;
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
    mxArray * HistC = NULL;
    mxArray * HistIntervalC = NULL;
    mxArray * PeakCRange = NULL;
    mxArray * MinC = NULL;
    mxArray * MaxC = NULL;
    mxArray * ZeroBool = NULL;
    mxArray * HistT = NULL;
    mxArray * HistIntervalT = NULL;
    mxArray * PeakTRange = NULL;
    mxArray * MinT = NULL;
    mxArray * MaxT = NULL;
    mxArray * HistBool = NULL;
    mxArray * HistN = NULL;
    mxArray * HistIntervalA = NULL;
    mxArray * PeakAmplRange = NULL;
    mxArray * MinAmpl = NULL;
    mxArray * MaxAmpl = NULL;
    mxArray * Period = NULL;
    mxArray * FitIdx = NULL;
    mxArray * PulseFitMaxIdx = NULL;
    mxArray * PulseFitMax = NULL;
    mxArray * PulseFitM = NULL;
    mxArray * MinKhi2Idx10 = NULL;
    mxArray * MinKhi2Idx = NULL;
    mxArray * MinKhi2 = NULL;
    mxArray * k = NULL;
    mxArray * FitNi = NULL;
    mxArray * ShortFit = NULL;
    mxArray * FitPulseFin = NULL;
    mxArray * FitPoints = NULL;
    mxArray * PolyKhi2 = NULL;
    mxArray * Khi2Fit = NULL;
    mxArray * Sum3 = NULL;
    mxArray * Sum2 = NULL;
    mxArray * Sum1 = NULL;
    mxArray * B = NULL;
    mxArray * A = NULL;
    mxArray * Khi2Fin = NULL;
    mxArray * PulseInterpShiftedTest = NULL;
    mxArray * PulseInterp10Shifted = NULL;
    mxArray * Sums3Short = NULL;
    mxArray * Sums2Short = NULL;
    mxArray * Sums3 = NULL;
    mxArray * Sums2 = NULL;
    mxArray * FitPulseShort = NULL;
    mxArray * FitPulse = NULL;
    mxArray * PulseInterpShifted = NULL;
    mxArray * FitN = NULL;
    mxArray * PulseI10MaxIdx = NULL;
    mxArray * PulseI10Max = NULL;
    mxArray * PulseIMaxIdx = NULL;
    mxArray * PulseIMax = NULL;
    mxArray * PulseInterp10 = NULL;
    mxArray * PulseInterp = NULL;
    mxArray * StartBFitPoint = NULL;
    mxArray * EndFitPoint = NULL;
    mxArray * StartFitPoint = NULL;
    mxArray * PulseMaxIdx = NULL;
    mxArray * PulseMax = NULL;
    mxArray * PulseFit = NULL;
    mxArray * PulseN = NULL;
    mxArray * MinPulseNorm = NULL;
    mxArray * PulseNorm = NULL;
    mxArray * PulseOverThr = NULL;
    mxArray * PulseDOverThr = NULL;
    mxArray * PulseD = NULL;
    mxArray * PulseR = NULL;
    mxArray * MinPulse = NULL;
    mxArray * Pulse = NULL;
    mxArray * StandardPulsesNorm = NULL;
    mxArray * StandardPulses = NULL;
    mxArray * M = NULL;
    mxArray * MaxIndSP = NULL;
    mxArray * RangeSP = NULL;
    mxArray * MinSPInd = NULL;
    mxArray * MinSP = NULL;
    mxArray * MaxSPInd = NULL;
    mxArray * MaxSP = NULL;
    mxArray * PolyFitLog = NULL;
    mxArray * FitLog = NULL;
    mxArray * TailIdx = NULL;
    mxArray * PolyTail = NULL;
    mxArray * StPeakN = NULL;
    mxArray * MinStPeakIdx = NULL;
    mxArray * MinStPeak = NULL;
    mxArray * MaxStPeakIdx = NULL;
    mxArray * MaxStPeak = NULL;
    mxArray * PeakEnd = NULL;
    mxArray * Idx = NULL;
    mxArray * PeakStart = NULL;
    mxArray * Tail = NULL;
    mxArray * StandardPulse = NULL;
    mxArray * StandardPeaksN = NULL;
    mxArray * StandardPeaks = NULL;
    mxArray * PeakSpanInd = NULL;
    mxArray * DoubleFrontSize = NULL;
    mxArray * DoubleFrontInd = NULL;
    mxArray * GoodPeakN = NULL;
    mxArray * PeakN = NULL;
    mxArray * FrontSignalN = NULL;
    mxArray * MaxPeakInd = NULL;
    mxArray * Ind = NULL;
    mxArray * MaxPeak = NULL;
    mxArray * Max = NULL;
    mxArray * NumGoodPeaks = NULL;
    mxArray * NumPeaks = NULL;
    mxArray * GoodVisiblePeakInd = NULL;
    mxArray * VisiblePeakInd = NULL;
    mxArray * E = NULL;
    mxArray * S = NULL;
    mxArray * PeakVal = NULL;
    mxArray * GoodPeakVal = NULL;
    mxArray * GoodPeakInd = NULL;
    mxArray * PeakOnFrontInd = NULL;
    mxArray * PeakInd = NULL;
    mxArray * Range = NULL;
    mxArray * MoveToSignal = NULL;
    mxArray * SizeMoveToNoise = NULL;
    mxArray * MoveToNoise = NULL;
    mxArray * EndNoise = NULL;
    mxArray * StartNoise = NULL;
    mxArray * NoiseL = NULL;
    mxArray * NoiseR = NULL;
    mxArray * Noise = NULL;
    mxArray * MeanValD = NULL;
    mxArray * LD = NULL;
    mxArray * trekD = NULL;
    mxArray * trekL = NULL;
    mxArray * i = NULL;
    mxArray * trekR = NULL;
    mxArray * SmoothedNoise = NULL;
    mxArray * SmoothGate = NULL;
    mxArray * MaxSpectr0 = NULL;
    mxArray * MaxSpectr = NULL;
    mxArray * MaxTime = NULL;
    mxArray * MinTime = NULL;
    mxArray * MaxAmp = NULL;
    mxArray * PolyZero = NULL;
    mxArray * PeakPolarity = NULL;
    mxArray * MeanVal = NULL;
    mxArray * NoiseArray = NULL;
    mxArray * SignalN = NULL;
    mxArray * SizeMoveToSignal = NULL;
    mxArray * Slow = NULL;
    mxArray * SlowInd = NULL;
    mxArray * SlowN = NULL;
    mxArray * EndSignal = NULL;
    mxArray * StartSignal = NULL;
    mxArray * StdVal = NULL;
    mxArray * StdValD = NULL;
    mxArray * Threshold = NULL;
    mxArray * ThresholdD = NULL;
    mxArray * NPeaks1 = NULL;
    mxArray * trekMinus = NULL;
    mxArray * Pass = NULL;
    mxArray * DeltaNPeaks = NULL;
    mxArray * NPeaks = NULL;
    mxArray * trekStart = NULL;
    mxArray * trekSize = NULL;
    mxArray * OutRangeN = NULL;
    mxArray * bool0 = NULL;
    mxArray * fid = NULL;
    mxArray * trek = NULL;
    mxArray * ans = NULL;
    mxArray * MinTailN = NULL;
    mxArray * MinFrontN = NULL;
    mxArray * MaxTailN = NULL;
    mxArray * MaxFrontN = NULL;
    mxArray * SecondPassFull = NULL;
    mxArray * Khi2Thr = NULL;
    mxArray * TauFitN = NULL;
    mxArray * BFitPointsN = NULL;
    mxArray * lowf = NULL;
    mxArray * tau = NULL;
    mxArray * DeadTime = NULL;
    mxArray * ChargeTime = NULL;
    mxArray * HistInterval = NULL;
    mxArray * AveragN = NULL;
    mxArray * MaxCombined = NULL;
    mxArray * MinInterval = NULL;
    mxArray * ZeroPoints = NULL;
    mxArray * Dshift = NULL;
    mxArray * MaxDuration = NULL;
    mxArray * MinDuration = NULL;
    mxArray * MaxTail = NULL;
    mxArray * MinTail = NULL;
    mxArray * MaxFront = NULL;
    mxArray * MinFront = NULL;
    mxArray * PeakSt = NULL;
    mxArray * OverSt = NULL;
    mxArray * AverageGate = NULL;
    mxArray * Plot2 = NULL;
    mxArray * Plot1 = NULL;
    mxArray * DeadAfter = NULL;
    mxArray * FrontCharge = NULL;
    mxArray * Fourie = NULL;
    mxArray * Delta = NULL;
    mxArray * Text = NULL;
    mclCopyArray(&FileName);
    mclCopyArray(&Dialog);
    mclCopyArray(&MaxSignal);
    /*
     * %[peaks,HistA]=Peaks(FileName); gets peaks from plasma x-ray trek.
     * 
     * Text=0;           % switch between text and binary input files
     */
    mlfAssign(&Text, _mxarray0_);
    /*
     * Delta=1;          % if Delta=1 then trekD is used for peak detection, else the peaks are detected from the trek.  
     */
    mlfAssign(&Delta, _mxarray1_);
    /*
     * Fourie=0;         %if Fourie=1 then performes Fourie transformation of the signal. 
     */
    mlfAssign(&Fourie, _mxarray0_);
    /*
     * % there are bugs in Fourie still. scale etc... 
     * FrontCharge=1;    % if FrontCharge=1 then the cahrge is calculated till peak maximum else charge is calculated within ChargeTime
     */
    mlfAssign(&FrontCharge, _mxarray1_);
    /*
     * DeadAfter=1;      % if DeadAfter=1 then all pulses during DeadTime 
     */
    mlfAssign(&DeadAfter, _mxarray1_);
    /*
     * % after peaks exceeding MaxSignal are eliminated (to avoied excited noises) 
     * Plot1=1;          % if 1 then trek plot is active                  
     */
    mlfAssign(&Plot1, _mxarray1_);
    /*
     * Plot2=0;          % if 1 then interval plot is active
     */
    mlfAssign(&Plot2, _mxarray0_);
    /*
     * 
     * AverageGate=0.1;  % Averaging gate
     */
    mlfAssign(&AverageGate, _mxarray2_);
    /*
     * OverSt=2;         % noise regection threshold, in standard deviations    
     */
    mlfAssign(&OverSt, _mxarray3_);
    /*
     * PeakSt=2;         % peak threshold, in standard deviations   
     */
    mlfAssign(&PeakSt, _mxarray3_);
    /*
     * MinFront=0.05;    % minimal front edge of peaks, us
     */
    mlfAssign(&MinFront, _mxarray4_);
    /*
     * MaxFront=0.15;    % maximal front edge of peaks, us
     */
    mlfAssign(&MaxFront, _mxarray5_);
    /*
     * MinTail=0.05;     % minimal tail edge of peaks, us
     */
    mlfAssign(&MinTail, _mxarray4_);
    /*
     * MaxTail=0.8;      % maximal tail edge of peaks, us
     */
    mlfAssign(&MaxTail, _mxarray6_);
    /*
     * 
     * MinDuration=0.1;  % minimal peak duration, us. Shorter peaks are eliminated 
     */
    mlfAssign(&MinDuration, _mxarray2_);
    /*
     * MaxDuration=0.95; % maximal peak duration, us. Longer peaks are eliminated. 
     */
    mlfAssign(&MaxDuration, _mxarray7_);
    /*
     * 
     * Dshift=1;         %circshift(trek(:,2),Dshift); 
     */
    mlfAssign(&Dshift, _mxarray1_);
    /*
     * ZeroPoints=8;     % for avaraging peak zero level
     */
    mlfAssign(&ZeroPoints, _mxarray8_);
    /*
     * MinInterval=0.1;  % minimum peak-to-peak interval,  us
     */
    mlfAssign(&MinInterval, _mxarray2_);
    /*
     * MaxCombined=30;   % maximum combined peaks allowed for MinInterval
     */
    mlfAssign(&MaxCombined, _mxarray9_);
    /*
     * AveragN=20;       % Averaged number of peaks in histogram interval  
     */
    mlfAssign(&AveragN, _mxarray10_);
    /*
     * 
     * HistInterval=20;  % count interval for amplitude and cahrge histograms
     */
    mlfAssign(&HistInterval, _mxarray10_);
    /*
     * ChargeTime=0.5;   % us
     */
    mlfAssign(&ChargeTime, _mxarray11_);
    /*
     * DeadTime=1.6;     % us 
     */
    mlfAssign(&DeadTime, _mxarray12_);
    /*
     * tau=0.025;        % us digitizing time
     */
    mlfAssign(&tau, _mxarray13_);
    /*
     * lowf=5;           % MHz,  frequencies higher than lowf may be cut by digital filter
     */
    mlfAssign(&lowf, _mxarray14_);
    /*
     * 
     * BFitPointsN=4;    %number of points for fitting b
     */
    mlfAssign(&BFitPointsN, _mxarray15_);
    /*
     * TauFitN=4;        %number of intervals in fitting by time dt=tau/TauFitN
     */
    mlfAssign(&TauFitN, _mxarray15_);
    /*
     * Khi2Thr=10;       %Sigma^2 threshold in pulsefiting;      
     */
    mlfAssign(&Khi2Thr, _mxarray16_);
    /*
     * SecondPassFull=false; %Second Pass of rejection with new noise etc. search or with old values StdVal etc.
     */
    mlfAssign(&SecondPassFull, mlfFalse(NULL));
    /*
     * 
     * 
     * MaxFrontN=round(MaxFront/tau); MaxTailN=round(MaxTail/tau);
     */
    mlfAssign(
      &MaxFrontN,
      mlfRound(mclMrdivide(mclVv(MaxFront, "MaxFront"), mclVv(tau, "tau"))));
    mlfAssign(
      &MaxTailN,
      mlfRound(mclMrdivide(mclVv(MaxTail, "MaxTail"), mclVv(tau, "tau"))));
    /*
     * MinFrontN=round(MinFront/tau); MinTailN=round(MinTail/tau);
     */
    mlfAssign(
      &MinFrontN,
      mlfRound(mclMrdivide(mclVv(MinFront, "MinFront"), mclVv(tau, "tau"))));
    mlfAssign(
      &MinTailN,
      mlfRound(mclMrdivide(mclVv(MinTail, "MinTail"), mclVv(tau, "tau"))));
    /*
     * 
     * %%%% Normal distribution  G(x)=exp(-0.5*((x-x0)/sigma)^2)/(2*pi)^0.5/sigma;
     * %%%% <G(x)>=1; <x*G(x)>=x0; <x^2*G(x)>=sigma^2; 
     * %%%% x>x0: <G(x)>=0.5; <x*G(x)>=x0+sigma/(2*pi)^0.5; <x^2*G(x)>=0.5*sigma^2; 
     * %%%% the number of meaurements N at x>k*sigma: 
     * %%%% k=(0.,0.2,0.4,0.6,0.8,1,1.2,1.4,1.8,2,2.2,2.4,2.6,2.8,3,3.2,3.4,3.6,3.8,4)
     * %%%% N=(1,0.841,0.689,0.548,0.423,0.317,0.230,0.161,0.0718,0.0455,0.0278,0.0164,0.00932,0.00511,0.00270,0.00137,0.000674,0.000318,0.000145,0.0000633)
     * 
     * %%%% G(x-x0=sigma)=0.607*G(0); G(x-x0=2*sigma)=0.368*G(0)
     * 
     * 
     * % frequency range after the fft transformation 
     * % N - the number of points in a trek
     * % tau  - measurement period
     * % fft(trek,N) -> N points in the spectrum in the range grom 0 to 1/tau
     * % and distanced by 1/tau/N-1. Only (0-1/2/tau) range should be taken into account!!!
     * 
     * if nargin<2 Dialog=true; MaxSignal=4095;  end; 
     */
    if (nargin_ < 2) {
        mlfAssign(&Dialog, mlfTrue(NULL));
        mlfAssign(&MaxSignal, _mxarray17_);
    }
    /*
     * 
     * tic;
     */
    mlfTic();
    /*
     * if Text  
     */
    if (mlfTobool(mclVv(Text, "Text"))) {
        /*
         * if isstr(FileName) trek=load(FileName);  else  trek=FileName;  end; 
         */
        if (mlfTobool(mlfIsstr(mclVa(FileName, "FileName")))) {
            mlfAssign(&trek, mlfLoadStruct(mclVa(FileName, "FileName"), NULL));
        } else {
            mlfAssign(&trek, mclVa(FileName, "FileName"));
        }
    /*
     * else    
     */
    } else {
        /*
         * if isstr(FileName) 
         */
        if (mlfTobool(mlfIsstr(mclVa(FileName, "FileName")))) {
            /*
             * fid = fopen(FileName); trek = fread(fid,inf,'int16'); fclose(fid);  
             */
            mlfAssign(
              &fid,
              mlfFopen(NULL, NULL, mclVa(FileName, "FileName"), NULL, NULL));
            mlfAssign(
              &trek,
              mlfFread(
                NULL, mclVv(fid, "fid"), _mxarray18_, _mxarray19_, NULL));
            mclAssignAns(&ans, mlfFclose(mclVv(fid, "fid")));
        /*
         * else  trek=FileName;  end; 
         */
        } else {
            mlfAssign(&trek, mclVa(FileName, "FileName"));
        }
    /*
     * end; 
     */
    }
    /*
     * clear fid;
     */
    mlfClear(&fid, NULL);
    /*
     * 
     * 
     * if size(trek,2)==1 trek(:,2)=trek; trek(:,1)=(0:tau:tau*(size(trek,1)-1))'; end; 
     */
    if (mclEqBool(
          mlfSize(mclValueVarargout(), mclVv(trek, "trek"), _mxarray3_),
          _mxarray1_)) {
        mclArrayAssign2(
          &trek, mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray3_);
        mclArrayAssign2(
          &trek,
          mlfCtranspose(
            mlfColon(
              _mxarray0_,
              mclVv(tau, "tau"),
              mclMtimes(
                mclVv(tau, "tau"),
                mclMinus(
                  mlfSize(mclValueVarargout(), mclVv(trek, "trek"), _mxarray1_),
                  _mxarray1_)))),
          mlfCreateColonIndex(),
          _mxarray1_);
    }
    /*
     * bool=(trek(:,2)>4095)|(trek(:,2)<0); OutRangeN=size(find(bool),1); 
     */
    mlfAssign(
      &bool0,
      mclOr(
        mclGt(
          mclArrayRef2(mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray3_),
          _mxarray17_),
        mclLt(
          mclArrayRef2(mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray3_),
          _mxarray0_)));
    mlfAssign(
      &OutRangeN,
      mlfSize(
        mclValueVarargout(),
        mlfFind(NULL, NULL, mclVv(bool0, "bool")),
        _mxarray1_));
    /*
     * if OutRangeN>0 fprintf('%7.0f  points out of the ADC range  \n',OutRangeN); end; 
     */
    if (mclGtBool(mclVv(OutRangeN, "OutRangeN"), _mxarray0_)) {
        mclAssignAns(
          &ans,
          mlfNFprintf(0, _mxarray21_, mclVv(OutRangeN, "OutRangeN"), NULL));
    }
    /*
     * trek(bool,:)=[];  bool=[]; 
     */
    mlfIndexDelete(&trek, "(?,?)", mclVv(bool0, "bool"), mlfCreateColonIndex());
    mlfAssign(&bool0, _mxarray23_);
    /*
     * trekSize=size(trek(:,1),1);
     */
    mlfAssign(
      &trekSize,
      mlfSize(
        mclValueVarargout(),
        mclArrayRef2(mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray1_),
        _mxarray1_));
    /*
     * fprintf('Loading time =                                               %7.4f  sec\n', toc); 
     */
    mclAssignAns(&ans, mlfNFprintf(0, _mxarray24_, mlfNToc(1), NULL));
    /*
     * clear bool;
     */
    mlfClear(&bool0, NULL);
    /*
     * 
     * trekStart=trek;
     */
    mlfAssign(&trekStart, mclVv(trek, "trek"));
    /*
     * NPeaks=1;
     */
    mlfAssign(&NPeaks, _mxarray1_);
    /*
     * DeltaNPeaks=NPeaks;
     */
    mlfAssign(&DeltaNPeaks, mclVv(NPeaks, "NPeaks"));
    /*
     * Pass=0;
     */
    mlfAssign(&Pass, _mxarray0_);
    /*
     * 
     * while DeltaNPeaks>0.1*NPeaks
     */
    while (mclGtBool(
             mclVv(DeltaNPeaks, "DeltaNPeaks"),
             mclMtimes(_mxarray2_, mclVv(NPeaks, "NPeaks")))) {
        /*
         * 
         * Pass=Pass+1;  
         */
        mlfAssign(&Pass, mclPlus(mclVv(Pass, "Pass"), _mxarray1_));
        /*
         * fprintf('Now is %3.0f Pass\n',Pass);
         */
        mclAssignAns(
          &ans, mlfNFprintf(0, _mxarray26_, mclVv(Pass, "Pass"), NULL));
        /*
         * if Pass>1 trek=trekMinus; end;  
         */
        if (mclGtBool(mclVv(Pass, "Pass"), _mxarray1_)) {
            mlfAssign(&trek, mclVv(trekMinus, "trekMinus"));
        }
        /*
         * if Pass==1 NPeaks=0;end;
         */
        if (mclEqBool(mclVv(Pass, "Pass"), _mxarray1_)) {
            mlfAssign(&NPeaks, _mxarray0_);
        }
        /*
         * 
         * NPeaks1=NPeaks;
         */
        mlfAssign(&NPeaks1, mclVv(NPeaks, "NPeaks"));
        /*
         * 
         * if SecondPassFull|Pass==1
         */
        {
            mxArray * a_
              = mclInitialize(mclVv(SecondPassFull, "SecondPassFull"));
            if (mlfTobool(a_)
                || mlfTobool(
                     mclOr(a_, mclEq(mclVv(Pass, "Pass"), _mxarray1_)))) {
                mxDestroyArray(a_);
                /*
                 * 
                 * if Pass>1 clear ThresholdD Threshold StdValD StdVal StartSignal EndSignal SlowN SlowInd Slow SizeMoveToSignal SignalN;end;
                 */
                if (mclGtBool(mclVv(Pass, "Pass"), _mxarray1_)) {
                    mlfClear(
                      &ThresholdD,
                      &Threshold,
                      &StdValD,
                      &StdVal,
                      &StartSignal,
                      &EndSignal,
                      &SlowN,
                      &SlowInd,
                      &Slow,
                      &SizeMoveToSignal,
                      &SignalN,
                      NULL);
                }
                /*
                 * 
                 * % search the signal pedestal and standard deviation 
                 * NoiseArray=logical(ones(trekSize,1));  % first, all measurements are considered as noise
                 */
                mlfAssign(
                  &NoiseArray,
                  mlfTrue(mclVv(trekSize, "trekSize"), _mxarray1_, NULL));
                /*
                 * [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0); 
                 */
                mlfAssign(
                  &MeanVal,
                  mlfPeaks2auto_MeanSearch(
                    &StdVal,
                    &PeakPolarity,
                    &NoiseArray,
                    mclVv(trek, "trek"),
                    mclVv(OverSt, "OverSt"),
                    mclVv(NoiseArray, "NoiseArray"),
                    _mxarray0_,
                    _mxarray0_,
                    NULL));
                /*
                 * %fprintf(' PeakPolarity = %2.0f\n', PeakPolarity);
                 * if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;    
                 */
                if (mclEqBool(
                      mclVv(PeakPolarity, "PeakPolarity"), _mxarray1_)) {
                    mclArrayAssign2(
                      &trek,
                      mclMinus(
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mlfCreateColonIndex(),
                          _mxarray3_),
                        mclVv(MeanVal, "MeanVal")),
                      mlfCreateColonIndex(),
                      _mxarray3_);
                } else {
                    mclArrayAssign2(
                      &trek,
                      mclMinus(
                        mclVv(MeanVal, "MeanVal"),
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mlfCreateColonIndex(),
                          _mxarray3_)),
                      mlfCreateColonIndex(),
                      _mxarray3_);
                }
                /*
                 * PolyZero=polyfit(trek(NoiseArray,1),trek(NoiseArray,2),2); 
                 */
                mlfAssign(
                  &PolyZero,
                  mlfNPolyfit(
                    1,
                    NULL,
                    NULL,
                    mclArrayRef2(
                      mclVv(trek, "trek"),
                      mclVv(NoiseArray, "NoiseArray"),
                      _mxarray1_),
                    mclArrayRef2(
                      mclVv(trek, "trek"),
                      mclVv(NoiseArray, "NoiseArray"),
                      _mxarray3_),
                    _mxarray3_));
                /*
                 * 
                 * fprintf('Mean search  =                                               %7.4f  sec\n', toc);
                 */
                mclAssignAns(
                  &ans, mlfNFprintf(0, _mxarray28_, mlfNToc(1), NULL));
                /*
                 * fprintf('  Previous mean   = %6.4f\n', MeanVal);
                 */
                mclAssignAns(
                  &ans,
                  mlfNFprintf(0, _mxarray30_, mclVv(MeanVal, "MeanVal"), NULL));
                /*
                 * fprintf('  Standard deviat = %6.4f\n', StdVal);
                 */
                mclAssignAns(
                  &ans,
                  mlfNFprintf(0, _mxarray32_, mclVv(StdVal, "StdVal"), NULL));
                /*
                 * 
                 * 
                 * trek(:,2)=trek(:,2)-(PolyZero(1)*trek(:,1).^2+PolyZero(2)*trek(:,1)+PolyZero(3));
                 */
                mclArrayAssign2(
                  &trek,
                  mclMinus(
                    mclArrayRef2(
                      mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray3_),
                    mclPlus(
                      mclPlus(
                        mclMtimes(
                          mclIntArrayRef1(mclVv(PolyZero, "PolyZero"), 1),
                          mlfPower(
                            mclArrayRef2(
                              mclVv(trek, "trek"),
                              mlfCreateColonIndex(),
                              _mxarray1_),
                            _mxarray3_)),
                        mclMtimes(
                          mclIntArrayRef1(mclVv(PolyZero, "PolyZero"), 2),
                          mclArrayRef2(
                            mclVv(trek, "trek"),
                            mlfCreateColonIndex(),
                            _mxarray1_))),
                      mclIntArrayRef1(mclVv(PolyZero, "PolyZero"), 3))),
                  mlfCreateColonIndex(),
                  _mxarray3_);
                /*
                 * [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0); 
                 */
                mlfAssign(
                  &MeanVal,
                  mlfPeaks2auto_MeanSearch(
                    &StdVal,
                    &PeakPolarity,
                    &NoiseArray,
                    mclVv(trek, "trek"),
                    mclVv(OverSt, "OverSt"),
                    mclVv(NoiseArray, "NoiseArray"),
                    _mxarray0_,
                    _mxarray0_,
                    NULL));
                /*
                 * %fprintf(' PeakPolarity = %2.0f\n', PeakPolarity);
                 * if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;    
                 */
                if (mclEqBool(
                      mclVv(PeakPolarity, "PeakPolarity"), _mxarray1_)) {
                    mclArrayAssign2(
                      &trek,
                      mclMinus(
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mlfCreateColonIndex(),
                          _mxarray3_),
                        mclVv(MeanVal, "MeanVal")),
                      mlfCreateColonIndex(),
                      _mxarray3_);
                } else {
                    mclArrayAssign2(
                      &trek,
                      mclMinus(
                        mclVv(MeanVal, "MeanVal"),
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mlfCreateColonIndex(),
                          _mxarray3_)),
                      mlfCreateColonIndex(),
                      _mxarray3_);
                }
                /*
                 * fprintf('Mean search  =                                               %7.4f  sec\n', toc);
                 */
                mclAssignAns(
                  &ans, mlfNFprintf(0, _mxarray28_, mlfNToc(1), NULL));
                /*
                 * fprintf('  fitting mean   = %6.4f\n', MeanVal);
                 */
                mclAssignAns(
                  &ans,
                  mlfNFprintf(0, _mxarray34_, mclVv(MeanVal, "MeanVal"), NULL));
                /*
                 * fprintf('  fitting standard deviat = %6.4f\n', StdVal);
                 */
                mclAssignAns(
                  &ans,
                  mlfNFprintf(0, _mxarray36_, mclVv(StdVal, "StdVal"), NULL));
                /*
                 * 
                 * clear PolyZero;
                 */
                mlfClear(&PolyZero, NULL);
                /*
                 * 
                 * if Pass==1 
                 */
                if (mclEqBool(mclVv(Pass, "Pass"), _mxarray1_)) {
                    /*
                     * MaxSignal = 2500;
                     */
                    mlfAssign(&MaxSignal, _mxarray38_);
                    /*
                     * MaxAmp=MaxSignal; 
                     */
                    mlfAssign(&MaxAmp, mclVa(MaxSignal, "MaxSignal"));
                    /*
                     * MinTime=trek(1,1);
                     */
                    mlfAssign(
                      &MinTime, mclIntArrayRef2(mclVv(trek, "trek"), 1, 1));
                    /*
                     * MaxTime=trek(end,1);
                     */
                    mlfAssign(
                      &MaxTime,
                      mclArrayRef2(
                        mclVv(trek, "trek"),
                        mlfEnd(mclVv(trek, "trek"), _mxarray1_, _mxarray3_),
                        _mxarray1_));
                    /*
                     * trekSize=size(trek(:,1),1);     
                     */
                    mlfAssign(
                      &trekSize,
                      mlfSize(
                        mclValueVarargout(),
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mlfCreateColonIndex(),
                          _mxarray1_),
                        _mxarray1_));
                    /*
                     * MaxSpectr=1; MaxSpectr0=0.5;  
                     */
                    mlfAssign(&MaxSpectr, _mxarray1_);
                    mlfAssign(&MaxSpectr0, _mxarray11_);
                    /*
                     * 
                     * % OutLimits=(trek(:,1)>MaxTime)|(trek(:,1)<MinTime);   %|(trek(:,2)>MaxSignal);
                     * % trek(OutLimits,:)=[]; NoiseArray(OutLimits,:)=[];
                     * % trekSize=size(trek(:,1),1); 
                     * 
                     * [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0);
                     */
                    mlfAssign(
                      &MeanVal,
                      mlfPeaks2auto_MeanSearch(
                        &StdVal,
                        &PeakPolarity,
                        &NoiseArray,
                        mclVv(trek, "trek"),
                        mclVv(OverSt, "OverSt"),
                        mclVv(NoiseArray, "NoiseArray"),
                        _mxarray0_,
                        _mxarray0_,
                        NULL));
                    /*
                     * %fprintf(' PeakPolarity = %2.0f\n', PeakPolarity);
                     * if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else  trek(:,2)=MeanVal-trek(:,2); end;  
                     */
                    if (mclEqBool(
                          mclVv(PeakPolarity, "PeakPolarity"), _mxarray1_)) {
                        mclArrayAssign2(
                          &trek,
                          mclMinus(
                            mclArrayRef2(
                              mclVv(trek, "trek"),
                              mlfCreateColonIndex(),
                              _mxarray3_),
                            mclVv(MeanVal, "MeanVal")),
                          mlfCreateColonIndex(),
                          _mxarray3_);
                    } else {
                        mclArrayAssign2(
                          &trek,
                          mclMinus(
                            mclVv(MeanVal, "MeanVal"),
                            mclArrayRef2(
                              mclVv(trek, "trek"),
                              mlfCreateColonIndex(),
                              _mxarray3_)),
                          mlfCreateColonIndex(),
                          _mxarray3_);
                    }
                    /*
                     * fprintf('New mean search  =                                           %7.4f  sec\n', toc); 
                     */
                    mclAssignAns(
                      &ans, mlfNFprintf(0, _mxarray39_, mlfNToc(1), NULL));
                    /*
                     * fprintf('  New mean            = %6.4f\n', MeanVal);
                     */
                    mclAssignAns(
                      &ans,
                      mlfNFprintf(
                        0, _mxarray41_, mclVv(MeanVal, "MeanVal"), NULL));
                    /*
                     * fprintf('  New standard deviat = %6.4f\n', StdVal);               
                     */
                    mclAssignAns(
                      &ans,
                      mlfNFprintf(
                        0, _mxarray43_, mclVv(StdVal, "StdVal"), NULL));
                /*
                 * end; 
                 */
                }
                /*
                 * %noise smoothing
                 * 
                 * if Pass==1
                 */
                if (mclEqBool(mclVv(Pass, "Pass"), _mxarray1_)) {
                    /*
                     * SmoothGate=round(AverageGate/tau);
                     */
                    mlfAssign(
                      &SmoothGate,
                      mlfRound(
                        mclMrdivide(
                          mclVv(AverageGate, "AverageGate"),
                          mclVv(tau, "tau"))));
                    /*
                     * %SmoothedNoise=filter(ones(1,SmoothGate)/SmoothGate,1,trek(NoiseArray,2));
                     * %trek(NoiseArray,2)=SmoothedNoise; 
                     * SmoothedNoise=filter(ones(1,SmoothGate)/SmoothGate,1,trek(:,2));
                     */
                    mlfAssign(
                      &SmoothedNoise,
                      mlfFilter(
                        NULL,
                        mclMrdivide(
                          mlfOnes(
                            _mxarray1_, mclVv(SmoothGate, "SmoothGate"), NULL),
                          mclVv(SmoothGate, "SmoothGate")),
                        _mxarray1_,
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mlfCreateColonIndex(),
                          _mxarray3_),
                        NULL,
                        NULL));
                    /*
                     * trek(:,2)=SmoothedNoise; 
                     */
                    mclArrayAssign2(
                      &trek,
                      mclVv(SmoothedNoise, "SmoothedNoise"),
                      mlfCreateColonIndex(),
                      _mxarray3_);
                    /*
                     * [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0); 
                     */
                    mlfAssign(
                      &MeanVal,
                      mlfPeaks2auto_MeanSearch(
                        &StdVal,
                        &PeakPolarity,
                        &NoiseArray,
                        mclVv(trek, "trek"),
                        mclVv(OverSt, "OverSt"),
                        mclVv(NoiseArray, "NoiseArray"),
                        _mxarray0_,
                        _mxarray0_,
                        NULL));
                    /*
                     * %fprintf(' PeakPolarity = %2.0f\n', PeakPolarity);
                     * if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;    
                     */
                    if (mclEqBool(
                          mclVv(PeakPolarity, "PeakPolarity"), _mxarray1_)) {
                        mclArrayAssign2(
                          &trek,
                          mclMinus(
                            mclArrayRef2(
                              mclVv(trek, "trek"),
                              mlfCreateColonIndex(),
                              _mxarray3_),
                            mclVv(MeanVal, "MeanVal")),
                          mlfCreateColonIndex(),
                          _mxarray3_);
                    } else {
                        mclArrayAssign2(
                          &trek,
                          mclMinus(
                            mclVv(MeanVal, "MeanVal"),
                            mclArrayRef2(
                              mclVv(trek, "trek"),
                              mlfCreateColonIndex(),
                              _mxarray3_)),
                          mlfCreateColonIndex(),
                          _mxarray3_);
                    }
                    /*
                     * fprintf('Mean search  =                                               %7.4f  sec\n', toc);
                     */
                    mclAssignAns(
                      &ans, mlfNFprintf(0, _mxarray28_, mlfNToc(1), NULL));
                    /*
                     * fprintf('  Smoothed mean            = %6.4f\n', MeanVal);
                     */
                    mclAssignAns(
                      &ans,
                      mlfNFprintf(
                        0, _mxarray45_, mclVv(MeanVal, "MeanVal"), NULL));
                    /*
                     * fprintf('  Smoothed standard deviat = %6.4f\n', StdVal);   
                     */
                    mclAssignAns(
                      &ans,
                      mlfNFprintf(
                        0, _mxarray47_, mclVv(StdVal, "StdVal"), NULL));
                    /*
                     * clear SmoothGate SmoothedNoise;
                     */
                    mlfClear(&SmoothGate, &SmoothedNoise, NULL);
                /*
                 * end;
                 */
                }
                /*
                 * 
                 * 
                 * % search the standard deviation of trekD noises 
                 * 
                 * trekR=circshift(trek(:,2),Dshift);   for i=1:Dshift   trekR(i)=trek(i,2);   end; 
                 */
                mlfAssign(
                  &trekR,
                  mlfCircshift(
                    mclArrayRef2(
                      mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray3_),
                    mclVv(Dshift, "Dshift")));
                {
                    int v_ = mclForIntStart(1);
                    int e_ = mclForIntEnd(mclVv(Dshift, "Dshift"));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray23_);
                    } else {
                        for (; ; ) {
                            mclIntArrayAssign1(
                              &trekR,
                              mclIntArrayRef2(mclVv(trek, "trek"), v_, 2),
                              v_);
                            if (v_ == e_) {
                                break;
                            }
                            ++v_;
                        }
                        mlfAssign(&i, mlfScalar(v_));
                    }
                }
                /*
                 * trekL=circshift(trek(:,2),-Dshift);  for i=1:Dshift   trekL(end+1-i)=trek(end+1-i,2);   end; 
                 */
                mlfAssign(
                  &trekL,
                  mlfCircshift(
                    mclArrayRef2(
                      mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray3_),
                    mclUminus(mclVv(Dshift, "Dshift"))));
                {
                    int v_ = mclForIntStart(1);
                    int e_ = mclForIntEnd(mclVv(Dshift, "Dshift"));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray23_);
                    } else {
                        for (; ; ) {
                            mclArrayAssign1(
                              &trekL,
                              mclArrayRef2(
                                mclVv(trek, "trek"),
                                mclMinus(
                                  mclPlus(
                                    mlfEnd(
                                      mclVv(trek, "trek"),
                                      _mxarray1_,
                                      _mxarray3_),
                                    _mxarray1_),
                                  mlfScalar(v_)),
                                _mxarray3_),
                              mclMinus(
                                mclPlus(
                                  mlfEnd(
                                    mclVv(trekL, "trekL"),
                                    _mxarray1_,
                                    _mxarray1_),
                                  _mxarray1_),
                                mlfScalar(v_)));
                            if (v_ == e_) {
                                break;
                            }
                            ++v_;
                        }
                        mlfAssign(&i, mlfScalar(v_));
                    }
                }
                /*
                 * trekD=trek(:,2)-trekR;
                 */
                mlfAssign(
                  &trekD,
                  mclMinus(
                    mclArrayRef2(
                      mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray3_),
                    mclVv(trekR, "trekR")));
                /*
                 * LD=length(trekD);
                 */
                mlfAssign(&LD, mlfScalar(mclLengthInt(mclVv(trekD, "trekD"))));
                /*
                 * %[MeanValD,StdValD,PeakPolarity,NoiseArrayD]=MeanSearch(trek,OverSt,NoiseArray,0,0,trekD);
                 * StdValD=std(trekD(NoiseArray));
                 */
                mlfAssign(
                  &StdValD,
                  mlfStd(
                    mclArrayRef1(
                      mclVv(trekD, "trekD"), mclVv(NoiseArray, "NoiseArray")),
                    NULL,
                    NULL));
                /*
                 * MeanValD=mean(trekD(NoiseArray));
                 */
                mlfAssign(
                  &MeanValD,
                  mlfMean(
                    mclArrayRef1(
                      mclVv(trekD, "trekD"), mclVv(NoiseArray, "NoiseArray")),
                    NULL));
                /*
                 * 
                 * clear trekR trekL;
                 */
                mlfClear(&trekR, &trekL, NULL);
                /*
                 * ThresholdD=StdValD*PeakSt; 
                 */
                mlfAssign(
                  &ThresholdD,
                  mclMtimes(
                    mclVv(StdValD, "StdValD"), mclVv(PeakSt, "PeakSt")));
                /*
                 * %ThresholdD=21
                 * Noise=(abs(trekD)<ThresholdD)&NoiseArray;    
                 */
                mlfAssign(
                  &Noise,
                  mclAnd(
                    mclLt(
                      mlfAbs(mclVv(trekD, "trekD")),
                      mclVv(ThresholdD, "ThresholdD")),
                    mclVv(NoiseArray, "NoiseArray")));
                /*
                 * % !!! remove noises as much as possible, 
                 * %     but peaks started under Treshold may be missed!!!
                 * 
                 * % Signal=(abs(trekD)>ThresholdD)|not(NoiseArray); %  remain signals as much as possible
                 * 
                 * clear NoiseArray;
                 */
                mlfClear(&NoiseArray, NULL);
                /*
                 * 
                 * %All in start noise    
                 * NoiseR=circshift(Noise,1);   NoiseR(1)=1;     NoiseL=circshift(Noise,-1);  NoiseL(end)=1; 
                 */
                mlfAssign(
                  &NoiseR, mlfCircshift(mclVv(Noise, "Noise"), _mxarray1_));
                mclIntArrayAssign1(&NoiseR, _mxarray1_, 1);
                mlfAssign(
                  &NoiseL, mlfCircshift(mclVv(Noise, "Noise"), _mxarray49_));
                mclArrayAssign1(
                  &NoiseL,
                  _mxarray1_,
                  mlfEnd(mclVv(NoiseL, "NoiseL"), _mxarray1_, _mxarray1_));
                /*
                 * StartNoise=find(Noise-NoiseR==1);   EndNoise=find(Noise-NoiseL==1);  % Noise intervals
                 */
                mlfAssign(
                  &StartNoise,
                  mlfFind(
                    NULL,
                    NULL,
                    mclEq(
                      mclMinus(mclVv(Noise, "Noise"), mclVv(NoiseR, "NoiseR")),
                      _mxarray1_)));
                mlfAssign(
                  &EndNoise,
                  mlfFind(
                    NULL,
                    NULL,
                    mclEq(
                      mclMinus(mclVv(Noise, "Noise"), mclVv(NoiseL, "NoiseL")),
                      _mxarray1_)));
                /*
                 * 
                 * if  StartNoise(1)<EndNoise(1)       StartNoise(1)=[];   end;
                 */
                if (mclLtBool(
                      mclIntArrayRef1(mclVv(StartNoise, "StartNoise"), 1),
                      mclIntArrayRef1(mclVv(EndNoise, "EndNoise"), 1))) {
                    mlfIndexDelete(&StartNoise, "(?)", _mxarray1_);
                }
                /*
                 * if  StartNoise(end)<EndNoise(end)   EndNoise(end)=[];   end;
                 */
                if (mclLtBool(
                      mclArrayRef1(
                        mclVv(StartNoise, "StartNoise"),
                        mlfEnd(
                          mclVv(StartNoise, "StartNoise"),
                          _mxarray1_,
                          _mxarray1_)),
                      mclArrayRef1(
                        mclVv(EndNoise, "EndNoise"),
                        mlfEnd(
                          mclVv(EndNoise, "EndNoise"),
                          _mxarray1_,
                          _mxarray1_)))) {
                    mlfIndexDelete(
                      &EndNoise,
                      "(?)",
                      mlfEnd(
                        mclVv(EndNoise, "EndNoise"), _mxarray1_, _mxarray1_));
                }
                /*
                 * %¬се что вначале трека в шум, чтоб не было пиков без началала
                 * Noise(1:EndNoise(1))=true;  
                 */
                mclArrayAssign1(
                  &Noise,
                  mlfTrue(NULL),
                  mlfColon(
                    _mxarray1_,
                    mclIntArrayRef1(mclVv(EndNoise, "EndNoise"), 1),
                    NULL));
                /*
                 * %¬се что находитс€ в конце трека в шум, чтоб не было незаконченных пиков  
                 * Noise(StartNoise(end):end)=true; 
                 */
                mclArrayAssign1(
                  &Noise,
                  mlfTrue(NULL),
                  mlfColon(
                    mclArrayRef1(
                      mclVv(StartNoise, "StartNoise"),
                      mlfEnd(
                        mclVv(StartNoise, "StartNoise"),
                        _mxarray1_,
                        _mxarray1_)),
                    mlfEnd(mclVv(Noise, "Noise"), _mxarray1_, _mxarray1_),
                    NULL));
                /*
                 * 
                 * 
                 * 
                 * %   Signals intervals (include noise edges)
                 * StartSignal=EndNoise(1:end);   EndSignal=StartNoise(1:end); 
                 */
                mlfAssign(
                  &StartSignal,
                  mclArrayRef1(
                    mclVv(EndNoise, "EndNoise"),
                    mlfColon(
                      _mxarray1_,
                      mlfEnd(
                        mclVv(EndNoise, "EndNoise"), _mxarray1_, _mxarray1_),
                      NULL)));
                mlfAssign(
                  &EndSignal,
                  mclArrayRef1(
                    mclVv(StartNoise, "StartNoise"),
                    mlfColon(
                      _mxarray1_,
                      mlfEnd(
                        mclVv(StartNoise, "StartNoise"),
                        _mxarray1_,
                        _mxarray1_),
                      NULL)));
                /*
                 * 
                 * clear NoiseR NoiseL;
                 */
                mlfClear(&NoiseR, &NoiseL, NULL);
                /*
                 * 
                 * % remove short signal intervals:  
                 * MoveToNoise=find((EndSignal-StartSignal<2+MinFrontN+MinTailN));
                 */
                mlfAssign(
                  &MoveToNoise,
                  mlfFind(
                    NULL,
                    NULL,
                    mclLt(
                      mclMinus(
                        mclVv(EndSignal, "EndSignal"),
                        mclVv(StartSignal, "StartSignal")),
                      mclPlus(
                        mclPlus(_mxarray3_, mclVv(MinFrontN, "MinFrontN")),
                        mclVv(MinTailN, "MinTailN")))));
                /*
                 * SizeMoveToNoise=size(MoveToNoise,1);
                 */
                mlfAssign(
                  &SizeMoveToNoise,
                  mlfSize(
                    mclValueVarargout(),
                    mclVv(MoveToNoise, "MoveToNoise"),
                    _mxarray1_));
                /*
                 * for i=1:SizeMoveToNoise; Noise(StartSignal(MoveToNoise(i)):EndSignal(MoveToNoise(i)))=true; end;    
                 */
                {
                    int v_ = mclForIntStart(1);
                    int e_
                      = mclForIntEnd(
                          mclVv(SizeMoveToNoise, "SizeMoveToNoise"));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray23_);
                    } else {
                        for (; ; ) {
                            mclArrayAssign1(
                              &Noise,
                              mlfTrue(NULL),
                              mlfColon(
                                mclArrayRef1(
                                  mclVv(StartSignal, "StartSignal"),
                                  mclIntArrayRef1(
                                    mclVv(MoveToNoise, "MoveToNoise"), v_)),
                                mclArrayRef1(
                                  mclVv(EndSignal, "EndSignal"),
                                  mclIntArrayRef1(
                                    mclVv(MoveToNoise, "MoveToNoise"), v_)),
                                NULL));
                            if (v_ == e_) {
                                break;
                            }
                            ++v_;
                        }
                        mlfAssign(&i, mlfScalar(v_));
                    }
                }
                /*
                 * StartSignal(MoveToNoise)=[]; EndSignal(MoveToNoise)=[];
                 */
                mlfIndexDelete(
                  &StartSignal, "(?)", mclVv(MoveToNoise, "MoveToNoise"));
                mlfIndexDelete(
                  &EndSignal, "(?)", mclVv(MoveToNoise, "MoveToNoise"));
                /*
                 * SignalN=size(StartSignal,1);
                 */
                mlfAssign(
                  &SignalN,
                  mlfSize(
                    mclValueVarargout(),
                    mclVv(StartSignal, "StartSignal"),
                    _mxarray1_));
                /*
                 * fprintf('   %3.0f    short signals are removed\n', SizeMoveToNoise); 
                 */
                mclAssignAns(
                  &ans,
                  mlfNFprintf(
                    0,
                    _mxarray50_,
                    mclVv(SizeMoveToNoise, "SizeMoveToNoise"),
                    NULL));
                /*
                 * 
                 * % new noise intervals:
                 * StartNoise=[1;EndSignal];  EndNoise=[StartSignal;trekSize];  
                 */
                mlfAssign(
                  &StartNoise,
                  mlfVertcat(
                    _mxarray1_,
                    mlfHorzcat(mclVv(EndSignal, "EndSignal"), NULL),
                    NULL));
                mlfAssign(
                  &EndNoise,
                  mlfVertcat(
                    mlfHorzcat(mclVv(StartSignal, "StartSignal"), NULL),
                    mclVv(trekSize, "trekSize"),
                    NULL));
                /*
                 * %remove single noise points: 
                 * MoveToSignal=find(EndNoise==StartNoise); SizeMoveToSignal=size(MoveToSignal,1);
                 */
                mlfAssign(
                  &MoveToSignal,
                  mlfFind(
                    NULL,
                    NULL,
                    mclEq(
                      mclVv(EndNoise, "EndNoise"),
                      mclVv(StartNoise, "StartNoise"))));
                mlfAssign(
                  &SizeMoveToSignal,
                  mlfSize(
                    mclValueVarargout(),
                    mclVv(MoveToSignal, "MoveToSignal"),
                    _mxarray1_));
                /*
                 * for i=1:SizeMoveToSignal; Noise(StartNoise(MoveToSignal(i)))=false; end; 
                 */
                {
                    int v_ = mclForIntStart(1);
                    int e_
                      = mclForIntEnd(
                          mclVv(SizeMoveToSignal, "SizeMoveToSignal"));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray23_);
                    } else {
                        for (; ; ) {
                            mclArrayAssign1(
                              &Noise,
                              mlfFalse(NULL),
                              mclArrayRef1(
                                mclVv(StartNoise, "StartNoise"),
                                mclIntArrayRef1(
                                  mclVv(MoveToSignal, "MoveToSignal"), v_)));
                            if (v_ == e_) {
                                break;
                            }
                            ++v_;
                        }
                        mlfAssign(&i, mlfScalar(v_));
                    }
                }
                /*
                 * StartNoise(MoveToSignal)=[]; EndNoise(MoveToSignal)=[];
                 */
                mlfIndexDelete(
                  &StartNoise, "(?)", mclVv(MoveToSignal, "MoveToSignal"));
                mlfIndexDelete(
                  &EndNoise, "(?)", mclVv(MoveToSignal, "MoveToSignal"));
                /*
                 * % new Signal intervals:
                 * StartSignal=EndNoise(1:end-1);   EndSignal=StartNoise(2:end); 
                 */
                mlfAssign(
                  &StartSignal,
                  mclArrayRef1(
                    mclVv(EndNoise, "EndNoise"),
                    mlfColon(
                      _mxarray1_,
                      mclMinus(
                        mlfEnd(
                          mclVv(EndNoise, "EndNoise"), _mxarray1_, _mxarray1_),
                        _mxarray1_),
                      NULL)));
                mlfAssign(
                  &EndSignal,
                  mclArrayRef1(
                    mclVv(StartNoise, "StartNoise"),
                    mlfColon(
                      _mxarray3_,
                      mlfEnd(
                        mclVv(StartNoise, "StartNoise"),
                        _mxarray1_,
                        _mxarray1_),
                      NULL)));
                /*
                 * SignalN=size(StartSignal,1);
                 */
                mlfAssign(
                  &SignalN,
                  mlfSize(
                    mclValueVarargout(),
                    mclVv(StartSignal, "StartSignal"),
                    _mxarray1_));
                /*
                 * 
                 * clear EndNoise StartNoise MoveToSignal;
                 */
                mlfClear(&EndNoise, &StartNoise, &MoveToSignal, NULL);
                /*
                 * 
                 * 
                 * %remove slow signals: 
                 * for i=1:SignalN 
                 */
                {
                    int v_ = mclForIntStart(1);
                    int e_ = mclForIntEnd(mclVv(SignalN, "SignalN"));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray23_);
                    } else {
                        /*
                         * Slow(i)=(size(find(trekD(StartSignal(i):EndSignal(i))>ThresholdD),1)<2);                  
                         * end; 
                         */
                        for (; ; ) {
                            mclIntArrayAssign1(
                              &Slow,
                              mclLt(
                                mlfSize(
                                  mclValueVarargout(),
                                  mlfFind(
                                    NULL,
                                    NULL,
                                    mclGt(
                                      mclArrayRef1(
                                        mclVv(trekD, "trekD"),
                                        mlfColon(
                                          mclIntArrayRef1(
                                            mclVv(StartSignal, "StartSignal"),
                                            v_),
                                          mclIntArrayRef1(
                                            mclVv(EndSignal, "EndSignal"), v_),
                                          NULL)),
                                      mclVv(ThresholdD, "ThresholdD"))),
                                  _mxarray1_),
                                _mxarray3_),
                              v_);
                            if (v_ == e_) {
                                break;
                            }
                            ++v_;
                        }
                        mlfAssign(&i, mlfScalar(v_));
                    }
                }
                /*
                 * SlowInd=find(Slow); SlowN=size(SlowInd,2);
                 */
                mlfAssign(&SlowInd, mlfFind(NULL, NULL, mclVv(Slow, "Slow")));
                mlfAssign(
                  &SlowN,
                  mlfSize(
                    mclValueVarargout(),
                    mclVv(SlowInd, "SlowInd"),
                    _mxarray3_));
                /*
                 * for i=1:size(SlowInd,2); Noise(StartSignal(SlowInd(i)):EndSignal(SlowInd(i)))=true; end; 
                 */
                {
                    int v_ = mclForIntStart(1);
                    int e_
                      = mclForIntEnd(
                          mlfSize(
                            mclValueVarargout(),
                            mclVv(SlowInd, "SlowInd"),
                            _mxarray3_));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray23_);
                    } else {
                        for (; ; ) {
                            mclArrayAssign1(
                              &Noise,
                              mlfTrue(NULL),
                              mlfColon(
                                mclArrayRef1(
                                  mclVv(StartSignal, "StartSignal"),
                                  mclIntArrayRef1(
                                    mclVv(SlowInd, "SlowInd"), v_)),
                                mclArrayRef1(
                                  mclVv(EndSignal, "EndSignal"),
                                  mclIntArrayRef1(
                                    mclVv(SlowInd, "SlowInd"), v_)),
                                NULL));
                            if (v_ == e_) {
                                break;
                            }
                            ++v_;
                        }
                        mlfAssign(&i, mlfScalar(v_));
                    }
                }
                /*
                 * StartSignal(Slow)=[]; EndSignal(Slow)=[]; SignalN=size(StartSignal,1);
                 */
                mlfIndexDelete(&StartSignal, "(?)", mclVv(Slow, "Slow"));
                mlfIndexDelete(&EndSignal, "(?)", mclVv(Slow, "Slow"));
                mlfAssign(
                  &SignalN,
                  mlfSize(
                    mclValueVarargout(),
                    mclVv(StartSignal, "StartSignal"),
                    _mxarray1_));
                /*
                 * 
                 * fprintf('   %3.0f    slow signals are removed\n', SlowN);
                 */
                mclAssignAns(
                  &ans,
                  mlfNFprintf(0, _mxarray52_, mclVv(SlowN, "SlowN"), NULL));
                /*
                 * 
                 * %remove small signals
                 * Threshold=StdVal*PeakSt;
                 */
                mlfAssign(
                  &Threshold,
                  mclMtimes(mclVv(StdVal, "StdVal"), mclVv(PeakSt, "PeakSt")));
                /*
                 * for i=1:SignalN; Range(i)=max(trek(StartSignal(i):EndSignal(i),2))-min(trek(StartSignal(i):EndSignal(i),2)); end;
                 */
                {
                    int v_ = mclForIntStart(1);
                    int e_ = mclForIntEnd(mclVv(SignalN, "SignalN"));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray23_);
                    } else {
                        for (; ; ) {
                            mclIntArrayAssign1(
                              &Range,
                              mclMinus(
                                mlfMax(
                                  NULL,
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclIntArrayRef1(
                                        mclVv(StartSignal, "StartSignal"), v_),
                                      mclIntArrayRef1(
                                        mclVv(EndSignal, "EndSignal"), v_),
                                      NULL),
                                    _mxarray3_),
                                  NULL,
                                  NULL),
                                mlfMin(
                                  NULL,
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclIntArrayRef1(
                                        mclVv(StartSignal, "StartSignal"), v_),
                                      mclIntArrayRef1(
                                        mclVv(EndSignal, "EndSignal"), v_),
                                      NULL),
                                    _mxarray3_),
                                  NULL,
                                  NULL)),
                              v_);
                            if (v_ == e_) {
                                break;
                            }
                            ++v_;
                        }
                        mlfAssign(&i, mlfScalar(v_));
                    }
                }
                /*
                 * MoveToNoise=[]; MoveToNoise=find((Range<Threshold)); 
                 */
                mlfAssign(&MoveToNoise, _mxarray23_);
                mlfAssign(
                  &MoveToNoise,
                  mlfFind(
                    NULL,
                    NULL,
                    mclLt(
                      mclVv(Range, "Range"), mclVv(Threshold, "Threshold"))));
                /*
                 * SizeMoveToNoise=size(MoveToNoise,2);
                 */
                mlfAssign(
                  &SizeMoveToNoise,
                  mlfSize(
                    mclValueVarargout(),
                    mclVv(MoveToNoise, "MoveToNoise"),
                    _mxarray3_));
                /*
                 * for i=1:SizeMoveToNoise; Noise(StartSignal(MoveToNoise(i)):EndSignal(MoveToNoise(i)))=true; end; 
                 */
                {
                    int v_ = mclForIntStart(1);
                    int e_
                      = mclForIntEnd(
                          mclVv(SizeMoveToNoise, "SizeMoveToNoise"));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray23_);
                    } else {
                        for (; ; ) {
                            mclArrayAssign1(
                              &Noise,
                              mlfTrue(NULL),
                              mlfColon(
                                mclArrayRef1(
                                  mclVv(StartSignal, "StartSignal"),
                                  mclIntArrayRef1(
                                    mclVv(MoveToNoise, "MoveToNoise"), v_)),
                                mclArrayRef1(
                                  mclVv(EndSignal, "EndSignal"),
                                  mclIntArrayRef1(
                                    mclVv(MoveToNoise, "MoveToNoise"), v_)),
                                NULL));
                            if (v_ == e_) {
                                break;
                            }
                            ++v_;
                        }
                        mlfAssign(&i, mlfScalar(v_));
                    }
                }
                /*
                 * StartSignal(MoveToNoise)=[]; EndSignal(MoveToNoise)=[];
                 */
                mlfIndexDelete(
                  &StartSignal, "(?)", mclVv(MoveToNoise, "MoveToNoise"));
                mlfIndexDelete(
                  &EndSignal, "(?)", mclVv(MoveToNoise, "MoveToNoise"));
                /*
                 * SignalN=size(StartSignal,1);
                 */
                mlfAssign(
                  &SignalN,
                  mlfSize(
                    mclValueVarargout(),
                    mclVv(StartSignal, "StartSignal"),
                    _mxarray1_));
                /*
                 * fprintf('   %3.0f    small signals are removed\n', SizeMoveToNoise); 
                 */
                mclAssignAns(
                  &ans,
                  mlfNFprintf(
                    0,
                    _mxarray54_,
                    mclVv(SizeMoveToNoise, "SizeMoveToNoise"),
                    NULL));
                /*
                 * 
                 * clear MoveToNoise SizeMoveToNoise;
                 */
                mlfClear(&MoveToNoise, &SizeMoveToNoise, NULL);
                /*
                 * clear Noise;  
                 */
                mlfClear(&Noise, NULL);
                /*
                 * fprintf('Signal intervals search  =                                   %7.4f  sec\n', toc);
                 */
                mclAssignAns(
                  &ans, mlfNFprintf(0, _mxarray56_, mlfNToc(1), NULL));
            } else {
                mxDestroyArray(a_);
            }
        /*
         * 
         * end;
         */
        }
        /*
         * 
         * 
         * 
         * 
         * 
         * %Test for matching noise, AllSignals and StartSignal EndSignal    
         * %Search for max inside signal intervals: 
         * PeakInd=[];PeakOnFrontInd=[];
         */
        mlfAssign(&PeakInd, _mxarray23_);
        mlfAssign(&PeakOnFrontInd, _mxarray23_);
        /*
         * if Pass==1 GoodPeakInd=[];GoodPeakVal=[];PeakVal=[]; end;
         */
        if (mclEqBool(mclVv(Pass, "Pass"), _mxarray1_)) {
            mlfAssign(&GoodPeakInd, _mxarray23_);
            mlfAssign(&GoodPeakVal, _mxarray23_);
            mlfAssign(&PeakVal, _mxarray23_);
        }
        /*
         * for i=1:SignalN         
         */
        {
            int v_ = mclForIntStart(1);
            int e_ = mclForIntEnd(mclVv(SignalN, "SignalN"));
            if (v_ > e_) {
                mlfAssign(&i, _mxarray23_);
            } else {
                /*
                 * S=StartSignal(i); E=EndSignal(i);
                 * %Ќужно различать просто ¬идимые максимумы, коих много и хорошие
                 * %максимумы. ¬ стандартные пики должны попадать только те, где и видимый
                 * %и хороший один
                 * if Pass==1
                 * VisiblePeakInd=find((trek(S:E,2)>=trek(S+1:E+1,2))&...
                 * (trek(S:E,2)>trek(S-1:E-1,2))&...            
                 * (trek(S-1:E-1,2)>trek(S-2:E-2,2)));  % preceeding                
                 * GoodVisiblePeakInd=find((trek(S:E,2)>=trek(S+1:E+1,2))&...
                 * (trek(S:E,2)>trek(S-1:E-1,2))&...            
                 * (trek(S-1:E-1,2)>trek(S-2:E-2,2))&...
                 * (trek(S:E,2)>trek(S-MinFrontN:E-MinFrontN,2)+MinFrontN*ThresholdD)&...
                 * (trek(S:E,2)>trek(S+2:E+2,2)+2*ThresholdD));  % preceeding                
                 * NumPeaks(i)=size(VisiblePeakInd,1); 
                 * NumGoodPeaks(i)=size(VisiblePeakInd,1); 
                 * if NumPeaks(i)==0 [Max,VisiblePeakInd]=max(trek(S:E,2));  end; 
                 * 
                 * PeakInd=[PeakInd;S+VisiblePeakInd-1];        
                 * GoodPeakInd=[GoodPeakInd;S+GoodVisiblePeakInd-1];        
                 * PeakVal=[PeakVal;trek(S+VisiblePeakInd-1,2)]; 
                 * GoodPeakVal=[GoodPeakVal;trek(S+VisiblePeakInd-1,2)]; 
                 * [MaxPeak(i),Ind]=max(trek(S+VisiblePeakInd-1,2)); % max signal between S and E
                 * MaxPeakInd(i)=S+VisiblePeakInd(Ind)-1; 
                 * FrontSignalN(i)=VisiblePeakInd(1);                  %from MK     
                 * else
                 * VisiblePeakInd=find((trek(S:E,2)>=trek(S+1:E+1,2))&...
                 * (trek(S:E,2)>trek(S-1:E-1,2))&...            
                 * (trek(S-1:E-1,2)>trek(S-2:E-2,2))&...
                 * (trek(S:E,2)>trek(S+2:E+2,2)+2*ThresholdD));  % preceeding                
                 * NumPeaks(i)=size(VisiblePeakInd,1); 
                 * if NumPeaks(i)==0 [Max,VisiblePeakInd]=max(trek(S:E,2));  end; 
                 * 
                 * PeakInd=[PeakInd;S+VisiblePeakInd-1];        
                 * [MaxPeak(i),Ind]=max(trek(S+VisiblePeakInd-1,2)); % max signal between S and E
                 * MaxPeakInd(i)=S+VisiblePeakInd(Ind)-1; 
                 * FrontSignalN(i)=VisiblePeakInd(1);                  %from MK          
                 * end;
                 * end; 
                 */
                for (; ; ) {
                    mlfAssign(
                      &S,
                      mclIntArrayRef1(mclVv(StartSignal, "StartSignal"), v_));
                    mlfAssign(
                      &E, mclIntArrayRef1(mclVv(EndSignal, "EndSignal"), v_));
                    if (mclEqBool(mclVv(Pass, "Pass"), _mxarray1_)) {
                        mlfAssign(
                          &VisiblePeakInd,
                          mlfFind(
                            NULL,
                            NULL,
                            mclAnd(
                              mclAnd(
                                mclGe(
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclVv(S, "S"), mclVv(E, "E"), NULL),
                                    _mxarray3_),
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclPlus(mclVv(S, "S"), _mxarray1_),
                                      mclPlus(mclVv(E, "E"), _mxarray1_),
                                      NULL),
                                    _mxarray3_)),
                                mclGt(
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclVv(S, "S"), mclVv(E, "E"), NULL),
                                    _mxarray3_),
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclMinus(mclVv(S, "S"), _mxarray1_),
                                      mclMinus(mclVv(E, "E"), _mxarray1_),
                                      NULL),
                                    _mxarray3_))),
                              mclGt(
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfColon(
                                    mclMinus(mclVv(S, "S"), _mxarray1_),
                                    mclMinus(mclVv(E, "E"), _mxarray1_),
                                    NULL),
                                  _mxarray3_),
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfColon(
                                    mclMinus(mclVv(S, "S"), _mxarray3_),
                                    mclMinus(mclVv(E, "E"), _mxarray3_),
                                    NULL),
                                  _mxarray3_)))));
                        mlfAssign(
                          &GoodVisiblePeakInd,
                          mlfFind(
                            NULL,
                            NULL,
                            mclAnd(
                              mclAnd(
                                mclAnd(
                                  mclAnd(
                                    mclGe(
                                      mclArrayRef2(
                                        mclVv(trek, "trek"),
                                        mlfColon(
                                          mclVv(S, "S"), mclVv(E, "E"), NULL),
                                        _mxarray3_),
                                      mclArrayRef2(
                                        mclVv(trek, "trek"),
                                        mlfColon(
                                          mclPlus(mclVv(S, "S"), _mxarray1_),
                                          mclPlus(mclVv(E, "E"), _mxarray1_),
                                          NULL),
                                        _mxarray3_)),
                                    mclGt(
                                      mclArrayRef2(
                                        mclVv(trek, "trek"),
                                        mlfColon(
                                          mclVv(S, "S"), mclVv(E, "E"), NULL),
                                        _mxarray3_),
                                      mclArrayRef2(
                                        mclVv(trek, "trek"),
                                        mlfColon(
                                          mclMinus(mclVv(S, "S"), _mxarray1_),
                                          mclMinus(mclVv(E, "E"), _mxarray1_),
                                          NULL),
                                        _mxarray3_))),
                                  mclGt(
                                    mclArrayRef2(
                                      mclVv(trek, "trek"),
                                      mlfColon(
                                        mclMinus(mclVv(S, "S"), _mxarray1_),
                                        mclMinus(mclVv(E, "E"), _mxarray1_),
                                        NULL),
                                      _mxarray3_),
                                    mclArrayRef2(
                                      mclVv(trek, "trek"),
                                      mlfColon(
                                        mclMinus(mclVv(S, "S"), _mxarray3_),
                                        mclMinus(mclVv(E, "E"), _mxarray3_),
                                        NULL),
                                      _mxarray3_))),
                                mclGt(
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclVv(S, "S"), mclVv(E, "E"), NULL),
                                    _mxarray3_),
                                  mclPlus(
                                    mclArrayRef2(
                                      mclVv(trek, "trek"),
                                      mlfColon(
                                        mclMinus(
                                          mclVv(S, "S"),
                                          mclVv(MinFrontN, "MinFrontN")),
                                        mclMinus(
                                          mclVv(E, "E"),
                                          mclVv(MinFrontN, "MinFrontN")),
                                        NULL),
                                      _mxarray3_),
                                    mclMtimes(
                                      mclVv(MinFrontN, "MinFrontN"),
                                      mclVv(ThresholdD, "ThresholdD"))))),
                              mclGt(
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL),
                                  _mxarray3_),
                                mclPlus(
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclPlus(mclVv(S, "S"), _mxarray3_),
                                      mclPlus(mclVv(E, "E"), _mxarray3_),
                                      NULL),
                                    _mxarray3_),
                                  mclMtimes(
                                    _mxarray3_,
                                    mclVv(ThresholdD, "ThresholdD")))))));
                        mclIntArrayAssign1(
                          &NumPeaks,
                          mlfSize(
                            mclValueVarargout(),
                            mclVv(VisiblePeakInd, "VisiblePeakInd"),
                            _mxarray1_),
                          v_);
                        mclIntArrayAssign1(
                          &NumGoodPeaks,
                          mlfSize(
                            mclValueVarargout(),
                            mclVv(VisiblePeakInd, "VisiblePeakInd"),
                            _mxarray1_),
                          v_);
                        if (mclEqBool(
                              mclIntArrayRef1(mclVv(NumPeaks, "NumPeaks"), v_),
                              _mxarray0_)) {
                            mlfAssign(
                              &Max,
                              mlfMax(
                                &VisiblePeakInd,
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL),
                                  _mxarray3_),
                                NULL,
                                NULL));
                        }
                        mlfAssign(
                          &PeakInd,
                          mlfVertcat(
                            mclVv(PeakInd, "PeakInd"),
                            mclMinus(
                              mclPlus(
                                mclVv(S, "S"),
                                mclVv(VisiblePeakInd, "VisiblePeakInd")),
                              _mxarray1_),
                            NULL));
                        mlfAssign(
                          &GoodPeakInd,
                          mlfVertcat(
                            mclVv(GoodPeakInd, "GoodPeakInd"),
                            mclMinus(
                              mclPlus(
                                mclVv(S, "S"),
                                mclVv(
                                  GoodVisiblePeakInd, "GoodVisiblePeakInd")),
                              _mxarray1_),
                            NULL));
                        mlfAssign(
                          &PeakVal,
                          mlfVertcat(
                            mclVv(PeakVal, "PeakVal"),
                            mclArrayRef2(
                              mclVv(trek, "trek"),
                              mclMinus(
                                mclPlus(
                                  mclVv(S, "S"),
                                  mclVv(VisiblePeakInd, "VisiblePeakInd")),
                                _mxarray1_),
                              _mxarray3_),
                            NULL));
                        mlfAssign(
                          &GoodPeakVal,
                          mlfVertcat(
                            mclVv(GoodPeakVal, "GoodPeakVal"),
                            mclArrayRef2(
                              mclVv(trek, "trek"),
                              mclMinus(
                                mclPlus(
                                  mclVv(S, "S"),
                                  mclVv(VisiblePeakInd, "VisiblePeakInd")),
                                _mxarray1_),
                              _mxarray3_),
                            NULL));
                        mclFeval(
                          mlfIndexVarargout(
                            &MaxPeak, "(?)", mlfScalar(v_), &Ind, "", NULL),
                          mlxMax,
                          mclArrayRef2(
                            mclVv(trek, "trek"),
                            mclMinus(
                              mclPlus(
                                mclVv(S, "S"),
                                mclVv(VisiblePeakInd, "VisiblePeakInd")),
                              _mxarray1_),
                            _mxarray3_),
                          NULL);
                        mclIntArrayAssign1(
                          &MaxPeakInd,
                          mclMinus(
                            mclPlus(
                              mclVv(S, "S"),
                              mclArrayRef1(
                                mclVv(VisiblePeakInd, "VisiblePeakInd"),
                                mclVv(Ind, "Ind"))),
                            _mxarray1_),
                          v_);
                        mclIntArrayAssign1(
                          &FrontSignalN,
                          mclIntArrayRef1(
                            mclVv(VisiblePeakInd, "VisiblePeakInd"), 1),
                          v_);
                    } else {
                        mlfAssign(
                          &VisiblePeakInd,
                          mlfFind(
                            NULL,
                            NULL,
                            mclAnd(
                              mclAnd(
                                mclAnd(
                                  mclGe(
                                    mclArrayRef2(
                                      mclVv(trek, "trek"),
                                      mlfColon(
                                        mclVv(S, "S"), mclVv(E, "E"), NULL),
                                      _mxarray3_),
                                    mclArrayRef2(
                                      mclVv(trek, "trek"),
                                      mlfColon(
                                        mclPlus(mclVv(S, "S"), _mxarray1_),
                                        mclPlus(mclVv(E, "E"), _mxarray1_),
                                        NULL),
                                      _mxarray3_)),
                                  mclGt(
                                    mclArrayRef2(
                                      mclVv(trek, "trek"),
                                      mlfColon(
                                        mclVv(S, "S"), mclVv(E, "E"), NULL),
                                      _mxarray3_),
                                    mclArrayRef2(
                                      mclVv(trek, "trek"),
                                      mlfColon(
                                        mclMinus(mclVv(S, "S"), _mxarray1_),
                                        mclMinus(mclVv(E, "E"), _mxarray1_),
                                        NULL),
                                      _mxarray3_))),
                                mclGt(
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclMinus(mclVv(S, "S"), _mxarray1_),
                                      mclMinus(mclVv(E, "E"), _mxarray1_),
                                      NULL),
                                    _mxarray3_),
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclMinus(mclVv(S, "S"), _mxarray3_),
                                      mclMinus(mclVv(E, "E"), _mxarray3_),
                                      NULL),
                                    _mxarray3_))),
                              mclGt(
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL),
                                  _mxarray3_),
                                mclPlus(
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclPlus(mclVv(S, "S"), _mxarray3_),
                                      mclPlus(mclVv(E, "E"), _mxarray3_),
                                      NULL),
                                    _mxarray3_),
                                  mclMtimes(
                                    _mxarray3_,
                                    mclVv(ThresholdD, "ThresholdD")))))));
                        mclIntArrayAssign1(
                          &NumPeaks,
                          mlfSize(
                            mclValueVarargout(),
                            mclVv(VisiblePeakInd, "VisiblePeakInd"),
                            _mxarray1_),
                          v_);
                        if (mclEqBool(
                              mclIntArrayRef1(mclVv(NumPeaks, "NumPeaks"), v_),
                              _mxarray0_)) {
                            mlfAssign(
                              &Max,
                              mlfMax(
                                &VisiblePeakInd,
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL),
                                  _mxarray3_),
                                NULL,
                                NULL));
                        }
                        mlfAssign(
                          &PeakInd,
                          mlfVertcat(
                            mclVv(PeakInd, "PeakInd"),
                            mclMinus(
                              mclPlus(
                                mclVv(S, "S"),
                                mclVv(VisiblePeakInd, "VisiblePeakInd")),
                              _mxarray1_),
                            NULL));
                        mclFeval(
                          mlfIndexVarargout(
                            &MaxPeak, "(?)", mlfScalar(v_), &Ind, "", NULL),
                          mlxMax,
                          mclArrayRef2(
                            mclVv(trek, "trek"),
                            mclMinus(
                              mclPlus(
                                mclVv(S, "S"),
                                mclVv(VisiblePeakInd, "VisiblePeakInd")),
                              _mxarray1_),
                            _mxarray3_),
                          NULL);
                        mclIntArrayAssign1(
                          &MaxPeakInd,
                          mclMinus(
                            mclPlus(
                              mclVv(S, "S"),
                              mclArrayRef1(
                                mclVv(VisiblePeakInd, "VisiblePeakInd"),
                                mclVv(Ind, "Ind"))),
                            _mxarray1_),
                          v_);
                        mclIntArrayAssign1(
                          &FrontSignalN,
                          mclIntArrayRef1(
                            mclVv(VisiblePeakInd, "VisiblePeakInd"), 1),
                          v_);
                    }
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
         * PeakN=size(PeakInd,1);
         */
        mlfAssign(
          &PeakN,
          mlfSize(mclValueVarargout(), mclVv(PeakInd, "PeakInd"), _mxarray1_));
        /*
         * if Pass==1 GoodPeakN=size(GoodPeakInd,1);end;
         */
        if (mclEqBool(mclVv(Pass, "Pass"), _mxarray1_)) {
            mlfAssign(
              &GoodPeakN,
              mlfSize(
                mclValueVarargout(),
                mclVv(GoodPeakInd, "GoodPeakInd"),
                _mxarray1_));
        }
        /*
         * fprintf('Peak search  =                                               %7.4f  sec\n', toc);
         */
        mclAssignAns(&ans, mlfNFprintf(0, _mxarray58_, mlfNToc(1), NULL));
        /*
         * fprintf('Number of peaks before Double front search= %3.0f\n',PeakN);
         */
        mclAssignAns(
          &ans, mlfNFprintf(0, _mxarray60_, mclVv(PeakN, "PeakN"), NULL));
        /*
         * if Pass==1 fprintf('Number of Good peaks before Double front search= %3.0f\n',GoodPeakN);end;
         */
        if (mclEqBool(mclVv(Pass, "Pass"), _mxarray1_)) {
            mclAssignAns(
              &ans,
              mlfNFprintf(0, _mxarray62_, mclVv(GoodPeakN, "GoodPeakN"), NULL));
        }
        /*
         * 
         * 
         * DoubleFrontInd=find(FrontSignalN>1.5*MaxFrontN);        %from MK 
         */
        mlfAssign(
          &DoubleFrontInd,
          mlfFind(
            NULL,
            NULL,
            mclGt(
              mclVv(FrontSignalN, "FrontSignalN"),
              mclMtimes(_mxarray64_, mclVv(MaxFrontN, "MaxFrontN")))));
        /*
         * DoubleFrontSize=size(DoubleFrontInd,2);                 %from MK 
         */
        mlfAssign(
          &DoubleFrontSize,
          mlfSize(
            mclValueVarargout(),
            mclVv(DoubleFrontInd, "DoubleFrontInd"),
            _mxarray3_));
        /*
         * % Search first peak in double fronts:                   %from MK 
         * if DoubleFrontSize>0                                    %from MK 
         */
        if (mclGtBool(mclVv(DoubleFrontSize, "DoubleFrontSize"), _mxarray0_)) {
            /*
             * for i=1:DoubleFrontSize                             %from MK 
             */
            int v_ = mclForIntStart(1);
            int e_ = mclForIntEnd(mclVv(DoubleFrontSize, "DoubleFrontSize"));
            if (v_ > e_) {
                mlfAssign(&i, _mxarray23_);
            } else {
                /*
                 * S=StartSignal(DoubleFrontInd(i))+1;             %from MK 
                 * E=StartSignal(DoubleFrontInd(i))+FrontSignalN(DoubleFrontInd(i))-1;%from MK 
                 * PeakSpanInd=find((trekD(S:E)<=trekD(S+1:E+1))&...
                 * (trekD(S:E)<trekD(S-1:E-1)));               %from MK 
                 * if ~isempty(PeakSpanInd)
                 * PeakInd=[PeakInd;max(S+PeakSpanInd(1)-1,S)];    %from MK 
                 * PeakOnFrontInd=[PeakOnFrontInd;max(S+PeakSpanInd(1)-1,S)];
                 * NumPeaks(DoubleFrontInd(i))=NumPeaks(DoubleFrontInd(i))+1; %from MK 
                 * FrontSignalN(DoubleFrontInd(i))=NumPeaks(DoubleFrontInd(i))+1;%from MK 
                 * end;
                 * end;                                                %from MK 
                 */
                for (; ; ) {
                    mlfAssign(
                      &S,
                      mclPlus(
                        mclArrayRef1(
                          mclVv(StartSignal, "StartSignal"),
                          mclIntArrayRef1(
                            mclVv(DoubleFrontInd, "DoubleFrontInd"), v_)),
                        _mxarray1_));
                    mlfAssign(
                      &E,
                      mclMinus(
                        mclPlus(
                          mclArrayRef1(
                            mclVv(StartSignal, "StartSignal"),
                            mclIntArrayRef1(
                              mclVv(DoubleFrontInd, "DoubleFrontInd"), v_)),
                          mclArrayRef1(
                            mclVv(FrontSignalN, "FrontSignalN"),
                            mclIntArrayRef1(
                              mclVv(DoubleFrontInd, "DoubleFrontInd"), v_))),
                        _mxarray1_));
                    mlfAssign(
                      &PeakSpanInd,
                      mlfFind(
                        NULL,
                        NULL,
                        mclAnd(
                          mclLe(
                            mclArrayRef1(
                              mclVv(trekD, "trekD"),
                              mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL)),
                            mclArrayRef1(
                              mclVv(trekD, "trekD"),
                              mlfColon(
                                mclPlus(mclVv(S, "S"), _mxarray1_),
                                mclPlus(mclVv(E, "E"), _mxarray1_),
                                NULL))),
                          mclLt(
                            mclArrayRef1(
                              mclVv(trekD, "trekD"),
                              mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL)),
                            mclArrayRef1(
                              mclVv(trekD, "trekD"),
                              mlfColon(
                                mclMinus(mclVv(S, "S"), _mxarray1_),
                                mclMinus(mclVv(E, "E"), _mxarray1_),
                                NULL))))));
                    if (mclNotBool(
                          mlfIsempty(mclVv(PeakSpanInd, "PeakSpanInd")))) {
                        mlfAssign(
                          &PeakInd,
                          mlfVertcat(
                            mclVv(PeakInd, "PeakInd"),
                            mlfMax(
                              NULL,
                              mclMinus(
                                mclPlus(
                                  mclVv(S, "S"),
                                  mclIntArrayRef1(
                                    mclVv(PeakSpanInd, "PeakSpanInd"), 1)),
                                _mxarray1_),
                              mclVv(S, "S"),
                              NULL),
                            NULL));
                        mlfAssign(
                          &PeakOnFrontInd,
                          mlfVertcat(
                            mclVv(PeakOnFrontInd, "PeakOnFrontInd"),
                            mlfMax(
                              NULL,
                              mclMinus(
                                mclPlus(
                                  mclVv(S, "S"),
                                  mclIntArrayRef1(
                                    mclVv(PeakSpanInd, "PeakSpanInd"), 1)),
                                _mxarray1_),
                              mclVv(S, "S"),
                              NULL),
                            NULL));
                        mclArrayAssign1(
                          &NumPeaks,
                          mclPlus(
                            mclArrayRef1(
                              mclVv(NumPeaks, "NumPeaks"),
                              mclIntArrayRef1(
                                mclVv(DoubleFrontInd, "DoubleFrontInd"), v_)),
                            _mxarray1_),
                          mclIntArrayRef1(
                            mclVv(DoubleFrontInd, "DoubleFrontInd"), v_));
                        mclArrayAssign1(
                          &FrontSignalN,
                          mclPlus(
                            mclArrayRef1(
                              mclVv(NumPeaks, "NumPeaks"),
                              mclIntArrayRef1(
                                mclVv(DoubleFrontInd, "DoubleFrontInd"), v_)),
                            _mxarray1_),
                          mclIntArrayRef1(
                            mclVv(DoubleFrontInd, "DoubleFrontInd"), v_));
                    }
                    if (v_ == e_) {
                        break;
                    }
                    ++v_;
                }
                mlfAssign(&i, mlfScalar(v_));
            }
            /*
             * PeakInd=sort(PeakInd);                              %from MK 
             */
            mlfAssign(&PeakInd, mlfSort(NULL, mclVv(PeakInd, "PeakInd"), NULL));
        /*
         * end;                                                    %from MK 
         */
        }
        /*
         * 
         * PeakN=size(PeakInd,1);
         */
        mlfAssign(
          &PeakN,
          mlfSize(mclValueVarargout(), mclVv(PeakInd, "PeakInd"), _mxarray1_));
        /*
         * fprintf('Double Front search  =                                       %7.4f  sec\n', toc); 
         */
        mclAssignAns(&ans, mlfNFprintf(0, _mxarray65_, mlfNToc(1), NULL));
        /*
         * fprintf('Number of peaks with Double fronts = %3.0f\n',PeakN);
         */
        mclAssignAns(
          &ans, mlfNFprintf(0, _mxarray67_, mclVv(PeakN, "PeakN"), NULL));
        /*
         * 
         * 
         * 
         * if Pass==1
         */
        if (mclEqBool(mclVv(Pass, "Pass"), _mxarray1_)) {
            /*
             * StandardPeaks=find((NumPeaks==1)'&(NumGoodPeaks==1)'&((EndSignal-StartSignal)>=MinFrontN+MinTailN)&(MaxPeak'-trek(StartSignal,2)>=3*Threshold)&(MaxPeak<MaxSignal)');
             */
            mlfAssign(
              &StandardPeaks,
              mlfFind(
                NULL,
                NULL,
                mclAnd(
                  mclAnd(
                    mclAnd(
                      mclAnd(
                        mlfCtranspose(
                          mclEq(mclVv(NumPeaks, "NumPeaks"), _mxarray1_)),
                        mlfCtranspose(
                          mclEq(
                            mclVv(NumGoodPeaks, "NumGoodPeaks"), _mxarray1_))),
                      mclGe(
                        mclMinus(
                          mclVv(EndSignal, "EndSignal"),
                          mclVv(StartSignal, "StartSignal")),
                        mclPlus(
                          mclVv(MinFrontN, "MinFrontN"),
                          mclVv(MinTailN, "MinTailN")))),
                    mclGe(
                      mclMinus(
                        mlfCtranspose(mclVv(MaxPeak, "MaxPeak")),
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mclVv(StartSignal, "StartSignal"),
                          _mxarray3_)),
                      mclMtimes(_mxarray69_, mclVv(Threshold, "Threshold")))),
                  mlfCtranspose(
                    mclLt(
                      mclVv(MaxPeak, "MaxPeak"),
                      mclVa(MaxSignal, "MaxSignal"))))));
            /*
             * StandardPeaksN=size(find(StandardPeaks),1);
             */
            mlfAssign(
              &StandardPeaksN,
              mlfSize(
                mclValueVarargout(),
                mlfFind(NULL, NULL, mclVv(StandardPeaks, "StandardPeaks")),
                _mxarray1_));
            /*
             * fprintf('StandardPeaks  search  =                                     %7.4f  sec\n', toc);
             */
            mclAssignAns(&ans, mlfNFprintf(0, _mxarray70_, mlfNToc(1), NULL));
            /*
             * fprintf('Number of StandardPeaks = %3.0f\n',StandardPeaksN);
             */
            mclAssignAns(
              &ans,
              mlfNFprintf(
                0, _mxarray72_, mclVv(StandardPeaksN, "StandardPeaksN"), NULL));
            /*
             * 
             * StandardPulse=zeros(MaxFrontN+MaxTailN,StandardPeaksN);
             */
            mlfAssign(
              &StandardPulse,
              mlfZeros(
                mclPlus(
                  mclVv(MaxFrontN, "MaxFrontN"), mclVv(MaxTailN, "MaxTailN")),
                mclVv(StandardPeaksN, "StandardPeaksN"),
                NULL));
            /*
             * for i=1:StandardPeaksN 
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVv(StandardPeaksN, "StandardPeaksN"));
                if (v_ > e_) {
                    mlfAssign(&i, _mxarray23_);
                } else {
                    /*
                     * Tail=[];
                     * [PeakStart(i),Idx]=max([StartSignal(StandardPeaks(i)),MaxPeakInd(StandardPeaks(i))-MaxFrontN]);
                     * [PeakEnd(i),Idx]=min([EndSignal(StandardPeaks(i)),MaxPeakInd(StandardPeaks(i))+MaxTailN]);
                     * [MaxStPeak(i),MaxStPeakIdx(i)]=max(trek(PeakStart(i):PeakEnd(i),2));
                     * [MinStPeak(i),MinStPeakIdx(i)]=min(trek(PeakStart(i):PeakEnd(i),2));
                     * MaxStPeakIdx(i)=PeakStart(i)+MaxStPeakIdx(i)-1;
                     * MinStPeakIdx(i)=PeakStart(i)+MinStPeakIdx(i)-1;
                     * StPeakN=size(trek(PeakStart(i):PeakEnd(i),2),1);
                     * %StandardPulse(1:size(trek(PulseStart(1,i):PulseEnd(1,i),2),1),i)=trek(PulseStart(1,i):PulseEnd(1,i),2);
                     * 
                     * % –аньше хвост продолжали пр€мой теперь полиномом ecли первое
                     * % значение меньше последнего
                     * if MinStPeakIdx(i)>MaxStPeakIdx(i)
                     * PolyTail=polyfit(1:1:size((PeakStart(i):MaxStPeakIdx(i)-1)',1),trek(PeakStart(i):MaxStPeakIdx(i)-1,2)',1);     
                     * Tail(1:10)=(PolyTail(1)*(-9:1:0)+PolyTail(2))';
                     * TailIdx=find(Tail>=trek(MinStPeakIdx(i),2));
                     * StandardPulse(1:size(TailIdx',1),i)=Tail(TailIdx)';
                     * if size(TailIdx',1)==0
                     * StandardPulse(1)=trek(MinStPeakIdx(i),2);     
                     * TailIdx=1;
                     * end;
                     * StandardPulse(size(TailIdx',1)+1:size(TailIdx',1)+StPeakN,i)=trek(PeakStart(i):PeakEnd(i),2);
                     * StandardPulse(size(TailIdx',1)+StPeakN+1:end,i)=trek(PeakEnd(i),2);
                     * end;
                     * if MinStPeakIdx(i)<MaxStPeakIdx(i)
                     * StandardPulse(1:StPeakN-(MinStPeakIdx(i)-PeakStart(i)),i)=trek(MinStPeakIdx(i):PeakEnd(i),2);
                     * FitLog=log(trek(MaxStPeakIdx(i)+1:PeakEnd(i),2)-trek(MinStPeakIdx(i),2));
                     * PolyFitLog=polyfit(1:1:size(FitLog,1),FitLog',1);     
                     * Tail(1:(MaxFrontN+MaxTailN)-(StPeakN-(MinStPeakIdx(i)-PeakStart(i))))=exp(PolyFitLog(2))*exp(PolyFitLog(1)*((StPeakN-(MinStPeakIdx(i)-PeakStart(i)))+1:MaxFrontN+MaxTailN))+trek(MinStPeakIdx(i),2);
                     * TailIdx=find(Tail>=trek(MinStPeakIdx(i),2));
                     * StandardPulse(StPeakN-(MinStPeakIdx(i)-PeakStart(i))+1:StPeakN-(MinStPeakIdx(i)-PeakStart(i))+size(TailIdx',1),i)=Tail(TailIdx)';
                     * 
                     * StandardPulse(StPeakN-(MinStPeakIdx(i)-PeakStart(i))+size(TailIdx',1)+1:end,i)=trek(MinStPeakIdx(i),2);
                     * 
                     * end;
                     * 
                     * [MaxSP(i),MaxSPInd(i)]=max(StandardPulse(:,i));
                     * [MinSP(i),MinSPInd(i)]=min(StandardPulse(:,i));
                     * RangeSP(i)=MaxSP(i)-MinSP(i); 
                     * end;
                     */
                    for (; ; ) {
                        mlfAssign(&Tail, _mxarray23_);
                        mclFeval(
                          mlfIndexVarargout(
                            &PeakStart, "(?)", mlfScalar(v_), &Idx, "", NULL),
                          mlxMax,
                          mlfHorzcat(
                            mclArrayRef1(
                              mclVv(StartSignal, "StartSignal"),
                              mclIntArrayRef1(
                                mclVv(StandardPeaks, "StandardPeaks"), v_)),
                            mclMinus(
                              mclArrayRef1(
                                mclVv(MaxPeakInd, "MaxPeakInd"),
                                mclIntArrayRef1(
                                  mclVv(StandardPeaks, "StandardPeaks"), v_)),
                              mclVv(MaxFrontN, "MaxFrontN")),
                            NULL),
                          NULL);
                        mclFeval(
                          mlfIndexVarargout(
                            &PeakEnd, "(?)", mlfScalar(v_), &Idx, "", NULL),
                          mlxMin,
                          mlfHorzcat(
                            mclArrayRef1(
                              mclVv(EndSignal, "EndSignal"),
                              mclIntArrayRef1(
                                mclVv(StandardPeaks, "StandardPeaks"), v_)),
                            mclPlus(
                              mclArrayRef1(
                                mclVv(MaxPeakInd, "MaxPeakInd"),
                                mclIntArrayRef1(
                                  mclVv(StandardPeaks, "StandardPeaks"), v_)),
                              mclVv(MaxTailN, "MaxTailN")),
                            NULL),
                          NULL);
                        mclFeval(
                          mlfIndexVarargout(
                            &MaxStPeak, "(?)", mlfScalar(v_),
                            &MaxStPeakIdx, "(?)", mlfScalar(v_),
                            NULL),
                          mlxMax,
                          mclArrayRef2(
                            mclVv(trek, "trek"),
                            mlfColon(
                              mclIntArrayRef1(
                                mclVv(PeakStart, "PeakStart"), v_),
                              mclIntArrayRef1(mclVv(PeakEnd, "PeakEnd"), v_),
                              NULL),
                            _mxarray3_),
                          NULL);
                        mclFeval(
                          mlfIndexVarargout(
                            &MinStPeak, "(?)", mlfScalar(v_),
                            &MinStPeakIdx, "(?)", mlfScalar(v_),
                            NULL),
                          mlxMin,
                          mclArrayRef2(
                            mclVv(trek, "trek"),
                            mlfColon(
                              mclIntArrayRef1(
                                mclVv(PeakStart, "PeakStart"), v_),
                              mclIntArrayRef1(mclVv(PeakEnd, "PeakEnd"), v_),
                              NULL),
                            _mxarray3_),
                          NULL);
                        mclIntArrayAssign1(
                          &MaxStPeakIdx,
                          mclMinus(
                            mclPlus(
                              mclIntArrayRef1(
                                mclVv(PeakStart, "PeakStart"), v_),
                              mclIntArrayRef1(
                                mclVv(MaxStPeakIdx, "MaxStPeakIdx"), v_)),
                            _mxarray1_),
                          v_);
                        mclIntArrayAssign1(
                          &MinStPeakIdx,
                          mclMinus(
                            mclPlus(
                              mclIntArrayRef1(
                                mclVv(PeakStart, "PeakStart"), v_),
                              mclIntArrayRef1(
                                mclVv(MinStPeakIdx, "MinStPeakIdx"), v_)),
                            _mxarray1_),
                          v_);
                        mlfAssign(
                          &StPeakN,
                          mlfSize(
                            mclValueVarargout(),
                            mclArrayRef2(
                              mclVv(trek, "trek"),
                              mlfColon(
                                mclIntArrayRef1(
                                  mclVv(PeakStart, "PeakStart"), v_),
                                mclIntArrayRef1(mclVv(PeakEnd, "PeakEnd"), v_),
                                NULL),
                              _mxarray3_),
                            _mxarray1_));
                        if (mclGtBool(
                              mclIntArrayRef1(
                                mclVv(MinStPeakIdx, "MinStPeakIdx"), v_),
                              mclIntArrayRef1(
                                mclVv(MaxStPeakIdx, "MaxStPeakIdx"), v_))) {
                            mlfAssign(
                              &PolyTail,
                              mlfNPolyfit(
                                1,
                                NULL,
                                NULL,
                                mlfColon(
                                  _mxarray1_,
                                  _mxarray1_,
                                  mlfSize(
                                    mclValueVarargout(),
                                    mlfCtranspose(
                                      mlfColon(
                                        mclIntArrayRef1(
                                          mclVv(PeakStart, "PeakStart"), v_),
                                        mclMinus(
                                          mclIntArrayRef1(
                                            mclVv(MaxStPeakIdx, "MaxStPeakIdx"),
                                            v_),
                                          _mxarray1_),
                                        NULL)),
                                    _mxarray1_)),
                                mlfCtranspose(
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclIntArrayRef1(
                                        mclVv(PeakStart, "PeakStart"), v_),
                                      mclMinus(
                                        mclIntArrayRef1(
                                          mclVv(MaxStPeakIdx, "MaxStPeakIdx"),
                                          v_),
                                        _mxarray1_),
                                      NULL),
                                    _mxarray3_)),
                                _mxarray1_));
                            mclArrayAssign1(
                              &Tail,
                              mlfCtranspose(
                                mclPlus(
                                  mclMtimes(
                                    mclIntArrayRef1(
                                      mclVv(PolyTail, "PolyTail"), 1),
                                    _mxarray74_),
                                  mclIntArrayRef1(
                                    mclVv(PolyTail, "PolyTail"), 2))),
                              mlfColon(_mxarray1_, _mxarray16_, NULL));
                            mlfAssign(
                              &TailIdx,
                              mlfFind(
                                NULL,
                                NULL,
                                mclGe(
                                  mclVv(Tail, "Tail"),
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mclIntArrayRef1(
                                      mclVv(MinStPeakIdx, "MinStPeakIdx"), v_),
                                    _mxarray3_))));
                            mclArrayAssign2(
                              &StandardPulse,
                              mlfCtranspose(
                                mclArrayRef1(
                                  mclVv(Tail, "Tail"),
                                  mclVv(TailIdx, "TailIdx"))),
                              mlfColon(
                                _mxarray1_,
                                mlfSize(
                                  mclValueVarargout(),
                                  mlfCtranspose(mclVv(TailIdx, "TailIdx")),
                                  _mxarray1_),
                                NULL),
                              mlfScalar(v_));
                            if (mclEqBool(
                                  mlfSize(
                                    mclValueVarargout(),
                                    mlfCtranspose(mclVv(TailIdx, "TailIdx")),
                                    _mxarray1_),
                                  _mxarray0_)) {
                                mclIntArrayAssign1(
                                  &StandardPulse,
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mclIntArrayRef1(
                                      mclVv(MinStPeakIdx, "MinStPeakIdx"), v_),
                                    _mxarray3_),
                                  1);
                                mlfAssign(&TailIdx, _mxarray1_);
                            }
                            mclArrayAssign2(
                              &StandardPulse,
                              mclArrayRef2(
                                mclVv(trek, "trek"),
                                mlfColon(
                                  mclIntArrayRef1(
                                    mclVv(PeakStart, "PeakStart"), v_),
                                  mclIntArrayRef1(
                                    mclVv(PeakEnd, "PeakEnd"), v_),
                                  NULL),
                                _mxarray3_),
                              mlfColon(
                                mclPlus(
                                  mlfSize(
                                    mclValueVarargout(),
                                    mlfCtranspose(mclVv(TailIdx, "TailIdx")),
                                    _mxarray1_),
                                  _mxarray1_),
                                mclPlus(
                                  mlfSize(
                                    mclValueVarargout(),
                                    mlfCtranspose(mclVv(TailIdx, "TailIdx")),
                                    _mxarray1_),
                                  mclVv(StPeakN, "StPeakN")),
                                NULL),
                              mlfScalar(v_));
                            mclArrayAssign2(
                              &StandardPulse,
                              mclArrayRef2(
                                mclVv(trek, "trek"),
                                mclIntArrayRef1(mclVv(PeakEnd, "PeakEnd"), v_),
                                _mxarray3_),
                              mlfColon(
                                mclPlus(
                                  mclPlus(
                                    mlfSize(
                                      mclValueVarargout(),
                                      mlfCtranspose(mclVv(TailIdx, "TailIdx")),
                                      _mxarray1_),
                                    mclVv(StPeakN, "StPeakN")),
                                  _mxarray1_),
                                mlfEnd(
                                  mclVv(StandardPulse, "StandardPulse"),
                                  _mxarray1_,
                                  _mxarray3_),
                                NULL),
                              mlfScalar(v_));
                        }
                        if (mclLtBool(
                              mclIntArrayRef1(
                                mclVv(MinStPeakIdx, "MinStPeakIdx"), v_),
                              mclIntArrayRef1(
                                mclVv(MaxStPeakIdx, "MaxStPeakIdx"), v_))) {
                            mclArrayAssign2(
                              &StandardPulse,
                              mclArrayRef2(
                                mclVv(trek, "trek"),
                                mlfColon(
                                  mclIntArrayRef1(
                                    mclVv(MinStPeakIdx, "MinStPeakIdx"), v_),
                                  mclIntArrayRef1(
                                    mclVv(PeakEnd, "PeakEnd"), v_),
                                  NULL),
                                _mxarray3_),
                              mlfColon(
                                _mxarray1_,
                                mclMinus(
                                  mclVv(StPeakN, "StPeakN"),
                                  mclMinus(
                                    mclIntArrayRef1(
                                      mclVv(MinStPeakIdx, "MinStPeakIdx"), v_),
                                    mclIntArrayRef1(
                                      mclVv(PeakStart, "PeakStart"), v_))),
                                NULL),
                              mlfScalar(v_));
                            mlfAssign(
                              &FitLog,
                              mlfLog(
                                mclMinus(
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclPlus(
                                        mclIntArrayRef1(
                                          mclVv(MaxStPeakIdx, "MaxStPeakIdx"),
                                          v_),
                                        _mxarray1_),
                                      mclIntArrayRef1(
                                        mclVv(PeakEnd, "PeakEnd"), v_),
                                      NULL),
                                    _mxarray3_),
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mclIntArrayRef1(
                                      mclVv(MinStPeakIdx, "MinStPeakIdx"), v_),
                                    _mxarray3_))));
                            mlfAssign(
                              &PolyFitLog,
                              mlfNPolyfit(
                                1,
                                NULL,
                                NULL,
                                mlfColon(
                                  _mxarray1_,
                                  _mxarray1_,
                                  mlfSize(
                                    mclValueVarargout(),
                                    mclVv(FitLog, "FitLog"),
                                    _mxarray1_)),
                                mlfCtranspose(mclVv(FitLog, "FitLog")),
                                _mxarray1_));
                            mclArrayAssign1(
                              &Tail,
                              mclPlus(
                                mclMtimes(
                                  mlfExp(
                                    mclIntArrayRef1(
                                      mclVv(PolyFitLog, "PolyFitLog"), 2)),
                                  mlfExp(
                                    mclMtimes(
                                      mclIntArrayRef1(
                                        mclVv(PolyFitLog, "PolyFitLog"), 1),
                                      mlfColon(
                                        mclPlus(
                                          mclMinus(
                                            mclVv(StPeakN, "StPeakN"),
                                            mclMinus(
                                              mclIntArrayRef1(
                                                mclVv(
                                                  MinStPeakIdx, "MinStPeakIdx"),
                                                v_),
                                              mclIntArrayRef1(
                                                mclVv(PeakStart, "PeakStart"),
                                                v_))),
                                          _mxarray1_),
                                        mclPlus(
                                          mclVv(MaxFrontN, "MaxFrontN"),
                                          mclVv(MaxTailN, "MaxTailN")),
                                        NULL)))),
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mclIntArrayRef1(
                                    mclVv(MinStPeakIdx, "MinStPeakIdx"), v_),
                                  _mxarray3_)),
                              mlfColon(
                                _mxarray1_,
                                mclMinus(
                                  mclPlus(
                                    mclVv(MaxFrontN, "MaxFrontN"),
                                    mclVv(MaxTailN, "MaxTailN")),
                                  mclMinus(
                                    mclVv(StPeakN, "StPeakN"),
                                    mclMinus(
                                      mclIntArrayRef1(
                                        mclVv(MinStPeakIdx, "MinStPeakIdx"),
                                        v_),
                                      mclIntArrayRef1(
                                        mclVv(PeakStart, "PeakStart"), v_)))),
                                NULL));
                            mlfAssign(
                              &TailIdx,
                              mlfFind(
                                NULL,
                                NULL,
                                mclGe(
                                  mclVv(Tail, "Tail"),
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mclIntArrayRef1(
                                      mclVv(MinStPeakIdx, "MinStPeakIdx"), v_),
                                    _mxarray3_))));
                            mclArrayAssign2(
                              &StandardPulse,
                              mlfCtranspose(
                                mclArrayRef1(
                                  mclVv(Tail, "Tail"),
                                  mclVv(TailIdx, "TailIdx"))),
                              mlfColon(
                                mclPlus(
                                  mclMinus(
                                    mclVv(StPeakN, "StPeakN"),
                                    mclMinus(
                                      mclIntArrayRef1(
                                        mclVv(MinStPeakIdx, "MinStPeakIdx"),
                                        v_),
                                      mclIntArrayRef1(
                                        mclVv(PeakStart, "PeakStart"), v_))),
                                  _mxarray1_),
                                mclPlus(
                                  mclMinus(
                                    mclVv(StPeakN, "StPeakN"),
                                    mclMinus(
                                      mclIntArrayRef1(
                                        mclVv(MinStPeakIdx, "MinStPeakIdx"),
                                        v_),
                                      mclIntArrayRef1(
                                        mclVv(PeakStart, "PeakStart"), v_))),
                                  mlfSize(
                                    mclValueVarargout(),
                                    mlfCtranspose(mclVv(TailIdx, "TailIdx")),
                                    _mxarray1_)),
                                NULL),
                              mlfScalar(v_));
                            mclArrayAssign2(
                              &StandardPulse,
                              mclArrayRef2(
                                mclVv(trek, "trek"),
                                mclIntArrayRef1(
                                  mclVv(MinStPeakIdx, "MinStPeakIdx"), v_),
                                _mxarray3_),
                              mlfColon(
                                mclPlus(
                                  mclPlus(
                                    mclMinus(
                                      mclVv(StPeakN, "StPeakN"),
                                      mclMinus(
                                        mclIntArrayRef1(
                                          mclVv(MinStPeakIdx, "MinStPeakIdx"),
                                          v_),
                                        mclIntArrayRef1(
                                          mclVv(PeakStart, "PeakStart"), v_))),
                                    mlfSize(
                                      mclValueVarargout(),
                                      mlfCtranspose(mclVv(TailIdx, "TailIdx")),
                                      _mxarray1_)),
                                  _mxarray1_),
                                mlfEnd(
                                  mclVv(StandardPulse, "StandardPulse"),
                                  _mxarray1_,
                                  _mxarray3_),
                                NULL),
                              mlfScalar(v_));
                        }
                        mclFeval(
                          mlfIndexVarargout(
                            &MaxSP, "(?)", mlfScalar(v_),
                            &MaxSPInd, "(?)", mlfScalar(v_),
                            NULL),
                          mlxMax,
                          mclArrayRef2(
                            mclVv(StandardPulse, "StandardPulse"),
                            mlfCreateColonIndex(),
                            mlfScalar(v_)),
                          NULL);
                        mclFeval(
                          mlfIndexVarargout(
                            &MinSP, "(?)", mlfScalar(v_),
                            &MinSPInd, "(?)", mlfScalar(v_),
                            NULL),
                          mlxMin,
                          mclArrayRef2(
                            mclVv(StandardPulse, "StandardPulse"),
                            mlfCreateColonIndex(),
                            mlfScalar(v_)),
                          NULL);
                        mclIntArrayAssign1(
                          &RangeSP,
                          mclMinus(
                            mclIntArrayRef1(mclVv(MaxSP, "MaxSP"), v_),
                            mclIntArrayRef1(mclVv(MinSP, "MinSP"), v_)),
                          v_);
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
             * %ищем максимальный индекс    
             * [MaxIndSP,M]=max(MaxSPInd);
             */
            mlfAssign(
              &MaxIndSP, mlfMax(&M, mclVv(MaxSPInd, "MaxSPInd"), NULL, NULL));
            /*
             * StandardPulses=zeros(MaxIndSP+MaxTailN,StandardPeaksN);
             */
            mlfAssign(
              &StandardPulses,
              mlfZeros(
                mclPlus(
                  mclVv(MaxIndSP, "MaxIndSP"), mclVv(MaxTailN, "MaxTailN")),
                mclVv(StandardPeaksN, "StandardPeaksN"),
                NULL));
            /*
             * StandardPulsesNorm=zeros(MaxIndSP+MaxTailN,StandardPeaksN);
             */
            mlfAssign(
              &StandardPulsesNorm,
              mlfZeros(
                mclPlus(
                  mclVv(MaxIndSP, "MaxIndSP"), mclVv(MaxTailN, "MaxTailN")),
                mclVv(StandardPeaksN, "StandardPeaksN"),
                NULL));
            /*
             * for i=1:StandardPeaksN 
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVv(StandardPeaksN, "StandardPeaksN"));
                if (v_ > e_) {
                    mlfAssign(&i, _mxarray23_);
                } else {
                    /*
                     * StandardPulses(1:MaxIndSP-MaxSPInd(i)+1,i)=StandardPulse(1,i);
                     * StandardPulsesNorm(1:MaxIndSP-MaxSPInd(i)+1,i)=(StandardPulse(1,i)-MinSP(i))/RangeSP(i);
                     * StandardPulses(MaxIndSP-MaxSPInd(i)+1:size(StandardPulse(:,i),1)+MaxIndSP-MaxSPInd(i),i)=StandardPulse(:,i);     
                     * StandardPulsesNorm(MaxIndSP-MaxSPInd(i)+1:size(StandardPulse(:,i),1)+MaxIndSP-MaxSPInd(i),i)=(StandardPulse(:,i)-MinSP(i))/RangeSP(i);     
                     * StandardPulses(size(StandardPulse(:,i),1)+MaxIndSP-MaxSPInd(i):end,i)=StandardPulse(end,i);
                     * StandardPulsesNorm(size(StandardPulse(:,i),1)+MaxIndSP-MaxSPInd(i):end,i)=(StandardPulse(end,i)-MinSP(i))/RangeSP(i);
                     * end;
                     */
                    for (; ; ) {
                        mclArrayAssign2(
                          &StandardPulses,
                          mclIntArrayRef2(
                            mclVv(StandardPulse, "StandardPulse"), 1, v_),
                          mlfColon(
                            _mxarray1_,
                            mclPlus(
                              mclMinus(
                                mclVv(MaxIndSP, "MaxIndSP"),
                                mclIntArrayRef1(
                                  mclVv(MaxSPInd, "MaxSPInd"), v_)),
                              _mxarray1_),
                            NULL),
                          mlfScalar(v_));
                        mclArrayAssign2(
                          &StandardPulsesNorm,
                          mclMrdivide(
                            mclMinus(
                              mclIntArrayRef2(
                                mclVv(StandardPulse, "StandardPulse"), 1, v_),
                              mclIntArrayRef1(mclVv(MinSP, "MinSP"), v_)),
                            mclIntArrayRef1(mclVv(RangeSP, "RangeSP"), v_)),
                          mlfColon(
                            _mxarray1_,
                            mclPlus(
                              mclMinus(
                                mclVv(MaxIndSP, "MaxIndSP"),
                                mclIntArrayRef1(
                                  mclVv(MaxSPInd, "MaxSPInd"), v_)),
                              _mxarray1_),
                            NULL),
                          mlfScalar(v_));
                        mclArrayAssign2(
                          &StandardPulses,
                          mclArrayRef2(
                            mclVv(StandardPulse, "StandardPulse"),
                            mlfCreateColonIndex(),
                            mlfScalar(v_)),
                          mlfColon(
                            mclPlus(
                              mclMinus(
                                mclVv(MaxIndSP, "MaxIndSP"),
                                mclIntArrayRef1(
                                  mclVv(MaxSPInd, "MaxSPInd"), v_)),
                              _mxarray1_),
                            mclMinus(
                              mclPlus(
                                mlfSize(
                                  mclValueVarargout(),
                                  mclArrayRef2(
                                    mclVv(StandardPulse, "StandardPulse"),
                                    mlfCreateColonIndex(),
                                    mlfScalar(v_)),
                                  _mxarray1_),
                                mclVv(MaxIndSP, "MaxIndSP")),
                              mclIntArrayRef1(mclVv(MaxSPInd, "MaxSPInd"), v_)),
                            NULL),
                          mlfScalar(v_));
                        mclArrayAssign2(
                          &StandardPulsesNorm,
                          mclMrdivide(
                            mclMinus(
                              mclArrayRef2(
                                mclVv(StandardPulse, "StandardPulse"),
                                mlfCreateColonIndex(),
                                mlfScalar(v_)),
                              mclIntArrayRef1(mclVv(MinSP, "MinSP"), v_)),
                            mclIntArrayRef1(mclVv(RangeSP, "RangeSP"), v_)),
                          mlfColon(
                            mclPlus(
                              mclMinus(
                                mclVv(MaxIndSP, "MaxIndSP"),
                                mclIntArrayRef1(
                                  mclVv(MaxSPInd, "MaxSPInd"), v_)),
                              _mxarray1_),
                            mclMinus(
                              mclPlus(
                                mlfSize(
                                  mclValueVarargout(),
                                  mclArrayRef2(
                                    mclVv(StandardPulse, "StandardPulse"),
                                    mlfCreateColonIndex(),
                                    mlfScalar(v_)),
                                  _mxarray1_),
                                mclVv(MaxIndSP, "MaxIndSP")),
                              mclIntArrayRef1(mclVv(MaxSPInd, "MaxSPInd"), v_)),
                            NULL),
                          mlfScalar(v_));
                        mclArrayAssign2(
                          &StandardPulses,
                          mclArrayRef2(
                            mclVv(StandardPulse, "StandardPulse"),
                            mlfEnd(
                              mclVv(StandardPulse, "StandardPulse"),
                              _mxarray1_,
                              _mxarray3_),
                            mlfScalar(v_)),
                          mlfColon(
                            mclMinus(
                              mclPlus(
                                mlfSize(
                                  mclValueVarargout(),
                                  mclArrayRef2(
                                    mclVv(StandardPulse, "StandardPulse"),
                                    mlfCreateColonIndex(),
                                    mlfScalar(v_)),
                                  _mxarray1_),
                                mclVv(MaxIndSP, "MaxIndSP")),
                              mclIntArrayRef1(mclVv(MaxSPInd, "MaxSPInd"), v_)),
                            mlfEnd(
                              mclVv(StandardPulses, "StandardPulses"),
                              _mxarray1_,
                              _mxarray3_),
                            NULL),
                          mlfScalar(v_));
                        mclArrayAssign2(
                          &StandardPulsesNorm,
                          mclMrdivide(
                            mclMinus(
                              mclArrayRef2(
                                mclVv(StandardPulse, "StandardPulse"),
                                mlfEnd(
                                  mclVv(StandardPulse, "StandardPulse"),
                                  _mxarray1_,
                                  _mxarray3_),
                                mlfScalar(v_)),
                              mclIntArrayRef1(mclVv(MinSP, "MinSP"), v_)),
                            mclIntArrayRef1(mclVv(RangeSP, "RangeSP"), v_)),
                          mlfColon(
                            mclMinus(
                              mclPlus(
                                mlfSize(
                                  mclValueVarargout(),
                                  mclArrayRef2(
                                    mclVv(StandardPulse, "StandardPulse"),
                                    mlfCreateColonIndex(),
                                    mlfScalar(v_)),
                                  _mxarray1_),
                                mclVv(MaxIndSP, "MaxIndSP")),
                              mclIntArrayRef1(mclVv(MaxSPInd, "MaxSPInd"), v_)),
                            mlfEnd(
                              mclVv(StandardPulsesNorm, "StandardPulsesNorm"),
                              _mxarray1_,
                              _mxarray3_),
                            NULL),
                          mlfScalar(v_));
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
             * %MeanTail=mean(StandardPulse(end-round(MaxTailN/3):end,:),1);
             * Pulse=mean(StandardPulses,2);
             */
            mlfAssign(
              &Pulse,
              mlfMean(mclVv(StandardPulses, "StandardPulses"), _mxarray3_));
            /*
             * [MinPulse,M]=min(Pulse);
             */
            mlfAssign(&MinPulse, mlfMin(&M, mclVv(Pulse, "Pulse"), NULL, NULL));
            /*
             * Pulse=Pulse-MinPulse;
             */
            mlfAssign(
              &Pulse,
              mclMinus(mclVv(Pulse, "Pulse"), mclVv(MinPulse, "MinPulse")));
            /*
             * PulseR=circshift(Pulse,1);
             */
            mlfAssign(&PulseR, mlfCircshift(mclVv(Pulse, "Pulse"), _mxarray1_));
            /*
             * PulseD=Pulse-PulseR; PulseD(1)=Pulse(1);
             */
            mlfAssign(
              &PulseD,
              mclMinus(mclVv(Pulse, "Pulse"), mclVv(PulseR, "PulseR")));
            mclIntArrayAssign1(
              &PulseD, mclIntArrayRef1(mclVv(Pulse, "Pulse"), 1), 1);
            /*
             * PulseDOverThr=find(Pulse>ThresholdD);
             */
            mlfAssign(
              &PulseDOverThr,
              mlfFind(
                NULL,
                NULL,
                mclGt(mclVv(Pulse, "Pulse"), mclVv(ThresholdD, "ThresholdD"))));
            /*
             * %if PulseDOverThr(1)<BFitPointsN+1
             * %   Pulse=[zeros(BFitPointsN+1,1);Pulse]; 
             * %end;
             * [MinPulse,M]=min(Pulse);
             */
            mlfAssign(&MinPulse, mlfMin(&M, mclVv(Pulse, "Pulse"), NULL, NULL));
            /*
             * PulseOverThr=find(Pulse>Threshold);
             */
            mlfAssign(
              &PulseOverThr,
              mlfFind(
                NULL,
                NULL,
                mclGt(mclVv(Pulse, "Pulse"), mclVv(Threshold, "Threshold"))));
            /*
             * 
             * 
             * PulseNorm=mean(StandardPulsesNorm,2);
             */
            mlfAssign(
              &PulseNorm,
              mlfMean(
                mclVv(StandardPulsesNorm, "StandardPulsesNorm"), _mxarray3_));
            /*
             * [MinPulseNorm,M]=min(Pulse);
             */
            mlfAssign(
              &MinPulseNorm, mlfMin(&M, mclVv(Pulse, "Pulse"), NULL, NULL));
            /*
             * PulseNorm=PulseNorm-MinPulseNorm;
             */
            mlfAssign(
              &PulseNorm,
              mclMinus(
                mclVv(PulseNorm, "PulseNorm"),
                mclVv(MinPulseNorm, "MinPulseNorm")));
            /*
             * PulseN=size(Pulse,1);
             */
            mlfAssign(
              &PulseN,
              mlfSize(mclValueVarargout(), mclVv(Pulse, "Pulse"), _mxarray1_));
            /*
             * PulseFit=[];
             */
            mlfAssign(&PulseFit, _mxarray23_);
            /*
             * [PulseMax,PulseMaxIdx]=max(Pulse);
             */
            mlfAssign(
              &PulseMax,
              mlfMax(&PulseMaxIdx, mclVv(Pulse, "Pulse"), NULL, NULL));
            /*
             * 
             * fprintf('Standard Pulse search  =                                     %7.4f  sec\n', toc);
             */
            mclAssignAns(&ans, mlfNFprintf(0, _mxarray76_, mlfNToc(1), NULL));
            /*
             * 
             * StartFitPoint=PulseMaxIdx-PulseOverThr(1)+3; 
             */
            mlfAssign(
              &StartFitPoint,
              mclPlus(
                mclMinus(
                  mclVv(PulseMaxIdx, "PulseMaxIdx"),
                  mclIntArrayRef1(mclVv(PulseOverThr, "PulseOverThr"), 1)),
                _mxarray69_));
            /*
             * EndFitPoint=2; 
             */
            mlfAssign(&EndFitPoint, _mxarray3_);
            /*
             * StartBFitPoint=StartFitPoint-1; 
             */
            mlfAssign(
              &StartBFitPoint,
              mclMinus(mclVv(StartFitPoint, "StartFitPoint"), _mxarray1_));
            /*
             * BFitPointsN=2; 
             */
            mlfAssign(&BFitPointsN, _mxarray3_);
            /*
             * 
             * PulseInterp(:,2)=interp1(Pulse,1:1/TauFitN:PulseN,'spline')';
             */
            mclArrayAssign2(
              &PulseInterp,
              mlfCtranspose(
                mlfInterp1(
                  mclVv(Pulse, "Pulse"),
                  mlfColon(
                    _mxarray1_,
                    mclMrdivide(_mxarray1_, mclVv(TauFitN, "TauFitN")),
                    mclVv(PulseN, "PulseN")),
                  _mxarray78_,
                  NULL)),
              mlfCreateColonIndex(),
              _mxarray3_);
            /*
             * PulseInterp10(:,2)=interp1(Pulse,1:1/(TauFitN*10):PulseN,'spline')';
             */
            mclArrayAssign2(
              &PulseInterp10,
              mlfCtranspose(
                mlfInterp1(
                  mclVv(Pulse, "Pulse"),
                  mlfColon(
                    _mxarray1_,
                    mclMrdivide(
                      _mxarray1_,
                      mclMtimes(mclVv(TauFitN, "TauFitN"), _mxarray16_)),
                    mclVv(PulseN, "PulseN")),
                  _mxarray78_,
                  NULL)),
              mlfCreateColonIndex(),
              _mxarray3_);
            /*
             * PulseInterp(:,1)=(1:1/TauFitN:PulseN)';
             */
            mclArrayAssign2(
              &PulseInterp,
              mlfCtranspose(
                mlfColon(
                  _mxarray1_,
                  mclMrdivide(_mxarray1_, mclVv(TauFitN, "TauFitN")),
                  mclVv(PulseN, "PulseN"))),
              mlfCreateColonIndex(),
              _mxarray1_);
            /*
             * PulseInterp10(:,1)=(1:1/(TauFitN*10):PulseN)';
             */
            mclArrayAssign2(
              &PulseInterp10,
              mlfCtranspose(
                mlfColon(
                  _mxarray1_,
                  mclMrdivide(
                    _mxarray1_,
                    mclMtimes(mclVv(TauFitN, "TauFitN"), _mxarray16_)),
                  mclVv(PulseN, "PulseN"))),
              mlfCreateColonIndex(),
              _mxarray1_);
            /*
             * [PulseIMax,PulseIMaxIdx]=max(PulseInterp(:,2));
             */
            mlfAssign(
              &PulseIMax,
              mlfMax(
                &PulseIMaxIdx,
                mclArrayRef2(
                  mclVv(PulseInterp, "PulseInterp"),
                  mlfCreateColonIndex(),
                  _mxarray3_),
                NULL,
                NULL));
            /*
             * [PulseI10Max,PulseI10MaxIdx]=max(PulseInterp10(:,2));
             */
            mlfAssign(
              &PulseI10Max,
              mlfMax(
                &PulseI10MaxIdx,
                mclArrayRef2(
                  mclVv(PulseInterp10, "PulseInterp10"),
                  mlfCreateColonIndex(),
                  _mxarray3_),
                NULL,
                NULL));
            /*
             * 
             * FitN=1+EndFitPoint+StartFitPoint;
             */
            mlfAssign(
              &FitN,
              mclPlus(
                mclPlus(_mxarray1_, mclVv(EndFitPoint, "EndFitPoint")),
                mclVv(StartFitPoint, "StartFitPoint")));
            /*
             * 
             * 
             * PulseInterp(:,1)=(1-PulseMaxIdx:1/TauFitN:PulseN-PulseMaxIdx)';
             */
            mclArrayAssign2(
              &PulseInterp,
              mlfCtranspose(
                mlfColon(
                  mclMinus(_mxarray1_, mclVv(PulseMaxIdx, "PulseMaxIdx")),
                  mclMrdivide(_mxarray1_, mclVv(TauFitN, "TauFitN")),
                  mclMinus(
                    mclVv(PulseN, "PulseN"),
                    mclVv(PulseMaxIdx, "PulseMaxIdx")))),
              mlfCreateColonIndex(),
              _mxarray1_);
            /*
             * PulseInterp10(:,1)=(1-PulseMaxIdx:1/(TauFitN*10):PulseN-PulseMaxIdx)';
             */
            mclArrayAssign2(
              &PulseInterp10,
              mlfCtranspose(
                mlfColon(
                  mclMinus(_mxarray1_, mclVv(PulseMaxIdx, "PulseMaxIdx")),
                  mclMrdivide(
                    _mxarray1_,
                    mclMtimes(mclVv(TauFitN, "TauFitN"), _mxarray16_)),
                  mclMinus(
                    mclVv(PulseN, "PulseN"),
                    mclVv(PulseMaxIdx, "PulseMaxIdx")))),
              mlfCreateColonIndex(),
              _mxarray1_);
            /*
             * for i=1:4*TauFitN
             */
            {
                int v_ = mclForIntStart(1);
                int e_
                  = mclForIntEnd(
                      mclMtimes(_mxarray15_, mclVv(TauFitN, "TauFitN")));
                if (v_ > e_) {
                    mlfAssign(&i, _mxarray23_);
                } else {
                    /*
                     * PulseInterpShifted=circshift(PulseInterp(:,2),-2*TauFitN-1+i);
                     * FitPulse(1:FitN,i)=PulseInterpShifted(PulseIMaxIdx-StartFitPoint*TauFitN:TauFitN:PulseIMaxIdx+EndFitPoint*TauFitN);
                     * FitPulseShort(1:FitN-EndFitPoint,i)=PulseInterpShifted(PulseIMaxIdx-StartFitPoint*TauFitN:TauFitN:PulseIMaxIdx);      
                     * Sums2(i)=sum(FitPulse(:,i));
                     * Sums3(i)=FitPulse(:,i)'*FitPulse(:,i);
                     * Sums2Short(i)=sum(FitPulseShort(:,i));
                     * Sums3Short(i)=FitPulseShort(:,i)'*FitPulseShort(:,i);
                     * end;
                     */
                    for (; ; ) {
                        mlfAssign(
                          &PulseInterpShifted,
                          mlfCircshift(
                            mclArrayRef2(
                              mclVv(PulseInterp, "PulseInterp"),
                              mlfCreateColonIndex(),
                              _mxarray3_),
                            mclPlus(
                              mclMinus(
                                mclMtimes(
                                  _mxarray80_, mclVv(TauFitN, "TauFitN")),
                                _mxarray1_),
                              mlfScalar(v_))));
                        mclArrayAssign2(
                          &FitPulse,
                          mclArrayRef1(
                            mclVv(PulseInterpShifted, "PulseInterpShifted"),
                            mlfColon(
                              mclMinus(
                                mclVv(PulseIMaxIdx, "PulseIMaxIdx"),
                                mclMtimes(
                                  mclVv(StartFitPoint, "StartFitPoint"),
                                  mclVv(TauFitN, "TauFitN"))),
                              mclVv(TauFitN, "TauFitN"),
                              mclPlus(
                                mclVv(PulseIMaxIdx, "PulseIMaxIdx"),
                                mclMtimes(
                                  mclVv(EndFitPoint, "EndFitPoint"),
                                  mclVv(TauFitN, "TauFitN"))))),
                          mlfColon(_mxarray1_, mclVv(FitN, "FitN"), NULL),
                          mlfScalar(v_));
                        mclArrayAssign2(
                          &FitPulseShort,
                          mclArrayRef1(
                            mclVv(PulseInterpShifted, "PulseInterpShifted"),
                            mlfColon(
                              mclMinus(
                                mclVv(PulseIMaxIdx, "PulseIMaxIdx"),
                                mclMtimes(
                                  mclVv(StartFitPoint, "StartFitPoint"),
                                  mclVv(TauFitN, "TauFitN"))),
                              mclVv(TauFitN, "TauFitN"),
                              mclVv(PulseIMaxIdx, "PulseIMaxIdx"))),
                          mlfColon(
                            _mxarray1_,
                            mclMinus(
                              mclVv(FitN, "FitN"),
                              mclVv(EndFitPoint, "EndFitPoint")),
                            NULL),
                          mlfScalar(v_));
                        mclIntArrayAssign1(
                          &Sums2,
                          mlfSum(
                            mclArrayRef2(
                              mclVv(FitPulse, "FitPulse"),
                              mlfCreateColonIndex(),
                              mlfScalar(v_)),
                            NULL),
                          v_);
                        mclIntArrayAssign1(
                          &Sums3,
                          mlf_times_transpose(
                            mclArrayRef2(
                              mclVv(FitPulse, "FitPulse"),
                              mlfCreateColonIndex(),
                              mlfScalar(v_)),
                            mclArrayRef2(
                              mclVv(FitPulse, "FitPulse"),
                              mlfCreateColonIndex(),
                              mlfScalar(v_)),
                            _mxarray81_),
                          v_);
                        mclIntArrayAssign1(
                          &Sums2Short,
                          mlfSum(
                            mclArrayRef2(
                              mclVv(FitPulseShort, "FitPulseShort"),
                              mlfCreateColonIndex(),
                              mlfScalar(v_)),
                            NULL),
                          v_);
                        mclIntArrayAssign1(
                          &Sums3Short,
                          mlf_times_transpose(
                            mclArrayRef2(
                              mclVv(FitPulseShort, "FitPulseShort"),
                              mlfCreateColonIndex(),
                              mlfScalar(v_)),
                            mclArrayRef2(
                              mclVv(FitPulseShort, "FitPulseShort"),
                              mlfCreateColonIndex(),
                              mlfScalar(v_)),
                            _mxarray81_),
                          v_);
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
         * end;
         */
        }
        /*
         * PulseInterp10Shifted=PulseInterp10;
         */
        mlfAssign(&PulseInterp10Shifted, mclVv(PulseInterp10, "PulseInterp10"));
        /*
         * PulseInterpShiftedTest=PulseInterpShifted;
         */
        mlfAssign(
          &PulseInterpShiftedTest,
          mclVv(PulseInterpShifted, "PulseInterpShifted"));
        /*
         * 
         * 
         * trekMinus=trek;
         */
        mlfAssign(&trekMinus, mclVv(trek, "trek"));
        /*
         * i=0;      
         */
        mlfAssign(&i, _mxarray0_);
        /*
         * if Pass==1 peaks=[]; end;
         */
        if (mclEqBool(mclVv(Pass, "Pass"), _mxarray1_)) {
            mlfAssign(&peaks, _mxarray23_);
        }
        /*
         * Khi2Fin=[];
         */
        mlfAssign(&Khi2Fin, _mxarray23_);
        /*
         * while i<size(PeakInd,1)
         */
        while (mclLtBool(
                 mclVv(i, "i"),
                 mlfSize(
                   mclValueVarargout(),
                   mclVv(PeakInd, "PeakInd"),
                   _mxarray1_))) {
            /*
             * i=i+1; 
             */
            mlfAssign(&i, mclPlus(mclVv(i, "i"), _mxarray1_));
            /*
             * A=[];B=[];Sum1=[];Sum2=[];Sum3=[];Khi2Fit=[];PolyKhi2=[];FitPoints=[];FitPulseFin=[];
             */
            mlfAssign(&A, _mxarray23_);
            mlfAssign(&B, _mxarray23_);
            mlfAssign(&Sum1, _mxarray23_);
            mlfAssign(&Sum2, _mxarray23_);
            mlfAssign(&Sum3, _mxarray23_);
            mlfAssign(&Khi2Fit, _mxarray23_);
            mlfAssign(&PolyKhi2, _mxarray23_);
            mlfAssign(&FitPoints, _mxarray23_);
            mlfAssign(&FitPulseFin, _mxarray23_);
            /*
             * Khi2Fin(i)=-1;
             */
            mclArrayAssign1(&Khi2Fin, _mxarray49_, mclVv(i, "i"));
            /*
             * 
             * B=mean(trekMinus(PeakInd(i)-StartBFitPoint-BFitPointsN+1:PeakInd(i)-StartBFitPoint,2));
             */
            mlfAssign(
              &B,
              mlfMean(
                mclArrayRef2(
                  mclVv(trekMinus, "trekMinus"),
                  mlfColon(
                    mclPlus(
                      mclMinus(
                        mclMinus(
                          mclArrayRef1(
                            mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                          mclVv(StartBFitPoint, "StartBFitPoint")),
                        mclVv(BFitPointsN, "BFitPointsN")),
                      _mxarray1_),
                    mclMinus(
                      mclArrayRef1(mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                      mclVv(StartBFitPoint, "StartBFitPoint")),
                    NULL),
                  _mxarray3_),
                NULL));
            /*
             * ShortFit=not(isempty(find(PeakOnFrontInd==PeakInd(i))));
             */
            mlfAssign(
              &ShortFit,
              mclNot(
                mlfIsempty(
                  mlfFind(
                    NULL,
                    NULL,
                    mclEq(
                      mclVv(PeakOnFrontInd, "PeakOnFrontInd"),
                      mclArrayRef1(
                        mclVv(PeakInd, "PeakInd"), mclVv(i, "i")))))));
            /*
             * if ShortFit 
             */
            if (mlfTobool(mclVv(ShortFit, "ShortFit"))) {
                /*
                 * FitNi=FitN-EndFitPoint;
                 */
                mlfAssign(
                  &FitNi,
                  mclMinus(
                    mclVv(FitN, "FitN"), mclVv(EndFitPoint, "EndFitPoint")));
                /*
                 * FitPoints(1:FitNi,:)=trekMinus(PeakInd(i)-StartFitPoint:PeakInd(i),:);            
                 */
                mclArrayAssign2(
                  &FitPoints,
                  mclArrayRef2(
                    mclVv(trekMinus, "trekMinus"),
                    mlfColon(
                      mclMinus(
                        mclArrayRef1(mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                        mclVv(StartFitPoint, "StartFitPoint")),
                      mclArrayRef1(mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                      NULL),
                    mlfCreateColonIndex()),
                  mlfColon(_mxarray1_, mclVv(FitNi, "FitNi"), NULL),
                  mlfCreateColonIndex());
                /*
                 * for k=1:4*TauFitN; 
                 */
                {
                    int v_ = mclForIntStart(1);
                    int e_
                      = mclForIntEnd(
                          mclMtimes(_mxarray15_, mclVv(TauFitN, "TauFitN")));
                    if (v_ > e_) {
                        mlfAssign(&k, _mxarray23_);
                    } else {
                        /*
                         * Sum1=FitPoints(:,2)'*FitPulseShort(:,k);
                         * Sum2=Sums2Short(k);
                         * Sum3=Sums3Short(k);
                         * A=(Sum1-B*Sum2)/Sum3;
                         * Khi2Fit(k)=(FitPoints(:,2)-A*FitPulseShort(:,k)-B)'*(FitPoints(:,2)-A*FitPulseShort(:,k)-B);
                         * end;
                         */
                        for (; ; ) {
                            mlfAssign(
                              &Sum1,
                              mlf_times_transpose(
                                mclArrayRef2(
                                  mclVv(FitPoints, "FitPoints"),
                                  mlfCreateColonIndex(),
                                  _mxarray3_),
                                mclArrayRef2(
                                  mclVv(FitPulseShort, "FitPulseShort"),
                                  mlfCreateColonIndex(),
                                  mlfScalar(v_)),
                                _mxarray81_));
                            mlfAssign(
                              &Sum2,
                              mclIntArrayRef1(
                                mclVv(Sums2Short, "Sums2Short"), v_));
                            mlfAssign(
                              &Sum3,
                              mclIntArrayRef1(
                                mclVv(Sums3Short, "Sums3Short"), v_));
                            mlfAssign(
                              &A,
                              mclMrdivide(
                                mclMinus(
                                  mclVv(Sum1, "Sum1"),
                                  mclMtimes(
                                    mclVv(B, "B"), mclVv(Sum2, "Sum2"))),
                                mclVv(Sum3, "Sum3")));
                            mclIntArrayAssign1(
                              &Khi2Fit,
                              mlf_times_transpose(
                                mclMinus(
                                  mclMinus(
                                    mclArrayRef2(
                                      mclVv(FitPoints, "FitPoints"),
                                      mlfCreateColonIndex(),
                                      _mxarray3_),
                                    mclMtimes(
                                      mclVv(A, "A"),
                                      mclArrayRef2(
                                        mclVv(FitPulseShort, "FitPulseShort"),
                                        mlfCreateColonIndex(),
                                        mlfScalar(v_)))),
                                  mclVv(B, "B")),
                                mclMinus(
                                  mclMinus(
                                    mclArrayRef2(
                                      mclVv(FitPoints, "FitPoints"),
                                      mlfCreateColonIndex(),
                                      _mxarray3_),
                                    mclMtimes(
                                      mclVv(A, "A"),
                                      mclArrayRef2(
                                        mclVv(FitPulseShort, "FitPulseShort"),
                                        mlfCreateColonIndex(),
                                        mlfScalar(v_)))),
                                  mclVv(B, "B")),
                                _mxarray81_),
                              v_);
                            if (v_ == e_) {
                                break;
                            }
                            ++v_;
                        }
                        mlfAssign(&k, mlfScalar(v_));
                    }
                }
                /*
                 * [MinKhi2(i),MinKhi2Idx(i)]=min(Khi2Fit);
                 */
                mclFeval(
                  mlfIndexVarargout(
                    &MinKhi2, "(?)", mclVv(i, "i"),
                    &MinKhi2Idx, "(?)", mclVv(i, "i"),
                    NULL),
                  mlxMin,
                  mclVv(Khi2Fit, "Khi2Fit"),
                  NULL);
                /*
                 * if (MinKhi2Idx(i)>2)&(MinKhi2Idx(i)<4*TauFitN-2)
                 */
                {
                    mxArray * a_
                      = mclInitialize(
                          mclGt(
                            mclArrayRef1(
                              mclVv(MinKhi2Idx, "MinKhi2Idx"), mclVv(i, "i")),
                            _mxarray3_));
                    if (mlfTobool(a_)
                        && mlfTobool(
                             mclAnd(
                               a_,
                               mclLt(
                                 mclArrayRef1(
                                   mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                   mclVv(i, "i")),
                                 mclMinus(
                                   mclMtimes(
                                     _mxarray15_, mclVv(TauFitN, "TauFitN")),
                                   _mxarray3_))))) {
                        mxDestroyArray(a_);
                        /*
                         * PolyKhi2=polyfit((MinKhi2Idx(i)-2:1:MinKhi2Idx(i)+2),Khi2Fit(MinKhi2Idx(i)-2:MinKhi2Idx(i)+2)/(FitNi*StdVal^2),2);                
                         */
                        mlfAssign(
                          &PolyKhi2,
                          mlfNPolyfit(
                            1,
                            NULL,
                            NULL,
                            mlfColon(
                              mclMinus(
                                mclArrayRef1(
                                  mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                  mclVv(i, "i")),
                                _mxarray3_),
                              _mxarray1_,
                              mclPlus(
                                mclArrayRef1(
                                  mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                  mclVv(i, "i")),
                                _mxarray3_)),
                            mclMrdivide(
                              mclArrayRef1(
                                mclVv(Khi2Fit, "Khi2Fit"),
                                mlfColon(
                                  mclMinus(
                                    mclArrayRef1(
                                      mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                      mclVv(i, "i")),
                                    _mxarray3_),
                                  mclPlus(
                                    mclArrayRef1(
                                      mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                      mclVv(i, "i")),
                                    _mxarray3_),
                                  NULL)),
                              mclMtimes(
                                mclVv(FitNi, "FitNi"),
                                mclMpower(
                                  mclVv(StdVal, "StdVal"), _mxarray3_))),
                            _mxarray3_));
                        /*
                         * 
                         * MinKhi2Idx10=-PolyKhi2(2)/(2*PolyKhi2(1));
                         */
                        mlfAssign(
                          &MinKhi2Idx10,
                          mclMrdivide(
                            mclUminus(
                              mclIntArrayRef1(mclVv(PolyKhi2, "PolyKhi2"), 2)),
                            mclMtimes(
                              _mxarray3_,
                              mclIntArrayRef1(
                                mclVv(PolyKhi2, "PolyKhi2"), 1))));
                        /*
                         * PulseInterpShifted=circshift(PulseInterp(:,2),-2*TauFitN-1+MinKhi2Idx(i));
                         */
                        mlfAssign(
                          &PulseInterpShifted,
                          mlfCircshift(
                            mclArrayRef2(
                              mclVv(PulseInterp, "PulseInterp"),
                              mlfCreateColonIndex(),
                              _mxarray3_),
                            mclPlus(
                              mclMinus(
                                mclMtimes(
                                  _mxarray80_, mclVv(TauFitN, "TauFitN")),
                                _mxarray1_),
                              mclArrayRef1(
                                mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                mclVv(i, "i")))));
                        /*
                         * PulseInterpShiftedTest=circshift(PulseInterp(:,2),-2*TauFitN-1+MinKhi2Idx(i)+sign(MinKhi2Idx10-MinKhi2Idx(i)));
                         */
                        mlfAssign(
                          &PulseInterpShiftedTest,
                          mlfCircshift(
                            mclArrayRef2(
                              mclVv(PulseInterp, "PulseInterp"),
                              mlfCreateColonIndex(),
                              _mxarray3_),
                            mclPlus(
                              mclPlus(
                                mclMinus(
                                  mclMtimes(
                                    _mxarray80_, mclVv(TauFitN, "TauFitN")),
                                  _mxarray1_),
                                mclArrayRef1(
                                  mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                  mclVv(i, "i"))),
                              mlfSign(
                                mclMinus(
                                  mclVv(MinKhi2Idx10, "MinKhi2Idx10"),
                                  mclArrayRef1(
                                    mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                    mclVv(i, "i")))))));
                        /*
                         * PulseInterp10Shifted=circshift(PulseInterp10(:,2),fix((-2*TauFitN-1+MinKhi2Idx10)*10));
                         */
                        mlfAssign(
                          &PulseInterp10Shifted,
                          mlfCircshift(
                            mclArrayRef2(
                              mclVv(PulseInterp10, "PulseInterp10"),
                              mlfCreateColonIndex(),
                              _mxarray3_),
                            mlfFix(
                              mclMtimes(
                                mclPlus(
                                  mclMinus(
                                    mclMtimes(
                                      _mxarray80_, mclVv(TauFitN, "TauFitN")),
                                    _mxarray1_),
                                  mclVv(MinKhi2Idx10, "MinKhi2Idx10")),
                                _mxarray16_))));
                        /*
                         * 
                         * FitPulseFin(1:FitNi)=PulseInterp10Shifted(PulseI10MaxIdx-StartFitPoint*TauFitN*10:TauFitN*10:PulseI10MaxIdx);
                         */
                        mclArrayAssign1(
                          &FitPulseFin,
                          mclArrayRef1(
                            mclVv(PulseInterp10Shifted, "PulseInterp10Shifted"),
                            mlfColon(
                              mclMinus(
                                mclVv(PulseI10MaxIdx, "PulseI10MaxIdx"),
                                mclMtimes(
                                  mclMtimes(
                                    mclVv(StartFitPoint, "StartFitPoint"),
                                    mclVv(TauFitN, "TauFitN")),
                                  _mxarray16_)),
                              mclMtimes(mclVv(TauFitN, "TauFitN"), _mxarray16_),
                              mclVv(PulseI10MaxIdx, "PulseI10MaxIdx"))),
                          mlfColon(_mxarray1_, mclVv(FitNi, "FitNi"), NULL));
                        /*
                         * Sum1=FitPoints(:,2)'*FitPulseFin(:);
                         */
                        mlfAssign(
                          &Sum1,
                          mlf_times_transpose(
                            mclArrayRef2(
                              mclVv(FitPoints, "FitPoints"),
                              mlfCreateColonIndex(),
                              _mxarray3_),
                            mclArrayRef1(
                              mclVv(FitPulseFin, "FitPulseFin"),
                              mlfCreateColonIndex()),
                            _mxarray81_));
                        /*
                         * Sum2=sum(FitPulseFin(:));
                         */
                        mlfAssign(
                          &Sum2,
                          mlfSum(
                            mclArrayRef1(
                              mclVv(FitPulseFin, "FitPulseFin"),
                              mlfCreateColonIndex()),
                            NULL));
                        /*
                         * Sum3=FitPulseFin(:)'*FitPulseFin(:);
                         */
                        mlfAssign(
                          &Sum3,
                          mlf_times_transpose(
                            mclArrayRef1(
                              mclVv(FitPulseFin, "FitPulseFin"),
                              mlfCreateColonIndex()),
                            mclArrayRef1(
                              mclVv(FitPulseFin, "FitPulseFin"),
                              mlfCreateColonIndex()),
                            _mxarray81_));
                        /*
                         * A=(Sum1-B*Sum2)/Sum3;
                         */
                        mlfAssign(
                          &A,
                          mclMrdivide(
                            mclMinus(
                              mclVv(Sum1, "Sum1"),
                              mclMtimes(mclVv(B, "B"), mclVv(Sum2, "Sum2"))),
                            mclVv(Sum3, "Sum3")));
                        /*
                         * Khi2Fin(i)=(FitPoints(:,2)-A*FitPulseFin(:)-B)'*(FitPoints(:,2)-A*FitPulseFin(:)-B);
                         */
                        mclArrayAssign1(
                          &Khi2Fin,
                          mlf_times_transpose(
                            mclMinus(
                              mclMinus(
                                mclArrayRef2(
                                  mclVv(FitPoints, "FitPoints"),
                                  mlfCreateColonIndex(),
                                  _mxarray3_),
                                mclMtimes(
                                  mclVv(A, "A"),
                                  mclArrayRef1(
                                    mclVv(FitPulseFin, "FitPulseFin"),
                                    mlfCreateColonIndex()))),
                              mclVv(B, "B")),
                            mclMinus(
                              mclMinus(
                                mclArrayRef2(
                                  mclVv(FitPoints, "FitPoints"),
                                  mlfCreateColonIndex(),
                                  _mxarray3_),
                                mclMtimes(
                                  mclVv(A, "A"),
                                  mclArrayRef1(
                                    mclVv(FitPulseFin, "FitPulseFin"),
                                    mlfCreateColonIndex()))),
                              mclVv(B, "B")),
                            _mxarray81_),
                          mclVv(i, "i"));
                    } else {
                        mxDestroyArray(a_);
                    }
                /*
                 * end;
                 */
                }
            /*
             * 
             * else
             */
            } else {
                /*
                 * FitNi=FitN;
                 */
                mlfAssign(&FitNi, mclVv(FitN, "FitN"));
                /*
                 * FitPoints(1:FitNi,:)=trekMinus(PeakInd(i)-StartFitPoint:PeakInd(i)+EndFitPoint,:);
                 */
                mclArrayAssign2(
                  &FitPoints,
                  mclArrayRef2(
                    mclVv(trekMinus, "trekMinus"),
                    mlfColon(
                      mclMinus(
                        mclArrayRef1(mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                        mclVv(StartFitPoint, "StartFitPoint")),
                      mclPlus(
                        mclArrayRef1(mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                        mclVv(EndFitPoint, "EndFitPoint")),
                      NULL),
                    mlfCreateColonIndex()),
                  mlfColon(_mxarray1_, mclVv(FitNi, "FitNi"), NULL),
                  mlfCreateColonIndex());
                /*
                 * for k=1:4*TauFitN; 
                 */
                {
                    int v_ = mclForIntStart(1);
                    int e_
                      = mclForIntEnd(
                          mclMtimes(_mxarray15_, mclVv(TauFitN, "TauFitN")));
                    if (v_ > e_) {
                        mlfAssign(&k, _mxarray23_);
                    } else {
                        /*
                         * Sum1=FitPoints(:,2)'*FitPulse(:,k);
                         * Sum2=Sums2(k);
                         * Sum3=Sums3(k);
                         * A=(Sum1-B*Sum2)/Sum3;
                         * Khi2Fit(k)=(FitPoints(:,2)-A*FitPulse(:,k)-B)'*(FitPoints(:,2)-A*FitPulse(:,k)-B);
                         * end;
                         */
                        for (; ; ) {
                            mlfAssign(
                              &Sum1,
                              mlf_times_transpose(
                                mclArrayRef2(
                                  mclVv(FitPoints, "FitPoints"),
                                  mlfCreateColonIndex(),
                                  _mxarray3_),
                                mclArrayRef2(
                                  mclVv(FitPulse, "FitPulse"),
                                  mlfCreateColonIndex(),
                                  mlfScalar(v_)),
                                _mxarray81_));
                            mlfAssign(
                              &Sum2,
                              mclIntArrayRef1(mclVv(Sums2, "Sums2"), v_));
                            mlfAssign(
                              &Sum3,
                              mclIntArrayRef1(mclVv(Sums3, "Sums3"), v_));
                            mlfAssign(
                              &A,
                              mclMrdivide(
                                mclMinus(
                                  mclVv(Sum1, "Sum1"),
                                  mclMtimes(
                                    mclVv(B, "B"), mclVv(Sum2, "Sum2"))),
                                mclVv(Sum3, "Sum3")));
                            mclIntArrayAssign1(
                              &Khi2Fit,
                              mlf_times_transpose(
                                mclMinus(
                                  mclMinus(
                                    mclArrayRef2(
                                      mclVv(FitPoints, "FitPoints"),
                                      mlfCreateColonIndex(),
                                      _mxarray3_),
                                    mclMtimes(
                                      mclVv(A, "A"),
                                      mclArrayRef2(
                                        mclVv(FitPulse, "FitPulse"),
                                        mlfCreateColonIndex(),
                                        mlfScalar(v_)))),
                                  mclVv(B, "B")),
                                mclMinus(
                                  mclMinus(
                                    mclArrayRef2(
                                      mclVv(FitPoints, "FitPoints"),
                                      mlfCreateColonIndex(),
                                      _mxarray3_),
                                    mclMtimes(
                                      mclVv(A, "A"),
                                      mclArrayRef2(
                                        mclVv(FitPulse, "FitPulse"),
                                        mlfCreateColonIndex(),
                                        mlfScalar(v_)))),
                                  mclVv(B, "B")),
                                _mxarray81_),
                              v_);
                            if (v_ == e_) {
                                break;
                            }
                            ++v_;
                        }
                        mlfAssign(&k, mlfScalar(v_));
                    }
                }
                /*
                 * [MinKhi2(i),MinKhi2Idx(i)]=min(Khi2Fit);
                 */
                mclFeval(
                  mlfIndexVarargout(
                    &MinKhi2, "(?)", mclVv(i, "i"),
                    &MinKhi2Idx, "(?)", mclVv(i, "i"),
                    NULL),
                  mlxMin,
                  mclVv(Khi2Fit, "Khi2Fit"),
                  NULL);
                /*
                 * if (MinKhi2Idx(i)>2)&(MinKhi2Idx(i)<4*TauFitN-2)
                 */
                {
                    mxArray * a_
                      = mclInitialize(
                          mclGt(
                            mclArrayRef1(
                              mclVv(MinKhi2Idx, "MinKhi2Idx"), mclVv(i, "i")),
                            _mxarray3_));
                    if (mlfTobool(a_)
                        && mlfTobool(
                             mclAnd(
                               a_,
                               mclLt(
                                 mclArrayRef1(
                                   mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                   mclVv(i, "i")),
                                 mclMinus(
                                   mclMtimes(
                                     _mxarray15_, mclVv(TauFitN, "TauFitN")),
                                   _mxarray3_))))) {
                        mxDestroyArray(a_);
                        /*
                         * PolyKhi2=polyfit((MinKhi2Idx(i)-2:1:MinKhi2Idx(i)+2),Khi2Fit(MinKhi2Idx(i)-2:MinKhi2Idx(i)+2)/(FitNi*StdVal^2),2);
                         */
                        mlfAssign(
                          &PolyKhi2,
                          mlfNPolyfit(
                            1,
                            NULL,
                            NULL,
                            mlfColon(
                              mclMinus(
                                mclArrayRef1(
                                  mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                  mclVv(i, "i")),
                                _mxarray3_),
                              _mxarray1_,
                              mclPlus(
                                mclArrayRef1(
                                  mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                  mclVv(i, "i")),
                                _mxarray3_)),
                            mclMrdivide(
                              mclArrayRef1(
                                mclVv(Khi2Fit, "Khi2Fit"),
                                mlfColon(
                                  mclMinus(
                                    mclArrayRef1(
                                      mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                      mclVv(i, "i")),
                                    _mxarray3_),
                                  mclPlus(
                                    mclArrayRef1(
                                      mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                      mclVv(i, "i")),
                                    _mxarray3_),
                                  NULL)),
                              mclMtimes(
                                mclVv(FitNi, "FitNi"),
                                mclMpower(
                                  mclVv(StdVal, "StdVal"), _mxarray3_))),
                            _mxarray3_));
                        /*
                         * 
                         * MinKhi2Idx10=-PolyKhi2(2)/(2*PolyKhi2(1));
                         */
                        mlfAssign(
                          &MinKhi2Idx10,
                          mclMrdivide(
                            mclUminus(
                              mclIntArrayRef1(mclVv(PolyKhi2, "PolyKhi2"), 2)),
                            mclMtimes(
                              _mxarray3_,
                              mclIntArrayRef1(
                                mclVv(PolyKhi2, "PolyKhi2"), 1))));
                        /*
                         * PulseInterpShifted=circshift(PulseInterp(:,2),-2*TauFitN-1+MinKhi2Idx(i));
                         */
                        mlfAssign(
                          &PulseInterpShifted,
                          mlfCircshift(
                            mclArrayRef2(
                              mclVv(PulseInterp, "PulseInterp"),
                              mlfCreateColonIndex(),
                              _mxarray3_),
                            mclPlus(
                              mclMinus(
                                mclMtimes(
                                  _mxarray80_, mclVv(TauFitN, "TauFitN")),
                                _mxarray1_),
                              mclArrayRef1(
                                mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                mclVv(i, "i")))));
                        /*
                         * PulseInterpShiftedTest=circshift(PulseInterp(:,2),-2*TauFitN-1+MinKhi2Idx(i)+sign(MinKhi2Idx10-MinKhi2Idx(i)));
                         */
                        mlfAssign(
                          &PulseInterpShiftedTest,
                          mlfCircshift(
                            mclArrayRef2(
                              mclVv(PulseInterp, "PulseInterp"),
                              mlfCreateColonIndex(),
                              _mxarray3_),
                            mclPlus(
                              mclPlus(
                                mclMinus(
                                  mclMtimes(
                                    _mxarray80_, mclVv(TauFitN, "TauFitN")),
                                  _mxarray1_),
                                mclArrayRef1(
                                  mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                  mclVv(i, "i"))),
                              mlfSign(
                                mclMinus(
                                  mclVv(MinKhi2Idx10, "MinKhi2Idx10"),
                                  mclArrayRef1(
                                    mclVv(MinKhi2Idx, "MinKhi2Idx"),
                                    mclVv(i, "i")))))));
                        /*
                         * PulseInterp10Shifted=circshift(PulseInterp10(:,2),fix((-2*TauFitN-1+MinKhi2Idx10)*10));
                         */
                        mlfAssign(
                          &PulseInterp10Shifted,
                          mlfCircshift(
                            mclArrayRef2(
                              mclVv(PulseInterp10, "PulseInterp10"),
                              mlfCreateColonIndex(),
                              _mxarray3_),
                            mlfFix(
                              mclMtimes(
                                mclPlus(
                                  mclMinus(
                                    mclMtimes(
                                      _mxarray80_, mclVv(TauFitN, "TauFitN")),
                                    _mxarray1_),
                                  mclVv(MinKhi2Idx10, "MinKhi2Idx10")),
                                _mxarray16_))));
                        /*
                         * 
                         * FitPulseFin(1:FitNi)=PulseInterp10Shifted(PulseI10MaxIdx-StartFitPoint*TauFitN*10:TauFitN*10:PulseI10MaxIdx+EndFitPoint*TauFitN*10);
                         */
                        mclArrayAssign1(
                          &FitPulseFin,
                          mclArrayRef1(
                            mclVv(PulseInterp10Shifted, "PulseInterp10Shifted"),
                            mlfColon(
                              mclMinus(
                                mclVv(PulseI10MaxIdx, "PulseI10MaxIdx"),
                                mclMtimes(
                                  mclMtimes(
                                    mclVv(StartFitPoint, "StartFitPoint"),
                                    mclVv(TauFitN, "TauFitN")),
                                  _mxarray16_)),
                              mclMtimes(mclVv(TauFitN, "TauFitN"), _mxarray16_),
                              mclPlus(
                                mclVv(PulseI10MaxIdx, "PulseI10MaxIdx"),
                                mclMtimes(
                                  mclMtimes(
                                    mclVv(EndFitPoint, "EndFitPoint"),
                                    mclVv(TauFitN, "TauFitN")),
                                  _mxarray16_)))),
                          mlfColon(_mxarray1_, mclVv(FitNi, "FitNi"), NULL));
                        /*
                         * Sum1=FitPoints(:,2)'*FitPulseFin(:);
                         */
                        mlfAssign(
                          &Sum1,
                          mlf_times_transpose(
                            mclArrayRef2(
                              mclVv(FitPoints, "FitPoints"),
                              mlfCreateColonIndex(),
                              _mxarray3_),
                            mclArrayRef1(
                              mclVv(FitPulseFin, "FitPulseFin"),
                              mlfCreateColonIndex()),
                            _mxarray81_));
                        /*
                         * Sum2=sum(FitPulseFin(:));
                         */
                        mlfAssign(
                          &Sum2,
                          mlfSum(
                            mclArrayRef1(
                              mclVv(FitPulseFin, "FitPulseFin"),
                              mlfCreateColonIndex()),
                            NULL));
                        /*
                         * Sum3=FitPulseFin(:)'*FitPulseFin(:);
                         */
                        mlfAssign(
                          &Sum3,
                          mlf_times_transpose(
                            mclArrayRef1(
                              mclVv(FitPulseFin, "FitPulseFin"),
                              mlfCreateColonIndex()),
                            mclArrayRef1(
                              mclVv(FitPulseFin, "FitPulseFin"),
                              mlfCreateColonIndex()),
                            _mxarray81_));
                        /*
                         * A=(Sum1-B*Sum2)/Sum3;
                         */
                        mlfAssign(
                          &A,
                          mclMrdivide(
                            mclMinus(
                              mclVv(Sum1, "Sum1"),
                              mclMtimes(mclVv(B, "B"), mclVv(Sum2, "Sum2"))),
                            mclVv(Sum3, "Sum3")));
                        /*
                         * Khi2Fin(i)=(FitPoints(:,2)-A*FitPulseFin(:)-B)'*(FitPoints(:,2)-A*FitPulseFin(:)-B);
                         */
                        mclArrayAssign1(
                          &Khi2Fin,
                          mlf_times_transpose(
                            mclMinus(
                              mclMinus(
                                mclArrayRef2(
                                  mclVv(FitPoints, "FitPoints"),
                                  mlfCreateColonIndex(),
                                  _mxarray3_),
                                mclMtimes(
                                  mclVv(A, "A"),
                                  mclArrayRef1(
                                    mclVv(FitPulseFin, "FitPulseFin"),
                                    mlfCreateColonIndex()))),
                              mclVv(B, "B")),
                            mclMinus(
                              mclMinus(
                                mclArrayRef2(
                                  mclVv(FitPoints, "FitPoints"),
                                  mlfCreateColonIndex(),
                                  _mxarray3_),
                                mclMtimes(
                                  mclVv(A, "A"),
                                  mclArrayRef1(
                                    mclVv(FitPulseFin, "FitPulseFin"),
                                    mlfCreateColonIndex()))),
                              mclVv(B, "B")),
                            _mxarray81_),
                          mclVv(i, "i"));
                    } else {
                        mxDestroyArray(a_);
                    }
                /*
                 * end;
                 */
                }
            /*
             * end; 
             */
            }
            /*
             * 
             * 
             * PulseFit=[];
             */
            mlfAssign(&PulseFit, _mxarray23_);
            /*
             * PulseFit=A*PulseInterp10Shifted(1:TauFitN*10:end)+B;
             */
            mlfAssign(
              &PulseFit,
              mclPlus(
                mclMtimes(
                  mclVv(A, "A"),
                  mclArrayRef1(
                    mclVv(PulseInterp10Shifted, "PulseInterp10Shifted"),
                    mlfColon(
                      _mxarray1_,
                      mclMtimes(mclVv(TauFitN, "TauFitN"), _mxarray16_),
                      mlfEnd(
                        mclVv(PulseInterp10Shifted, "PulseInterp10Shifted"),
                        _mxarray1_,
                        _mxarray1_)))),
                mclVv(B, "B")));
            /*
             * PulseFitM=[];
             */
            mlfAssign(&PulseFitM, _mxarray23_);
            /*
             * PulseFitM=A*PulseInterp10Shifted(1:TauFitN*10:end);
             */
            mlfAssign(
              &PulseFitM,
              mclMtimes(
                mclVv(A, "A"),
                mclArrayRef1(
                  mclVv(PulseInterp10Shifted, "PulseInterp10Shifted"),
                  mlfColon(
                    _mxarray1_,
                    mclMtimes(mclVv(TauFitN, "TauFitN"), _mxarray16_),
                    mlfEnd(
                      mclVv(PulseInterp10Shifted, "PulseInterp10Shifted"),
                      _mxarray1_,
                      _mxarray1_)))));
            /*
             * [PulseFitMax,PulseFitMaxIdx]=max(PulseFit);
             */
            mlfAssign(
              &PulseFitMax,
              mlfMax(&PulseFitMaxIdx, mclVv(PulseFit, "PulseFit"), NULL, NULL));
            /*
             * FitIdx=PeakInd(i)+PulseInterp10(1:TauFitN*10:end,1);
             */
            mlfAssign(
              &FitIdx,
              mclPlus(
                mclArrayRef1(mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                mclArrayRef2(
                  mclVv(PulseInterp10, "PulseInterp10"),
                  mlfColon(
                    _mxarray1_,
                    mclMtimes(mclVv(TauFitN, "TauFitN"), _mxarray16_),
                    mlfEnd(
                      mclVv(PulseInterp10, "PulseInterp10"),
                      _mxarray1_,
                      _mxarray3_)),
                  _mxarray1_)));
            /*
             * FitIdx(find(FitIdx>trekSize-1))=[];   
             */
            mlfIndexDelete(
              &FitIdx,
              "(?)",
              mlfFind(
                NULL,
                NULL,
                mclGt(
                  mclVv(FitIdx, "FitIdx"),
                  mclMinus(mclVv(trekSize, "trekSize"), _mxarray1_))));
            /*
             * FitIdx(find(FitIdx<MinFront+1))=[];   
             */
            mlfIndexDelete(
              &FitIdx,
              "(?)",
              mlfFind(
                NULL,
                NULL,
                mclLt(
                  mclVv(FitIdx, "FitIdx"),
                  mclPlus(mclVv(MinFront, "MinFront"), _mxarray1_))));
            /*
             * 
             * 
             * if (Khi2Fin(i))>0
             */
            if (mclGtBool(
                  mclArrayRef1(mclVv(Khi2Fin, "Khi2Fin"), mclVv(i, "i")),
                  _mxarray0_)) {
                /*
                 * if  Khi2Fin(i)/(FitNi*StdVal^2)<Khi2Thr  
                 */
                if (mclLtBool(
                      mclMrdivide(
                        mclArrayRef1(mclVv(Khi2Fin, "Khi2Fin"), mclVv(i, "i")),
                        mclMtimes(
                          mclVv(FitNi, "FitNi"),
                          mclMpower(mclVv(StdVal, "StdVal"), _mxarray3_))),
                      mclVv(Khi2Thr, "Khi2Thr"))) {
                    /*
                     * trekMinus(FitIdx,2)=trekMinus(FitIdx,2)-PulseFitM(1:size(FitIdx,1));   
                     */
                    mclArrayAssign2(
                      &trekMinus,
                      mclMinus(
                        mclArrayRef2(
                          mclVv(trekMinus, "trekMinus"),
                          mclVv(FitIdx, "FitIdx"),
                          _mxarray3_),
                        mclArrayRef1(
                          mclVv(PulseFitM, "PulseFitM"),
                          mlfColon(
                            _mxarray1_,
                            mlfSize(
                              mclValueVarargout(),
                              mclVv(FitIdx, "FitIdx"),
                              _mxarray1_),
                            NULL))),
                      mclVv(FitIdx, "FitIdx"),
                      _mxarray3_);
                    /*
                     * 
                     * if A*PulseMax>Threshold
                     */
                    if (mclGtBool(
                          mclMtimes(mclVv(A, "A"), mclVv(PulseMax, "PulseMax")),
                          mclVv(Threshold, "Threshold"))) {
                        /*
                         * NPeaks=NPeaks+1;
                         */
                        mlfAssign(
                          &NPeaks,
                          mclPlus(mclVv(NPeaks, "NPeaks"), _mxarray1_));
                        /*
                         * peaks(NPeaks,1)=trekMinus(PeakInd(i),1)-MaxFront;                            %Peak Start Time
                         */
                        mclArrayAssign2(
                          &peaks,
                          mclMinus(
                            mclArrayRef2(
                              mclVv(trekMinus, "trekMinus"),
                              mclArrayRef1(
                                mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                              _mxarray1_),
                            mclVv(MaxFront, "MaxFront")),
                          mclVv(NPeaks, "NPeaks"),
                          _mxarray1_);
                        /*
                         * peaks(NPeaks,2)=trekMinus(PeakInd(i),1)+(-2*TauFitN-1+MinKhi2Idx10)*tau;     %Peak Max Time
                         */
                        mclArrayAssign2(
                          &peaks,
                          mclPlus(
                            mclArrayRef2(
                              mclVv(trekMinus, "trekMinus"),
                              mclArrayRef1(
                                mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                              _mxarray1_),
                            mclMtimes(
                              mclPlus(
                                mclMinus(
                                  mclMtimes(
                                    _mxarray80_, mclVv(TauFitN, "TauFitN")),
                                  _mxarray1_),
                                mclVv(MinKhi2Idx10, "MinKhi2Idx10")),
                              mclVv(tau, "tau"))),
                          mclVv(NPeaks, "NPeaks"),
                          _mxarray3_);
                        /*
                         * 
                         * peaks(NPeaks,4)=B;                                                           %Peak Zero Level
                         */
                        mclArrayAssign2(
                          &peaks,
                          mclVv(B, "B"),
                          mclVv(NPeaks, "NPeaks"),
                          _mxarray15_);
                        /*
                         * peaks(NPeaks,5)=A*PulseMax;                                                  %Peak Amplitude
                         */
                        mclArrayAssign2(
                          &peaks,
                          mclMtimes(mclVv(A, "A"), mclVv(PulseMax, "PulseMax")),
                          mclVv(NPeaks, "NPeaks"),
                          _mxarray14_);
                        /*
                         * peaks(NPeaks,6)=A*PulseMax*0.5;                                              %FrontCharge
                         */
                        mclArrayAssign2(
                          &peaks,
                          mclMtimes(
                            mclMtimes(
                              mclVv(A, "A"), mclVv(PulseMax, "PulseMax")),
                            _mxarray11_),
                          mclVv(NPeaks, "NPeaks"),
                          _mxarray81_);
                        /*
                         * peaks(NPeaks,7)=MaxFront+MaxTail;                                            % peak or front duration (depending on FrontCharge)
                         */
                        mclArrayAssign2(
                          &peaks,
                          mclPlus(
                            mclVv(MaxFront, "MaxFront"),
                            mclVv(MaxTail, "MaxTail")),
                          mclVv(NPeaks, "NPeaks"),
                          _mxarray82_);
                        /*
                         * peaks(NPeaks,8)=Pass;                                                        % number of Pass in which peak finded
                         */
                        mclArrayAssign2(
                          &peaks,
                          mclVv(Pass, "Pass"),
                          mclVv(NPeaks, "NPeaks"),
                          _mxarray8_);
                    /*
                     * end;                       
                     */
                    }
                    /*
                     * S=FitIdx(1); E=FitIdx(end);
                     */
                    mlfAssign(&S, mclIntArrayRef1(mclVv(FitIdx, "FitIdx"), 1));
                    mlfAssign(
                      &E,
                      mclArrayRef1(
                        mclVv(FitIdx, "FitIdx"),
                        mlfEnd(
                          mclVv(FitIdx, "FitIdx"), _mxarray1_, _mxarray1_)));
                    /*
                     * 
                     * 
                     * VisiblePeakInd=find((trekMinus(S:E,2)>=trekMinus(S+1:E+1,2))&...
                     */
                    mlfAssign(
                      &VisiblePeakInd,
                      mlfFind(
                        NULL,
                        NULL,
                        mclAnd(
                          mclAnd(
                            mclAnd(
                              mclAnd(
                                mclGe(
                                  mclArrayRef2(
                                    mclVv(trekMinus, "trekMinus"),
                                    mlfColon(
                                      mclVv(S, "S"), mclVv(E, "E"), NULL),
                                    _mxarray3_),
                                  mclArrayRef2(
                                    mclVv(trekMinus, "trekMinus"),
                                    mlfColon(
                                      mclPlus(mclVv(S, "S"), _mxarray1_),
                                      mclPlus(mclVv(E, "E"), _mxarray1_),
                                      NULL),
                                    _mxarray3_)),
                                mclGt(
                                  mclArrayRef2(
                                    mclVv(trekMinus, "trekMinus"),
                                    mlfColon(
                                      mclVv(S, "S"), mclVv(E, "E"), NULL),
                                    _mxarray3_),
                                  mclArrayRef2(
                                    mclVv(trekMinus, "trekMinus"),
                                    mlfColon(
                                      mclMinus(mclVv(S, "S"), _mxarray1_),
                                      mclMinus(mclVv(E, "E"), _mxarray1_),
                                      NULL),
                                    _mxarray3_))),
                              mclGt(
                                mclArrayRef2(
                                  mclVv(trekMinus, "trekMinus"),
                                  mlfColon(
                                    mclMinus(mclVv(S, "S"), _mxarray1_),
                                    mclMinus(mclVv(E, "E"), _mxarray1_),
                                    NULL),
                                  _mxarray3_),
                                mclArrayRef2(
                                  mclVv(trekMinus, "trekMinus"),
                                  mlfColon(
                                    mclMinus(mclVv(S, "S"), _mxarray3_),
                                    mclMinus(mclVv(E, "E"), _mxarray3_),
                                    NULL),
                                  _mxarray3_))),
                            mclGt(
                              mclArrayRef2(
                                mclVv(trekMinus, "trekMinus"),
                                mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL),
                                _mxarray3_),
                              mclPlus(
                                mclArrayRef2(
                                  mclVv(trekMinus, "trekMinus"),
                                  mlfColon(
                                    mclMinus(
                                      mclVv(S, "S"),
                                      mclVv(MinFrontN, "MinFrontN")),
                                    mclMinus(
                                      mclVv(E, "E"),
                                      mclVv(MinFrontN, "MinFrontN")),
                                    NULL),
                                  _mxarray3_),
                                mclMtimes(
                                  mclVv(MinFrontN, "MinFrontN"),
                                  mclVv(ThresholdD, "ThresholdD"))))),
                          mclGt(
                            mclArrayRef2(
                              mclVv(trekMinus, "trekMinus"),
                              mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL),
                              _mxarray3_),
                            mclPlus(
                              mclArrayRef2(
                                mclVv(trekMinus, "trekMinus"),
                                mlfColon(
                                  mclMinus(
                                    mclVv(S, "S"),
                                    mclVv(MinFrontN, "MinFrontN")),
                                  mclMinus(
                                    mclVv(E, "E"),
                                    mclVv(MinFrontN, "MinFrontN")),
                                  NULL),
                                _mxarray3_),
                              mclVv(Threshold, "Threshold"))))));
                    /*
                     * (trekMinus(S:E,2)>trekMinus(S-1:E-1,2))&...            
                     * (trekMinus(S-1:E-1,2)>trekMinus(S-2:E-2,2))&...
                     * (trekMinus(S:E,2)>trekMinus(S-MinFrontN:E-MinFrontN,2)+MinFrontN*ThresholdD)&...
                     * (trekMinus(S:E,2)>trekMinus(S-MinFrontN:E-MinFrontN,2)+Threshold));  % preceeding                
                     * 
                     * if i<PeakN
                     */
                    if (mclLtBool(mclVv(i, "i"), mclVv(PeakN, "PeakN"))) {
                        /*
                         * VisiblePeakInd(find(S+VisiblePeakInd-1>=PeakInd(i+1)))=[];
                         */
                        mlfIndexDelete(
                          &VisiblePeakInd,
                          "(?)",
                          mlfFind(
                            NULL,
                            NULL,
                            mclGe(
                              mclMinus(
                                mclPlus(
                                  mclVv(S, "S"),
                                  mclVv(VisiblePeakInd, "VisiblePeakInd")),
                                _mxarray1_),
                              mclArrayRef1(
                                mclVv(PeakInd, "PeakInd"),
                                mclPlus(mclVv(i, "i"), _mxarray1_)))));
                    /*
                     * end;
                     */
                    }
                    /*
                     * VisiblePeakInd(find(S+VisiblePeakInd-1<=PeakInd(i)))=[];
                     */
                    mlfIndexDelete(
                      &VisiblePeakInd,
                      "(?)",
                      mlfFind(
                        NULL,
                        NULL,
                        mclLe(
                          mclMinus(
                            mclPlus(
                              mclVv(S, "S"),
                              mclVv(VisiblePeakInd, "VisiblePeakInd")),
                            _mxarray1_),
                          mclArrayRef1(
                            mclVv(PeakInd, "PeakInd"), mclVv(i, "i")))));
                    /*
                     * 
                     * if ~isempty(VisiblePeakInd)        
                     */
                    if (mclNotBool(
                          mlfIsempty(
                            mclVv(VisiblePeakInd, "VisiblePeakInd")))) {
                        /*
                         * PeakInd=[PeakInd;S+VisiblePeakInd(1)-1];        
                         */
                        mlfAssign(
                          &PeakInd,
                          mlfVertcat(
                            mclVv(PeakInd, "PeakInd"),
                            mclMinus(
                              mclPlus(
                                mclVv(S, "S"),
                                mclIntArrayRef1(
                                  mclVv(VisiblePeakInd, "VisiblePeakInd"), 1)),
                              _mxarray1_),
                            NULL));
                        /*
                         * PeakN=size(PeakInd,1);
                         */
                        mlfAssign(
                          &PeakN,
                          mlfSize(
                            mclValueVarargout(),
                            mclVv(PeakInd, "PeakInd"),
                            _mxarray1_));
                        /*
                         * PeakInd=sort(PeakInd);
                         */
                        mlfAssign(
                          &PeakInd,
                          mlfSort(NULL, mclVv(PeakInd, "PeakInd"), NULL));
                    /*
                     * end;
                     */
                    }
                /*
                 * 
                 * end;  
                 */
                }
            /*
             * end;
             */
            }
        /*
         * 
         * 
         * end;
         */
        }
        /*
         * fprintf('trek rejection  =                                            %7.4f  sec\n', toc);
         */
        mclAssignAns(&ans, mlfNFprintf(0, _mxarray83_, mlfNToc(1), NULL));
        /*
         * peaks=sortrows(peaks,2);
         */
        mlfAssign(&peaks, mlfSortrows(NULL, mclVv(peaks, "peaks"), _mxarray3_));
        /*
         * NPeaks=size(peaks,1);
         */
        mlfAssign(
          &NPeaks,
          mlfSize(mclValueVarargout(), mclVv(peaks, "peaks"), _mxarray1_));
        /*
         * DeltaNPeaks=NPeaks-NPeaks1;
         */
        mlfAssign(
          &DeltaNPeaks,
          mclMinus(mclVv(NPeaks, "NPeaks"), mclVv(NPeaks1, "NPeaks1")));
        /*
         * 
         * if Pass==1
         */
        if (mclEqBool(mclVv(Pass, "Pass"), _mxarray1_)) {
            /*
             * clear TailIdx Tail StandardPulsesNorm StandardPulses StandardPulse StandardPeaksN StandardPeaks StPeakN; 
             */
            mlfClear(
              &TailIdx,
              &Tail,
              &StandardPulsesNorm,
              &StandardPulses,
              &StandardPulse,
              &StandardPeaksN,
              &StandardPeaks,
              &StPeakN,
              NULL);
            /*
             * clear RangeSP Range PolyTail PolyFitLog FitLog PeakVal PeakStart PeakEnd NumGoodPeaks;   
             */
            mlfClear(
              &RangeSP,
              &Range,
              &PolyTail,
              &PolyFitLog,
              &FitLog,
              &PeakVal,
              &PeakStart,
              &PeakEnd,
              &NumGoodPeaks,
              NULL);
            /*
             * clear MaxPeak MaxPeakInd MaxStPeak MaxStPeakIdx MaxSPInd MaxIndSP MaxSP MinSP MinSPInd MinStPeakIdx MinStPeak;
             */
            mlfClear(
              &MaxPeak,
              &MaxPeakInd,
              &MaxStPeak,
              &MaxStPeakIdx,
              &MaxSPInd,
              &MaxIndSP,
              &MaxSP,
              &MinSP,
              &MinSPInd,
              &MinStPeakIdx,
              &MinStPeak,
              NULL);
        /*
         * end;
         */
        }
        /*
         * clear k i VisiblePeakInd;
         */
        mlfClear(&k, &i, &VisiblePeakInd, NULL);
        /*
         * clear Sum3 Sum2 Sum1;
         */
        mlfClear(&Sum3, &Sum2, &Sum1, NULL);
        /*
         * clear Khi2Fit S PulseOverThr ;
         */
        mlfClear(&Khi2Fit, &S, &PulseOverThr, NULL);
        /*
         * clear PeakSpanInd PeakOnFrontInd PeakN PeakInd OutRangeN NumPeaks;
         */
        mlfClear(
          &PeakSpanInd,
          &PeakOnFrontInd,
          &PeakN,
          &PeakInd,
          &OutRangeN,
          &NumPeaks,
          NULL);
        /*
         * clear MinKhi2Idx MinKhi2 MinInterval M Ind Idx;
         */
        mlfClear(&MinKhi2Idx, &MinKhi2, &MinInterval, &M, &Ind, &Idx, NULL);
        /*
         * clear GoodPeakN GoodPeakInd GoodPeakVal FrontSignalN FitIdx E;
         */
        mlfClear(
          &GoodPeakN,
          &GoodPeakInd,
          &GoodPeakVal,
          &FrontSignalN,
          &FitIdx,
          &E,
          NULL);
        /*
         * clear DoubleFrontSize DoubleFrontInd A B;
         */
        mlfClear(&DoubleFrontSize, &DoubleFrontInd, &A, &B, NULL);
    /*
     * 
     * end;
     */
    }
    /*
     * 
     * 
     * 
     * 
     * 
     * if NPeaks>1 Period=(peaks(end,1)-peaks(1,1))/NPeaks;  else
     */
    if (mclGtBool(mclVv(NPeaks, "NPeaks"), _mxarray1_)) {
        mlfAssign(
          &Period,
          mclMrdivide(
            mclMinus(
              mclArrayRef2(
                mclVv(peaks, "peaks"),
                mlfEnd(mclVv(peaks, "peaks"), _mxarray1_, _mxarray3_),
                _mxarray1_),
              mclIntArrayRef2(mclVv(peaks, "peaks"), 1, 1)),
            mclVv(NPeaks, "NPeaks")));
    } else {
        /*
         * Period=(trek(end,1)-trek(1,1));            end;                        
         */
        mlfAssign(
          &Period,
          mclMinus(
            mclArrayRef2(
              mclVv(trek, "trek"),
              mlfEnd(mclVv(trek, "trek"), _mxarray1_, _mxarray3_),
              _mxarray1_),
            mclIntArrayRef2(mclVv(trek, "trek"), 1, 1)));
    }
    /*
     * peaks(:,3)=circshift(peaks(:,2),-1)-peaks(:,2);   % peak-to-peak interval, us (after peak)
     */
    mclArrayAssign2(
      &peaks,
      mclMinus(
        mlfCircshift(
          mclArrayRef2(
            mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray3_),
          _mxarray49_),
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray3_)),
      mlfCreateColonIndex(),
      _mxarray69_);
    /*
     * peaks(end,3)=Period; 
     */
    mclArrayAssign2(
      &peaks,
      mclVv(Period, "Period"),
      mlfEnd(mclVv(peaks, "peaks"), _mxarray1_, _mxarray3_),
      _mxarray69_);
    /*
     * 
     * %if size(PeakInd,1)>size(MinSigma,1) PeakInd(end)=[]; end;
     * 
     * 
     * 
     * %peak amplitude histogram
     * MaxAmpl=max(peaks(:,5));
     */
    mlfAssign(
      &MaxAmpl,
      mlfMax(
        NULL,
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray14_),
        NULL,
        NULL));
    /*
     * MinAmpl=0; %min(peaks(:,4));
     */
    mlfAssign(&MinAmpl, _mxarray0_);
    /*
     * PeakAmplRange=MaxAmpl-MinAmpl; 
     */
    mlfAssign(
      &PeakAmplRange,
      mclMinus(mclVv(MaxAmpl, "MaxAmpl"), mclVv(MinAmpl, "MinAmpl")));
    /*
     * HistIntervalA=HistInterval; %   =PeakAmplRange/HistN;       % interval for amplitudes
     */
    mlfAssign(&HistIntervalA, mclVv(HistInterval, "HistInterval"));
    /*
     * %HistN=fix(NPeaks/AveragN);  
     * HistN=fix(PeakAmplRange/HistIntervalA)+1;  
     */
    mlfAssign(
      &HistN,
      mclPlus(
        mlfFix(
          mclMrdivide(
            mclVv(PeakAmplRange, "PeakAmplRange"),
            mclVv(HistIntervalA, "HistIntervalA"))),
        _mxarray1_));
    /*
     * if HistN==0; HistN=1; end;     % the number of intervals 
     */
    if (mclEqBool(mclVv(HistN, "HistN"), _mxarray0_)) {
        mlfAssign(&HistN, _mxarray1_);
    }
    /*
     * 
     * for i=1:HistN
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVv(HistN, "HistN"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray23_);
        } else {
            /*
             * HistA(i,1)=MinAmpl+(i-0.5)*HistIntervalA; 
             * HistBool=(peaks(:,5)<HistA(i,1)+HistIntervalA/2)&...
             * (peaks(:,5)>=HistA(i,1)-HistIntervalA/2);
             * HistA(i,2)=size(peaks(HistBool,1),1);  %peak aplitude
             * HistA(i,3)=sqrt(HistA(i,2));           %peak aplitude error
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign2(
                  HistA,
                  mclPlus(
                    mclVv(MinAmpl, "MinAmpl"),
                    mclMtimes(
                      mlfScalar(svDoubleScalarMinus((double) v_, .5)),
                      mclVv(HistIntervalA, "HistIntervalA"))),
                  v_,
                  1);
                mlfAssign(
                  &HistBool,
                  mclAnd(
                    mclLt(
                      mclArrayRef2(
                        mclVv(peaks, "peaks"),
                        mlfCreateColonIndex(),
                        _mxarray14_),
                      mclPlus(
                        mclIntArrayRef2(mclVv(*HistA, "HistA"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalA, "HistIntervalA"), _mxarray3_))),
                    mclGe(
                      mclArrayRef2(
                        mclVv(peaks, "peaks"),
                        mlfCreateColonIndex(),
                        _mxarray14_),
                      mclMinus(
                        mclIntArrayRef2(mclVv(*HistA, "HistA"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalA, "HistIntervalA"),
                          _mxarray3_)))));
                mclIntArrayAssign2(
                  HistA,
                  mlfSize(
                    mclValueVarargout(),
                    mclArrayRef2(
                      mclVv(peaks, "peaks"),
                      mclVv(HistBool, "HistBool"),
                      _mxarray1_),
                    _mxarray1_),
                  v_,
                  2);
                mclIntArrayAssign2(
                  HistA,
                  mlfSqrt(mclIntArrayRef2(mclVv(*HistA, "HistA"), v_, 2)),
                  v_,
                  3);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * % ZeroBool=HistA(:,2)==0; 
     * % HistA(ZeroBool,:)=[]; 
     * 
     * 
     * %peak interval histogram
     * MaxT=max(peaks(:,3));
     */
    mlfAssign(
      &MaxT,
      mlfMax(
        NULL,
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray69_),
        NULL,
        NULL));
    /*
     * MinT=min(peaks(:,3));
     */
    mlfAssign(
      &MinT,
      mlfMin(
        NULL,
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray69_),
        NULL,
        NULL));
    /*
     * PeakTRange=MaxT-MinT; 
     */
    mlfAssign(&PeakTRange, mclMinus(mclVv(MaxT, "MaxT"), mclVv(MinT, "MinT")));
    /*
     * HistIntervalT=PeakTRange/HistN;          % interval for T
     */
    mlfAssign(
      &HistIntervalT,
      mclMrdivide(mclVv(PeakTRange, "PeakTRange"), mclVv(HistN, "HistN")));
    /*
     * for i=1:HistN
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVv(HistN, "HistN"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray23_);
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
                        _mxarray69_),
                      mclPlus(
                        mclIntArrayRef2(mclVv(HistT, "HistT"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalT, "HistIntervalT"), _mxarray3_))),
                    mclGe(
                      mclArrayRef2(
                        mclVv(peaks, "peaks"),
                        mlfCreateColonIndex(),
                        _mxarray69_),
                      mclMinus(
                        mclIntArrayRef2(mclVv(HistT, "HistT"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalT, "HistIntervalT"),
                          _mxarray3_)))));
                mclIntArrayAssign2(
                  &HistT,
                  mlfSize(
                    mclValueVarargout(),
                    mclArrayRef2(
                      mclVv(peaks, "peaks"),
                      mclVv(HistBool, "HistBool"),
                      _mxarray1_),
                    _mxarray1_),
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
        mclArrayRef2(mclVv(HistT, "HistT"), mlfCreateColonIndex(), _mxarray3_),
        _mxarray0_));
    /*
     * HistT(ZeroBool,:)=[];
     */
    mlfIndexDelete(
      &HistT, "(?,?)", mclVv(ZeroBool, "ZeroBool"), mlfCreateColonIndex());
    /*
     * 
     * %peak 'charge'  histogram
     * MaxC=max(peaks(:,6));
     */
    mlfAssign(
      &MaxC,
      mlfMax(
        NULL,
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray81_),
        NULL,
        NULL));
    /*
     * MinC=0; %   min(peaks(:,6));
     */
    mlfAssign(&MinC, _mxarray0_);
    /*
     * PeakCRange=MaxC-MinC; 
     */
    mlfAssign(&PeakCRange, mclMinus(mclVv(MaxC, "MaxC"), mclVv(MinC, "MinC")));
    /*
     * HistIntervalC=HistInterval; %  =PeakCRange/HistN;          % Charge
     */
    mlfAssign(&HistIntervalC, mclVv(HistInterval, "HistInterval"));
    /*
     * HistN=fix(PeakCRange/HistIntervalC)+1;  
     */
    mlfAssign(
      &HistN,
      mclPlus(
        mlfFix(
          mclMrdivide(
            mclVv(PeakCRange, "PeakCRange"),
            mclVv(HistIntervalC, "HistIntervalC"))),
        _mxarray1_));
    /*
     * for i=1:HistN
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVv(HistN, "HistN"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray23_);
        } else {
            /*
             * HistC(i,1)=MinC+(i-0.5)*HistIntervalC; 
             * HistBool=(peaks(:,6)<HistC(i,1)+HistIntervalC/2)&...
             * (peaks(:,6)>=HistC(i,1)-HistIntervalC/2);
             * HistC(i,2)=size(peaks(HistBool,1),1);    % peak charge
             * HistC(i,3)=sqrt(HistC(i,2));             %peak charge error
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign2(
                  &HistC,
                  mclPlus(
                    mclVv(MinC, "MinC"),
                    mclMtimes(
                      mlfScalar(svDoubleScalarMinus((double) v_, .5)),
                      mclVv(HistIntervalC, "HistIntervalC"))),
                  v_,
                  1);
                mlfAssign(
                  &HistBool,
                  mclAnd(
                    mclLt(
                      mclArrayRef2(
                        mclVv(peaks, "peaks"),
                        mlfCreateColonIndex(),
                        _mxarray81_),
                      mclPlus(
                        mclIntArrayRef2(mclVv(HistC, "HistC"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalC, "HistIntervalC"), _mxarray3_))),
                    mclGe(
                      mclArrayRef2(
                        mclVv(peaks, "peaks"),
                        mlfCreateColonIndex(),
                        _mxarray81_),
                      mclMinus(
                        mclIntArrayRef2(mclVv(HistC, "HistC"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalC, "HistIntervalC"),
                          _mxarray3_)))));
                mclIntArrayAssign2(
                  &HistC,
                  mlfSize(
                    mclValueVarargout(),
                    mclArrayRef2(
                      mclVv(peaks, "peaks"),
                      mclVv(HistBool, "HistBool"),
                      _mxarray1_),
                    _mxarray1_),
                  v_,
                  2);
                mclIntArrayAssign2(
                  &HistC,
                  mlfSqrt(mclIntArrayRef2(mclVv(HistC, "HistC"), v_, 2)),
                  v_,
                  3);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * % ZeroBool=HistC(:,2)==0; 
     * % HistC(ZeroBool,:)=[];
     * 
     * 
     * %Poisson interval distribution
     * test=rand(NPeaks,1)*(trek(end,1)-trek(1,1));
     */
    mlfAssign(
      &test,
      mclMtimes(
        mlfNRand(1, mclVv(NPeaks, "NPeaks"), _mxarray1_, NULL),
        mclMinus(
          mclArrayRef2(
            mclVv(trek, "trek"),
            mlfEnd(mclVv(trek, "trek"), _mxarray1_, _mxarray3_),
            _mxarray1_),
          mclIntArrayRef2(mclVv(trek, "trek"), 1, 1))));
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
        mlfCircshift(mclVv(Poisson, "Poisson"), _mxarray49_),
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
            _mxarray1_,
            mclMinus(
              mlfEnd(mclVv(Poisson, "Poisson"), _mxarray1_, _mxarray1_),
              _mxarray1_),
            NULL)),
        NULL));
    /*
     * Poisson(end)=MeanP; 
     */
    mclArrayAssign1(
      &Poisson,
      mclVv(MeanP, "MeanP"),
      mlfEnd(mclVv(Poisson, "Poisson"), _mxarray1_, _mxarray1_));
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
     * for i=1:HistN
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVv(HistN, "HistN"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray23_);
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
                          mclVv(HistIntervalP, "HistIntervalP"), _mxarray3_))),
                    mclGe(
                      mclVv(Poisson, "Poisson"),
                      mclMinus(
                        mclIntArrayRef2(mclVv(HistP, "HistP"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalP, "HistIntervalP"),
                          _mxarray3_)))));
                mclIntArrayAssign2(
                  &HistP,
                  mlfSize(
                    mclValueVarargout(),
                    mclArrayRef1(
                      mclVv(Poisson, "Poisson"), mclVv(HistBool, "HistBool")),
                    _mxarray1_),
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
     * fprintf('---------------------\n');                
     */
    mclAssignAns(&ans, mlfNFprintf(0, _mxarray85_, NULL));
    /*
     * fprintf('Peak threshold =  %3.3f\n', Threshold);
     */
    mclAssignAns(
      &ans, mlfNFprintf(0, _mxarray87_, mclVv(Threshold, "Threshold"), NULL));
    /*
     * fprintf('The number of peaks =  %5.0f\n', NPeaks);
     */
    mclAssignAns(
      &ans, mlfNFprintf(0, _mxarray89_, mclVv(NPeaks, "NPeaks"), NULL));
    /*
     * fprintf('The period of peaks =  %6.4f ms\n', Period/1000);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(
        0,
        _mxarray91_,
        mclMrdivide(mclVv(Period, "Period"), _mxarray93_),
        NULL));
    /*
     * fprintf('Resolution in the peak amplitude histogram=  %3.3f counts\n', HistIntervalA);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(0, _mxarray94_, mclVv(HistIntervalA, "HistIntervalA"), NULL));
    /*
     * fprintf('Resolution in the peak interval histogram=  %3.3f us\n', HistIntervalT);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(0, _mxarray96_, mclVv(HistIntervalT, "HistIntervalT"), NULL));
    /*
     * fprintf('Expected number of double peaks for 0.025 us = %3.3f \n', NPeaks*0.025/Period);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(
        0,
        _mxarray98_,
        mclMrdivide(
          mclMtimes(mclVv(NPeaks, "NPeaks"), _mxarray13_),
          mclVv(Period, "Period")),
        NULL));
    /*
     * fprintf('=====================\n');                
     */
    mclAssignAns(&ans, mlfNFprintf(0, _mxarray100_, NULL));
    /*
     * 
     * if isstr(FileName) HistAFile=FileName; HistAFile(1:4)='hisA'; 
     */
    if (mlfTobool(mlfIsstr(mclVa(FileName, "FileName")))) {
        mlfAssign(&HistAFile, mclVa(FileName, "FileName"));
        mclArrayAssign1(
          &HistAFile, _mxarray102_, mlfColon(_mxarray1_, _mxarray15_, NULL));
    /*
     * else HistAFile='HistA.dat'; end; 
     */
    } else {
        mlfAssign(&HistAFile, _mxarray104_);
    }
    /*
     * fid=fopen(HistAFile,'w'); 
     */
    mlfAssign(
      &fid,
      mlfFopen(NULL, NULL, mclVv(HistAFile, "HistAFile"), _mxarray106_, NULL));
    /*
     * fprintf(fid,'%6.2f %3.0f %5.2f\n' ,HistA');
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(
        0,
        mclVv(fid, "fid"),
        _mxarray108_,
        mlfCtranspose(mclVv(*HistA, "HistA")),
        NULL));
    /*
     * fclose(fid);    
     */
    mclAssignAns(&ans, mlfFclose(mclVv(fid, "fid")));
    /*
     * if isstr(FileName) HistCFile=FileName; HistCFile(1:4)='hisC'; 
     */
    if (mlfTobool(mlfIsstr(mclVa(FileName, "FileName")))) {
        mlfAssign(&HistCFile, mclVa(FileName, "FileName"));
        mclArrayAssign1(
          &HistCFile, _mxarray110_, mlfColon(_mxarray1_, _mxarray15_, NULL));
    /*
     * else HistCFile='HistC.dat'; end; 
     */
    } else {
        mlfAssign(&HistCFile, _mxarray112_);
    }
    /*
     * fid=fopen(HistCFile,'w'); 
     */
    mlfAssign(
      &fid,
      mlfFopen(NULL, NULL, mclVv(HistCFile, "HistCFile"), _mxarray106_, NULL));
    /*
     * fprintf(fid,'%6.2f %3.0f %5.2f\n' ,HistC');
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(
        0,
        mclVv(fid, "fid"),
        _mxarray108_,
        mlfCtranspose(mclVv(HistC, "HistC")),
        NULL));
    /*
     * fclose(fid);    
     */
    mclAssignAns(&ans, mlfFclose(mclVv(fid, "fid")));
    /*
     * 
     * if isstr(FileName) PeakFile=FileName;  PeakFile(1:4)='peak'; 
     */
    if (mlfTobool(mlfIsstr(mclVa(FileName, "FileName")))) {
        mlfAssign(&PeakFile, mclVa(FileName, "FileName"));
        mclArrayAssign1(
          &PeakFile, _mxarray114_, mlfColon(_mxarray1_, _mxarray15_, NULL));
    /*
     * else PeakFile='peaks.dat'; end; 
     */
    } else {
        mlfAssign(&PeakFile, _mxarray116_);
    }
    /*
     * %if isstr(FileName)&&strcmp(PeakFile,FileName) PeakFile=['Peaks',FileName]; end; 
     * 
     * fid=fopen(PeakFile,'w');
     */
    mlfAssign(
      &fid,
      mlfFopen(NULL, NULL, mclVv(PeakFile, "PeakFile"), _mxarray106_, NULL));
    /*
     * fprintf(fid,'start       peak      interv      zero  ampl    charge duration CombN\n'); 
     */
    mclAssignAns(&ans, mlfNFprintf(0, mclVv(fid, "fid"), _mxarray118_, NULL));
    /*
     * fprintf(fid,'%10.3f %10.3f %9.3f %7.2f %7.2f %7.2f %5.3f %2.0f \n' ,peaks');
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(
        0,
        mclVv(fid, "fid"),
        _mxarray120_,
        mlfCtranspose(mclVv(peaks, "peaks")),
        NULL));
    /*
     * fclose(fid);    
     */
    mclAssignAns(&ans, mlfFclose(mclVv(fid, "fid")));
    /*
     * fprintf('All time=                                                    %7.3f',toc);
     */
    mclAssignAns(&ans, mlfNFprintf(0, _mxarray122_, mlfNToc(1), NULL));
    mclValidateOutput(peaks, 1, nargout_, "peaks", "peaks2auto");
    mclValidateOutput(*HistA, 2, nargout_, "HistA", "peaks2auto");
    mxDestroyArray(Text);
    mxDestroyArray(Delta);
    mxDestroyArray(Fourie);
    mxDestroyArray(FrontCharge);
    mxDestroyArray(DeadAfter);
    mxDestroyArray(Plot1);
    mxDestroyArray(Plot2);
    mxDestroyArray(AverageGate);
    mxDestroyArray(OverSt);
    mxDestroyArray(PeakSt);
    mxDestroyArray(MinFront);
    mxDestroyArray(MaxFront);
    mxDestroyArray(MinTail);
    mxDestroyArray(MaxTail);
    mxDestroyArray(MinDuration);
    mxDestroyArray(MaxDuration);
    mxDestroyArray(Dshift);
    mxDestroyArray(ZeroPoints);
    mxDestroyArray(MinInterval);
    mxDestroyArray(MaxCombined);
    mxDestroyArray(AveragN);
    mxDestroyArray(HistInterval);
    mxDestroyArray(ChargeTime);
    mxDestroyArray(DeadTime);
    mxDestroyArray(tau);
    mxDestroyArray(lowf);
    mxDestroyArray(BFitPointsN);
    mxDestroyArray(TauFitN);
    mxDestroyArray(Khi2Thr);
    mxDestroyArray(SecondPassFull);
    mxDestroyArray(MaxFrontN);
    mxDestroyArray(MaxTailN);
    mxDestroyArray(MinFrontN);
    mxDestroyArray(MinTailN);
    mxDestroyArray(ans);
    mxDestroyArray(trek);
    mxDestroyArray(fid);
    mxDestroyArray(bool0);
    mxDestroyArray(OutRangeN);
    mxDestroyArray(trekSize);
    mxDestroyArray(trekStart);
    mxDestroyArray(NPeaks);
    mxDestroyArray(DeltaNPeaks);
    mxDestroyArray(Pass);
    mxDestroyArray(trekMinus);
    mxDestroyArray(NPeaks1);
    mxDestroyArray(ThresholdD);
    mxDestroyArray(Threshold);
    mxDestroyArray(StdValD);
    mxDestroyArray(StdVal);
    mxDestroyArray(StartSignal);
    mxDestroyArray(EndSignal);
    mxDestroyArray(SlowN);
    mxDestroyArray(SlowInd);
    mxDestroyArray(Slow);
    mxDestroyArray(SizeMoveToSignal);
    mxDestroyArray(SignalN);
    mxDestroyArray(NoiseArray);
    mxDestroyArray(MeanVal);
    mxDestroyArray(PeakPolarity);
    mxDestroyArray(PolyZero);
    mxDestroyArray(MaxAmp);
    mxDestroyArray(MinTime);
    mxDestroyArray(MaxTime);
    mxDestroyArray(MaxSpectr);
    mxDestroyArray(MaxSpectr0);
    mxDestroyArray(SmoothGate);
    mxDestroyArray(SmoothedNoise);
    mxDestroyArray(trekR);
    mxDestroyArray(i);
    mxDestroyArray(trekL);
    mxDestroyArray(trekD);
    mxDestroyArray(LD);
    mxDestroyArray(MeanValD);
    mxDestroyArray(Noise);
    mxDestroyArray(NoiseR);
    mxDestroyArray(NoiseL);
    mxDestroyArray(StartNoise);
    mxDestroyArray(EndNoise);
    mxDestroyArray(MoveToNoise);
    mxDestroyArray(SizeMoveToNoise);
    mxDestroyArray(MoveToSignal);
    mxDestroyArray(Range);
    mxDestroyArray(PeakInd);
    mxDestroyArray(PeakOnFrontInd);
    mxDestroyArray(GoodPeakInd);
    mxDestroyArray(GoodPeakVal);
    mxDestroyArray(PeakVal);
    mxDestroyArray(S);
    mxDestroyArray(E);
    mxDestroyArray(VisiblePeakInd);
    mxDestroyArray(GoodVisiblePeakInd);
    mxDestroyArray(NumPeaks);
    mxDestroyArray(NumGoodPeaks);
    mxDestroyArray(Max);
    mxDestroyArray(MaxPeak);
    mxDestroyArray(Ind);
    mxDestroyArray(MaxPeakInd);
    mxDestroyArray(FrontSignalN);
    mxDestroyArray(PeakN);
    mxDestroyArray(GoodPeakN);
    mxDestroyArray(DoubleFrontInd);
    mxDestroyArray(DoubleFrontSize);
    mxDestroyArray(PeakSpanInd);
    mxDestroyArray(StandardPeaks);
    mxDestroyArray(StandardPeaksN);
    mxDestroyArray(StandardPulse);
    mxDestroyArray(Tail);
    mxDestroyArray(PeakStart);
    mxDestroyArray(Idx);
    mxDestroyArray(PeakEnd);
    mxDestroyArray(MaxStPeak);
    mxDestroyArray(MaxStPeakIdx);
    mxDestroyArray(MinStPeak);
    mxDestroyArray(MinStPeakIdx);
    mxDestroyArray(StPeakN);
    mxDestroyArray(PolyTail);
    mxDestroyArray(TailIdx);
    mxDestroyArray(FitLog);
    mxDestroyArray(PolyFitLog);
    mxDestroyArray(MaxSP);
    mxDestroyArray(MaxSPInd);
    mxDestroyArray(MinSP);
    mxDestroyArray(MinSPInd);
    mxDestroyArray(RangeSP);
    mxDestroyArray(MaxIndSP);
    mxDestroyArray(M);
    mxDestroyArray(StandardPulses);
    mxDestroyArray(StandardPulsesNorm);
    mxDestroyArray(Pulse);
    mxDestroyArray(MinPulse);
    mxDestroyArray(PulseR);
    mxDestroyArray(PulseD);
    mxDestroyArray(PulseDOverThr);
    mxDestroyArray(PulseOverThr);
    mxDestroyArray(PulseNorm);
    mxDestroyArray(MinPulseNorm);
    mxDestroyArray(PulseN);
    mxDestroyArray(PulseFit);
    mxDestroyArray(PulseMax);
    mxDestroyArray(PulseMaxIdx);
    mxDestroyArray(StartFitPoint);
    mxDestroyArray(EndFitPoint);
    mxDestroyArray(StartBFitPoint);
    mxDestroyArray(PulseInterp);
    mxDestroyArray(PulseInterp10);
    mxDestroyArray(PulseIMax);
    mxDestroyArray(PulseIMaxIdx);
    mxDestroyArray(PulseI10Max);
    mxDestroyArray(PulseI10MaxIdx);
    mxDestroyArray(FitN);
    mxDestroyArray(PulseInterpShifted);
    mxDestroyArray(FitPulse);
    mxDestroyArray(FitPulseShort);
    mxDestroyArray(Sums2);
    mxDestroyArray(Sums3);
    mxDestroyArray(Sums2Short);
    mxDestroyArray(Sums3Short);
    mxDestroyArray(PulseInterp10Shifted);
    mxDestroyArray(PulseInterpShiftedTest);
    mxDestroyArray(Khi2Fin);
    mxDestroyArray(A);
    mxDestroyArray(B);
    mxDestroyArray(Sum1);
    mxDestroyArray(Sum2);
    mxDestroyArray(Sum3);
    mxDestroyArray(Khi2Fit);
    mxDestroyArray(PolyKhi2);
    mxDestroyArray(FitPoints);
    mxDestroyArray(FitPulseFin);
    mxDestroyArray(ShortFit);
    mxDestroyArray(FitNi);
    mxDestroyArray(k);
    mxDestroyArray(MinKhi2);
    mxDestroyArray(MinKhi2Idx);
    mxDestroyArray(MinKhi2Idx10);
    mxDestroyArray(PulseFitM);
    mxDestroyArray(PulseFitMax);
    mxDestroyArray(PulseFitMaxIdx);
    mxDestroyArray(FitIdx);
    mxDestroyArray(Period);
    mxDestroyArray(MaxAmpl);
    mxDestroyArray(MinAmpl);
    mxDestroyArray(PeakAmplRange);
    mxDestroyArray(HistIntervalA);
    mxDestroyArray(HistN);
    mxDestroyArray(HistBool);
    mxDestroyArray(MaxT);
    mxDestroyArray(MinT);
    mxDestroyArray(PeakTRange);
    mxDestroyArray(HistIntervalT);
    mxDestroyArray(HistT);
    mxDestroyArray(ZeroBool);
    mxDestroyArray(MaxC);
    mxDestroyArray(MinC);
    mxDestroyArray(PeakCRange);
    mxDestroyArray(HistIntervalC);
    mxDestroyArray(HistC);
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
    mxDestroyArray(PeakFile);
    mxDestroyArray(MaxSignal);
    mxDestroyArray(Dialog);
    mxDestroyArray(FileName);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return peaks;
    /*
     * 
     * 
     * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     * 
     */
}

/*
 * The function "Mpeaks2auto_MeanSearch" is the implementation version of the
 * "peaks2auto/MeanSearch" M-function from file
 * "e:\scn\efield\matlab\peaks2auto.m" (lines 696-747). It contains the actual
 * compiled code for that M-function. It is a static function and must only be
 * called from one of the interface functions, appearing below.
 */
/*
 * function [MeanVal,StdVal,PP,Noise]=MeanSearch(tr,OverSt,Noise,Plot1,Plot2,trD);    
 */
static mxArray * Mpeaks2auto_MeanSearch(mxArray * * StdVal,
                                        mxArray * * PP,
                                        mxArray * * Noise,
                                        int nargout_,
                                        mxArray * tr,
                                        mxArray * OverSt,
                                        mxArray * Noise_in,
                                        mxArray * Plot1,
                                        mxArray * Plot2,
                                        mxArray * trD) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_peaks2auto);
    int nargin_ = mclNargin(6, tr, OverSt, Noise_in, Plot1, Plot2, trD, NULL);
    mxArray * MeanVal = NULL;
    mxArray * SingleNoise = NULL;
    mxArray * NoiseR = NULL;
    mxArray * NoiseL = NULL;
    mxArray * NoiseLevel = NULL;
    mxArray * L = NULL;
    mxArray * NoisePoints = NULL;
    mxArray * PeakPolarity = NULL;
    mxArray * DeltaM = NULL;
    mxArray * MinVal = NULL;
    mxArray * MaxVal = NULL;
    mxArray * Negative = NULL;
    mxArray * Positive = NULL;
    mxArray * St = NULL;
    mxArray * M = NULL;
    mxArray * trSize = NULL;
    mclCopyArray(&tr);
    mclCopyArray(&OverSt);
    mclCopyInputArg(Noise, Noise_in);
    mclCopyArray(&Plot1);
    mclCopyArray(&Plot2);
    mclCopyArray(&trD);
    /*
     * % search the signal pedestal and make it zero
     * % Input parameters: tr or trD - input measurements, Over St (see above), Noise - assumed initial noise array  
     * % Output parameters: MeanValue, Standad deviation, Pulse polarity, Noise - residual noise array
     * if nargin<4     Plot1=false;    Plot2=false;    end;  
     */
    if (nargin_ < 4) {
        mlfAssign(&Plot1, mlfFalse(NULL));
        mlfAssign(&Plot2, mlfFalse(NULL));
    }
    /*
     * if nargin<5     Plot2=false;    end;  
     */
    if (nargin_ < 5) {
        mlfAssign(&Plot2, mlfFalse(NULL));
    }
    /*
     * trSize=size(tr(:,1)); %  (N,1) dimension
     */
    mlfAssign(
      &trSize,
      mlfSize(
        mclValueVarargout(),
        mclArrayRef2(mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray1_),
        NULL));
    /*
     * trSize=trSize(1);
     */
    mlfAssign(&trSize, mclIntArrayRef1(mclVv(trSize, "trSize"), 1));
    /*
     * 
     * % if nargin==6    MaxVal=max(trD);     MinVal=min(trD);     DeltaM=MaxVal-MinVal; 
     * %          else   MaxVal=max(tr(:,2)); MinVal=min(tr(:,2)); DeltaM=MaxVal-MinVal;  end; 
     * % if nargin==6    M =mean(trD);     St=std(trD);     
     * %          else   M =mean(tr(:,2)); St=std(tr(:,2));   end; 
     * 
     * if nargin==6    M =mean(trD);     St=std(trD);
     */
    if (nargin_ == 6) {
        mlfAssign(&M, mlfMean(mclVa(trD, "trD"), NULL));
        mlfAssign(&St, mlfStd(mclVa(trD, "trD"), NULL, NULL));
    /*
     * else   M =mean(tr(:,2)); St=std(tr(:,2));   end;
     */
    } else {
        mlfAssign(
          &M,
          mlfMean(
            mclArrayRef2(mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray3_),
            NULL));
        mlfAssign(
          &St,
          mlfStd(
            mclArrayRef2(mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray3_),
            NULL,
            NULL));
    }
    /*
     * 
     * if nargin==6    Positive=size(find(trD-(M+5*St)>0),1);  Negative=size(find(trD-(M-5*St)<0),1); 
     */
    if (nargin_ == 6) {
        mlfAssign(
          &Positive,
          mlfSize(
            mclValueVarargout(),
            mlfFind(
              NULL,
              NULL,
              mclGt(
                mclMinus(
                  mclVa(trD, "trD"),
                  mclPlus(
                    mclVv(M, "M"), mclMtimes(_mxarray14_, mclVv(St, "St")))),
                _mxarray0_)),
            _mxarray1_));
        mlfAssign(
          &Negative,
          mlfSize(
            mclValueVarargout(),
            mlfFind(
              NULL,
              NULL,
              mclLt(
                mclMinus(
                  mclVa(trD, "trD"),
                  mclMinus(
                    mclVv(M, "M"), mclMtimes(_mxarray14_, mclVv(St, "St")))),
                _mxarray0_)),
            _mxarray1_));
        /*
         * MaxVal=max(trD);     MinVal=min(trD);   DeltaM=MaxVal-MinVal; 
         */
        mlfAssign(&MaxVal, mlfMax(NULL, mclVa(trD, "trD"), NULL, NULL));
        mlfAssign(&MinVal, mlfMin(NULL, mclVa(trD, "trD"), NULL, NULL));
        mlfAssign(
          &DeltaM, mclMinus(mclVv(MaxVal, "MaxVal"), mclVv(MinVal, "MinVal")));
    /*
     * else   Positive=size(find(tr(:,2)-(M+5*St)>0),1);  
     */
    } else {
        mlfAssign(
          &Positive,
          mlfSize(
            mclValueVarargout(),
            mlfFind(
              NULL,
              NULL,
              mclGt(
                mclMinus(
                  mclArrayRef2(
                    mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray3_),
                  mclPlus(
                    mclVv(M, "M"), mclMtimes(_mxarray14_, mclVv(St, "St")))),
                _mxarray0_)),
            _mxarray1_));
        /*
         * Negative=size(find(tr(:,2)-(M-5*St)<0),1); 
         */
        mlfAssign(
          &Negative,
          mlfSize(
            mclValueVarargout(),
            mlfFind(
              NULL,
              NULL,
              mclLt(
                mclMinus(
                  mclArrayRef2(
                    mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray3_),
                  mclMinus(
                    mclVv(M, "M"), mclMtimes(_mxarray14_, mclVv(St, "St")))),
                _mxarray0_)),
            _mxarray1_));
        /*
         * MaxVal=max(tr(:,2)); MinVal=min(tr(:,2)); DeltaM=MaxVal-MinVal;  end;
         */
        mlfAssign(
          &MaxVal,
          mlfMax(
            NULL,
            mclArrayRef2(mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray3_),
            NULL,
            NULL));
        mlfAssign(
          &MinVal,
          mlfMin(
            NULL,
            mclArrayRef2(mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray3_),
            NULL,
            NULL));
        mlfAssign(
          &DeltaM, mclMinus(mclVv(MaxVal, "MaxVal"), mclVv(MinVal, "MinVal")));
    }
    /*
     * 
     * if Positive>Negative PeakPolarity=1; else PeakPolarity=-1;  end; 
     */
    if (mclGtBool(mclVv(Positive, "Positive"), mclVv(Negative, "Negative"))) {
        mlfAssign(&PeakPolarity, _mxarray1_);
    } else {
        mlfAssign(&PeakPolarity, _mxarray49_);
    }
    /*
     * 
     * NoisePoints=size(find(Noise),1); 
     */
    mlfAssign(
      &NoisePoints,
      mlfSize(
        mclValueVarargout(),
        mlfFind(NULL, NULL, mclVa(*Noise, "Noise")),
        _mxarray1_));
    /*
     * if Plot1 
     */
    if (mlfTobool(mclVa(Plot1, "Plot1"))) {
        /*
         * if nargin==6    M=M;
         */
        if (nargin_ == 6) {
            mlfAssign(&M, mclVv(M, "M"));
        /*
         * else        M=M;     end; 
         */
        } else {
            mlfAssign(&M, mclVv(M, "M"));
        }
    /*
     * end; 
     */
    }
    /*
     * while DeltaM>0.1
     */
    while (mclGtBool(mclVv(DeltaM, "DeltaM"), _mxarray2_)) {
        /*
         * if nargin==6  M =[M,mean(trD(Noise))];   St=[St,std(trD(Noise))]; 
         */
        if (nargin_ == 6) {
            mlfAssign(
              &M,
              mlfHorzcat(
                mclVv(M, "M"),
                mlfMean(
                  mclArrayRef1(mclVa(trD, "trD"), mclVa(*Noise, "Noise")),
                  NULL),
                NULL));
            mlfAssign(
              &St,
              mlfHorzcat(
                mclVv(St, "St"),
                mlfStd(
                  mclArrayRef1(mclVa(trD, "trD"), mclVa(*Noise, "Noise")),
                  NULL,
                  NULL),
                NULL));
        /*
         * else   M =[M,mean(tr(Noise,2))];  St=[St,std(tr(Noise,2))];  end;           
         */
        } else {
            mlfAssign(
              &M,
              mlfHorzcat(
                mclVv(M, "M"),
                mlfMean(
                  mclArrayRef2(
                    mclVa(tr, "tr"), mclVa(*Noise, "Noise"), _mxarray3_),
                  NULL),
                NULL));
            mlfAssign(
              &St,
              mlfHorzcat(
                mclVv(St, "St"),
                mlfStd(
                  mclArrayRef2(
                    mclVa(tr, "tr"), mclVa(*Noise, "Noise"), _mxarray3_),
                  NULL,
                  NULL),
                NULL));
        }
        /*
         * L=length(M);    
         */
        mlfAssign(&L, mlfScalar(mclLengthInt(mclVv(M, "M"))));
        /*
         * if L>2   DeltaM=abs(M(L)-M(L-1));  else     DeltaM=10;    end; 
         */
        if (mclGtBool(mclVv(L, "L"), _mxarray3_)) {
            mlfAssign(
              &DeltaM,
              mlfAbs(
                mclMinus(
                  mclArrayRef1(mclVv(M, "M"), mclVv(L, "L")),
                  mclArrayRef1(
                    mclVv(M, "M"), mclMinus(mclVv(L, "L"), _mxarray1_)))));
        } else {
            mlfAssign(&DeltaM, _mxarray16_);
        }
        /*
         * NoiseLevel=M(L)+PeakPolarity*OverSt*St(L);    
         */
        mlfAssign(
          &NoiseLevel,
          mclPlus(
            mclArrayRef1(mclVv(M, "M"), mclVv(L, "L")),
            mclMtimes(
              mclMtimes(
                mclVv(PeakPolarity, "PeakPolarity"), mclVa(OverSt, "OverSt")),
              mclArrayRef1(mclVv(St, "St"), mclVv(L, "L")))));
        /*
         * if nargin==6        
         */
        if (nargin_ == 6) {
            /*
             * if PeakPolarity==1 Noise=(trD<NoiseLevel); else Noise=(trD>NoiseLevel);  end;          %(abs(M(L)-tr(:,2))<OverSt*St(L));
             */
            if (mclEqBool(mclVv(PeakPolarity, "PeakPolarity"), _mxarray1_)) {
                mlfAssign(
                  Noise,
                  mclLt(mclVa(trD, "trD"), mclVv(NoiseLevel, "NoiseLevel")));
            } else {
                mlfAssign(
                  Noise,
                  mclGt(mclVa(trD, "trD"), mclVv(NoiseLevel, "NoiseLevel")));
            }
        /*
         * else
         */
        } else {
            /*
             * if PeakPolarity==1 Noise=(tr(:,2)<NoiseLevel); else; Noise=(tr(:,2)>NoiseLevel); end;  %(abs(M(L)-tr(:,2))<OverSt*St(L));
             */
            if (mclEqBool(mclVv(PeakPolarity, "PeakPolarity"), _mxarray1_)) {
                mlfAssign(
                  Noise,
                  mclLt(
                    mclArrayRef2(
                      mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray3_),
                    mclVv(NoiseLevel, "NoiseLevel")));
            } else {
                mlfAssign(
                  Noise,
                  mclGt(
                    mclArrayRef2(
                      mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray3_),
                    mclVv(NoiseLevel, "NoiseLevel")));
            }
        /*
         * end; 
         */
        }
        /*
         * NoisePoints=[NoisePoints,size(find(Noise),1)];
         */
        mlfAssign(
          &NoisePoints,
          mlfHorzcat(
            mclVv(NoisePoints, "NoisePoints"),
            mlfSize(
              mclValueVarargout(),
              mlfFind(NULL, NULL, mclVa(*Noise, "Noise")),
              _mxarray1_),
            NULL));
    /*
     * %if St(L)==0 DeltaM=0;end;
     * end; 
     */
    }
    /*
     * NoiseL=circshift(Noise,-1);   NoiseL(end)=Noise(end);     
     */
    mlfAssign(&NoiseL, mlfCircshift(mclVa(*Noise, "Noise"), _mxarray49_));
    mclArrayAssign1(
      &NoiseL,
      mclArrayRef1(
        mclVa(*Noise, "Noise"),
        mlfEnd(mclVa(*Noise, "Noise"), _mxarray1_, _mxarray1_)),
      mlfEnd(mclVv(NoiseL, "NoiseL"), _mxarray1_, _mxarray1_));
    /*
     * NoiseR=circshift(Noise,1);    NoiseR(1)=Noise(1);
     */
    mlfAssign(&NoiseR, mlfCircshift(mclVa(*Noise, "Noise"), _mxarray1_));
    mclIntArrayAssign1(&NoiseR, mclIntArrayRef1(mclVa(*Noise, "Noise"), 1), 1);
    /*
     * SingleNoise=not(Noise)&NoiseR&NoiseL;           %search alone peaks above the NoiseLevel
     */
    mlfAssign(
      &SingleNoise,
      mclAnd(
        mclAnd(mclNot(mclVa(*Noise, "Noise")), mclVv(NoiseR, "NoiseR")),
        mclVv(NoiseL, "NoiseL")));
    /*
     * Noise(SingleNoise)=true;                        %the alone peaks are brought to the Noise array
     */
    mclArrayAssign1(Noise, mlfTrue(NULL), mclVv(SingleNoise, "SingleNoise"));
    /*
     * 
     * MeanVal=M(L); StdVal=St(L); PP=PeakPolarity;
     */
    mlfAssign(&MeanVal, mclArrayRef1(mclVv(M, "M"), mclVv(L, "L")));
    mlfAssign(StdVal, mclArrayRef1(mclVv(St, "St"), mclVv(L, "L")));
    mlfAssign(PP, mclVv(PeakPolarity, "PeakPolarity"));
    mclValidateOutput(MeanVal, 1, nargout_, "MeanVal", "peaks2auto/MeanSearch");
    mclValidateOutput(*StdVal, 2, nargout_, "StdVal", "peaks2auto/MeanSearch");
    mclValidateOutput(*PP, 3, nargout_, "PP", "peaks2auto/MeanSearch");
    mclValidateOutput(*Noise, 4, nargout_, "Noise", "peaks2auto/MeanSearch");
    mxDestroyArray(trSize);
    mxDestroyArray(M);
    mxDestroyArray(St);
    mxDestroyArray(Positive);
    mxDestroyArray(Negative);
    mxDestroyArray(MaxVal);
    mxDestroyArray(MinVal);
    mxDestroyArray(DeltaM);
    mxDestroyArray(PeakPolarity);
    mxDestroyArray(NoisePoints);
    mxDestroyArray(L);
    mxDestroyArray(NoiseLevel);
    mxDestroyArray(NoiseL);
    mxDestroyArray(NoiseR);
    mxDestroyArray(SingleNoise);
    mxDestroyArray(trD);
    mxDestroyArray(Plot2);
    mxDestroyArray(Plot1);
    mxDestroyArray(OverSt);
    mxDestroyArray(tr);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return MeanVal;
    /*
     * %M(1)=[];  St(1)=[]; L=L-1; 
     */
}
