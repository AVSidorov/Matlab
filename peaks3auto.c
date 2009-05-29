/*
 * MATLAB Compiler: 3.0
 * Date: Mon Jun 26 03:29:51 2006
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-m" "-W" "main" "-L"
 * "C" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "Peaks3auto.m" 
 */
#include "peaks3auto.h"
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

static mxChar _array24_[58] = { 'L', 'o', 'a', 'd', 'i', 'n', 'g', ' ', 't',
                                'i', 'm', 'e', ' ', '=', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', '%', '7', '.', '4', 'f', ' ', ' ', 's',
                                'e', 'c', 0x005c, 'n' };
static mxArray * _mxarray23_;

static mxChar _array26_[56] = { 'F', 'i', 'r', 's', 't', ' ', 'm', 'e', 'a',
                                'n', ' ', 's', 'e', 'a', 'r', 'c', 'h', ' ',
                                ' ', '=', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%',
                                '7', '.', '4', 'f', ' ', ' ', 's', 'e', 'c',
                                0x005c, 'n' };
static mxArray * _mxarray25_;

static mxChar _array28_[27] = { ' ', ' ', 'S', 't', 'a', 'n', 'd',
                                'a', 'r', 'd', ' ', 'd', 'e', 'v',
                                'i', 'a', 't', ' ', '=', ' ', '%',
                                '6', '.', '4', 'f', 0x005c, 'n' };
static mxArray * _mxarray27_;

static mxChar _array30_[35] = { 'R', 'e', 'm', 'o', 'v', 'i', 'n', 'g', ' ',
                                'f', 'a', 's', 't', ' ', 'z', 'e', 'r', 'o',
                                ' ', 'o', 's', 'c', 'i', 'l', 'l', 'a', 't',
                                'i', 'o', 'n', '.', '.', '.', 0x005c, 'n' };
static mxArray * _mxarray29_;

static mxChar _array32_[6] = { 'l', 'i', 'n', 'e', 'a', 'r' };
static mxArray * _mxarray31_;

static mxChar _array34_[56] = { ' ', ' ', 'F', 'i', 'n', 'a', 'l', ' ', 'm',
                                'e', 'a', 'n', ' ', 's', 'e', 'a', 'r', 'c',
                                'h', ' ', ' ', '=', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%',
                                '7', '.', '4', 'f', ' ', ' ', 's', 'e', 'c',
                                0x005c, 'n' };
static mxArray * _mxarray33_;
static mxArray * _mxarray35_;

static mxChar _array37_[74] = { 'M', 'e', 'a', 'n', ' ', 's', 'e', 'a', 'r',
                                'c', 'h', ' ', ' ', '=', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%',
                                '7', '.', '4', 'f', ' ', ' ', 's', 'e', 'c',
                                0x005c, 'n' };
static mxArray * _mxarray36_;

static mxChar _array39_[36] = { ' ', ' ', 'S', 'm', 'o', 'o', 't', 'h',
                                'e', 'd', ' ', 'm', 'e', 'a', 'n', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', '=', ' ', '%', '6', '.',
                                '4', 'f', 0x005c, 'n' };
static mxArray * _mxarray38_;

static mxChar _array41_[36] = { ' ', ' ', 'S', 'm', 'o', 'o', 't', 'h',
                                'e', 'd', ' ', 's', 't', 'a', 'n', 'd',
                                'a', 'r', 'd', ' ', 'd', 'e', 'v', 'i',
                                'a', 't', ' ', '=', ' ', '%', '6', '.',
                                '4', 'f', 0x005c, 'n' };
static mxArray * _mxarray40_;
static mxArray * _mxarray42_;
static mxArray * _mxarray43_;

static mxChar _array45_[39] = { ' ', ' ', ' ', '%', '3', '.', '0', 'f',
                                ' ', ' ', ' ', ' ', 's', 'h', 'o', 'r',
                                't', ' ', 's', 'i', 'g', 'n', 'a', 'l',
                                's', ' ', 'a', 'r', 'e', ' ', 'r', 'e',
                                'm', 'o', 'v', 'e', 'd', 0x005c, 'n' };
static mxArray * _mxarray44_;

static mxChar _array47_[38] = { ' ', ' ', ' ', '%', '3', '.', '0', 'f',
                                ' ', ' ', ' ', ' ', 's', 'l', 'o', 'w',
                                ' ', 's', 'i', 'g', 'n', 'a', 'l', 's',
                                ' ', 'a', 'r', 'e', ' ', 'r', 'e', 'm',
                                'o', 'v', 'e', 'd', 0x005c, 'n' };
static mxArray * _mxarray46_;

static mxChar _array49_[39] = { ' ', ' ', ' ', '%', '3', '.', '0', 'f',
                                ' ', ' ', ' ', ' ', 's', 'm', 'a', 'l',
                                'l', ' ', 's', 'i', 'g', 'n', 'a', 'l',
                                's', ' ', 'a', 'r', 'e', ' ', 'r', 'e',
                                'm', 'o', 'v', 'e', 'd', 0x005c, 'n' };
static mxArray * _mxarray48_;

static mxChar _array51_[82] = { 'S', 'i', 'g', 'n', 'a', 'l', ' ', 'i', 'n',
                                't', 'e', 'r', 'v', 'a', 'l', 's', ' ', 's',
                                'e', 'a', 'r', 'c', 'h', ' ', ' ', '=', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', '%', '7',
                                '.', '4', 'f', ' ', ' ', 's', 'e', 'c',
                                0x005c, 'n' };
static mxArray * _mxarray50_;

static mxChar _array53_[81] = { 'P', 'e', 'a', 'k', ' ', 's', 'e', 'a', 'r',
                                'c', 'h', ' ', ' ', '=', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', '%', '7', '.',
                                '4', 'f', ' ', ' ', 's', 'e', 'c', 0x005c,
                                'n' };
static mxArray * _mxarray52_;

static mxChar _array55_[51] = { 'N', 'u', 'm', 'b', 'e', 'r', ' ', 'o', 'f',
                                ' ', 'p', 'e', 'a', 'k', 's', ' ', 'b', 'e',
                                'f', 'o', 'r', 'e', ' ', 'D', 'o', 'u', 'b',
                                'l', 'e', ' ', 'f', 'r', 'o', 'n', 't', ' ',
                                's', 'e', 'a', 'r', 'c', 'h', '=', ' ', '%',
                                '3', '.', '0', 'f', 0x005c, 'n' };
static mxArray * _mxarray54_;

static mxChar _array57_[56] = { 'N', 'u', 'm', 'b', 'e', 'r', ' ', 'o', 'f',
                                ' ', 'G', 'o', 'o', 'd', ' ', 'p', 'e', 'a',
                                'k', 's', ' ', 'b', 'e', 'f', 'o', 'r', 'e',
                                ' ', 'D', 'o', 'u', 'b', 'l', 'e', ' ', 'f',
                                'r', 'o', 'n', 't', ' ', 's', 'e', 'a', 'r',
                                'c', 'h', '=', ' ', '%', '3', '.', '0', 'f',
                                0x005c, 'n' };
static mxArray * _mxarray56_;
static mxArray * _mxarray58_;

static mxChar _array60_[76] = { 'D', 'o', 'u', 'b', 'l', 'e', ' ', 'F', 'r',
                                'o', 'n', 't', ' ', 's', 'e', 'a', 'r', 'c',
                                'h', ' ', ' ', '=', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', '%', '7', '.', '4', 'f', ' ', ' ', 's',
                                'e', 'c', 0x005c, 'n' };
static mxArray * _mxarray59_;

static mxChar _array62_[44] = { 'N', 'u', 'm', 'b', 'e', 'r', ' ', 'o', 'f',
                                ' ', 'p', 'e', 'a', 'k', 's', ' ', 'w', 'i',
                                't', 'h', ' ', 'D', 'o', 'u', 'b', 'l', 'e',
                                ' ', 'f', 'r', 'o', 'n', 't', 's', ' ', '=',
                                ' ', '%', '3', '.', '0', 'f', 0x005c, 'n' };
static mxArray * _mxarray61_;
static mxArray * _mxarray63_;

static mxChar _array65_[72] = { 'S', 't', 'a', 'n', 'd', 'a', 'r', 'd', 'P',
                                'e', 'a', 'k', 's', ' ', ' ', 's', 'e', 'a',
                                'r', 'c', 'h', ' ', ' ', '=', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
                                ' ', ' ', ' ', ' ', ' ', ' ', '%', '7', '.',
                                '4', 'f', ' ', ' ', 's', 'e', 'c', 0x005c,
                                'n' };
static mxArray * _mxarray64_;

static mxChar _array67_[33] = { 'N', 'u', 'm', 'b', 'e', 'r', ' ', 'o', 'f',
                                ' ', 'S', 't', 'a', 'n', 'd', 'a', 'r', 'd',
                                'P', 'e', 'a', 'k', 's', ' ', '=', ' ', '%',
                                '3', '.', '0', 'f', 0x005c, 'n' };
static mxArray * _mxarray66_;

static mxChar _array69_[6] = { 's', 'p', 'l', 'i', 'n', 'e' };
static mxArray * _mxarray68_;
static mxArray * _mxarray70_;

static mxChar _array72_[38] = { 's', 'c', 'a', 'n', ' ', 't', 'h', 'e',
                                ' ', 't', 'r', 'e', 'k', ' ', 'w', 'i',
                                't', 'h', ' ', 'S', 't', 'a', 'n', 'd',
                                'a', 'r', 'd', ' ', 'p', 'u', 'l', 's',
                                'e', '.', '.', '.', 0x005c, 'n' };
static mxArray * _mxarray71_;
static mxArray * _mxarray73_;

static mxChar _array75_[23] = { '-', '-', '-', '-', '-', '-', '-', '-',
                                '-', '-', '-', '-', '-', '-', '-', '-',
                                '-', '-', '-', '-', '-', 0x005c, 'n' };
static mxArray * _mxarray74_;

static mxChar _array77_[25] = { 'P', 'e', 'a', 'k', ' ', 't', 'h', 'r', 'e',
                                's', 'h', 'o', 'l', 'd', ' ', '=', ' ', ' ',
                                '%', '3', '.', '3', 'f', 0x005c, 'n' };
static mxArray * _mxarray76_;

static mxChar _array79_[30] = { 'T', 'h', 'e', ' ', 'n', 'u', 'm', 'b',
                                'e', 'r', ' ', 'o', 'f', ' ', 'p', 'e',
                                'a', 'k', 's', ' ', '=', ' ', ' ', '%',
                                '5', '.', '0', 'f', 0x005c, 'n' };
static mxArray * _mxarray78_;

static mxChar _array81_[33] = { 'T', 'h', 'e', ' ', 'p', 'e', 'r', 'i', 'o',
                                'd', ' ', 'o', 'f', ' ', 'p', 'e', 'a', 'k',
                                's', ' ', '=', ' ', ' ', '%', '6', '.', '4',
                                'f', ' ', 'm', 's', 0x005c, 'n' };
static mxArray * _mxarray80_;
static mxArray * _mxarray82_;

static mxChar _array84_[59] = { 'R', 'e', 's', 'o', 'l', 'u', 't', 'i', 'o',
                                'n', ' ', 'i', 'n', ' ', 't', 'h', 'e', ' ',
                                'p', 'e', 'a', 'k', ' ', 'a', 'm', 'p', 'l',
                                'i', 't', 'u', 'd', 'e', ' ', 'h', 'i', 's',
                                't', 'o', 'g', 'r', 'a', 'm', '=', ' ', ' ',
                                '%', '3', '.', '3', 'f', ' ', 'c', 'o', 'u',
                                'n', 't', 's', 0x005c, 'n' };
static mxArray * _mxarray83_;

static mxChar _array86_[54] = { 'R', 'e', 's', 'o', 'l', 'u', 't', 'i',
                                'o', 'n', ' ', 'i', 'n', ' ', 't', 'h',
                                'e', ' ', 'p', 'e', 'a', 'k', ' ', 'i',
                                'n', 't', 'e', 'r', 'v', 'a', 'l', ' ',
                                'h', 'i', 's', 't', 'o', 'g', 'r', 'a',
                                'm', '=', ' ', ' ', '%', '3', '.', '3',
                                'f', ' ', 'u', 's', 0x005c, 'n' };
static mxArray * _mxarray85_;

static mxChar _array88_[55] = { 'E', 'x', 'p', 'e', 'c', 't', 'e', 'd',
                                ' ', 'n', 'u', 'm', 'b', 'e', 'r', ' ',
                                'o', 'f', ' ', 'd', 'o', 'u', 'b', 'l',
                                'e', ' ', 'p', 'e', 'a', 'k', 's', ' ',
                                'f', 'o', 'r', ' ', '0', '.', '0', '2',
                                '5', ' ', 'u', 's', ' ', '=', ' ', '%',
                                '3', '.', '3', 'f', ' ', 0x005c, 'n' };
static mxArray * _mxarray87_;

static mxChar _array90_[23] = { '=', '=', '=', '=', '=', '=', '=', '=',
                                '=', '=', '=', '=', '=', '=', '=', '=',
                                '=', '=', '=', '=', '=', 0x005c, 'n' };
static mxArray * _mxarray89_;

static mxChar _array92_[4] = { 'h', 'i', 's', 'A' };
static mxArray * _mxarray91_;

static mxChar _array94_[9] = { 'H', 'i', 's', 't', 'A', '.', 'd', 'a', 't' };
static mxArray * _mxarray93_;

static mxChar _array96_[4] = { 'h', 'i', 's', 'C' };
static mxArray * _mxarray95_;

static mxChar _array98_[9] = { 'H', 'i', 's', 't', 'C', '.', 'd', 'a', 't' };
static mxArray * _mxarray97_;

static mxChar _array100_[1] = { 'w' };
static mxArray * _mxarray99_;

static mxChar _array102_[19] = { '%', '6', '.', '2', 'f', ' ', '%',
                                 '3', '.', '0', 'f', ' ', '%', '5',
                                 '.', '2', 'f', 0x005c, 'n' };
static mxArray * _mxarray101_;

static mxChar _array104_[4] = { 'p', 'e', 'a', 'k' };
static mxArray * _mxarray103_;

static mxChar _array106_[9] = { 'p', 'e', 'a', 'k', 's', '.', 'd', 'a', 't' };
static mxArray * _mxarray105_;

static mxChar _array108_[71] = { 's', 't', 'a', 'r', 't', ' ', ' ', ' ', ' ',
                                 ' ', ' ', ' ', 'p', 'e', 'a', 'k', ' ', ' ',
                                 ' ', ' ', ' ', ' ', 'i', 'n', 't', 'e', 'r',
                                 'v', ' ', ' ', ' ', ' ', ' ', ' ', 'z', 'e',
                                 'r', 'o', ' ', ' ', 'a', 'm', 'p', 'l', ' ',
                                 ' ', ' ', ' ', 'c', 'h', 'a', 'r', 'g', 'e',
                                 ' ', 'd', 'u', 'r', 'a', 't', 'i', 'o', 'n',
                                 ' ', 'C', 'o', 'm', 'b', 'N', 0x005c, 'n' };
static mxArray * _mxarray107_;

static mxChar _array110_[52] = { '%', '1', '0', '.', '3', 'f', ' ', '%', '1',
                                 '0', '.', '3', 'f', ' ', '%', '9', '.', '3',
                                 'f', ' ', '%', '7', '.', '2', 'f', ' ', '%',
                                 '7', '.', '2', 'f', ' ', '%', '7', '.', '2',
                                 'f', ' ', '%', '5', '.', '3', 'f', ' ', '%',
                                 '2', '.', '0', 'f', ' ', 0x005c, 'n' };
static mxArray * _mxarray109_;
static mxArray * _mxarray111_;

void InitializeModule_peaks3auto(void) {
    _mxarray0_ = mclInitializeDouble(1.0);
    _mxarray1_ = mclInitializeDouble(0.0);
    _mxarray2_ = mclInitializeDouble(.025);
    _mxarray3_ = mclInitializeDouble(30.0);
    _mxarray4_ = mclInitializeDouble(2.0);
    _mxarray5_ = mclInitializeDouble(.05);
    _mxarray6_ = mclInitializeDouble(.125);
    _mxarray7_ = mclInitializeDouble(.4);
    _mxarray8_ = mclInitializeDouble(.1);
    _mxarray9_ = mclInitializeDouble(.95);
    _mxarray10_ = mclInitializeDouble(8.0);
    _mxarray11_ = mclInitializeDouble(20.0);
    _mxarray12_ = mclInitializeDouble(.5);
    _mxarray13_ = mclInitializeDouble(1.6);
    _mxarray14_ = mclInitializeDouble(5.0);
    _mxarray15_ = mclInitializeDouble(4.0);
    _mxarray16_ = mclInitializeDouble(40.0);
    _mxarray17_ = mclInitializeDouble(4095.0);
    _ieee_plusinf_ = mclGetInf();
    _mxarray18_ = mclInitializeDouble(_ieee_plusinf_);
    _mxarray19_ = mclInitializeString(5, _array20_);
    _mxarray21_ = mclInitializeString(38, _array22_);
    _mxarray23_ = mclInitializeString(58, _array24_);
    _mxarray25_ = mclInitializeString(56, _array26_);
    _mxarray27_ = mclInitializeString(27, _array28_);
    _mxarray29_ = mclInitializeString(35, _array30_);
    _mxarray31_ = mclInitializeString(6, _array32_);
    _mxarray33_ = mclInitializeString(56, _array34_);
    _mxarray35_ = mclInitializeDouble(1.1);
    _mxarray36_ = mclInitializeString(74, _array37_);
    _mxarray38_ = mclInitializeString(36, _array39_);
    _mxarray40_ = mclInitializeString(36, _array41_);
    _mxarray42_ = mclInitializeDoubleVector(0, 0, (double *)NULL);
    _mxarray43_ = mclInitializeDouble(-1.0);
    _mxarray44_ = mclInitializeString(39, _array45_);
    _mxarray46_ = mclInitializeString(38, _array47_);
    _mxarray48_ = mclInitializeString(39, _array49_);
    _mxarray50_ = mclInitializeString(82, _array51_);
    _mxarray52_ = mclInitializeString(81, _array53_);
    _mxarray54_ = mclInitializeString(51, _array55_);
    _mxarray56_ = mclInitializeString(56, _array57_);
    _mxarray58_ = mclInitializeDouble(1.5);
    _mxarray59_ = mclInitializeString(76, _array60_);
    _mxarray61_ = mclInitializeString(44, _array62_);
    _mxarray63_ = mclInitializeDouble(3.0);
    _mxarray64_ = mclInitializeString(72, _array65_);
    _mxarray66_ = mclInitializeString(33, _array67_);
    _mxarray68_ = mclInitializeString(6, _array69_);
    _mxarray70_ = mclInitializeDouble(6.0);
    _mxarray71_ = mclInitializeString(38, _array72_);
    _mxarray73_ = mclInitializeDouble(7.0);
    _mxarray74_ = mclInitializeString(23, _array75_);
    _mxarray76_ = mclInitializeString(25, _array77_);
    _mxarray78_ = mclInitializeString(30, _array79_);
    _mxarray80_ = mclInitializeString(33, _array81_);
    _mxarray82_ = mclInitializeDouble(1000.0);
    _mxarray83_ = mclInitializeString(59, _array84_);
    _mxarray85_ = mclInitializeString(54, _array86_);
    _mxarray87_ = mclInitializeString(55, _array88_);
    _mxarray89_ = mclInitializeString(23, _array90_);
    _mxarray91_ = mclInitializeString(4, _array92_);
    _mxarray93_ = mclInitializeString(9, _array94_);
    _mxarray95_ = mclInitializeString(4, _array96_);
    _mxarray97_ = mclInitializeString(9, _array98_);
    _mxarray99_ = mclInitializeString(1, _array100_);
    _mxarray101_ = mclInitializeString(19, _array102_);
    _mxarray103_ = mclInitializeString(4, _array104_);
    _mxarray105_ = mclInitializeString(9, _array106_);
    _mxarray107_ = mclInitializeString(71, _array108_);
    _mxarray109_ = mclInitializeString(52, _array110_);
    _mxarray111_ = mclInitializeDouble(10.0);
}

void TerminateModule_peaks3auto(void) {
    mxDestroyArray(_mxarray111_);
    mxDestroyArray(_mxarray109_);
    mxDestroyArray(_mxarray107_);
    mxDestroyArray(_mxarray105_);
    mxDestroyArray(_mxarray103_);
    mxDestroyArray(_mxarray101_);
    mxDestroyArray(_mxarray99_);
    mxDestroyArray(_mxarray97_);
    mxDestroyArray(_mxarray95_);
    mxDestroyArray(_mxarray93_);
    mxDestroyArray(_mxarray91_);
    mxDestroyArray(_mxarray89_);
    mxDestroyArray(_mxarray87_);
    mxDestroyArray(_mxarray85_);
    mxDestroyArray(_mxarray83_);
    mxDestroyArray(_mxarray82_);
    mxDestroyArray(_mxarray80_);
    mxDestroyArray(_mxarray78_);
    mxDestroyArray(_mxarray76_);
    mxDestroyArray(_mxarray74_);
    mxDestroyArray(_mxarray73_);
    mxDestroyArray(_mxarray71_);
    mxDestroyArray(_mxarray70_);
    mxDestroyArray(_mxarray68_);
    mxDestroyArray(_mxarray66_);
    mxDestroyArray(_mxarray64_);
    mxDestroyArray(_mxarray63_);
    mxDestroyArray(_mxarray61_);
    mxDestroyArray(_mxarray59_);
    mxDestroyArray(_mxarray58_);
    mxDestroyArray(_mxarray56_);
    mxDestroyArray(_mxarray54_);
    mxDestroyArray(_mxarray52_);
    mxDestroyArray(_mxarray50_);
    mxDestroyArray(_mxarray48_);
    mxDestroyArray(_mxarray46_);
    mxDestroyArray(_mxarray44_);
    mxDestroyArray(_mxarray43_);
    mxDestroyArray(_mxarray42_);
    mxDestroyArray(_mxarray40_);
    mxDestroyArray(_mxarray38_);
    mxDestroyArray(_mxarray36_);
    mxDestroyArray(_mxarray35_);
    mxDestroyArray(_mxarray33_);
    mxDestroyArray(_mxarray31_);
    mxDestroyArray(_mxarray29_);
    mxDestroyArray(_mxarray27_);
    mxDestroyArray(_mxarray25_);
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

static mxArray * mlfPeaks3auto_MeanSearch(mxArray * * StdVal,
                                          mxArray * * PP,
                                          mxArray * * Noise,
                                          mxArray * tr,
                                          mxArray * OverSt,
                                          mxArray * Noise_in,
                                          mxArray * Plot1,
                                          mxArray * Plot2,
                                          mxArray * trD);
static void mlxPeaks3auto_MeanSearch(int nlhs,
                                     mxArray * plhs[],
                                     int nrhs,
                                     mxArray * prhs[]);
static mxArray * Mpeaks3auto(mxArray * * HistA,
                             int nargout_,
                             mxArray * FileName,
                             mxArray * Dialog,
                             mxArray * MaxSignal);
static mxArray * Mpeaks3auto_MeanSearch(mxArray * * StdVal,
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
  = { { "MeanSearch", mlxPeaks3auto_MeanSearch, 6, 4, NULL } };

_mexLocalFunctionTable _local_function_table_peaks3auto
  = { 1, local_function_table_ };

/*
 * The function "mlfPeaks3auto" contains the normal interface for the
 * "peaks3auto" M-function from file "e:\scn\efield\matlab\peaks3auto.m" (lines
 * 1-797). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfPeaks3auto(mxArray * * HistA,
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
    peaks = Mpeaks3auto(&HistA__, nargout, FileName, Dialog, MaxSignal);
    mlfRestorePreviousContext(1, 3, HistA, FileName, Dialog, MaxSignal);
    if (HistA != NULL) {
        mclCopyOutputArg(HistA, HistA__);
    } else {
        mxDestroyArray(HistA__);
    }
    return mlfReturnValue(peaks);
}

/*
 * The function "mlxPeaks3auto" contains the feval interface for the
 * "peaks3auto" M-function from file "e:\scn\efield\matlab\peaks3auto.m" (lines
 * 1-797). The feval function calls the implementation version of peaks3auto
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxPeaks3auto(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: peaks3auto Line: 1 Column:"
            " 1 The function \"peaks3auto\" was called with m"
            "ore than the declared number of outputs (2)."),
          NULL);
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: peaks3auto Line: 1 Column"
            ": 1 The function \"peaks3auto\" was called with"
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
    mplhs[0] = Mpeaks3auto(&mplhs[1], nlhs, mprhs[0], mprhs[1], mprhs[2]);
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
 * The function "mlfPeaks3auto_MeanSearch" contains the normal interface for
 * the "peaks3auto/MeanSearch" M-function from file
 * "e:\scn\efield\matlab\peaks3auto.m" (lines 797-845). This function processes
 * any input arguments and passes them to the implementation version of the
 * function, appearing above.
 */
static mxArray * mlfPeaks3auto_MeanSearch(mxArray * * StdVal,
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
      = Mpeaks3auto_MeanSearch(
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
 * The function "mlxPeaks3auto_MeanSearch" contains the feval interface for the
 * "peaks3auto/MeanSearch" M-function from file
 * "e:\scn\efield\matlab\peaks3auto.m" (lines 797-845). The feval function
 * calls the implementation version of peaks3auto/MeanSearch through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
static void mlxPeaks3auto_MeanSearch(int nlhs,
                                     mxArray * plhs[],
                                     int nrhs,
                                     mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[4];
    int i;
    if (nlhs > 4) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: peaks3auto/MeanSearch Line: 797 Co"
            "lumn: 1 The function \"peaks3auto/MeanSearch\" was calle"
            "d with more than the declared number of outputs (4)."),
          NULL);
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: peaks3auto/MeanSearch Line: 797 C"
            "olumn: 1 The function \"peaks3auto/MeanSearch\" was cal"
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
      = Mpeaks3auto_MeanSearch(
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
 * The function "Mpeaks3auto" is the implementation version of the "peaks3auto"
 * M-function from file "e:\scn\efield\matlab\peaks3auto.m" (lines 1-797). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [peaks,HistA]=Peaks3auto(FileName,Dialog,MaxSignal);
 */
static mxArray * Mpeaks3auto(mxArray * * HistA,
                             int nargout_,
                             mxArray * FileName,
                             mxArray * Dialog,
                             mxArray * MaxSignal) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_peaks3auto);
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
    mxArray * HH = NULL;
    mxArray * HistBool = NULL;
    mxArray * PassBoolSize = NULL;
    mxArray * PassBool = NULL;
    mxArray * p = NULL;
    mxArray * PassN = NULL;
    mxArray * HistN = NULL;
    mxArray * HistIntervalA = NULL;
    mxArray * PeakAmplRange = NULL;
    mxArray * MinAmpl = NULL;
    mxArray * MaxAmpl = NULL;
    mxArray * Period = NULL;
    mxArray * VisiblePeakN = NULL;
    mxArray * FitIdxOk = NULL;
    mxArray * SubtractedPulse = NULL;
    mxArray * FitIdx = NULL;
    mxArray * dt = NULL;
    mxArray * FineShift = NULL;
    mxArray * Ampl = NULL;
    mxArray * Khi2MinIdxFine = NULL;
    mxArray * KhiFitN = NULL;
    mxArray * NfromEdge = NULL;
    mxArray * CoarseShift = NULL;
    mxArray * MinKhi2Idx = NULL;
    mxArray * Sums2 = NULL;
    mxArray * Sums1 = NULL;
    mxArray * NetFitSignal = NULL;
    mxArray * FitNi = NULL;
    mxArray * FitSignalStart = NULL;
    mxArray * ShortFit = NULL;
    mxArray * BckgIndx = NULL;
    mxArray * MinKhi2 = NULL;
    mxArray * FitPulseFin = NULL;
    mxArray * FitSignal = NULL;
    mxArray * PolyKhi2 = NULL;
    mxArray * Khi2Fit = NULL;
    mxArray * Sum3 = NULL;
    mxArray * Sum2 = NULL;
    mxArray * Sum1 = NULL;
    mxArray * B = NULL;
    mxArray * A = NULL;
    mxArray * StartFitPoint = NULL;
    mxArray * KhiCoeffShort = NULL;
    mxArray * KhiCoeff = NULL;
    mxArray * Khi2Fin = NULL;
    mxArray * PulseInterpShiftedTest = NULL;
    mxArray * PulseInterpFineShifted = NULL;
    mxArray * Sums3Short = NULL;
    mxArray * Sums3 = NULL;
    mxArray * FitPulses = NULL;
    mxArray * PulseInterpShifted = NULL;
    mxArray * DiagLogic = NULL;
    mxArray * k = NULL;
    mxArray * InterpRange = NULL;
    mxArray * InterpHalfRange = NULL;
    mxArray * FitFineInterpPulseInterval = NULL;
    mxArray * MaxPulseInterpFineIndx = NULL;
    mxArray * LastNonZeroInterpFine = NULL;
    mxArray * FirstNonZeroInterpFine = NULL;
    mxArray * FitInterpPulseInterval = NULL;
    mxArray * Indx = NULL;
    mxArray * MaxPulseInterpIndx = NULL;
    mxArray * LastNonZeroInterp = NULL;
    mxArray * FirstNonZeroInterp = NULL;
    mxArray * SampleInterpFineN = NULL;
    mxArray * PulseInterpFine = NULL;
    mxArray * SampleInterpN = NULL;
    mxArray * PulseInterp = NULL;
    mxArray * FitN = NULL;
    mxArray * FitBackgndInterval = NULL;
    mxArray * FitPulseInterval = NULL;
    mxArray * StandardPulseNorm = NULL;
    mxArray * LastNonZero = NULL;
    mxArray * FirstNonZero = NULL;
    mxArray * MaxStandardPulseIndx = NULL;
    mxArray * MaxStandardPulse = NULL;
    mxArray * ToZero = NULL;
    mxArray * Zero = NULL;
    mxArray * x = NULL;
    mxArray * SignalsRightOk = NULL;
    mxArray * SignalCenterOk = NULL;
    mxArray * SignalsLeftOk = NULL;
    mxArray * DeltaMean = NULL;
    mxArray * RightMin = NULL;
    mxArray * MinStdRight = NULL;
    mxArray * LeftMin = NULL;
    mxArray * MinStdLeft = NULL;
    mxArray * SelectedN = NULL;
    mxArray * stdStandardPulse = NULL;
    mxArray * MeanStandardPulse = NULL;
    mxArray * SelectedStandrdPulse = NULL;
    mxArray * SignalsOk = NULL;
    mxArray * StandardPulse = NULL;
    mxArray * SampleN = NULL;
    mxArray * SampleTail = NULL;
    mxArray * SampleFront = NULL;
    mxArray * PeakEnd = NULL;
    mxArray * PeakStart = NULL;
    mxArray * AscendTop = NULL;
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
    mxArray * PeakOnFrontInd = NULL;
    mxArray * GoodPeakVal = NULL;
    mxArray * GoodPeakInd = NULL;
    mxArray * PeakVal = NULL;
    mxArray * PeakInd = NULL;
    mxArray * Range = NULL;
    mxArray * MoveToSignal = NULL;
    mxArray * SizeMoveToNoise = NULL;
    mxArray * MoveToNoise = NULL;
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
    mxArray * OutLimits = NULL;
    mxArray * MaxTime = NULL;
    mxArray * MinTime = NULL;
    mxArray * MaxAmp = NULL;
    mxArray * EndNoise = NULL;
    mxArray * StartNoise = NULL;
    mxArray * NoiseInterp = NULL;
    mxArray * NoiseAver = NULL;
    mxArray * DeltaStd = NULL;
    mxArray * Std0 = NULL;
    mxArray * trekStart = NULL;
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
    mxArray * FineInterpN = NULL;
    mxArray * InterpN = NULL;
    mxArray * BeyondMaxN = NULL;
    mxArray * BFitSignalN = NULL;
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
    mxArray * NoiseAverN = NULL;
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
     * Text=false;           % switch between text and binary input files
     */
    mlfAssign(&Text, mlfFalse(NULL));
    /*
     * Delta=1;          % if Delta=1 then trekD is used for peak detection, else the peaks are detected from the trek.  
     */
    mlfAssign(&Delta, _mxarray0_);
    /*
     * Fourie=0;         %if Fourie=1 then performes Fourie transformation of the signal. 
     */
    mlfAssign(&Fourie, _mxarray1_);
    /*
     * % there are bugs in Fourie still. scale etc... 
     * FrontCharge=1;    % if FrontCharge=1 then the cahrge is calculated till peak maximum else charge is calculated within ChargeTime
     */
    mlfAssign(&FrontCharge, _mxarray0_);
    /*
     * DeadAfter=1;      % if DeadAfter=1 then all pulses during DeadTime 
     */
    mlfAssign(&DeadAfter, _mxarray0_);
    /*
     * % after peaks exceeding MaxSignal are eliminated (to avoied excited noises) 
     * Plot1=1;          % if 1 then trek plot is active                  
     */
    mlfAssign(&Plot1, _mxarray0_);
    /*
     * Plot2=0;          % if 1 then interval plot is active
     */
    mlfAssign(&Plot2, _mxarray1_);
    /*
     * 
     * AverageGate=0.025; % Averaging gate, us  (there is a 1 point shift between PeakInd and trek at 0.05 )
     */
    mlfAssign(&AverageGate, _mxarray2_);
    /*
     * NoiseAverN=30;    % the number of points for noise (ONLY) averaging
     */
    mlfAssign(&NoiseAverN, _mxarray3_);
    /*
     * OverSt=2;         % noise regection threshold, in standard deviations    
     */
    mlfAssign(&OverSt, _mxarray4_);
    /*
     * PeakSt=2;         % peak threshold, in standard deviations   
     */
    mlfAssign(&PeakSt, _mxarray4_);
    /*
     * MinFront=0.05;    % minimal front edge of peaks, us
     */
    mlfAssign(&MinFront, _mxarray5_);
    /*
     * MaxFront=0.125;    % maximal front edge of peaks, us
     */
    mlfAssign(&MaxFront, _mxarray6_);
    /*
     * MinTail=0.05;     % minimal tail edge of peaks, us
     */
    mlfAssign(&MinTail, _mxarray5_);
    /*
     * MaxTail=0.4;      % maximal tail edge of peaks, us
     */
    mlfAssign(&MaxTail, _mxarray7_);
    /*
     * 
     * MinDuration=0.1;  % minimal peak duration, us. Shorter peaks are eliminated 
     */
    mlfAssign(&MinDuration, _mxarray8_);
    /*
     * MaxDuration=0.95; % maximal peak duration, us. Longer peaks are eliminated. 
     */
    mlfAssign(&MaxDuration, _mxarray9_);
    /*
     * 
     * Dshift=1;         %circshift(trek(:,2),Dshift); 
     */
    mlfAssign(&Dshift, _mxarray0_);
    /*
     * ZeroPoints=8;     % for avaraging peak zero level
     */
    mlfAssign(&ZeroPoints, _mxarray10_);
    /*
     * MinInterval=0.1;  % minimum peak-to-peak interval,  us
     */
    mlfAssign(&MinInterval, _mxarray8_);
    /*
     * MaxCombined=30;   % maximum combined peaks allowed for MinInterval
     */
    mlfAssign(&MaxCombined, _mxarray3_);
    /*
     * AveragN=20;       % Averaged number of peaks in histogram interval  
     */
    mlfAssign(&AveragN, _mxarray11_);
    /*
     * 
     * HistInterval=20;  % count interval for amplitude and cahrge histograms
     */
    mlfAssign(&HistInterval, _mxarray11_);
    /*
     * ChargeTime=0.5;   % us
     */
    mlfAssign(&ChargeTime, _mxarray12_);
    /*
     * DeadTime=1.6;     % us 
     */
    mlfAssign(&DeadTime, _mxarray13_);
    /*
     * tau=0.025;        % us digitizing time
     */
    mlfAssign(&tau, _mxarray2_);
    /*
     * lowf=5;           % MHz,  frequencies higher than lowf may be cut by digital filter
     */
    mlfAssign(&lowf, _mxarray14_);
    /*
     * 
     * BFitSignalN=4;    %number of points for background fitting
     */
    mlfAssign(&BFitSignalN, _mxarray15_);
    /*
     * BeyondMaxN=2;     %number of points beyond the maximum for signal fitting
     */
    mlfAssign(&BeyondMaxN, _mxarray4_);
    /*
     * InterpN=4;        %number of extra intervals for intrpolation of Standard Pulse in fitting
     */
    mlfAssign(&InterpN, _mxarray15_);
    /*
     * FineInterpN=40;   %number of extra intervals for fine intrpolation of Standard Pulse in fitting
     */
    mlfAssign(&FineInterpN, _mxarray16_);
    /*
     * Khi2Thr=5;       %Sigma^2 threshold in pulsefiting;      
     */
    mlfAssign(&Khi2Thr, _mxarray14_);
    /*
     * SecondPassFull=false; %Second Pass of rejection with new noise etc. 
     */
    mlfAssign(&SecondPassFull, mlfFalse(NULL));
    /*
     * %search or with old values StdVal etc.
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
     * 
     * if not(isstr(FileName)) trek=FileName; else
     */
    if (mlfTobool(mclNot(mlfIsstr(mclVa(FileName, "FileName"))))) {
        mlfAssign(&trek, mclVa(FileName, "FileName"));
    } else {
        /*
         * if Text  trek=load(FileName);  else  
         */
        if (mlfTobool(mclVv(Text, "Text"))) {
            mlfAssign(&trek, mlfLoadStruct(mclVa(FileName, "FileName"), NULL));
        } else {
            /*
             * fid = fopen(FileName); trek = fread(fid,inf,'int16'); fclose(fid); clear fid; 
             */
            mlfAssign(
              &fid,
              mlfFopen(NULL, NULL, mclVa(FileName, "FileName"), NULL, NULL));
            mlfAssign(
              &trek,
              mlfFread(
                NULL, mclVv(fid, "fid"), _mxarray18_, _mxarray19_, NULL));
            mclAssignAns(&ans, mlfFclose(mclVv(fid, "fid")));
            mlfClear(&fid, NULL);
        /*
         * end; end; 
         */
        }
    }
    /*
     * 
     * if size(trek,2)==1 trek(:,2)=trek; trek(:,1)=(0:tau:tau*(size(trek,1)-1))'; end; 
     */
    if (mclEqBool(
          mlfSize(mclValueVarargout(), mclVv(trek, "trek"), _mxarray4_),
          _mxarray0_)) {
        mclArrayAssign2(
          &trek, mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray4_);
        mclArrayAssign2(
          &trek,
          mlfCtranspose(
            mlfColon(
              _mxarray1_,
              mclVv(tau, "tau"),
              mclMtimes(
                mclVv(tau, "tau"),
                mclMinus(
                  mlfSize(mclValueVarargout(), mclVv(trek, "trek"), _mxarray0_),
                  _mxarray0_)))),
          mlfCreateColonIndex(),
          _mxarray0_);
    }
    /*
     * bool=(trek(:,2)>4095)|(trek(:,2)<0); OutRangeN=size(find(bool),1); 
     */
    mlfAssign(
      &bool0,
      mclOr(
        mclGt(
          mclArrayRef2(mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray4_),
          _mxarray17_),
        mclLt(
          mclArrayRef2(mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray4_),
          _mxarray1_)));
    mlfAssign(
      &OutRangeN,
      mlfSize(
        mclValueVarargout(),
        mlfFind(NULL, NULL, mclVv(bool0, "bool")),
        _mxarray0_));
    /*
     * if OutRangeN>0 fprintf('%7.0f  points out of the ADC range  \n',OutRangeN); end; 
     */
    if (mclGtBool(mclVv(OutRangeN, "OutRangeN"), _mxarray1_)) {
        mclAssignAns(
          &ans,
          mlfNFprintf(0, _mxarray21_, mclVv(OutRangeN, "OutRangeN"), NULL));
    }
    /*
     * trek(bool,:)=[];  clear bool; 
     */
    mlfIndexDelete(&trek, "(?,?)", mclVv(bool0, "bool"), mlfCreateColonIndex());
    mlfClear(&bool0, NULL);
    /*
     * trekSize=size(trek(:,1),1);
     */
    mlfAssign(
      &trekSize,
      mlfSize(
        mclValueVarargout(),
        mclArrayRef2(mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray0_),
        _mxarray0_));
    /*
     * fprintf('Loading time =                                %7.4f  sec\n', toc); tic; 
     */
    mclAssignAns(&ans, mlfNFprintf(0, _mxarray23_, mlfNToc(1), NULL));
    mlfTic();
    /*
     * 
     * NPeaks=0;  DeltaNPeaks=1;   Pass=0;
     */
    mlfAssign(&NPeaks, _mxarray1_);
    mlfAssign(&DeltaNPeaks, _mxarray0_);
    mlfAssign(&Pass, _mxarray1_);
    /*
     * 
     * while DeltaNPeaks>0.1*NPeaks
     */
    while (mclGtBool(
             mclVv(DeltaNPeaks, "DeltaNPeaks"),
             mclMtimes(_mxarray8_, mclVv(NPeaks, "NPeaks")))) {
        /*
         * 
         * Pass=Pass+1;  
         */
        mlfAssign(&Pass, mclPlus(mclVv(Pass, "Pass"), _mxarray0_));
        /*
         * if Pass>1 trek=trekMinus; end;  
         */
        if (mclGtBool(mclVv(Pass, "Pass"), _mxarray0_)) {
            mlfAssign(&trek, mclVv(trekMinus, "trekMinus"));
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
                     mclOr(a_, mclEq(mclVv(Pass, "Pass"), _mxarray0_)))) {
                mxDestroyArray(a_);
                /*
                 * 
                 * clear ThresholdD Threshold StdValD StdVal StartSignal EndSignal...
                 */
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
                /*
                 * SlowN SlowInd Slow SizeMoveToSignal SignalN;
                 * 
                 * % search the signal pedestal and standard deviation 
                 * NoiseArray=logical(ones(trekSize,1));  % first, all measurements are considered as noise
                 */
                mlfAssign(
                  &NoiseArray,
                  mlfTrue(mclVv(trekSize, "trekSize"), _mxarray0_, NULL));
                /*
                 * 
                 * [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0); 
                 */
                mlfAssign(
                  &MeanVal,
                  mlfPeaks3auto_MeanSearch(
                    &StdVal,
                    &PeakPolarity,
                    &NoiseArray,
                    mclVv(trek, "trek"),
                    mclVv(OverSt, "OverSt"),
                    mclVv(NoiseArray, "NoiseArray"),
                    _mxarray1_,
                    _mxarray1_,
                    NULL));
                /*
                 * if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;    
                 */
                if (mclEqBool(
                      mclVv(PeakPolarity, "PeakPolarity"), _mxarray0_)) {
                    mclArrayAssign2(
                      &trek,
                      mclMinus(
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mlfCreateColonIndex(),
                          _mxarray4_),
                        mclVv(MeanVal, "MeanVal")),
                      mlfCreateColonIndex(),
                      _mxarray4_);
                } else {
                    mclArrayAssign2(
                      &trek,
                      mclMinus(
                        mclVv(MeanVal, "MeanVal"),
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mlfCreateColonIndex(),
                          _mxarray4_)),
                      mlfCreateColonIndex(),
                      _mxarray4_);
                }
                /*
                 * trekStart=trek;
                 */
                mlfAssign(&trekStart, mclVv(trek, "trek"));
                /*
                 * 
                 * fprintf('First mean search  =                        %7.4f  sec\n', toc); tic;
                 */
                mclAssignAns(
                  &ans, mlfNFprintf(0, _mxarray25_, mlfNToc(1), NULL));
                mlfTic();
                /*
                 * fprintf('  Standard deviat = %6.4f\n', StdVal);
                 */
                mclAssignAns(
                  &ans,
                  mlfNFprintf(0, _mxarray27_, mclVv(StdVal, "StdVal"), NULL));
                /*
                 * 
                 * %remove fast oscillations of zero level:
                 * fprintf('Removing fast zero oscillation...\n');
                 */
                mclAssignAns(&ans, mlfNFprintf(0, _mxarray29_, NULL));
                /*
                 * Std0=StdVal; DeltaStd=1; 
                 */
                mlfAssign(&Std0, mclVv(StdVal, "StdVal"));
                mlfAssign(&DeltaStd, _mxarray0_);
                /*
                 * while DeltaStd>0.1
                 */
                while (mclGtBool(mclVv(DeltaStd, "DeltaStd"), _mxarray8_)) {
                    /*
                     * NoiseAver=filter(ones(1,NoiseAverN)/NoiseAverN,1,trek(NoiseArray,2));
                     */
                    mlfAssign(
                      &NoiseAver,
                      mlfFilter(
                        NULL,
                        mclMrdivide(
                          mlfOnes(
                            _mxarray0_, mclVv(NoiseAverN, "NoiseAverN"), NULL),
                          mclVv(NoiseAverN, "NoiseAverN")),
                        _mxarray0_,
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mclVv(NoiseArray, "NoiseArray"),
                          _mxarray4_),
                        NULL,
                        NULL));
                    /*
                     * NoiseInterp=interp1(trek(NoiseArray,1),NoiseAver,trek(:,1),'linear');
                     */
                    mlfAssign(
                      &NoiseInterp,
                      mlfInterp1(
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mclVv(NoiseArray, "NoiseArray"),
                          _mxarray0_),
                        mclVv(NoiseAver, "NoiseAver"),
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mlfCreateColonIndex(),
                          _mxarray0_),
                        _mxarray31_,
                        NULL));
                    /*
                     * StartNoise=min(find(NoiseArray==1));   EndNoise=max(find(NoiseArray==1));
                     */
                    mlfAssign(
                      &StartNoise,
                      mlfMin(
                        NULL,
                        mlfFind(
                          NULL,
                          NULL,
                          mclEq(mclVv(NoiseArray, "NoiseArray"), _mxarray0_)),
                        NULL,
                        NULL));
                    mlfAssign(
                      &EndNoise,
                      mlfMax(
                        NULL,
                        mlfFind(
                          NULL,
                          NULL,
                          mclEq(mclVv(NoiseArray, "NoiseArray"), _mxarray0_)),
                        NULL,
                        NULL));
                    /*
                     * NoiseInterp(1:StartNoise)=NoiseInterp(StartNoise);
                     */
                    mclArrayAssign1(
                      &NoiseInterp,
                      mclArrayRef1(
                        mclVv(NoiseInterp, "NoiseInterp"),
                        mclVv(StartNoise, "StartNoise")),
                      mlfColon(
                        _mxarray0_, mclVv(StartNoise, "StartNoise"), NULL));
                    /*
                     * NoiseInterp(EndNoise+1:trekSize)=NoiseInterp(EndNoise);
                     */
                    mclArrayAssign1(
                      &NoiseInterp,
                      mclArrayRef1(
                        mclVv(NoiseInterp, "NoiseInterp"),
                        mclVv(EndNoise, "EndNoise")),
                      mlfColon(
                        mclPlus(mclVv(EndNoise, "EndNoise"), _mxarray0_),
                        mclVv(trekSize, "trekSize"),
                        NULL));
                    /*
                     * trek(:,2)=trek(:,2)-NoiseInterp;
                     */
                    mclArrayAssign2(
                      &trek,
                      mclMinus(
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mlfCreateColonIndex(),
                          _mxarray4_),
                        mclVv(NoiseInterp, "NoiseInterp")),
                      mlfCreateColonIndex(),
                      _mxarray4_);
                    /*
                     * NoiseArray=logical(ones(trekSize,1));
                     */
                    mlfAssign(
                      &NoiseArray,
                      mlfTrue(mclVv(trekSize, "trekSize"), _mxarray0_, NULL));
                    /*
                     * [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0);
                     */
                    mlfAssign(
                      &MeanVal,
                      mlfPeaks3auto_MeanSearch(
                        &StdVal,
                        &PeakPolarity,
                        &NoiseArray,
                        mclVv(trek, "trek"),
                        mclVv(OverSt, "OverSt"),
                        mclVv(NoiseArray, "NoiseArray"),
                        _mxarray1_,
                        _mxarray1_,
                        NULL));
                    /*
                     * trek(:,2)=trek(:,2)-MeanVal;
                     */
                    mclArrayAssign2(
                      &trek,
                      mclMinus(
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mlfCreateColonIndex(),
                          _mxarray4_),
                        mclVv(MeanVal, "MeanVal")),
                      mlfCreateColonIndex(),
                      _mxarray4_);
                    /*
                     * DeltaStd=(Std0-StdVal)/StdVal;   Std0=StdVal; 
                     */
                    mlfAssign(
                      &DeltaStd,
                      mclMrdivide(
                        mclMinus(mclVv(Std0, "Std0"), mclVv(StdVal, "StdVal")),
                        mclVv(StdVal, "StdVal")));
                    mlfAssign(&Std0, mclVv(StdVal, "StdVal"));
                /*
                 * end;
                 */
                }
                /*
                 * 
                 * fprintf('  Final mean search  =                      %7.4f  sec\n', toc); tic;
                 */
                mclAssignAns(
                  &ans, mlfNFprintf(0, _mxarray33_, mlfNToc(1), NULL));
                mlfTic();
                /*
                 * fprintf('  Standard deviat = %6.4f\n', StdVal);
                 */
                mclAssignAns(
                  &ans,
                  mlfNFprintf(0, _mxarray27_, mclVv(StdVal, "StdVal"), NULL));
                /*
                 * 
                 * 
                 * clear trekStart; 
                 */
                mlfClear(&trekStart, NULL);
                /*
                 * 
                 * %   trek(:,2)=trek(:,2)-(PolyZero(1)*trek(:,1).^2+PolyZero(2)*trek(:,1)+PolyZero(3));
                 * %   [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0); 
                 * %fprintf(' PeakPolarity = %2.0f\n', PeakPolarity);
                 * %   if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;    
                 * %   if Dialog delete(TrekPlot0); TrekPlot0=plot(trek(:,1),trek(:,2),'-b'); end; 
                 * %  fprintf('Mean search  =                                            %7.4f  sec\n', toc); tic;
                 * %  fprintf('  fitting mean   = %6.4f\n', MeanVal);
                 * %  fprintf('  fitting standard deviat = %6.4f\n', StdVal);
                 * 
                 * % clear PolyZero;
                 * 
                 * if Dialog&(Pass==1) 
                 */
                {
                    mxArray * a_0 = mclInitialize(mclVa(Dialog, "Dialog"));
                    if (mlfTobool(a_0)
                        && mlfTobool(
                             mclAnd(
                               a_0, mclEq(mclVv(Pass, "Pass"), _mxarray0_)))) {
                        mxDestroyArray(a_0);
                        /*
                         * MaxSignal = 1.1*max(trek(:,2));
                         */
                        mlfAssign(
                          &MaxSignal,
                          mclMtimes(
                            _mxarray35_,
                            mlfMax(
                              NULL,
                              mclArrayRef2(
                                mclVv(trek, "trek"),
                                mlfCreateColonIndex(),
                                _mxarray4_),
                              NULL,
                              NULL)));
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
                            mlfEnd(mclVv(trek, "trek"), _mxarray0_, _mxarray4_),
                            _mxarray0_));
                        /*
                         * %%  Move OutLimits before PolyZero  ???? 
                         * OutLimits=(trek(:,1)>MaxTime)|(trek(:,1)<MinTime);   %|(trek(:,2)>MaxSignal);
                         */
                        mlfAssign(
                          &OutLimits,
                          mclOr(
                            mclGt(
                              mclArrayRef2(
                                mclVv(trek, "trek"),
                                mlfCreateColonIndex(),
                                _mxarray0_),
                              mclVv(MaxTime, "MaxTime")),
                            mclLt(
                              mclArrayRef2(
                                mclVv(trek, "trek"),
                                mlfCreateColonIndex(),
                                _mxarray0_),
                              mclVv(MinTime, "MinTime"))));
                        /*
                         * trek(OutLimits,:)=[];  NoiseArray(OutLimits,:)=[];
                         */
                        mlfIndexDelete(
                          &trek,
                          "(?,?)",
                          mclVv(OutLimits, "OutLimits"),
                          mlfCreateColonIndex());
                        mlfIndexDelete(
                          &NoiseArray,
                          "(?,?)",
                          mclVv(OutLimits, "OutLimits"),
                          mlfCreateColonIndex());
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
                              _mxarray0_),
                            _mxarray0_));
                        /*
                         * clear OutLimits;   
                         */
                        mlfClear(&OutLimits, NULL);
                        /*
                         * MaxSpectr=1; MaxSpectr0=0.5;  
                         */
                        mlfAssign(&MaxSpectr, _mxarray0_);
                        mlfAssign(&MaxSpectr0, _mxarray12_);
                    /*
                     * else 
                     */
                    } else {
                        mxDestroyArray(a_0);
                        /*
                         * MaxAmp=MaxSignal;  MinTime=trek(1,1);  MaxTime=trek(end,1);
                         */
                        mlfAssign(&MaxAmp, mclVa(MaxSignal, "MaxSignal"));
                        mlfAssign(
                          &MinTime, mclIntArrayRef2(mclVv(trek, "trek"), 1, 1));
                        mlfAssign(
                          &MaxTime,
                          mclArrayRef2(
                            mclVv(trek, "trek"),
                            mlfEnd(mclVv(trek, "trek"), _mxarray0_, _mxarray4_),
                            _mxarray0_));
                        /*
                         * MaxSpectr=1; MaxSpectr0=0.5;    
                         */
                        mlfAssign(&MaxSpectr, _mxarray0_);
                        mlfAssign(&MaxSpectr0, _mxarray12_);
                    }
                /*
                 * end; 
                 */
                }
                /*
                 * 
                 * % OutLimits=(trek(:,1)>MaxTime)|(trek(:,1)<MinTime);   %|(trek(:,2)>MaxSignal);
                 * % trek(OutLimits,:)=[]; NoiseArray(OutLimits,:)=[];
                 * % trekSize=size(trek(:,1),1); 
                 * 
                 * 
                 * tic;    
                 */
                mlfTic();
                /*
                 * if (Pass==1)&(AverageGate>=0.05)
                 */
                {
                    mxArray * a_1
                      = mclInitialize(mclEq(mclVv(Pass, "Pass"), _mxarray0_));
                    if (mlfTobool(a_1)
                        && mlfTobool(
                             mclAnd(
                               a_1,
                               mclGe(
                                 mclVv(AverageGate, "AverageGate"),
                                 _mxarray5_)))) {
                        mxDestroyArray(a_1);
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
                                _mxarray0_,
                                mclVv(SmoothGate, "SmoothGate"),
                                NULL),
                              mclVv(SmoothGate, "SmoothGate")),
                            _mxarray0_,
                            mclArrayRef2(
                              mclVv(trek, "trek"),
                              mlfCreateColonIndex(),
                              _mxarray4_),
                            NULL,
                            NULL));
                        /*
                         * trek(:,2)=SmoothedNoise; 
                         */
                        mclArrayAssign2(
                          &trek,
                          mclVv(SmoothedNoise, "SmoothedNoise"),
                          mlfCreateColonIndex(),
                          _mxarray4_);
                        /*
                         * [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0); 
                         */
                        mlfAssign(
                          &MeanVal,
                          mlfPeaks3auto_MeanSearch(
                            &StdVal,
                            &PeakPolarity,
                            &NoiseArray,
                            mclVv(trek, "trek"),
                            mclVv(OverSt, "OverSt"),
                            mclVv(NoiseArray, "NoiseArray"),
                            _mxarray1_,
                            _mxarray1_,
                            NULL));
                        /*
                         * %fprintf(' PeakPolarity = %2.0f\n', PeakPolarity);
                         * if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;    
                         */
                        if (mclEqBool(
                              mclVv(PeakPolarity, "PeakPolarity"),
                              _mxarray0_)) {
                            mclArrayAssign2(
                              &trek,
                              mclMinus(
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfCreateColonIndex(),
                                  _mxarray4_),
                                mclVv(MeanVal, "MeanVal")),
                              mlfCreateColonIndex(),
                              _mxarray4_);
                        } else {
                            mclArrayAssign2(
                              &trek,
                              mclMinus(
                                mclVv(MeanVal, "MeanVal"),
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfCreateColonIndex(),
                                  _mxarray4_)),
                              mlfCreateColonIndex(),
                              _mxarray4_);
                        }
                        /*
                         * fprintf('Mean search  =                                                %7.4f  sec\n', toc);
                         */
                        mclAssignAns(
                          &ans, mlfNFprintf(0, _mxarray36_, mlfNToc(1), NULL));
                        /*
                         * fprintf('  Smoothed mean            = %6.4f\n', MeanVal);
                         */
                        mclAssignAns(
                          &ans,
                          mlfNFprintf(
                            0, _mxarray38_, mclVv(MeanVal, "MeanVal"), NULL));
                        /*
                         * fprintf('  Smoothed standard deviat = %6.4f\n', StdVal);   
                         */
                        mclAssignAns(
                          &ans,
                          mlfNFprintf(
                            0, _mxarray40_, mclVv(StdVal, "StdVal"), NULL));
                        /*
                         * clear SmoothGate SmoothedNoise;
                         */
                        mlfClear(&SmoothGate, &SmoothedNoise, NULL);
                    } else {
                        mxDestroyArray(a_1);
                    }
                /*
                 * end;
                 */
                }
                /*
                 * 
                 * %if MaxSpectr<MaxSpectr0     delete(TrekPlot0);      delete(ImagTrekPlot);    end; 
                 * 
                 * %delete(TrekPlot0);delete(FR1);delete(FR2);delete(FR3);
                 * %TrekPlot0=plot(trek(:,1),trek(:,2),'-b');   
                 * %fprintf('Pause. look at the figure and press any key\n');
                 * %pause;
                 * tic;
                 */
                mlfTic();
                /*
                 * % search the standard deviation of trekD noises 
                 * 
                 * trekR=circshift(trek(:,2),Dshift);   for i=1:Dshift   trekR(i)=trek(i,2);   end; 
                 */
                mlfAssign(
                  &trekR,
                  mlfCircshift(
                    mclArrayRef2(
                      mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray4_),
                    mclVv(Dshift, "Dshift")));
                {
                    int v_ = mclForIntStart(1);
                    int e_ = mclForIntEnd(mclVv(Dshift, "Dshift"));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray42_);
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
                      mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray4_),
                    mclUminus(mclVv(Dshift, "Dshift"))));
                {
                    int v_ = mclForIntStart(1);
                    int e_ = mclForIntEnd(mclVv(Dshift, "Dshift"));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray42_);
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
                                      _mxarray0_,
                                      _mxarray4_),
                                    _mxarray0_),
                                  mlfScalar(v_)),
                                _mxarray4_),
                              mclMinus(
                                mclPlus(
                                  mlfEnd(
                                    mclVv(trekL, "trekL"),
                                    _mxarray0_,
                                    _mxarray0_),
                                  _mxarray0_),
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
                      mclVv(trek, "trek"), mlfCreateColonIndex(), _mxarray4_),
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
                  &NoiseR, mlfCircshift(mclVv(Noise, "Noise"), _mxarray0_));
                mclIntArrayAssign1(&NoiseR, _mxarray0_, 1);
                mlfAssign(
                  &NoiseL, mlfCircshift(mclVv(Noise, "Noise"), _mxarray43_));
                mclArrayAssign1(
                  &NoiseL,
                  _mxarray0_,
                  mlfEnd(mclVv(NoiseL, "NoiseL"), _mxarray0_, _mxarray0_));
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
                      _mxarray0_)));
                mlfAssign(
                  &EndNoise,
                  mlfFind(
                    NULL,
                    NULL,
                    mclEq(
                      mclMinus(mclVv(Noise, "Noise"), mclVv(NoiseL, "NoiseL")),
                      _mxarray0_)));
                /*
                 * 
                 * if  StartNoise(1)<EndNoise(1)       StartNoise(1)=[];   end;
                 */
                if (mclLtBool(
                      mclIntArrayRef1(mclVv(StartNoise, "StartNoise"), 1),
                      mclIntArrayRef1(mclVv(EndNoise, "EndNoise"), 1))) {
                    mlfIndexDelete(&StartNoise, "(?)", _mxarray0_);
                }
                /*
                 * if  StartNoise(end)<EndNoise(end)   EndNoise(end)=[];   end;
                 */
                if (mclLtBool(
                      mclArrayRef1(
                        mclVv(StartNoise, "StartNoise"),
                        mlfEnd(
                          mclVv(StartNoise, "StartNoise"),
                          _mxarray0_,
                          _mxarray0_)),
                      mclArrayRef1(
                        mclVv(EndNoise, "EndNoise"),
                        mlfEnd(
                          mclVv(EndNoise, "EndNoise"),
                          _mxarray0_,
                          _mxarray0_)))) {
                    mlfIndexDelete(
                      &EndNoise,
                      "(?)",
                      mlfEnd(
                        mclVv(EndNoise, "EndNoise"), _mxarray0_, _mxarray0_));
                }
                /*
                 * %Все что вначале трека в шум, чтоб не было пиков без началала
                 * Noise(1:EndNoise(1))=true;  
                 */
                mclArrayAssign1(
                  &Noise,
                  mlfTrue(NULL),
                  mlfColon(
                    _mxarray0_,
                    mclIntArrayRef1(mclVv(EndNoise, "EndNoise"), 1),
                    NULL));
                /*
                 * %Все что находится в конце трека в шум, чтоб не было незаконченных пиков  
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
                        _mxarray0_,
                        _mxarray0_)),
                    mlfEnd(mclVv(Noise, "Noise"), _mxarray0_, _mxarray0_),
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
                      _mxarray0_,
                      mlfEnd(
                        mclVv(EndNoise, "EndNoise"), _mxarray0_, _mxarray0_),
                      NULL)));
                mlfAssign(
                  &EndSignal,
                  mclArrayRef1(
                    mclVv(StartNoise, "StartNoise"),
                    mlfColon(
                      _mxarray0_,
                      mlfEnd(
                        mclVv(StartNoise, "StartNoise"),
                        _mxarray0_,
                        _mxarray0_),
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
                        mclPlus(_mxarray4_, mclVv(MinFrontN, "MinFrontN")),
                        mclVv(MinTailN, "MinTailN")))));
                /*
                 * SizeMoveToNoise=size(MoveToNoise,1);
                 */
                mlfAssign(
                  &SizeMoveToNoise,
                  mlfSize(
                    mclValueVarargout(),
                    mclVv(MoveToNoise, "MoveToNoise"),
                    _mxarray0_));
                /*
                 * for i=1:SizeMoveToNoise; Noise(StartSignal(MoveToNoise(i)):EndSignal(MoveToNoise(i)))=true; end;    
                 */
                {
                    int v_ = mclForIntStart(1);
                    int e_
                      = mclForIntEnd(
                          mclVv(SizeMoveToNoise, "SizeMoveToNoise"));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray42_);
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
                    _mxarray0_));
                /*
                 * fprintf('   %3.0f    short signals are removed\n', SizeMoveToNoise); 
                 */
                mclAssignAns(
                  &ans,
                  mlfNFprintf(
                    0,
                    _mxarray44_,
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
                    _mxarray0_,
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
                    _mxarray0_));
                /*
                 * for i=1:SizeMoveToSignal; Noise(StartNoise(MoveToSignal(i)))=false; end; 
                 */
                {
                    int v_ = mclForIntStart(1);
                    int e_
                      = mclForIntEnd(
                          mclVv(SizeMoveToSignal, "SizeMoveToSignal"));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray42_);
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
                      _mxarray0_,
                      mclMinus(
                        mlfEnd(
                          mclVv(EndNoise, "EndNoise"), _mxarray0_, _mxarray0_),
                        _mxarray0_),
                      NULL)));
                mlfAssign(
                  &EndSignal,
                  mclArrayRef1(
                    mclVv(StartNoise, "StartNoise"),
                    mlfColon(
                      _mxarray4_,
                      mlfEnd(
                        mclVv(StartNoise, "StartNoise"),
                        _mxarray0_,
                        _mxarray0_),
                      NULL)));
                /*
                 * SignalN=size(StartSignal,1);
                 */
                mlfAssign(
                  &SignalN,
                  mlfSize(
                    mclValueVarargout(),
                    mclVv(StartSignal, "StartSignal"),
                    _mxarray0_));
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
                        mlfAssign(&i, _mxarray42_);
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
                                  _mxarray0_),
                                _mxarray4_),
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
                    _mxarray4_));
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
                            _mxarray4_));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray42_);
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
                    _mxarray0_));
                /*
                 * 
                 * fprintf('   %3.0f    slow signals are removed\n', SlowN);
                 */
                mclAssignAns(
                  &ans,
                  mlfNFprintf(0, _mxarray46_, mclVv(SlowN, "SlowN"), NULL));
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
                        mlfAssign(&i, _mxarray42_);
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
                                    _mxarray4_),
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
                                    _mxarray4_),
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
                mlfAssign(&MoveToNoise, _mxarray42_);
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
                    _mxarray4_));
                /*
                 * for i=1:SizeMoveToNoise; Noise(StartSignal(MoveToNoise(i)):EndSignal(MoveToNoise(i)))=true; end; 
                 */
                {
                    int v_ = mclForIntStart(1);
                    int e_
                      = mclForIntEnd(
                          mclVv(SizeMoveToNoise, "SizeMoveToNoise"));
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray42_);
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
                    _mxarray0_));
                /*
                 * fprintf('   %3.0f    small signals are removed\n', SizeMoveToNoise); 
                 */
                mclAssignAns(
                  &ans,
                  mlfNFprintf(
                    0,
                    _mxarray48_,
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
                 * fprintf('Signal intervals search  =                                            %7.4f  sec\n', toc);
                 */
                mclAssignAns(
                  &ans, mlfNFprintf(0, _mxarray50_, mlfNToc(1), NULL));
            /*
             * 
             * %fprintf('Pause. look at the figure and press any key\n');
             * %pause;
             * else
             */
            } else {
                mxDestroyArray(a_);
            }
        /*
         * end;
         */
        }
        /*
         * tic;
         */
        mlfTic();
        /*
         * 
         * 
         * 
         * 
         * 
         * %Test for matching noise, AllSignals and StartSignal EndSignal    
         * %Search for max inside signal intervals: 
         * PeakInd=[];PeakVal=[];GoodPeakInd=[];GoodPeakVal=[];PeakOnFrontInd=[]; 
         */
        mlfAssign(&PeakInd, _mxarray42_);
        mlfAssign(&PeakVal, _mxarray42_);
        mlfAssign(&GoodPeakInd, _mxarray42_);
        mlfAssign(&GoodPeakVal, _mxarray42_);
        mlfAssign(&PeakOnFrontInd, _mxarray42_);
        /*
         * for i=1:SignalN         
         */
        {
            int v_ = mclForIntStart(1);
            int e_ = mclForIntEnd(mclVv(SignalN, "SignalN"));
            if (v_ > e_) {
                mlfAssign(&i, _mxarray42_);
            } else {
                /*
                 * S=StartSignal(i); E=EndSignal(i);
                 * %Нужно различать просто Видимые максимумы, коих много и хорошие
                 * %максимумы. В стандартные пики должны попадать только те, где и видимый
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
                 * [MaxPeak(i,1),Ind]=max(trek(S+VisiblePeakInd-1,2)); % max signal between S and E
                 * MaxPeakInd(i,1)=S+VisiblePeakInd(Ind)-1; 
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
                 * [MaxPeak(i,1),Ind]=max(trek(S+VisiblePeakInd-1,2)); % max signal between S and E
                 * MaxPeakInd(i,1)=S+VisiblePeakInd(Ind)-1; 
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
                    if (mclEqBool(mclVv(Pass, "Pass"), _mxarray0_)) {
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
                                    _mxarray4_),
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclPlus(mclVv(S, "S"), _mxarray0_),
                                      mclPlus(mclVv(E, "E"), _mxarray0_),
                                      NULL),
                                    _mxarray4_)),
                                mclGt(
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclVv(S, "S"), mclVv(E, "E"), NULL),
                                    _mxarray4_),
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclMinus(mclVv(S, "S"), _mxarray0_),
                                      mclMinus(mclVv(E, "E"), _mxarray0_),
                                      NULL),
                                    _mxarray4_))),
                              mclGt(
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfColon(
                                    mclMinus(mclVv(S, "S"), _mxarray0_),
                                    mclMinus(mclVv(E, "E"), _mxarray0_),
                                    NULL),
                                  _mxarray4_),
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfColon(
                                    mclMinus(mclVv(S, "S"), _mxarray4_),
                                    mclMinus(mclVv(E, "E"), _mxarray4_),
                                    NULL),
                                  _mxarray4_)))));
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
                                        _mxarray4_),
                                      mclArrayRef2(
                                        mclVv(trek, "trek"),
                                        mlfColon(
                                          mclPlus(mclVv(S, "S"), _mxarray0_),
                                          mclPlus(mclVv(E, "E"), _mxarray0_),
                                          NULL),
                                        _mxarray4_)),
                                    mclGt(
                                      mclArrayRef2(
                                        mclVv(trek, "trek"),
                                        mlfColon(
                                          mclVv(S, "S"), mclVv(E, "E"), NULL),
                                        _mxarray4_),
                                      mclArrayRef2(
                                        mclVv(trek, "trek"),
                                        mlfColon(
                                          mclMinus(mclVv(S, "S"), _mxarray0_),
                                          mclMinus(mclVv(E, "E"), _mxarray0_),
                                          NULL),
                                        _mxarray4_))),
                                  mclGt(
                                    mclArrayRef2(
                                      mclVv(trek, "trek"),
                                      mlfColon(
                                        mclMinus(mclVv(S, "S"), _mxarray0_),
                                        mclMinus(mclVv(E, "E"), _mxarray0_),
                                        NULL),
                                      _mxarray4_),
                                    mclArrayRef2(
                                      mclVv(trek, "trek"),
                                      mlfColon(
                                        mclMinus(mclVv(S, "S"), _mxarray4_),
                                        mclMinus(mclVv(E, "E"), _mxarray4_),
                                        NULL),
                                      _mxarray4_))),
                                mclGt(
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclVv(S, "S"), mclVv(E, "E"), NULL),
                                    _mxarray4_),
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
                                      _mxarray4_),
                                    mclMtimes(
                                      mclVv(MinFrontN, "MinFrontN"),
                                      mclVv(ThresholdD, "ThresholdD"))))),
                              mclGt(
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL),
                                  _mxarray4_),
                                mclPlus(
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclPlus(mclVv(S, "S"), _mxarray4_),
                                      mclPlus(mclVv(E, "E"), _mxarray4_),
                                      NULL),
                                    _mxarray4_),
                                  mclMtimes(
                                    _mxarray4_,
                                    mclVv(ThresholdD, "ThresholdD")))))));
                        mclIntArrayAssign1(
                          &NumPeaks,
                          mlfSize(
                            mclValueVarargout(),
                            mclVv(VisiblePeakInd, "VisiblePeakInd"),
                            _mxarray0_),
                          v_);
                        mclIntArrayAssign1(
                          &NumGoodPeaks,
                          mlfSize(
                            mclValueVarargout(),
                            mclVv(VisiblePeakInd, "VisiblePeakInd"),
                            _mxarray0_),
                          v_);
                        if (mclEqBool(
                              mclIntArrayRef1(mclVv(NumPeaks, "NumPeaks"), v_),
                              _mxarray1_)) {
                            mlfAssign(
                              &Max,
                              mlfMax(
                                &VisiblePeakInd,
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL),
                                  _mxarray4_),
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
                              _mxarray0_),
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
                              _mxarray0_),
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
                                _mxarray0_),
                              _mxarray4_),
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
                                _mxarray0_),
                              _mxarray4_),
                            NULL));
                        mclFeval(
                          mlfIndexVarargout(
                            &MaxPeak, "(?,?)", mlfScalar(v_), _mxarray0_,
                            &Ind, "",
                            NULL),
                          mlxMax,
                          mclArrayRef2(
                            mclVv(trek, "trek"),
                            mclMinus(
                              mclPlus(
                                mclVv(S, "S"),
                                mclVv(VisiblePeakInd, "VisiblePeakInd")),
                              _mxarray0_),
                            _mxarray4_),
                          NULL);
                        mclIntArrayAssign2(
                          &MaxPeakInd,
                          mclMinus(
                            mclPlus(
                              mclVv(S, "S"),
                              mclArrayRef1(
                                mclVv(VisiblePeakInd, "VisiblePeakInd"),
                                mclVv(Ind, "Ind"))),
                            _mxarray0_),
                          v_,
                          1);
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
                                      _mxarray4_),
                                    mclArrayRef2(
                                      mclVv(trek, "trek"),
                                      mlfColon(
                                        mclPlus(mclVv(S, "S"), _mxarray0_),
                                        mclPlus(mclVv(E, "E"), _mxarray0_),
                                        NULL),
                                      _mxarray4_)),
                                  mclGt(
                                    mclArrayRef2(
                                      mclVv(trek, "trek"),
                                      mlfColon(
                                        mclVv(S, "S"), mclVv(E, "E"), NULL),
                                      _mxarray4_),
                                    mclArrayRef2(
                                      mclVv(trek, "trek"),
                                      mlfColon(
                                        mclMinus(mclVv(S, "S"), _mxarray0_),
                                        mclMinus(mclVv(E, "E"), _mxarray0_),
                                        NULL),
                                      _mxarray4_))),
                                mclGt(
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclMinus(mclVv(S, "S"), _mxarray0_),
                                      mclMinus(mclVv(E, "E"), _mxarray0_),
                                      NULL),
                                    _mxarray4_),
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclMinus(mclVv(S, "S"), _mxarray4_),
                                      mclMinus(mclVv(E, "E"), _mxarray4_),
                                      NULL),
                                    _mxarray4_))),
                              mclGt(
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL),
                                  _mxarray4_),
                                mclPlus(
                                  mclArrayRef2(
                                    mclVv(trek, "trek"),
                                    mlfColon(
                                      mclPlus(mclVv(S, "S"), _mxarray4_),
                                      mclPlus(mclVv(E, "E"), _mxarray4_),
                                      NULL),
                                    _mxarray4_),
                                  mclMtimes(
                                    _mxarray4_,
                                    mclVv(ThresholdD, "ThresholdD")))))));
                        mclIntArrayAssign1(
                          &NumPeaks,
                          mlfSize(
                            mclValueVarargout(),
                            mclVv(VisiblePeakInd, "VisiblePeakInd"),
                            _mxarray0_),
                          v_);
                        if (mclEqBool(
                              mclIntArrayRef1(mclVv(NumPeaks, "NumPeaks"), v_),
                              _mxarray1_)) {
                            mlfAssign(
                              &Max,
                              mlfMax(
                                &VisiblePeakInd,
                                mclArrayRef2(
                                  mclVv(trek, "trek"),
                                  mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL),
                                  _mxarray4_),
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
                              _mxarray0_),
                            NULL));
                        mclFeval(
                          mlfIndexVarargout(
                            &MaxPeak, "(?,?)", mlfScalar(v_), _mxarray0_,
                            &Ind, "",
                            NULL),
                          mlxMax,
                          mclArrayRef2(
                            mclVv(trek, "trek"),
                            mclMinus(
                              mclPlus(
                                mclVv(S, "S"),
                                mclVv(VisiblePeakInd, "VisiblePeakInd")),
                              _mxarray0_),
                            _mxarray4_),
                          NULL);
                        mclIntArrayAssign2(
                          &MaxPeakInd,
                          mclMinus(
                            mclPlus(
                              mclVv(S, "S"),
                              mclArrayRef1(
                                mclVv(VisiblePeakInd, "VisiblePeakInd"),
                                mclVv(Ind, "Ind"))),
                            _mxarray0_),
                          v_,
                          1);
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
          mlfSize(mclValueVarargout(), mclVv(PeakInd, "PeakInd"), _mxarray0_));
        /*
         * GoodPeakN=size(GoodPeakInd,1);
         */
        mlfAssign(
          &GoodPeakN,
          mlfSize(
            mclValueVarargout(),
            mclVv(GoodPeakInd, "GoodPeakInd"),
            _mxarray0_));
        /*
         * fprintf('Peak search  =                                                       %7.4f  sec\n', toc); tic;
         */
        mclAssignAns(&ans, mlfNFprintf(0, _mxarray52_, mlfNToc(1), NULL));
        mlfTic();
        /*
         * fprintf('Number of peaks before Double front search= %3.0f\n',PeakN);
         */
        mclAssignAns(
          &ans, mlfNFprintf(0, _mxarray54_, mclVv(PeakN, "PeakN"), NULL));
        /*
         * if Pass==1 fprintf('Number of Good peaks before Double front search= %3.0f\n',GoodPeakN);end;
         */
        if (mclEqBool(mclVv(Pass, "Pass"), _mxarray0_)) {
            mclAssignAns(
              &ans,
              mlfNFprintf(0, _mxarray56_, mclVv(GoodPeakN, "GoodPeakN"), NULL));
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
              mclMtimes(_mxarray58_, mclVv(MaxFrontN, "MaxFrontN")))));
        /*
         * DoubleFrontSize=size(DoubleFrontInd,2);                 %from MK 
         */
        mlfAssign(
          &DoubleFrontSize,
          mlfSize(
            mclValueVarargout(),
            mclVv(DoubleFrontInd, "DoubleFrontInd"),
            _mxarray4_));
        /*
         * % Search first peak in double fronts:                   %from MK 
         * if DoubleFrontSize>0                                    %from MK 
         */
        if (mclGtBool(mclVv(DoubleFrontSize, "DoubleFrontSize"), _mxarray1_)) {
            /*
             * for i=1:DoubleFrontSize                             %from MK 
             */
            int v_ = mclForIntStart(1);
            int e_ = mclForIntEnd(mclVv(DoubleFrontSize, "DoubleFrontSize"));
            if (v_ > e_) {
                mlfAssign(&i, _mxarray42_);
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
                        _mxarray0_));
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
                        _mxarray0_));
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
                                mclPlus(mclVv(S, "S"), _mxarray0_),
                                mclPlus(mclVv(E, "E"), _mxarray0_),
                                NULL))),
                          mclLt(
                            mclArrayRef1(
                              mclVv(trekD, "trekD"),
                              mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL)),
                            mclArrayRef1(
                              mclVv(trekD, "trekD"),
                              mlfColon(
                                mclMinus(mclVv(S, "S"), _mxarray0_),
                                mclMinus(mclVv(E, "E"), _mxarray0_),
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
                                _mxarray0_),
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
                                _mxarray0_),
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
                            _mxarray0_),
                          mclIntArrayRef1(
                            mclVv(DoubleFrontInd, "DoubleFrontInd"), v_));
                        mclArrayAssign1(
                          &FrontSignalN,
                          mclPlus(
                            mclArrayRef1(
                              mclVv(NumPeaks, "NumPeaks"),
                              mclIntArrayRef1(
                                mclVv(DoubleFrontInd, "DoubleFrontInd"), v_)),
                            _mxarray0_),
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
          mlfSize(mclValueVarargout(), mclVv(PeakInd, "PeakInd"), _mxarray0_));
        /*
         * fprintf('Double Front search  =                                          %7.4f  sec\n', toc); 
         */
        mclAssignAns(&ans, mlfNFprintf(0, _mxarray59_, mlfNToc(1), NULL));
        /*
         * fprintf('Number of peaks with Double fronts = %3.0f\n',PeakN);
         */
        mclAssignAns(
          &ans, mlfNFprintf(0, _mxarray61_, mclVv(PeakN, "PeakN"), NULL));
        /*
         * 
         * 
         * %fprintf('Pause. look at the figure and press any key\n');
         * %pause;
         * tic;
         */
        mlfTic();
        /*
         * 
         * if Pass==1
         */
        if (mclEqBool(mclVv(Pass, "Pass"), _mxarray0_)) {
            /*
             * StandardPeaks=find((NumPeaks==1)'&(NumGoodPeaks==1)'&...
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
                        mclAnd(
                          mclAnd(
                            mclAnd(
                              mlfCtranspose(
                                mclEq(mclVv(NumPeaks, "NumPeaks"), _mxarray0_)),
                              mlfCtranspose(
                                mclEq(
                                  mclVv(NumGoodPeaks, "NumGoodPeaks"),
                                  _mxarray0_))),
                            mclGe(
                              mclMinus(
                                mclVv(EndSignal, "EndSignal"),
                                mclVv(StartSignal, "StartSignal")),
                              mclPlus(
                                mclVv(MinFrontN, "MinFrontN"),
                                mclVv(MinTailN, "MinTailN")))),
                          mclGe(
                            mclMinus(
                              mclVv(MaxPeakInd, "MaxPeakInd"),
                              mclVv(StartSignal, "StartSignal")),
                            mclVv(MinFrontN, "MinFrontN"))),
                        mclLe(
                          mclMinus(
                            mclVv(MaxPeakInd, "MaxPeakInd"),
                            mclVv(StartSignal, "StartSignal")),
                          mclVv(MaxFrontN, "MaxFrontN"))),
                      mclGe(
                        mclMinus(
                          mclVv(MaxPeak, "MaxPeak"),
                          mclArrayRef2(
                            mclVv(trek, "trek"),
                            mclVv(StartSignal, "StartSignal"),
                            _mxarray4_)),
                        mclMtimes(_mxarray63_, mclVv(Threshold, "Threshold")))),
                    mclLt(
                      mclMinus(
                        mclVv(MaxPeak, "MaxPeak"),
                        mclArrayRef2(
                          mclVv(trek, "trek"),
                          mclVv(StartSignal, "StartSignal"),
                          _mxarray4_)),
                      mclVa(MaxSignal, "MaxSignal"))),
                  mclLt(
                    mclVv(MaxPeak, "MaxPeak"),
                    mclVa(MaxSignal, "MaxSignal")))));
            /*
             * ((EndSignal-StartSignal)>=MinFrontN+MinTailN)&...
             * ((MaxPeakInd-StartSignal)>=MinFrontN)&...
             * ((MaxPeakInd-StartSignal)<=MaxFrontN)&...
             * (MaxPeak-trek(StartSignal,2)>=3*Threshold)&...
             * (MaxPeak-trek(StartSignal,2)<MaxSignal)&MaxPeak<MaxSignal);
             * StandardPeaksN=size(find(StandardPeaks),1);
             */
            mlfAssign(
              &StandardPeaksN,
              mlfSize(
                mclValueVarargout(),
                mlfFind(NULL, NULL, mclVv(StandardPeaks, "StandardPeaks")),
                _mxarray0_));
            /*
             * 
             * %         figure; hold on;
             * %         for i=1:StandardPeaksN 
             * %             plot(trek(StartSignal(StandardPeaks(i)):EndSignal(StandardPeaks(i)),2));
             * %         end;
             * %pause; 
             * fprintf('StandardPeaks  search  =                                    %7.4f  sec\n', toc);tic;
             */
            mclAssignAns(&ans, mlfNFprintf(0, _mxarray64_, mlfNToc(1), NULL));
            mlfTic();
            /*
             * fprintf('Number of StandardPeaks = %3.0f\n',StandardPeaksN);
             */
            mclAssignAns(
              &ans,
              mlfNFprintf(
                0, _mxarray66_, mclVv(StandardPeaksN, "StandardPeaksN"), NULL));
            /*
             * 
             * %Synhronize standard peaks using two highest points:
             * 
             * AscendTop=trek(MaxPeakInd(StandardPeaks)-1)>=trek(MaxPeakInd(StandardPeaks)+1);
             */
            mlfAssign(
              &AscendTop,
              mclGe(
                mclArrayRef1(
                  mclVv(trek, "trek"),
                  mclMinus(
                    mclArrayRef1(
                      mclVv(MaxPeakInd, "MaxPeakInd"),
                      mclVv(StandardPeaks, "StandardPeaks")),
                    _mxarray0_)),
                mclArrayRef1(
                  mclVv(trek, "trek"),
                  mclPlus(
                    mclArrayRef1(
                      mclVv(MaxPeakInd, "MaxPeakInd"),
                      mclVv(StandardPeaks, "StandardPeaks")),
                    _mxarray0_))));
            /*
             * 
             * PeakStart=max([StartSignal(StandardPeaks),MaxPeakInd(StandardPeaks)-AscendTop-MaxFrontN]');
             */
            mlfAssign(
              &PeakStart,
              mlfMax(
                NULL,
                mlfCtranspose(
                  mlfHorzcat(
                    mclArrayRef1(
                      mclVv(StartSignal, "StartSignal"),
                      mclVv(StandardPeaks, "StandardPeaks")),
                    mclMinus(
                      mclMinus(
                        mclArrayRef1(
                          mclVv(MaxPeakInd, "MaxPeakInd"),
                          mclVv(StandardPeaks, "StandardPeaks")),
                        mclVv(AscendTop, "AscendTop")),
                      mclVv(MaxFrontN, "MaxFrontN")),
                    NULL)),
                NULL,
                NULL));
            /*
             * PeakEnd  =min([EndSignal(StandardPeaks),MaxPeakInd(StandardPeaks)-AscendTop+MaxTailN]');
             */
            mlfAssign(
              &PeakEnd,
              mlfMin(
                NULL,
                mlfCtranspose(
                  mlfHorzcat(
                    mclArrayRef1(
                      mclVv(EndSignal, "EndSignal"),
                      mclVv(StandardPeaks, "StandardPeaks")),
                    mclPlus(
                      mclMinus(
                        mclArrayRef1(
                          mclVv(MaxPeakInd, "MaxPeakInd"),
                          mclVv(StandardPeaks, "StandardPeaks")),
                        mclVv(AscendTop, "AscendTop")),
                      mclVv(MaxTailN, "MaxTailN")),
                    NULL)),
                NULL,
                NULL));
            /*
             * 
             * SampleFront=2*MaxFrontN;  SampleTail=2*MaxTailN;  
             */
            mlfAssign(
              &SampleFront,
              mclMtimes(_mxarray4_, mclVv(MaxFrontN, "MaxFrontN")));
            mlfAssign(
              &SampleTail, mclMtimes(_mxarray4_, mclVv(MaxTailN, "MaxTailN")));
            /*
             * SampleN=SampleFront+SampleTail+1;
             */
            mlfAssign(
              &SampleN,
              mclPlus(
                mclPlus(
                  mclVv(SampleFront, "SampleFront"),
                  mclVv(SampleTail, "SampleTail")),
                _mxarray0_));
            /*
             * StandardPulse=zeros(SampleFront+SampleTail+1,StandardPeaksN);
             */
            mlfAssign(
              &StandardPulse,
              mlfZeros(
                mclPlus(
                  mclPlus(
                    mclVv(SampleFront, "SampleFront"),
                    mclVv(SampleTail, "SampleTail")),
                  _mxarray0_),
                mclVv(StandardPeaksN, "StandardPeaksN"),
                NULL));
            /*
             * 
             * for i=1:StandardPeaksN 
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVv(StandardPeaksN, "StandardPeaksN"));
                if (v_ > e_) {
                    mlfAssign(&i, _mxarray42_);
                } else {
                    /*
                     * StandardPulse(:,i)=trek(MaxPeakInd(StandardPeaks(i))-AscendTop(i)-SampleFront:...
                     * MaxPeakInd(StandardPeaks(i))-AscendTop(i)+SampleTail,2);
                     * end;    
                     */
                    for (; ; ) {
                        mclArrayAssign2(
                          &StandardPulse,
                          mclArrayRef2(
                            mclVv(trek, "trek"),
                            mlfColon(
                              mclMinus(
                                mclMinus(
                                  mclArrayRef1(
                                    mclVv(MaxPeakInd, "MaxPeakInd"),
                                    mclIntArrayRef1(
                                      mclVv(StandardPeaks, "StandardPeaks"),
                                      v_)),
                                  mclIntArrayRef1(
                                    mclVv(AscendTop, "AscendTop"), v_)),
                                mclVv(SampleFront, "SampleFront")),
                              mclPlus(
                                mclMinus(
                                  mclArrayRef1(
                                    mclVv(MaxPeakInd, "MaxPeakInd"),
                                    mclIntArrayRef1(
                                      mclVv(StandardPeaks, "StandardPeaks"),
                                      v_)),
                                  mclIntArrayRef1(
                                    mclVv(AscendTop, "AscendTop"), v_)),
                                mclVv(SampleTail, "SampleTail")),
                              NULL),
                            _mxarray4_),
                          mlfCreateColonIndex(),
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
             * SignalsOk=StandardPulse<MaxSignal;
             */
            mlfAssign(
              &SignalsOk,
              mclLt(
                mclVv(StandardPulse, "StandardPulse"),
                mclVa(MaxSignal, "MaxSignal")));
            /*
             * for i=1:SampleN 
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVv(SampleN, "SampleN"));
                if (v_ > e_) {
                    mlfAssign(&i, _mxarray42_);
                } else {
                    /*
                     * SelectedStandrdPulse=StandardPulse(i,SignalsOk(i,:));
                     * MeanStandardPulse(i,1)=mean(SelectedStandrdPulse);
                     * stdStandardPulse(i,1)=std(SelectedStandrdPulse);
                     * SelectedN(i,1)=sum(SignalsOk(i,:));
                     * end;        
                     */
                    for (; ; ) {
                        mlfAssign(
                          &SelectedStandrdPulse,
                          mclArrayRef2(
                            mclVv(StandardPulse, "StandardPulse"),
                            mlfScalar(v_),
                            mclArrayRef2(
                              mclVv(SignalsOk, "SignalsOk"),
                              mlfScalar(v_),
                              mlfCreateColonIndex())));
                        mclIntArrayAssign2(
                          &MeanStandardPulse,
                          mlfMean(
                            mclVv(SelectedStandrdPulse, "SelectedStandrdPulse"),
                            NULL),
                          v_,
                          1);
                        mclIntArrayAssign2(
                          &stdStandardPulse,
                          mlfStd(
                            mclVv(SelectedStandrdPulse, "SelectedStandrdPulse"),
                            NULL,
                            NULL),
                          v_,
                          1);
                        mclIntArrayAssign2(
                          &SelectedN,
                          mlfSum(
                            mclArrayRef2(
                              mclVv(SignalsOk, "SignalsOk"),
                              mlfScalar(v_),
                              mlfCreateColonIndex()),
                            NULL),
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
             * [MinStdLeft,LeftMin]=min(stdStandardPulse(1:SampleFront));
             */
            mlfAssign(
              &MinStdLeft,
              mlfMin(
                &LeftMin,
                mclArrayRef1(
                  mclVv(stdStandardPulse, "stdStandardPulse"),
                  mlfColon(
                    _mxarray0_, mclVv(SampleFront, "SampleFront"), NULL)),
                NULL,
                NULL));
            /*
             * [MinStdRight,RightMin]=min(stdStandardPulse(SampleFront+1:end));
             */
            mlfAssign(
              &MinStdRight,
              mlfMin(
                &RightMin,
                mclArrayRef1(
                  mclVv(stdStandardPulse, "stdStandardPulse"),
                  mlfColon(
                    mclPlus(mclVv(SampleFront, "SampleFront"), _mxarray0_),
                    mlfEnd(
                      mclVv(stdStandardPulse, "stdStandardPulse"),
                      _mxarray0_,
                      _mxarray0_),
                    NULL)),
                NULL,
                NULL));
            /*
             * RightMin=RightMin+SampleFront-1;
             */
            mlfAssign(
              &RightMin,
              mclMinus(
                mclPlus(
                  mclVv(RightMin, "RightMin"),
                  mclVv(SampleFront, "SampleFront")),
                _mxarray0_));
            /*
             * 
             * DeltaMean=(StandardPulse-repmat(MeanStandardPulse,1,StandardPeaksN));
             */
            mlfAssign(
              &DeltaMean,
              mclMinus(
                mclVv(StandardPulse, "StandardPulse"),
                mlfRepmat(
                  mclVv(MeanStandardPulse, "MeanStandardPulse"),
                  _mxarray0_,
                  mclVv(StandardPeaksN, "StandardPeaksN"))));
            /*
             * 
             * SignalsLeftOk=DeltaMean(1:LeftMin,:)<=2*MinStdLeft;
             */
            mlfAssign(
              &SignalsLeftOk,
              mclLe(
                mclArrayRef2(
                  mclVv(DeltaMean, "DeltaMean"),
                  mlfColon(_mxarray0_, mclVv(LeftMin, "LeftMin"), NULL),
                  mlfCreateColonIndex()),
                mclMtimes(_mxarray4_, mclVv(MinStdLeft, "MinStdLeft"))));
            /*
             * SignalCenterOk=logical(ones(RightMin-LeftMin-1,StandardPeaksN));
             */
            mlfAssign(
              &SignalCenterOk,
              mlfTrue(
                mclMinus(
                  mclMinus(
                    mclVv(RightMin, "RightMin"), mclVv(LeftMin, "LeftMin")),
                  _mxarray0_),
                mclVv(StandardPeaksN, "StandardPeaksN"),
                NULL));
            /*
             * SignalsRightOk=DeltaMean(RightMin:end,:)<=2*MinStdRight;
             */
            mlfAssign(
              &SignalsRightOk,
              mclLe(
                mclArrayRef2(
                  mclVv(DeltaMean, "DeltaMean"),
                  mlfColon(
                    mclVv(RightMin, "RightMin"),
                    mlfEnd(
                      mclVv(DeltaMean, "DeltaMean"), _mxarray0_, _mxarray4_),
                    NULL),
                  mlfCreateColonIndex()),
                mclMtimes(_mxarray4_, mclVv(MinStdRight, "MinStdRight"))));
            /*
             * SignalsOk=SignalsOk&[SignalsLeftOk;SignalCenterOk;SignalsRightOk];
             */
            mlfAssign(
              &SignalsOk,
              mclAnd(
                mclVv(SignalsOk, "SignalsOk"),
                mlfVertcat(
                  mclVv(SignalsLeftOk, "SignalsLeftOk"),
                  mclVv(SignalCenterOk, "SignalCenterOk"),
                  mclVv(SignalsRightOk, "SignalsRightOk"),
                  NULL)));
            /*
             * 
             * 
             * clear  SignalsLeftOk SignalCenterOk SignalsRightOk;
             */
            mlfClear(&SignalsLeftOk, &SignalCenterOk, &SignalsRightOk, NULL);
            /*
             * 
             * for i=1:SampleN 
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVv(SampleN, "SampleN"));
                if (v_ > e_) {
                    mlfAssign(&i, _mxarray42_);
                } else {
                    /*
                     * SelectedStandrdPulse=StandardPulse(i,SignalsOk(i,:));
                     * MeanStandardPulse(i,1)=mean(SelectedStandrdPulse);
                     * stdStandardPulse(i,1)=std(SelectedStandrdPulse);
                     * SelectedN(i,1)=sum(SignalsOk(i,:));
                     * end;
                     */
                    for (; ; ) {
                        mlfAssign(
                          &SelectedStandrdPulse,
                          mclArrayRef2(
                            mclVv(StandardPulse, "StandardPulse"),
                            mlfScalar(v_),
                            mclArrayRef2(
                              mclVv(SignalsOk, "SignalsOk"),
                              mlfScalar(v_),
                              mlfCreateColonIndex())));
                        mclIntArrayAssign2(
                          &MeanStandardPulse,
                          mlfMean(
                            mclVv(SelectedStandrdPulse, "SelectedStandrdPulse"),
                            NULL),
                          v_,
                          1);
                        mclIntArrayAssign2(
                          &stdStandardPulse,
                          mlfStd(
                            mclVv(SelectedStandrdPulse, "SelectedStandrdPulse"),
                            NULL,
                            NULL),
                          v_,
                          1);
                        mclIntArrayAssign2(
                          &SelectedN,
                          mlfSum(
                            mclArrayRef2(
                              mclVv(SignalsOk, "SignalsOk"),
                              mlfScalar(v_),
                              mlfCreateColonIndex()),
                            NULL),
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
             * x=[1:SampleFront+1-MaxFrontN,SampleN-SampleTail+MaxTailN:SampleN]';
             */
            mlfAssign(
              &x,
              mlfCtranspose(
                mlfHorzcat(
                  mlfColon(
                    _mxarray0_,
                    mclMinus(
                      mclPlus(mclVv(SampleFront, "SampleFront"), _mxarray0_),
                      mclVv(MaxFrontN, "MaxFrontN")),
                    NULL),
                  mlfColon(
                    mclPlus(
                      mclMinus(
                        mclVv(SampleN, "SampleN"),
                        mclVv(SampleTail, "SampleTail")),
                      mclVv(MaxTailN, "MaxTailN")),
                    mclVv(SampleN, "SampleN"),
                    NULL),
                  NULL)));
            /*
             * Zero=polyfit(x,MeanStandardPulse(x),1);
             */
            mlfAssign(
              &Zero,
              mlfNPolyfit(
                1,
                NULL,
                NULL,
                mclVv(x, "x"),
                mclArrayRef1(
                  mclVv(MeanStandardPulse, "MeanStandardPulse"), mclVv(x, "x")),
                _mxarray0_));
            /*
             * x=[1:SampleN]';
             */
            mlfAssign(
              &x,
              mlfCtranspose(
                mlfColon(_mxarray0_, mclVv(SampleN, "SampleN"), NULL)));
            /*
             * MeanStandardPulse=MeanStandardPulse-(Zero(1)*x+Zero(2));
             */
            mlfAssign(
              &MeanStandardPulse,
              mclMinus(
                mclVv(MeanStandardPulse, "MeanStandardPulse"),
                mclPlus(
                  mclMtimes(
                    mclIntArrayRef1(mclVv(Zero, "Zero"), 1), mclVv(x, "x")),
                  mclIntArrayRef1(mclVv(Zero, "Zero"), 2))));
            /*
             * stdStandardPulse= stdStandardPulse./(SelectedN-1).^0.5;
             */
            mlfAssign(
              &stdStandardPulse,
              mclRdivide(
                mclVv(stdStandardPulse, "stdStandardPulse"),
                mlfPower(
                  mclMinus(mclVv(SelectedN, "SelectedN"), _mxarray0_),
                  _mxarray12_)));
            /*
             * ToZero=MeanStandardPulse<stdStandardPulse;
             */
            mlfAssign(
              &ToZero,
              mclLt(
                mclVv(MeanStandardPulse, "MeanStandardPulse"),
                mclVv(stdStandardPulse, "stdStandardPulse")));
            /*
             * MeanStandardPulse(ToZero)=0;
             */
            mclArrayAssign1(
              &MeanStandardPulse, _mxarray1_, mclVv(ToZero, "ToZero"));
            /*
             * [MaxStandardPulse,MaxStandardPulseIndx]=max(MeanStandardPulse);
             */
            mlfAssign(
              &MaxStandardPulse,
              mlfMax(
                &MaxStandardPulseIndx,
                mclVv(MeanStandardPulse, "MeanStandardPulse"),
                NULL,
                NULL));
            /*
             * FirstNonZero=max(find(MeanStandardPulse(1:MaxStandardPulseIndx)==0))+1;
             */
            mlfAssign(
              &FirstNonZero,
              mclPlus(
                mlfMax(
                  NULL,
                  mlfFind(
                    NULL,
                    NULL,
                    mclEq(
                      mclArrayRef1(
                        mclVv(MeanStandardPulse, "MeanStandardPulse"),
                        mlfColon(
                          _mxarray0_,
                          mclVv(MaxStandardPulseIndx, "MaxStandardPulseIndx"),
                          NULL)),
                      _mxarray1_)),
                  NULL,
                  NULL),
                _mxarray0_));
            /*
             * LastNonZero=min(find(MeanStandardPulse(MaxStandardPulseIndx:end)==0))+MaxStandardPulseIndx;        
             */
            mlfAssign(
              &LastNonZero,
              mclPlus(
                mlfMin(
                  NULL,
                  mlfFind(
                    NULL,
                    NULL,
                    mclEq(
                      mclArrayRef1(
                        mclVv(MeanStandardPulse, "MeanStandardPulse"),
                        mlfColon(
                          mclVv(MaxStandardPulseIndx, "MaxStandardPulseIndx"),
                          mlfEnd(
                            mclVv(MeanStandardPulse, "MeanStandardPulse"),
                            _mxarray0_,
                            _mxarray0_),
                          NULL)),
                      _mxarray1_)),
                  NULL,
                  NULL),
                mclVv(MaxStandardPulseIndx, "MaxStandardPulseIndx")));
            /*
             * MeanStandardPulse(1:FirstNonZero-1)=0;
             */
            mclArrayAssign1(
              &MeanStandardPulse,
              _mxarray1_,
              mlfColon(
                _mxarray0_,
                mclMinus(mclVv(FirstNonZero, "FirstNonZero"), _mxarray0_),
                NULL));
            /*
             * MeanStandardPulse(LastNonZero+1:end)=0;
             */
            mclArrayAssign1(
              &MeanStandardPulse,
              _mxarray1_,
              mlfColon(
                mclPlus(mclVv(LastNonZero, "LastNonZero"), _mxarray0_),
                mlfEnd(
                  mclVv(MeanStandardPulse, "MeanStandardPulse"),
                  _mxarray0_,
                  _mxarray0_),
                NULL));
            /*
             * 
             * StandardPulseNorm=MeanStandardPulse/MaxStandardPulse;
             */
            mlfAssign(
              &StandardPulseNorm,
              mclMrdivide(
                mclVv(MeanStandardPulse, "MeanStandardPulse"),
                mclVv(MaxStandardPulse, "MaxStandardPulse")));
            /*
             * 
             * %intervals for pulse fitting:
             * FitPulseInterval=[FirstNonZero:MaxStandardPulseIndx+BeyondMaxN]';
             */
            mlfAssign(
              &FitPulseInterval,
              mlfCtranspose(
                mlfColon(
                  mclVv(FirstNonZero, "FirstNonZero"),
                  mclPlus(
                    mclVv(MaxStandardPulseIndx, "MaxStandardPulseIndx"),
                    mclVv(BeyondMaxN, "BeyondMaxN")),
                  NULL)));
            /*
             * FitBackgndInterval=[FirstNonZero-2,FirstNonZero-1]';
             */
            mlfAssign(
              &FitBackgndInterval,
              mlfCtranspose(
                mlfHorzcat(
                  mclMinus(mclVv(FirstNonZero, "FirstNonZero"), _mxarray4_),
                  mclMinus(mclVv(FirstNonZero, "FirstNonZero"), _mxarray0_),
                  NULL)));
            /*
             * FitN=size(FitPulseInterval,1);
             */
            mlfAssign(
              &FitN,
              mlfSize(
                mclValueVarargout(),
                mclVv(FitPulseInterval, "FitPulseInterval"),
                _mxarray0_));
            /*
             * 
             * 
             * PulseInterp(:,1)=(1:1/InterpN:SampleN)';        
             */
            mclArrayAssign2(
              &PulseInterp,
              mlfCtranspose(
                mlfColon(
                  _mxarray0_,
                  mclMrdivide(_mxarray0_, mclVv(InterpN, "InterpN")),
                  mclVv(SampleN, "SampleN"))),
              mlfCreateColonIndex(),
              _mxarray0_);
            /*
             * SampleInterpN=size(PulseInterp,1);
             */
            mlfAssign(
              &SampleInterpN,
              mlfSize(
                mclValueVarargout(),
                mclVv(PulseInterp, "PulseInterp"),
                _mxarray0_));
            /*
             * 
             * PulseInterpFine(:,1)=(1:1/FineInterpN:SampleN)'; 
             */
            mclArrayAssign2(
              &PulseInterpFine,
              mlfCtranspose(
                mlfColon(
                  _mxarray0_,
                  mclMrdivide(_mxarray0_, mclVv(FineInterpN, "FineInterpN")),
                  mclVv(SampleN, "SampleN"))),
              mlfCreateColonIndex(),
              _mxarray0_);
            /*
             * SampleInterpFineN=size(PulseInterpFine,1);
             */
            mlfAssign(
              &SampleInterpFineN,
              mlfSize(
                mclValueVarargout(),
                mclVv(PulseInterpFine, "PulseInterpFine"),
                _mxarray0_));
            /*
             * 
             * PulseInterp(:,2)=interp1(StandardPulseNorm,PulseInterp(:,1),'spline');
             */
            mclArrayAssign2(
              &PulseInterp,
              mlfInterp1(
                mclVv(StandardPulseNorm, "StandardPulseNorm"),
                mclArrayRef2(
                  mclVv(PulseInterp, "PulseInterp"),
                  mlfCreateColonIndex(),
                  _mxarray0_),
                _mxarray68_,
                NULL),
              mlfCreateColonIndex(),
              _mxarray4_);
            /*
             * 
             * FirstNonZeroInterp=(FirstNonZero-1)*InterpN+1;           %expected from StandardPulseNorm
             */
            mlfAssign(
              &FirstNonZeroInterp,
              mclPlus(
                mclMtimes(
                  mclMinus(mclVv(FirstNonZero, "FirstNonZero"), _mxarray0_),
                  mclVv(InterpN, "InterpN")),
                _mxarray0_));
            /*
             * LastNonZeroInterp =(LastNonZero-1)*InterpN+1;            %expected from StandardPulseNorm
             */
            mlfAssign(
              &LastNonZeroInterp,
              mclPlus(
                mclMtimes(
                  mclMinus(mclVv(LastNonZero, "LastNonZero"), _mxarray0_),
                  mclVv(InterpN, "InterpN")),
                _mxarray0_));
            /*
             * MaxPulseInterpIndx=(MaxStandardPulseIndx-1)*InterpN+1;   %expected from StandardPulseNorm
             */
            mlfAssign(
              &MaxPulseInterpIndx,
              mclPlus(
                mclMtimes(
                  mclMinus(
                    mclVv(MaxStandardPulseIndx, "MaxStandardPulseIndx"),
                    _mxarray0_),
                  mclVv(InterpN, "InterpN")),
                _mxarray0_));
            /*
             * %corrections: 
             * FirstNonZeroInterp=max(find(PulseInterp(1:FirstNonZeroInterp,2)<=0))+1;
             */
            mlfAssign(
              &FirstNonZeroInterp,
              mclPlus(
                mlfMax(
                  NULL,
                  mlfFind(
                    NULL,
                    NULL,
                    mclLe(
                      mclArrayRef2(
                        mclVv(PulseInterp, "PulseInterp"),
                        mlfColon(
                          _mxarray0_,
                          mclVv(FirstNonZeroInterp, "FirstNonZeroInterp"),
                          NULL),
                        _mxarray4_),
                      _mxarray1_)),
                  NULL,
                  NULL),
                _mxarray0_));
            /*
             * LastNonZeroInterp=min(find(PulseInterp(LastNonZeroInterp:end,2)<=0))+LastNonZeroInterp-2;
             */
            mlfAssign(
              &LastNonZeroInterp,
              mclMinus(
                mclPlus(
                  mlfMin(
                    NULL,
                    mlfFind(
                      NULL,
                      NULL,
                      mclLe(
                        mclArrayRef2(
                          mclVv(PulseInterp, "PulseInterp"),
                          mlfColon(
                            mclVv(LastNonZeroInterp, "LastNonZeroInterp"),
                            mlfEnd(
                              mclVv(PulseInterp, "PulseInterp"),
                              _mxarray0_,
                              _mxarray4_),
                            NULL),
                          _mxarray4_),
                        _mxarray1_)),
                    NULL,
                    NULL),
                  mclVv(LastNonZeroInterp, "LastNonZeroInterp")),
                _mxarray4_));
            /*
             * PulseInterp(1:FirstNonZeroInterp-1,2)=0;
             */
            mclArrayAssign2(
              &PulseInterp,
              _mxarray1_,
              mlfColon(
                _mxarray0_,
                mclMinus(
                  mclVv(FirstNonZeroInterp, "FirstNonZeroInterp"), _mxarray0_),
                NULL),
              _mxarray4_);
            /*
             * PulseInterp(LastNonZeroInterp+1:end,2)=0;
             */
            mclArrayAssign2(
              &PulseInterp,
              _mxarray1_,
              mlfColon(
                mclPlus(
                  mclVv(LastNonZeroInterp, "LastNonZeroInterp"), _mxarray0_),
                mlfEnd(
                  mclVv(PulseInterp, "PulseInterp"), _mxarray0_, _mxarray4_),
                NULL),
              _mxarray4_);
            /*
             * [Max,Indx]=max(PulseInterp(:,2));
             */
            mlfAssign(
              &Max,
              mlfMax(
                &Indx,
                mclArrayRef2(
                  mclVv(PulseInterp, "PulseInterp"),
                  mlfCreateColonIndex(),
                  _mxarray4_),
                NULL,
                NULL));
            /*
             * PulseInterp(:,2)=PulseInterp(:,2)/Max;
             */
            mclArrayAssign2(
              &PulseInterp,
              mclMrdivide(
                mclArrayRef2(
                  mclVv(PulseInterp, "PulseInterp"),
                  mlfCreateColonIndex(),
                  _mxarray4_),
                mclVv(Max, "Max")),
              mlfCreateColonIndex(),
              _mxarray4_);
            /*
             * PulseInterp(:,2)=circshift(PulseInterp(:,2),MaxPulseInterpIndx-Indx);
             */
            mclArrayAssign2(
              &PulseInterp,
              mlfCircshift(
                mclArrayRef2(
                  mclVv(PulseInterp, "PulseInterp"),
                  mlfCreateColonIndex(),
                  _mxarray4_),
                mclMinus(
                  mclVv(MaxPulseInterpIndx, "MaxPulseInterpIndx"),
                  mclVv(Indx, "Indx"))),
              mlfCreateColonIndex(),
              _mxarray4_);
            /*
             * 
             * 
             * FitInterpPulseInterval=(FitPulseInterval-1)*InterpN+1;
             */
            mlfAssign(
              &FitInterpPulseInterval,
              mclPlus(
                mclMtimes(
                  mclMinus(
                    mclVv(FitPulseInterval, "FitPulseInterval"), _mxarray0_),
                  mclVv(InterpN, "InterpN")),
                _mxarray0_));
            /*
             * FitInterpPulseInterval=[FitInterpPulseInterval(1):FitInterpPulseInterval(end)];
             */
            mlfAssign(
              &FitInterpPulseInterval,
              mlfColon(
                mclIntArrayRef1(
                  mclVv(FitInterpPulseInterval, "FitInterpPulseInterval"), 1),
                mclArrayRef1(
                  mclVv(FitInterpPulseInterval, "FitInterpPulseInterval"),
                  mlfEnd(
                    mclVv(FitInterpPulseInterval, "FitInterpPulseInterval"),
                    _mxarray0_,
                    _mxarray0_)),
                NULL));
            /*
             * 
             * PulseInterpFine(:,2)=interp1(StandardPulseNorm,PulseInterpFine(:,1),'spline');
             */
            mclArrayAssign2(
              &PulseInterpFine,
              mlfInterp1(
                mclVv(StandardPulseNorm, "StandardPulseNorm"),
                mclArrayRef2(
                  mclVv(PulseInterpFine, "PulseInterpFine"),
                  mlfCreateColonIndex(),
                  _mxarray0_),
                _mxarray68_,
                NULL),
              mlfCreateColonIndex(),
              _mxarray4_);
            /*
             * 
             * FirstNonZeroInterpFine=(FirstNonZero-1)*FineInterpN+1;           %expected from StandardPulseNorm
             */
            mlfAssign(
              &FirstNonZeroInterpFine,
              mclPlus(
                mclMtimes(
                  mclMinus(mclVv(FirstNonZero, "FirstNonZero"), _mxarray0_),
                  mclVv(FineInterpN, "FineInterpN")),
                _mxarray0_));
            /*
             * LastNonZeroInterpFine =(LastNonZero-1)*FineInterpN+1;            %expected from StandardPulseNorm
             */
            mlfAssign(
              &LastNonZeroInterpFine,
              mclPlus(
                mclMtimes(
                  mclMinus(mclVv(LastNonZero, "LastNonZero"), _mxarray0_),
                  mclVv(FineInterpN, "FineInterpN")),
                _mxarray0_));
            /*
             * MaxPulseInterpFineIndx=(MaxStandardPulseIndx-1)*FineInterpN+1;   %expected from StandardPulseNorm
             */
            mlfAssign(
              &MaxPulseInterpFineIndx,
              mclPlus(
                mclMtimes(
                  mclMinus(
                    mclVv(MaxStandardPulseIndx, "MaxStandardPulseIndx"),
                    _mxarray0_),
                  mclVv(FineInterpN, "FineInterpN")),
                _mxarray0_));
            /*
             * %corrections: 
             * FirstNonZeroInterpFine=max(find(PulseInterpFine(1:FirstNonZeroInterpFine,2)<=0))+1;
             */
            mlfAssign(
              &FirstNonZeroInterpFine,
              mclPlus(
                mlfMax(
                  NULL,
                  mlfFind(
                    NULL,
                    NULL,
                    mclLe(
                      mclArrayRef2(
                        mclVv(PulseInterpFine, "PulseInterpFine"),
                        mlfColon(
                          _mxarray0_,
                          mclVv(
                            FirstNonZeroInterpFine, "FirstNonZeroInterpFine"),
                          NULL),
                        _mxarray4_),
                      _mxarray1_)),
                  NULL,
                  NULL),
                _mxarray0_));
            /*
             * LastNonZeroInterpFine=min(find(PulseInterpFine(LastNonZeroInterpFine:end,2)<=0))+LastNonZeroInterpFine-2;
             */
            mlfAssign(
              &LastNonZeroInterpFine,
              mclMinus(
                mclPlus(
                  mlfMin(
                    NULL,
                    mlfFind(
                      NULL,
                      NULL,
                      mclLe(
                        mclArrayRef2(
                          mclVv(PulseInterpFine, "PulseInterpFine"),
                          mlfColon(
                            mclVv(
                              LastNonZeroInterpFine, "LastNonZeroInterpFine"),
                            mlfEnd(
                              mclVv(PulseInterpFine, "PulseInterpFine"),
                              _mxarray0_,
                              _mxarray4_),
                            NULL),
                          _mxarray4_),
                        _mxarray1_)),
                    NULL,
                    NULL),
                  mclVv(LastNonZeroInterpFine, "LastNonZeroInterpFine")),
                _mxarray4_));
            /*
             * PulseInterpFine(1:FirstNonZeroInterpFine-1,2)=0;
             */
            mclArrayAssign2(
              &PulseInterpFine,
              _mxarray1_,
              mlfColon(
                _mxarray0_,
                mclMinus(
                  mclVv(FirstNonZeroInterpFine, "FirstNonZeroInterpFine"),
                  _mxarray0_),
                NULL),
              _mxarray4_);
            /*
             * PulseInterpFine(LastNonZeroInterpFine+1:end,2)=0;   
             */
            mclArrayAssign2(
              &PulseInterpFine,
              _mxarray1_,
              mlfColon(
                mclPlus(
                  mclVv(LastNonZeroInterpFine, "LastNonZeroInterpFine"),
                  _mxarray0_),
                mlfEnd(
                  mclVv(PulseInterpFine, "PulseInterpFine"),
                  _mxarray0_,
                  _mxarray4_),
                NULL),
              _mxarray4_);
            /*
             * [Max,Indx]=max(PulseInterpFine(:,2));
             */
            mlfAssign(
              &Max,
              mlfMax(
                &Indx,
                mclArrayRef2(
                  mclVv(PulseInterpFine, "PulseInterpFine"),
                  mlfCreateColonIndex(),
                  _mxarray4_),
                NULL,
                NULL));
            /*
             * PulseInterpFine(:,2)=PulseInterpFine(:,2)/Max;
             */
            mclArrayAssign2(
              &PulseInterpFine,
              mclMrdivide(
                mclArrayRef2(
                  mclVv(PulseInterpFine, "PulseInterpFine"),
                  mlfCreateColonIndex(),
                  _mxarray4_),
                mclVv(Max, "Max")),
              mlfCreateColonIndex(),
              _mxarray4_);
            /*
             * PulseInterpFine(:,2)=circshift(PulseInterpFine(:,2),MaxPulseInterpFineIndx-Indx);
             */
            mclArrayAssign2(
              &PulseInterpFine,
              mlfCircshift(
                mclArrayRef2(
                  mclVv(PulseInterpFine, "PulseInterpFine"),
                  mlfCreateColonIndex(),
                  _mxarray4_),
                mclMinus(
                  mclVv(MaxPulseInterpFineIndx, "MaxPulseInterpFineIndx"),
                  mclVv(Indx, "Indx"))),
              mlfCreateColonIndex(),
              _mxarray4_);
            /*
             * FirstNonZeroInterpFine=FirstNonZeroInterpFine+MaxPulseInterpFineIndx-Indx;
             */
            mlfAssign(
              &FirstNonZeroInterpFine,
              mclMinus(
                mclPlus(
                  mclVv(FirstNonZeroInterpFine, "FirstNonZeroInterpFine"),
                  mclVv(MaxPulseInterpFineIndx, "MaxPulseInterpFineIndx")),
                mclVv(Indx, "Indx")));
            /*
             * LastNonZeroInterpFine=LastNonZeroInterpFine+MaxPulseInterpFineIndx-Indx;
             */
            mlfAssign(
              &LastNonZeroInterpFine,
              mclMinus(
                mclPlus(
                  mclVv(LastNonZeroInterpFine, "LastNonZeroInterpFine"),
                  mclVv(MaxPulseInterpFineIndx, "MaxPulseInterpFineIndx")),
                mclVv(Indx, "Indx")));
            /*
             * 
             * 
             * FitFineInterpPulseInterval=(FitPulseInterval-1)*FineInterpN+1;
             */
            mlfAssign(
              &FitFineInterpPulseInterval,
              mclPlus(
                mclMtimes(
                  mclMinus(
                    mclVv(FitPulseInterval, "FitPulseInterval"), _mxarray0_),
                  mclVv(FineInterpN, "FineInterpN")),
                _mxarray0_));
            /*
             * FitFineInterpPulseInterval=[FitFineInterpPulseInterval(1):FitFineInterpPulseInterval(end)];
             */
            mlfAssign(
              &FitFineInterpPulseInterval,
              mlfColon(
                mclIntArrayRef1(
                  mclVv(
                    FitFineInterpPulseInterval, "FitFineInterpPulseInterval"),
                  1),
                mclArrayRef1(
                  mclVv(
                    FitFineInterpPulseInterval, "FitFineInterpPulseInterval"),
                  mlfEnd(
                    mclVv(
                      FitFineInterpPulseInterval, "FitFineInterpPulseInterval"),
                    _mxarray0_,
                    _mxarray0_)),
                NULL));
            /*
             * 
             * 
             * %FitN=1+EndFitPoint+StartFitPoint;
             * 
             * 
             * 
             * StandardPulseNorm(:,2)=StandardPulseNorm;
             */
            mclArrayAssign2(
              &StandardPulseNorm,
              mclVv(StandardPulseNorm, "StandardPulseNorm"),
              mlfCreateColonIndex(),
              _mxarray4_);
            /*
             * StandardPulseNorm(:,1)=[1-MaxStandardPulseIndx:SampleN-MaxStandardPulseIndx]';
             */
            mclArrayAssign2(
              &StandardPulseNorm,
              mlfCtranspose(
                mlfColon(
                  mclMinus(
                    _mxarray0_,
                    mclVv(MaxStandardPulseIndx, "MaxStandardPulseIndx")),
                  mclMinus(
                    mclVv(SampleN, "SampleN"),
                    mclVv(MaxStandardPulseIndx, "MaxStandardPulseIndx")),
                  NULL)),
              mlfCreateColonIndex(),
              _mxarray0_);
            /*
             * 
             * PulseInterp(:,1)=[1-MaxPulseInterpIndx:SampleInterpN-MaxPulseInterpIndx]'/InterpN;               
             */
            mclArrayAssign2(
              &PulseInterp,
              mclMrdivide(
                mlfCtranspose(
                  mlfColon(
                    mclMinus(
                      _mxarray0_,
                      mclVv(MaxPulseInterpIndx, "MaxPulseInterpIndx")),
                    mclMinus(
                      mclVv(SampleInterpN, "SampleInterpN"),
                      mclVv(MaxPulseInterpIndx, "MaxPulseInterpIndx")),
                    NULL)),
                mclVv(InterpN, "InterpN")),
              mlfCreateColonIndex(),
              _mxarray0_);
            /*
             * PulseInterpFine(:,1)=[1-MaxPulseInterpFineIndx:SampleInterpFineN-MaxPulseInterpFineIndx]'/FineInterpN;
             */
            mclArrayAssign2(
              &PulseInterpFine,
              mclMrdivide(
                mlfCtranspose(
                  mlfColon(
                    mclMinus(
                      _mxarray0_,
                      mclVv(MaxPulseInterpFineIndx, "MaxPulseInterpFineIndx")),
                    mclMinus(
                      mclVv(SampleInterpFineN, "SampleInterpFineN"),
                      mclVv(MaxPulseInterpFineIndx, "MaxPulseInterpFineIndx")),
                    NULL)),
                mclVv(FineInterpN, "FineInterpN")),
              mlfCreateColonIndex(),
              _mxarray0_);
            /*
             * 
             * tic;
             */
            mlfTic();
            /*
             * 
             * InterpHalfRange=2*InterpN;
             */
            mlfAssign(
              &InterpHalfRange,
              mclMtimes(_mxarray4_, mclVv(InterpN, "InterpN")));
            /*
             * InterpRange=2*InterpHalfRange+1;
             */
            mlfAssign(
              &InterpRange,
              mclPlus(
                mclMtimes(
                  _mxarray4_, mclVv(InterpHalfRange, "InterpHalfRange")),
                _mxarray0_));
            /*
             * for i=1:InterpRange for k=1:InterpRange DiagLogic(i,k)=i==k; end; end;
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVv(InterpRange, "InterpRange"));
                if (v_ > e_) {
                    mlfAssign(&i, _mxarray42_);
                } else {
                    for (; ; ) {
                        int v_0 = mclForIntStart(1);
                        int e_0
                          = mclForIntEnd(mclVv(InterpRange, "InterpRange"));
                        if (v_0 > e_0) {
                            mlfAssign(&k, _mxarray42_);
                        } else {
                            for (; ; ) {
                                mclIntArrayAssign2(
                                  &DiagLogic,
                                  mclBoolToArray(v_ == v_0),
                                  v_,
                                  v_0);
                                if (v_0 == e_0) {
                                    break;
                                }
                                ++v_0;
                            }
                            mlfAssign(&k, mlfScalar(v_0));
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
             * x=FitInterpPulseInterval(1):InterpN:FitInterpPulseInterval(end);
             */
            mlfAssign(
              &x,
              mlfColon(
                mclIntArrayRef1(
                  mclVv(FitInterpPulseInterval, "FitInterpPulseInterval"), 1),
                mclVv(InterpN, "InterpN"),
                mclArrayRef1(
                  mclVv(FitInterpPulseInterval, "FitInterpPulseInterval"),
                  mlfEnd(
                    mclVv(FitInterpPulseInterval, "FitInterpPulseInterval"),
                    _mxarray0_,
                    _mxarray0_))));
            /*
             * %x=[MaxPulseInterpIndx-StartFitPoint*InterpN:InterpN:MaxPulseInterpIndx+EndFitPoint*InterpN]';
             * for i=1:InterpRange
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVv(InterpRange, "InterpRange"));
                if (v_ > e_) {
                    mlfAssign(&i, _mxarray42_);
                } else {
                    /*
                     * PulseInterpShifted=circshift(PulseInterp(:,2),-InterpHalfRange-1+i);
                     * FitPulses(1:FitN,i)=PulseInterpShifted(x);
                     * Sums3(i,1)=FitPulses(:,i)'*FitPulses(:,i);
                     * Sums3Short(i,1)=FitPulses(1:FitN-BeyondMaxN,i)'*FitPulses(1:FitN-BeyondMaxN,i);
                     * end;
                     */
                    for (; ; ) {
                        mlfAssign(
                          &PulseInterpShifted,
                          mlfCircshift(
                            mclArrayRef2(
                              mclVv(PulseInterp, "PulseInterp"),
                              mlfCreateColonIndex(),
                              _mxarray4_),
                            mclPlus(
                              mclMinus(
                                mclUminus(
                                  mclVv(InterpHalfRange, "InterpHalfRange")),
                                _mxarray0_),
                              mlfScalar(v_))));
                        mclArrayAssign2(
                          &FitPulses,
                          mclArrayRef1(
                            mclVv(PulseInterpShifted, "PulseInterpShifted"),
                            mclVv(x, "x")),
                          mlfColon(_mxarray0_, mclVv(FitN, "FitN"), NULL),
                          mlfScalar(v_));
                        mclIntArrayAssign2(
                          &Sums3,
                          mlf_times_transpose(
                            mclArrayRef2(
                              mclVv(FitPulses, "FitPulses"),
                              mlfCreateColonIndex(),
                              mlfScalar(v_)),
                            mclArrayRef2(
                              mclVv(FitPulses, "FitPulses"),
                              mlfCreateColonIndex(),
                              mlfScalar(v_)),
                            _mxarray70_),
                          v_,
                          1);
                        mclIntArrayAssign2(
                          &Sums3Short,
                          mlf_times_transpose(
                            mclArrayRef2(
                              mclVv(FitPulses, "FitPulses"),
                              mlfColon(
                                _mxarray0_,
                                mclMinus(
                                  mclVv(FitN, "FitN"),
                                  mclVv(BeyondMaxN, "BeyondMaxN")),
                                NULL),
                              mlfScalar(v_)),
                            mclArrayRef2(
                              mclVv(FitPulses, "FitPulses"),
                              mlfColon(
                                _mxarray0_,
                                mclMinus(
                                  mclVv(FitN, "FitN"),
                                  mclVv(BeyondMaxN, "BeyondMaxN")),
                                NULL),
                              mlfScalar(v_)),
                            _mxarray70_),
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
         * end;
         */
        }
        /*
         * PulseInterpFineShifted=PulseInterpFine;
         */
        mlfAssign(
          &PulseInterpFineShifted, mclVv(PulseInterpFine, "PulseInterpFine"));
        /*
         * PulseInterpShiftedTest=PulseInterpShifted;
         */
        mlfAssign(
          &PulseInterpShiftedTest,
          mclVv(PulseInterpShifted, "PulseInterpShifted"));
        /*
         * 
         * trekMinus=trek;
         */
        mlfAssign(&trekMinus, mclVv(trek, "trek"));
        /*
         * i=0;      
         */
        mlfAssign(&i, _mxarray1_);
        /*
         * if Pass==1 peaks=[]; end;
         */
        if (mclEqBool(mclVv(Pass, "Pass"), _mxarray0_)) {
            mlfAssign(&peaks, _mxarray42_);
        }
        /*
         * Khi2Fin=[];
         */
        mlfAssign(&Khi2Fin, _mxarray42_);
        /*
         * KhiCoeff=1/FitN/StdVal^2;
         */
        mlfAssign(
          &KhiCoeff,
          mclMrdivide(
            mclMrdivide(_mxarray0_, mclVv(FitN, "FitN")),
            mclMpower(mclVv(StdVal, "StdVal"), _mxarray4_)));
        /*
         * KhiCoeffShort=1/(FitN-BeyondMaxN)/StdVal^2;
         */
        mlfAssign(
          &KhiCoeffShort,
          mclMrdivide(
            mclMrdivide(
              _mxarray0_,
              mclMinus(mclVv(FitN, "FitN"), mclVv(BeyondMaxN, "BeyondMaxN"))),
            mclMpower(mclVv(StdVal, "StdVal"), _mxarray4_)));
        /*
         * 
         * %figure; plot(trek(1:1000,2));
         * 
         * FitBackgndInterval=FitBackgndInterval-MaxStandardPulseIndx;
         */
        mlfAssign(
          &FitBackgndInterval,
          mclMinus(
            mclVv(FitBackgndInterval, "FitBackgndInterval"),
            mclVv(MaxStandardPulseIndx, "MaxStandardPulseIndx")));
        /*
         * FitPulseInterval=FitPulseInterval-MaxStandardPulseIndx;
         */
        mlfAssign(
          &FitPulseInterval,
          mclMinus(
            mclVv(FitPulseInterval, "FitPulseInterval"),
            mclVv(MaxStandardPulseIndx, "MaxStandardPulseIndx")));
        /*
         * StartFitPoint=FitPulseInterval(1);
         */
        mlfAssign(
          &StartFitPoint,
          mclIntArrayRef1(mclVv(FitPulseInterval, "FitPulseInterval"), 1));
        /*
         * fprintf('scan the trek with Standard pulse...\n');   tic; 
         */
        mclAssignAns(&ans, mlfNFprintf(0, _mxarray71_, NULL));
        mlfTic();
        /*
         * while i<size(PeakInd,1)
         */
        while (mclLtBool(
                 mclVv(i, "i"),
                 mlfSize(
                   mclValueVarargout(),
                   mclVv(PeakInd, "PeakInd"),
                   _mxarray0_))) {
            /*
             * i=i+1;
             */
            mlfAssign(&i, mclPlus(mclVv(i, "i"), _mxarray0_));
            /*
             * A=[];B=[];Sum1=[];Sum2=[];Sum3=[];Khi2Fit=[];PolyKhi2=[];FitSignal=[];FitPulseFin=[];
             */
            mlfAssign(&A, _mxarray42_);
            mlfAssign(&B, _mxarray42_);
            mlfAssign(&Sum1, _mxarray42_);
            mlfAssign(&Sum2, _mxarray42_);
            mlfAssign(&Sum3, _mxarray42_);
            mlfAssign(&Khi2Fit, _mxarray42_);
            mlfAssign(&PolyKhi2, _mxarray42_);
            mlfAssign(&FitSignal, _mxarray42_);
            mlfAssign(&FitPulseFin, _mxarray42_);
            /*
             * MinKhi2(i)=-1;
             */
            mclArrayAssign1(&MinKhi2, _mxarray43_, mclVv(i, "i"));
            /*
             * if Pass==2
             */
            if (mclEqBool(mclVv(Pass, "Pass"), _mxarray4_)) {
                /*
                 * i=i;
                 */
                mlfAssign(&i, mclVv(i, "i"));
            /*
             * end;
             */
            }
            /*
             * BckgIndx=PeakInd(i)+FitBackgndInterval;  BckgIndx(BckgIndx<1)=1;
             */
            mlfAssign(
              &BckgIndx,
              mclPlus(
                mclArrayRef1(mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                mclVv(FitBackgndInterval, "FitBackgndInterval")));
            mclArrayAssign1(
              &BckgIndx,
              _mxarray0_,
              mclLt(mclVv(BckgIndx, "BckgIndx"), _mxarray0_));
            /*
             * B(i)=mean(trekMinus(BckgIndx,2));
             */
            mclArrayAssign1(
              &B,
              mlfMean(
                mclArrayRef2(
                  mclVv(trekMinus, "trekMinus"),
                  mclVv(BckgIndx, "BckgIndx"),
                  _mxarray4_),
                NULL),
              mclVv(i, "i"));
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
             * 
             * FitSignal=[];   
             */
            mlfAssign(&FitSignal, _mxarray42_);
            /*
             * FitSignalStart=PeakInd(i)+StartFitPoint;   
             */
            mlfAssign(
              &FitSignalStart,
              mclPlus(
                mclArrayRef1(mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                mclVv(StartFitPoint, "StartFitPoint")));
            /*
             * if FitSignalStart(1)>2
             */
            if (mclGtBool(
                  mclIntArrayRef1(mclVv(FitSignalStart, "FitSignalStart"), 1),
                  _mxarray4_)) {
                /*
                 * if ShortFit
                 */
                if (mlfTobool(mclVv(ShortFit, "ShortFit"))) {
                    /*
                     * FitNi=FitN-BeyondMaxN;
                     */
                    mlfAssign(
                      &FitNi,
                      mclMinus(
                        mclVv(FitN, "FitN"), mclVv(BeyondMaxN, "BeyondMaxN")));
                    /*
                     * FitSignal(1:FitNi,:)=trekMinus(FitSignalStart:FitSignalStart+FitNi-1,:);
                     */
                    mclArrayAssign2(
                      &FitSignal,
                      mclArrayRef2(
                        mclVv(trekMinus, "trekMinus"),
                        mlfColon(
                          mclVv(FitSignalStart, "FitSignalStart"),
                          mclMinus(
                            mclPlus(
                              mclVv(FitSignalStart, "FitSignalStart"),
                              mclVv(FitNi, "FitNi")),
                            _mxarray0_),
                          NULL),
                        mlfCreateColonIndex()),
                      mlfColon(_mxarray0_, mclVv(FitNi, "FitNi"), NULL),
                      mlfCreateColonIndex());
                    /*
                     * NetFitSignal=FitSignal(1:FitNi,2)-B(i);
                     */
                    mlfAssign(
                      &NetFitSignal,
                      mclMinus(
                        mclArrayRef2(
                          mclVv(FitSignal, "FitSignal"),
                          mlfColon(_mxarray0_, mclVv(FitNi, "FitNi"), NULL),
                          _mxarray4_),
                        mclArrayRef1(mclVv(B, "B"), mclVv(i, "i"))));
                    /*
                     * Sums1=NetFitSignal'*NetFitSignal;
                     */
                    mlfAssign(
                      &Sums1,
                      mlf_times_transpose(
                        mclVv(NetFitSignal, "NetFitSignal"),
                        mclVv(NetFitSignal, "NetFitSignal"),
                        _mxarray70_));
                    /*
                     * Sums2=FitPulses(1:FitNi,:)'*NetFitSignal;
                     */
                    mlfAssign(
                      &Sums2,
                      mlf_times_transpose(
                        mclArrayRef2(
                          mclVv(FitPulses, "FitPulses"),
                          mlfColon(_mxarray0_, mclVv(FitNi, "FitNi"), NULL),
                          mlfCreateColonIndex()),
                        mclVv(NetFitSignal, "NetFitSignal"),
                        _mxarray70_));
                    /*
                     * Khi2Fit=Sums1-(Sums2.^2)./Sums3Short;
                     */
                    mlfAssign(
                      &Khi2Fit,
                      mclMinus(
                        mclVv(Sums1, "Sums1"),
                        mclRdivide(
                          mlfPower(mclVv(Sums2, "Sums2"), _mxarray4_),
                          mclVv(Sums3Short, "Sums3Short"))));
                    /*
                     * Khi2Fit=Khi2Fit*KhiCoeffShort;
                     */
                    mlfAssign(
                      &Khi2Fit,
                      mclMtimes(
                        mclVv(Khi2Fit, "Khi2Fit"),
                        mclVv(KhiCoeffShort, "KhiCoeffShort")));
                /*
                 * else
                 */
                } else {
                    /*
                     * FitNi=FitN;
                     */
                    mlfAssign(&FitNi, mclVv(FitN, "FitN"));
                    /*
                     * FitSignal(1:FitNi,:)=trekMinus(FitSignalStart:FitSignalStart+FitNi-1,:);
                     */
                    mclArrayAssign2(
                      &FitSignal,
                      mclArrayRef2(
                        mclVv(trekMinus, "trekMinus"),
                        mlfColon(
                          mclVv(FitSignalStart, "FitSignalStart"),
                          mclMinus(
                            mclPlus(
                              mclVv(FitSignalStart, "FitSignalStart"),
                              mclVv(FitNi, "FitNi")),
                            _mxarray0_),
                          NULL),
                        mlfCreateColonIndex()),
                      mlfColon(_mxarray0_, mclVv(FitNi, "FitNi"), NULL),
                      mlfCreateColonIndex());
                    /*
                     * NetFitSignal=FitSignal(1:FitNi,2)-B(i);
                     */
                    mlfAssign(
                      &NetFitSignal,
                      mclMinus(
                        mclArrayRef2(
                          mclVv(FitSignal, "FitSignal"),
                          mlfColon(_mxarray0_, mclVv(FitNi, "FitNi"), NULL),
                          _mxarray4_),
                        mclArrayRef1(mclVv(B, "B"), mclVv(i, "i"))));
                    /*
                     * Sums1=NetFitSignal'*NetFitSignal;
                     */
                    mlfAssign(
                      &Sums1,
                      mlf_times_transpose(
                        mclVv(NetFitSignal, "NetFitSignal"),
                        mclVv(NetFitSignal, "NetFitSignal"),
                        _mxarray70_));
                    /*
                     * Sums2=FitPulses'*NetFitSignal;
                     */
                    mlfAssign(
                      &Sums2,
                      mlf_times_transpose(
                        mclVv(FitPulses, "FitPulses"),
                        mclVv(NetFitSignal, "NetFitSignal"),
                        _mxarray70_));
                    /*
                     * Khi2Fit=Sums1-(Sums2.^2)./Sums3;
                     */
                    mlfAssign(
                      &Khi2Fit,
                      mclMinus(
                        mclVv(Sums1, "Sums1"),
                        mclRdivide(
                          mlfPower(mclVv(Sums2, "Sums2"), _mxarray4_),
                          mclVv(Sums3, "Sums3"))));
                    /*
                     * Khi2Fit=Khi2Fit*KhiCoeff;
                     */
                    mlfAssign(
                      &Khi2Fit,
                      mclMtimes(
                        mclVv(Khi2Fit, "Khi2Fit"),
                        mclVv(KhiCoeff, "KhiCoeff")));
                /*
                 * end;
                 */
                }
                /*
                 * %figure; plot(Khi2Fit,'-ko'); hold on;
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
                 * CoarseShift=(MinKhi2Idx(i)-InterpHalfRange-1);
                 */
                mlfAssign(
                  &CoarseShift,
                  mclMinus(
                    mclMinus(
                      mclArrayRef1(
                        mclVv(MinKhi2Idx, "MinKhi2Idx"), mclVv(i, "i")),
                      mclVv(InterpHalfRange, "InterpHalfRange")),
                    _mxarray0_));
                /*
                 * NfromEdge=min(MinKhi2Idx(i)-1,InterpRange-MinKhi2Idx(i));
                 */
                mlfAssign(
                  &NfromEdge,
                  mlfMin(
                    NULL,
                    mclMinus(
                      mclArrayRef1(
                        mclVv(MinKhi2Idx, "MinKhi2Idx"), mclVv(i, "i")),
                      _mxarray0_),
                    mclMinus(
                      mclVv(InterpRange, "InterpRange"),
                      mclArrayRef1(
                        mclVv(MinKhi2Idx, "MinKhi2Idx"), mclVv(i, "i"))),
                    NULL));
                /*
                 * if NfromEdge>0
                 */
                if (mclGtBool(mclVv(NfromEdge, "NfromEdge"), _mxarray1_)) {
                    /*
                     * KhiFitN=min(NfromEdge,2);
                     */
                    mlfAssign(
                      &KhiFitN,
                      mlfMin(
                        NULL, mclVv(NfromEdge, "NfromEdge"), _mxarray4_, NULL));
                    /*
                     * x=[MinKhi2Idx(i)-KhiFitN:1:MinKhi2Idx(i)+KhiFitN]';
                     */
                    mlfAssign(
                      &x,
                      mlfCtranspose(
                        mlfColon(
                          mclMinus(
                            mclArrayRef1(
                              mclVv(MinKhi2Idx, "MinKhi2Idx"), mclVv(i, "i")),
                            mclVv(KhiFitN, "KhiFitN")),
                          _mxarray0_,
                          mclPlus(
                            mclArrayRef1(
                              mclVv(MinKhi2Idx, "MinKhi2Idx"), mclVv(i, "i")),
                            mclVv(KhiFitN, "KhiFitN")))));
                    /*
                     * if ShortFit A=Sums2(x)./Sums3Short(x); else A=Sums2(x)./Sums3(x);end;
                     */
                    if (mlfTobool(mclVv(ShortFit, "ShortFit"))) {
                        mlfAssign(
                          &A,
                          mclRdivide(
                            mclArrayRef1(mclVv(Sums2, "Sums2"), mclVv(x, "x")),
                            mclArrayRef1(
                              mclVv(Sums3Short, "Sums3Short"), mclVv(x, "x"))));
                    } else {
                        mlfAssign(
                          &A,
                          mclRdivide(
                            mclArrayRef1(mclVv(Sums2, "Sums2"), mclVv(x, "x")),
                            mclArrayRef1(
                              mclVv(Sums3, "Sums3"), mclVv(x, "x"))));
                    }
                    /*
                     * PolyKhi2=polyfit(x,Khi2Fit(x),2);
                     */
                    mlfAssign(
                      &PolyKhi2,
                      mlfNPolyfit(
                        1,
                        NULL,
                        NULL,
                        mclVv(x, "x"),
                        mclArrayRef1(mclVv(Khi2Fit, "Khi2Fit"), mclVv(x, "x")),
                        _mxarray4_));
                    /*
                     * Khi2MinIdxFine=-PolyKhi2(2)/(2*PolyKhi2(1));
                     */
                    mlfAssign(
                      &Khi2MinIdxFine,
                      mclMrdivide(
                        mclUminus(
                          mclIntArrayRef1(mclVv(PolyKhi2, "PolyKhi2"), 2)),
                        mclMtimes(
                          _mxarray4_,
                          mclIntArrayRef1(mclVv(PolyKhi2, "PolyKhi2"), 1))));
                    /*
                     * MinKhi2(i)=PolyKhi2(1)*Khi2MinIdxFine^2+PolyKhi2(2)*Khi2MinIdxFine+PolyKhi2(3);
                     */
                    mclArrayAssign1(
                      &MinKhi2,
                      mclPlus(
                        mclPlus(
                          mclMtimes(
                            mclIntArrayRef1(mclVv(PolyKhi2, "PolyKhi2"), 1),
                            mclMpower(
                              mclVv(Khi2MinIdxFine, "Khi2MinIdxFine"),
                              _mxarray4_)),
                          mclMtimes(
                            mclIntArrayRef1(mclVv(PolyKhi2, "PolyKhi2"), 2),
                            mclVv(Khi2MinIdxFine, "Khi2MinIdxFine"))),
                        mclIntArrayRef1(mclVv(PolyKhi2, "PolyKhi2"), 3)),
                      mclVv(i, "i"));
                    /*
                     * %plot(Khi2MinIdxFine,MinKhi2(i),'or');
                     * Ampl=interp1(x,A,Khi2MinIdxFine,'spline');
                     */
                    mlfAssign(
                      &Ampl,
                      mlfInterp1(
                        mclVv(x, "x"),
                        mclVv(A, "A"),
                        mclVv(Khi2MinIdxFine, "Khi2MinIdxFine"),
                        _mxarray68_,
                        NULL));
                    /*
                     * FineShift(i)=round(FineInterpN/InterpN*(Khi2MinIdxFine-MinKhi2Idx(i)));
                     */
                    mclArrayAssign1(
                      &FineShift,
                      mlfRound(
                        mclMtimes(
                          mclMrdivide(
                            mclVv(FineInterpN, "FineInterpN"),
                            mclVv(InterpN, "InterpN")),
                          mclMinus(
                            mclVv(Khi2MinIdxFine, "Khi2MinIdxFine"),
                            mclArrayRef1(
                              mclVv(MinKhi2Idx, "MinKhi2Idx"),
                              mclVv(i, "i"))))),
                      mclVv(i, "i"));
                    /*
                     * FineShift(i)=CoarseShift*FineInterpN/InterpN+FineShift(i);
                     */
                    mclArrayAssign1(
                      &FineShift,
                      mclPlus(
                        mclMrdivide(
                          mclMtimes(
                            mclVv(CoarseShift, "CoarseShift"),
                            mclVv(FineInterpN, "FineInterpN")),
                          mclVv(InterpN, "InterpN")),
                        mclArrayRef1(
                          mclVv(FineShift, "FineShift"), mclVv(i, "i"))),
                      mclVv(i, "i"));
                    /*
                     * PulseInterpFineShifted=circshift(PulseInterpFine(:,2),FineShift(i));
                     */
                    mlfAssign(
                      &PulseInterpFineShifted,
                      mlfCircshift(
                        mclArrayRef2(
                          mclVv(PulseInterpFine, "PulseInterpFine"),
                          mlfCreateColonIndex(),
                          _mxarray4_),
                        mclArrayRef1(
                          mclVv(FineShift, "FineShift"), mclVv(i, "i"))));
                    /*
                     * dt(i)=FineShift(i)/FineInterpN*tau;
                     */
                    mclArrayAssign1(
                      &dt,
                      mclMtimes(
                        mclMrdivide(
                          mclArrayRef1(
                            mclVv(FineShift, "FineShift"), mclVv(i, "i")),
                          mclVv(FineInterpN, "FineInterpN")),
                        mclVv(tau, "tau")),
                      mclVv(i, "i"));
                /*
                 * else
                 */
                } else {
                    /*
                     * if MinKhi2Idx(i)==1
                     */
                    if (mclEqBool(
                          mclArrayRef1(
                            mclVv(MinKhi2Idx, "MinKhi2Idx"), mclVv(i, "i")),
                          _mxarray0_)) {
                        /*
                         * MinKhi2Idx(i)=1; MinKhi2(i)=Khi2Fit(1);
                         */
                        mclArrayAssign1(&MinKhi2Idx, _mxarray0_, mclVv(i, "i"));
                        mclArrayAssign1(
                          &MinKhi2,
                          mclIntArrayRef1(mclVv(Khi2Fit, "Khi2Fit"), 1),
                          mclVv(i, "i"));
                        /*
                         * Ampl=Sums2(1)/Sums3(1);
                         */
                        mlfAssign(
                          &Ampl,
                          mclMrdivide(
                            mclIntArrayRef1(mclVv(Sums2, "Sums2"), 1),
                            mclIntArrayRef1(mclVv(Sums3, "Sums3"), 1)));
                        /*
                         * CoarseShift(i)=(MinKhi2Idx(i)-InterpHalfRange-1);
                         */
                        mclArrayAssign1(
                          &CoarseShift,
                          mclMinus(
                            mclMinus(
                              mclArrayRef1(
                                mclVv(MinKhi2Idx, "MinKhi2Idx"), mclVv(i, "i")),
                              mclVv(InterpHalfRange, "InterpHalfRange")),
                            _mxarray0_),
                          mclVv(i, "i"));
                        /*
                         * FineShift(i)=0;
                         */
                        mclArrayAssign1(&FineShift, _mxarray1_, mclVv(i, "i"));
                        /*
                         * PulseInterpFineShifted=circshift(PulseInterpFine(:,2),FineShift(i));
                         */
                        mlfAssign(
                          &PulseInterpFineShifted,
                          mlfCircshift(
                            mclArrayRef2(
                              mclVv(PulseInterpFine, "PulseInterpFine"),
                              mlfCreateColonIndex(),
                              _mxarray4_),
                            mclArrayRef1(
                              mclVv(FineShift, "FineShift"), mclVv(i, "i"))));
                        /*
                         * dt(i)=FineShift(i)/FineInterpN*tau;
                         */
                        mclArrayAssign1(
                          &dt,
                          mclMtimes(
                            mclMrdivide(
                              mclArrayRef1(
                                mclVv(FineShift, "FineShift"), mclVv(i, "i")),
                              mclVv(FineInterpN, "FineInterpN")),
                            mclVv(tau, "tau")),
                          mclVv(i, "i"));
                    /*
                     * end;
                     */
                    }
                    /*
                     * if MinKhi2Idx(i)==InterpRange
                     */
                    if (mclEqBool(
                          mclArrayRef1(
                            mclVv(MinKhi2Idx, "MinKhi2Idx"), mclVv(i, "i")),
                          mclVv(InterpRange, "InterpRange"))) {
                        /*
                         * MinKhi2Idx(i)=InterpRange;
                         */
                        mclArrayAssign1(
                          &MinKhi2Idx,
                          mclVv(InterpRange, "InterpRange"),
                          mclVv(i, "i"));
                        /*
                         * MinKhi2(i)=Khi2Fit(end);
                         */
                        mclArrayAssign1(
                          &MinKhi2,
                          mclArrayRef1(
                            mclVv(Khi2Fit, "Khi2Fit"),
                            mlfEnd(
                              mclVv(Khi2Fit, "Khi2Fit"),
                              _mxarray0_,
                              _mxarray0_)),
                          mclVv(i, "i"));
                        /*
                         * Ampl=Sums2(end)/Sums3(end);
                         */
                        mlfAssign(
                          &Ampl,
                          mclMrdivide(
                            mclArrayRef1(
                              mclVv(Sums2, "Sums2"),
                              mlfEnd(
                                mclVv(Sums2, "Sums2"), _mxarray0_, _mxarray0_)),
                            mclArrayRef1(
                              mclVv(Sums3, "Sums3"),
                              mlfEnd(
                                mclVv(Sums3, "Sums3"),
                                _mxarray0_,
                                _mxarray0_))));
                        /*
                         * CoarseShift(i)=(MinKhi2Idx(i)-InterpHalfRange-1);
                         */
                        mclArrayAssign1(
                          &CoarseShift,
                          mclMinus(
                            mclMinus(
                              mclArrayRef1(
                                mclVv(MinKhi2Idx, "MinKhi2Idx"), mclVv(i, "i")),
                              mclVv(InterpHalfRange, "InterpHalfRange")),
                            _mxarray0_),
                          mclVv(i, "i"));
                        /*
                         * FineShift(i)=0;
                         */
                        mclArrayAssign1(&FineShift, _mxarray1_, mclVv(i, "i"));
                        /*
                         * PulseInterpFineShifted=circshift(PulseInterpFine(:,2),FineShift(i));
                         */
                        mlfAssign(
                          &PulseInterpFineShifted,
                          mlfCircshift(
                            mclArrayRef2(
                              mclVv(PulseInterpFine, "PulseInterpFine"),
                              mlfCreateColonIndex(),
                              _mxarray4_),
                            mclArrayRef1(
                              mclVv(FineShift, "FineShift"), mclVv(i, "i"))));
                        /*
                         * dt(i)=FineShift(i)/FineInterpN*tau;
                         */
                        mclArrayAssign1(
                          &dt,
                          mclMtimes(
                            mclMrdivide(
                              mclArrayRef1(
                                mclVv(FineShift, "FineShift"), mclVv(i, "i")),
                              mclVv(FineInterpN, "FineInterpN")),
                            mclVv(tau, "tau")),
                          mclVv(i, "i"));
                    /*
                     * end;
                     */
                    }
                /*
                 * end;
                 */
                }
            /*
             * else MinKhi2(i)=-1;Ampl=-1; end; 
             */
            } else {
                mclArrayAssign1(&MinKhi2, _mxarray43_, mclVv(i, "i"));
                mlfAssign(&Ampl, _mxarray43_);
            }
            /*
             * 
             * 
             * %         close(PulsePlot);
             * %         PulsePlot=figure;   set(hp,'name',num2str(i));
             * %         plot([1:FitNi]'+StartFitPoint-1,NetFitSignal+B(i),'-bo'); hold on;
             * %         plot(FitBackgndInterval,trekMinus(PeakInd(i)+FitBackgndInterval,2),'-ko');
             * %         if NfromEdge>0
             * %             plot([1:FitNi]'+StartFitPoint-1,A(KhiFitN+1)*FitPulses(1:FitNi,MinKhi2Idx(i))+B(i),'-g.');
             * %             [Min,k]=min([Khi2Fit(MinKhi2Idx(i)-1),MinKhi2(i)*1000,Khi2Fit(MinKhi2Idx(i)+1)]);
             * %             plot([1:FitNi]'+StartFitPoint-1,A(KhiFitN+k-1)*FitPulses(1:FitNi,MinKhi2Idx(i)+k-2)+B(i),'-g.');
             * %         end;
             * %         plot(PulseInterpFine(:,1),Ampl*PulseInterpFineShifted+B(i),'-r');
             * %         pause(0.05);
             * FitIdx=PulseInterpFine(1:FineInterpN:end,1);
             */
            mlfAssign(
              &FitIdx,
              mclArrayRef2(
                mclVv(PulseInterpFine, "PulseInterpFine"),
                mlfColon(
                  _mxarray0_,
                  mclVv(FineInterpN, "FineInterpN"),
                  mlfEnd(
                    mclVv(PulseInterpFine, "PulseInterpFine"),
                    _mxarray0_,
                    _mxarray4_)),
                _mxarray0_));
            /*
             * SubtractedPulse=Ampl*PulseInterpFineShifted(1:FineInterpN:end);
             */
            mlfAssign(
              &SubtractedPulse,
              mclMtimes(
                mclVv(Ampl, "Ampl"),
                mclArrayRef1(
                  mclVv(PulseInterpFineShifted, "PulseInterpFineShifted"),
                  mlfColon(
                    _mxarray0_,
                    mclVv(FineInterpN, "FineInterpN"),
                    mlfEnd(
                      mclVv(PulseInterpFineShifted, "PulseInterpFineShifted"),
                      _mxarray0_,
                      _mxarray0_)))));
            /*
             * %plot(FitIdx,SubtractedPulse+B(i),'ro');
             * 
             * FitIdx=PeakInd(i)+PulseInterpFine(1:FineInterpN:end,1);
             */
            mlfAssign(
              &FitIdx,
              mclPlus(
                mclArrayRef1(mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                mclArrayRef2(
                  mclVv(PulseInterpFine, "PulseInterpFine"),
                  mlfColon(
                    _mxarray0_,
                    mclVv(FineInterpN, "FineInterpN"),
                    mlfEnd(
                      mclVv(PulseInterpFine, "PulseInterpFine"),
                      _mxarray0_,
                      _mxarray4_)),
                  _mxarray0_)));
            /*
             * FitIdxOk=(FitIdx<trekSize-1)&(FitIdx>1+MinFrontN);
             */
            mlfAssign(
              &FitIdxOk,
              mclAnd(
                mclLt(
                  mclVv(FitIdx, "FitIdx"),
                  mclMinus(mclVv(trekSize, "trekSize"), _mxarray0_)),
                mclGt(
                  mclVv(FitIdx, "FitIdx"),
                  mclPlus(_mxarray0_, mclVv(MinFrontN, "MinFrontN")))));
            /*
             * 
             * 
             * if (MinKhi2(i)>0)&(Ampl>0);
             */
            {
                mxArray * a_
                  = mclInitialize(
                      mclGt(
                        mclArrayRef1(mclVv(MinKhi2, "MinKhi2"), mclVv(i, "i")),
                        _mxarray1_));
                if (mlfTobool(a_)
                    && mlfTobool(
                         mclAnd(a_, mclGt(mclVv(Ampl, "Ampl"), _mxarray1_)))) {
                    mxDestroyArray(a_);
                    /*
                     * if  MinKhi2(i)<Khi2Thr
                     */
                    if (mclLtBool(
                          mclArrayRef1(
                            mclVv(MinKhi2, "MinKhi2"), mclVv(i, "i")),
                          mclVv(Khi2Thr, "Khi2Thr"))) {
                        /*
                         * trekMinus(FitIdx(FitIdxOk),2)=trekMinus(FitIdx(FitIdxOk),2)-SubtractedPulse(FitIdxOk);
                         */
                        mclArrayAssign2(
                          &trekMinus,
                          mclMinus(
                            mclArrayRef2(
                              mclVv(trekMinus, "trekMinus"),
                              mclArrayRef1(
                                mclVv(FitIdx, "FitIdx"),
                                mclVv(FitIdxOk, "FitIdxOk")),
                              _mxarray4_),
                            mclArrayRef1(
                              mclVv(SubtractedPulse, "SubtractedPulse"),
                              mclVv(FitIdxOk, "FitIdxOk"))),
                          mclArrayRef1(
                            mclVv(FitIdx, "FitIdx"),
                            mclVv(FitIdxOk, "FitIdxOk")),
                          _mxarray4_);
                        /*
                         * 
                         * if Ampl>Threshold
                         */
                        if (mclGtBool(
                              mclVv(Ampl, "Ampl"),
                              mclVv(Threshold, "Threshold"))) {
                            /*
                             * NPeaks=NPeaks+1;
                             */
                            mlfAssign(
                              &NPeaks,
                              mclPlus(mclVv(NPeaks, "NPeaks"), _mxarray0_));
                            /*
                             * peaks(NPeaks,1)=trekMinus(PeakInd(i),1)-MinFront;  %Peak Start Time
                             */
                            mclArrayAssign2(
                              &peaks,
                              mclMinus(
                                mclArrayRef2(
                                  mclVv(trekMinus, "trekMinus"),
                                  mclArrayRef1(
                                    mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                                  _mxarray0_),
                                mclVv(MinFront, "MinFront")),
                              mclVv(NPeaks, "NPeaks"),
                              _mxarray0_);
                            /*
                             * peaks(NPeaks,2)=trekMinus(PeakInd(i),1)+dt(i);     %Peak Max Time
                             */
                            mclArrayAssign2(
                              &peaks,
                              mclPlus(
                                mclArrayRef2(
                                  mclVv(trekMinus, "trekMinus"),
                                  mclArrayRef1(
                                    mclVv(PeakInd, "PeakInd"), mclVv(i, "i")),
                                  _mxarray0_),
                                mclArrayRef1(mclVv(dt, "dt"), mclVv(i, "i"))),
                              mclVv(NPeaks, "NPeaks"),
                              _mxarray4_);
                            /*
                             * peaks(NPeaks,4)=B(i);                              %Peak Zero Level
                             */
                            mclArrayAssign2(
                              &peaks,
                              mclArrayRef1(mclVv(B, "B"), mclVv(i, "i")),
                              mclVv(NPeaks, "NPeaks"),
                              _mxarray15_);
                            /*
                             * peaks(NPeaks,5)=Ampl;                              %Peak Amplitude
                             */
                            mclArrayAssign2(
                              &peaks,
                              mclVv(Ampl, "Ampl"),
                              mclVv(NPeaks, "NPeaks"),
                              _mxarray14_);
                            /*
                             * peaks(NPeaks,6)=Ampl;                              %FrontCharge
                             */
                            mclArrayAssign2(
                              &peaks,
                              mclVv(Ampl, "Ampl"),
                              mclVv(NPeaks, "NPeaks"),
                              _mxarray70_);
                            /*
                             * peaks(NPeaks,7)=MaxFront+MaxTail;                  % peak or front duration (depending on FrontCharge)
                             */
                            mclArrayAssign2(
                              &peaks,
                              mclPlus(
                                mclVv(MaxFront, "MaxFront"),
                                mclVv(MaxTail, "MaxTail")),
                              mclVv(NPeaks, "NPeaks"),
                              _mxarray73_);
                            /*
                             * peaks(NPeaks,8)=Pass;                              % number of Pass in which peak finded
                             */
                            mclArrayAssign2(
                              &peaks,
                              mclVv(Pass, "Pass"),
                              mclVv(NPeaks, "NPeaks"),
                              _mxarray10_);
                        /*
                         * end;
                         */
                        }
                        /*
                         * S=min(FitIdx(FitIdxOk)); E=max(FitIdx(FitIdxOk));
                         */
                        mlfAssign(
                          &S,
                          mlfMin(
                            NULL,
                            mclArrayRef1(
                              mclVv(FitIdx, "FitIdx"),
                              mclVv(FitIdxOk, "FitIdxOk")),
                            NULL,
                            NULL));
                        mlfAssign(
                          &E,
                          mlfMax(
                            NULL,
                            mclArrayRef1(
                              mclVv(FitIdx, "FitIdx"),
                              mclVv(FitIdxOk, "FitIdxOk")),
                            NULL,
                            NULL));
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
                                        _mxarray4_),
                                      mclArrayRef2(
                                        mclVv(trekMinus, "trekMinus"),
                                        mlfColon(
                                          mclPlus(mclVv(S, "S"), _mxarray0_),
                                          mclPlus(mclVv(E, "E"), _mxarray0_),
                                          NULL),
                                        _mxarray4_)),
                                    mclGt(
                                      mclArrayRef2(
                                        mclVv(trekMinus, "trekMinus"),
                                        mlfColon(
                                          mclVv(S, "S"), mclVv(E, "E"), NULL),
                                        _mxarray4_),
                                      mclArrayRef2(
                                        mclVv(trekMinus, "trekMinus"),
                                        mlfColon(
                                          mclMinus(mclVv(S, "S"), _mxarray0_),
                                          mclMinus(mclVv(E, "E"), _mxarray0_),
                                          NULL),
                                        _mxarray4_))),
                                  mclGt(
                                    mclArrayRef2(
                                      mclVv(trekMinus, "trekMinus"),
                                      mlfColon(
                                        mclMinus(mclVv(S, "S"), _mxarray0_),
                                        mclMinus(mclVv(E, "E"), _mxarray0_),
                                        NULL),
                                      _mxarray4_),
                                    mclArrayRef2(
                                      mclVv(trekMinus, "trekMinus"),
                                      mlfColon(
                                        mclMinus(mclVv(S, "S"), _mxarray4_),
                                        mclMinus(mclVv(E, "E"), _mxarray4_),
                                        NULL),
                                      _mxarray4_))),
                                mclGt(
                                  mclArrayRef2(
                                    mclVv(trekMinus, "trekMinus"),
                                    mlfColon(
                                      mclVv(S, "S"), mclVv(E, "E"), NULL),
                                    _mxarray4_),
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
                                      _mxarray4_),
                                    mclMtimes(
                                      mclVv(MinFrontN, "MinFrontN"),
                                      mclVv(ThresholdD, "ThresholdD"))))),
                              mclGt(
                                mclArrayRef2(
                                  mclVv(trekMinus, "trekMinus"),
                                  mlfColon(mclVv(S, "S"), mclVv(E, "E"), NULL),
                                  _mxarray4_),
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
                                    _mxarray4_),
                                  mclVv(Threshold, "Threshold"))))));
                        /*
                         * (trekMinus(S:E,2)>trekMinus(S-1:E-1,2))&...
                         * (trekMinus(S-1:E-1,2)>trekMinus(S-2:E-2,2))&...
                         * (trekMinus(S:E,2)>trekMinus(S-MinFrontN:E-MinFrontN,2)+MinFrontN*ThresholdD)&...
                         * (trekMinus(S:E,2)>trekMinus(S-MinFrontN:E-MinFrontN,2)+Threshold));  % preceeding
                         * VisiblePeakN=size(VisiblePeakInd,2);
                         */
                        mlfAssign(
                          &VisiblePeakN,
                          mlfSize(
                            mclValueVarargout(),
                            mclVv(VisiblePeakInd, "VisiblePeakInd"),
                            _mxarray4_));
                        /*
                         * if (i<PeakN)&(VisiblePeakN>0)
                         */
                        {
                            mxArray * a_2
                              = mclInitialize(
                                  mclLt(mclVv(i, "i"), mclVv(PeakN, "PeakN")));
                            if (mlfTobool(a_2)
                                && mlfTobool(
                                     mclAnd(
                                       a_2,
                                       mclGt(
                                         mclVv(VisiblePeakN, "VisiblePeakN"),
                                         _mxarray1_)))) {
                                mxDestroyArray(a_2);
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
                                          mclVv(
                                            VisiblePeakInd, "VisiblePeakInd")),
                                        _mxarray0_),
                                      mclArrayRef1(
                                        mclVv(PeakInd, "PeakInd"),
                                        mclPlus(mclVv(i, "i"), _mxarray0_)))));
                            } else {
                                mxDestroyArray(a_2);
                            }
                        /*
                         * end;
                         */
                        }
                        /*
                         * 
                         * if VisiblePeakN>0
                         */
                        if (mclGtBool(
                              mclVv(VisiblePeakN, "VisiblePeakN"),
                              _mxarray1_)) {
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
                                    _mxarray0_),
                                  mclArrayRef1(
                                    mclVv(PeakInd, "PeakInd"),
                                    mclVv(i, "i")))));
                            /*
                             * if numel(VisiblePeakInd)>0
                             */
                            if (mclGtBool(
                                  mlfNumel(
                                    mclVv(VisiblePeakInd, "VisiblePeakInd")),
                                  _mxarray1_)) {
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
                                          mclVv(
                                            VisiblePeakInd, "VisiblePeakInd"),
                                          1)),
                                      _mxarray0_),
                                    NULL));
                                /*
                                 * PeakN=size(PeakInd,1);
                                 */
                                mlfAssign(
                                  &PeakN,
                                  mlfSize(
                                    mclValueVarargout(),
                                    mclVv(PeakInd, "PeakInd"),
                                    _mxarray0_));
                                /*
                                 * PeakInd=sort(PeakInd);
                                 */
                                mlfAssign(
                                  &PeakInd,
                                  mlfSort(
                                    NULL, mclVv(PeakInd, "PeakInd"), NULL));
                            /*
                             * end;
                             */
                            }
                        /*
                         * %      plot(trekMinus(PeakInd(i+1),1),trekMinus(PeakInd(i+1),2),'md');
                         * end;
                         */
                        }
                    /*
                     * 
                     * end;
                     */
                    }
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
         * %if size(PeakInd,1)>size(MinSigma,1) PeakInd(end)=[]; end;
         * 
         * tic;  
         */
        mlfTic();
        /*
         * peaks=sortrows(peaks,2);
         */
        mlfAssign(&peaks, mlfSortrows(NULL, mclVv(peaks, "peaks"), _mxarray4_));
        /*
         * NPeaks=size(peaks,1);
         */
        mlfAssign(
          &NPeaks,
          mlfSize(mclValueVarargout(), mclVv(peaks, "peaks"), _mxarray0_));
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
        if (mclEqBool(mclVv(Pass, "Pass"), _mxarray0_)) {
            /*
             * clear  StandardPulse StandardPeaksN StandardPeaks ; 
             */
            mlfClear(&StandardPulse, &StandardPeaksN, &StandardPeaks, NULL);
            /*
             * clear  Range  PeakVal PeakStart PeakEnd NumGoodPeaks;   
             */
            mlfClear(
              &Range, &PeakVal, &PeakStart, &PeakEnd, &NumGoodPeaks, NULL);
            /*
             * clear MaxPeak MaxPeakInd;
             */
            mlfClear(&MaxPeak, &MaxPeakInd, NULL);
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
         * clear Khi2Fit S;
         */
        mlfClear(&Khi2Fit, &S, NULL);
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
         * clear MinKhi2Idx MinKhi2 MinInterval  Ind;
         */
        mlfClear(&MinKhi2Idx, &MinKhi2, &MinInterval, &Ind, NULL);
        /*
         * clear GoodPeakN GoodPeakInd GoodPeakVal FrontSignalN FitIdx    E;
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
    if (mclGtBool(mclVv(NPeaks, "NPeaks"), _mxarray0_)) {
        mlfAssign(
          &Period,
          mclMrdivide(
            mclMinus(
              mclArrayRef2(
                mclVv(peaks, "peaks"),
                mlfEnd(mclVv(peaks, "peaks"), _mxarray0_, _mxarray4_),
                _mxarray0_),
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
              mlfEnd(mclVv(trek, "trek"), _mxarray0_, _mxarray4_),
              _mxarray0_),
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
            mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray4_),
          _mxarray43_),
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray4_)),
      mlfCreateColonIndex(),
      _mxarray63_);
    /*
     * peaks(end,3)=Period; 
     */
    mclArrayAssign2(
      &peaks,
      mclVv(Period, "Period"),
      mlfEnd(mclVv(peaks, "peaks"), _mxarray0_, _mxarray4_),
      _mxarray63_);
    /*
     * 
     * %if size(PeakInd,1)>size(MinSigma,1) PeakInd(end)=[]; end;
     * 
     * 
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
    mlfAssign(&MinAmpl, _mxarray1_);
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
        _mxarray0_));
    /*
     * PassN=max(peaks(:,8));
     */
    mlfAssign(
      &PassN,
      mlfMax(
        NULL,
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray10_),
        NULL,
        NULL));
    /*
     * if HistN==0; HistN=1; end;     % the number of intervals 
     */
    if (mclEqBool(mclVv(HistN, "HistN"), _mxarray1_)) {
        mlfAssign(&HistN, _mxarray0_);
    }
    /*
     * for p=1:PassN
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVv(PassN, "PassN"));
        if (v_ > e_) {
            mlfAssign(&p, _mxarray42_);
        } else {
            /*
             * PassBool=peaks(:,8)==p;  PassBoolSize=size((find(PassBool)));
             * for i=1:HistN
             * HistA(p,i,1)=MinAmpl+(i-0.5)*HistIntervalA;
             * HistBool=(peaks(:,5)<HistA(p,i,1)+HistIntervalA/2)&...
             * (peaks(:,5)>=HistA(p,i,1)-HistIntervalA/2&PassBool);
             * HistA(p,i,2)=size(peaks(HistBool),1);  %peak aplitude
             * HH=HistA(p,i,2);
             * HistA(p,i,3)=sqrt(HistA(p,i,2));           %peak aplitude error
             * end;  end;
             */
            for (; ; ) {
                mlfAssign(
                  &PassBool,
                  mclEq(
                    mclArrayRef2(
                      mclVv(peaks, "peaks"),
                      mlfCreateColonIndex(),
                      _mxarray10_),
                    mlfScalar(v_)));
                mlfAssign(
                  &PassBoolSize,
                  mlfSize(
                    mclValueVarargout(),
                    mlfFind(NULL, NULL, mclVv(PassBool, "PassBool")),
                    NULL));
                {
                    int v_1 = mclForIntStart(1);
                    int e_1 = mclForIntEnd(mclVv(HistN, "HistN"));
                    if (v_1 > e_1) {
                        mlfAssign(&i, _mxarray42_);
                    } else {
                        for (; ; ) {
                            mlfIndexAssign(
                              HistA,
                              "(?,?,?)",
                              mlfScalar(v_),
                              mlfScalar(v_1),
                              _mxarray0_,
                              mclPlus(
                                mclVv(MinAmpl, "MinAmpl"),
                                mclMtimes(
                                  mlfScalar(
                                    svDoubleScalarMinus((double) v_1, .5)),
                                  mclVv(HistIntervalA, "HistIntervalA"))));
                            mlfAssign(
                              &HistBool,
                              mclAnd(
                                mclLt(
                                  mclArrayRef2(
                                    mclVv(peaks, "peaks"),
                                    mlfCreateColonIndex(),
                                    _mxarray14_),
                                  mclPlus(
                                    mlfIndexRef(
                                      mclVv(*HistA, "HistA"),
                                      "(?,?,?)",
                                      mlfScalar(v_),
                                      mlfScalar(v_1),
                                      _mxarray0_),
                                    mclMrdivide(
                                      mclVv(HistIntervalA, "HistIntervalA"),
                                      _mxarray4_))),
                                mclAnd(
                                  mclGe(
                                    mclArrayRef2(
                                      mclVv(peaks, "peaks"),
                                      mlfCreateColonIndex(),
                                      _mxarray14_),
                                    mclMinus(
                                      mlfIndexRef(
                                        mclVv(*HistA, "HistA"),
                                        "(?,?,?)",
                                        mlfScalar(v_),
                                        mlfScalar(v_1),
                                        _mxarray0_),
                                      mclMrdivide(
                                        mclVv(HistIntervalA, "HistIntervalA"),
                                        _mxarray4_))),
                                  mclVv(PassBool, "PassBool"))));
                            mlfIndexAssign(
                              HistA,
                              "(?,?,?)",
                              mlfScalar(v_),
                              mlfScalar(v_1),
                              _mxarray4_,
                              mlfSize(
                                mclValueVarargout(),
                                mclArrayRef1(
                                  mclVv(peaks, "peaks"),
                                  mclVv(HistBool, "HistBool")),
                                _mxarray0_));
                            mlfAssign(
                              &HH,
                              mlfIndexRef(
                                mclVv(*HistA, "HistA"),
                                "(?,?,?)",
                                mlfScalar(v_),
                                mlfScalar(v_1),
                                _mxarray4_));
                            mlfIndexAssign(
                              HistA,
                              "(?,?,?)",
                              mlfScalar(v_),
                              mlfScalar(v_1),
                              _mxarray63_,
                              mlfSqrt(
                                mlfIndexRef(
                                  mclVv(*HistA, "HistA"),
                                  "(?,?,?)",
                                  mlfScalar(v_),
                                  mlfScalar(v_1),
                                  _mxarray4_)));
                            if (v_1 == e_1) {
                                break;
                            }
                            ++v_1;
                        }
                        mlfAssign(&i, mlfScalar(v_1));
                    }
                }
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&p, mlfScalar(v_));
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
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray63_),
        NULL,
        NULL));
    /*
     * MinT=min(peaks(:,3));
     */
    mlfAssign(
      &MinT,
      mlfMin(
        NULL,
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray63_),
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
            mlfAssign(&i, _mxarray42_);
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
                        _mxarray63_),
                      mclPlus(
                        mclIntArrayRef2(mclVv(HistT, "HistT"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalT, "HistIntervalT"), _mxarray4_))),
                    mclGe(
                      mclArrayRef2(
                        mclVv(peaks, "peaks"),
                        mlfCreateColonIndex(),
                        _mxarray63_),
                      mclMinus(
                        mclIntArrayRef2(mclVv(HistT, "HistT"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalT, "HistIntervalT"),
                          _mxarray4_)))));
                mclIntArrayAssign2(
                  &HistT,
                  mlfSize(
                    mclValueVarargout(),
                    mclArrayRef2(
                      mclVv(peaks, "peaks"),
                      mclVv(HistBool, "HistBool"),
                      _mxarray0_),
                    _mxarray0_),
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
        mclArrayRef2(mclVv(HistT, "HistT"), mlfCreateColonIndex(), _mxarray4_),
        _mxarray1_));
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
        mclArrayRef2(mclVv(peaks, "peaks"), mlfCreateColonIndex(), _mxarray70_),
        NULL,
        NULL));
    /*
     * MinC=0; %   min(peaks(:,6));
     */
    mlfAssign(&MinC, _mxarray1_);
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
        _mxarray0_));
    /*
     * for i=1:HistN
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVv(HistN, "HistN"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray42_);
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
                        _mxarray70_),
                      mclPlus(
                        mclIntArrayRef2(mclVv(HistC, "HistC"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalC, "HistIntervalC"), _mxarray4_))),
                    mclGe(
                      mclArrayRef2(
                        mclVv(peaks, "peaks"),
                        mlfCreateColonIndex(),
                        _mxarray70_),
                      mclMinus(
                        mclIntArrayRef2(mclVv(HistC, "HistC"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalC, "HistIntervalC"),
                          _mxarray4_)))));
                mclIntArrayAssign2(
                  &HistC,
                  mlfSize(
                    mclValueVarargout(),
                    mclArrayRef2(
                      mclVv(peaks, "peaks"),
                      mclVv(HistBool, "HistBool"),
                      _mxarray0_),
                    _mxarray0_),
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
        mlfNRand(1, mclVv(NPeaks, "NPeaks"), _mxarray0_, NULL),
        mclMinus(
          mclArrayRef2(
            mclVv(trek, "trek"),
            mlfEnd(mclVv(trek, "trek"), _mxarray0_, _mxarray4_),
            _mxarray0_),
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
        mlfCircshift(mclVv(Poisson, "Poisson"), _mxarray43_),
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
            _mxarray0_,
            mclMinus(
              mlfEnd(mclVv(Poisson, "Poisson"), _mxarray0_, _mxarray0_),
              _mxarray0_),
            NULL)),
        NULL));
    /*
     * Poisson(end)=MeanP; 
     */
    mclArrayAssign1(
      &Poisson,
      mclVv(MeanP, "MeanP"),
      mlfEnd(mclVv(Poisson, "Poisson"), _mxarray0_, _mxarray0_));
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
            mlfAssign(&i, _mxarray42_);
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
                          mclVv(HistIntervalP, "HistIntervalP"), _mxarray4_))),
                    mclGe(
                      mclVv(Poisson, "Poisson"),
                      mclMinus(
                        mclIntArrayRef2(mclVv(HistP, "HistP"), v_, 1),
                        mclMrdivide(
                          mclVv(HistIntervalP, "HistIntervalP"),
                          _mxarray4_)))));
                mclIntArrayAssign2(
                  &HistP,
                  mlfSize(
                    mclValueVarargout(),
                    mclArrayRef1(
                      mclVv(Poisson, "Poisson"), mclVv(HistBool, "HistBool")),
                    _mxarray0_),
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
    mclAssignAns(&ans, mlfNFprintf(0, _mxarray74_, NULL));
    /*
     * fprintf('Peak threshold =  %3.3f\n', Threshold);
     */
    mclAssignAns(
      &ans, mlfNFprintf(0, _mxarray76_, mclVv(Threshold, "Threshold"), NULL));
    /*
     * fprintf('The number of peaks =  %5.0f\n', NPeaks);
     */
    mclAssignAns(
      &ans, mlfNFprintf(0, _mxarray78_, mclVv(NPeaks, "NPeaks"), NULL));
    /*
     * fprintf('The period of peaks =  %6.4f ms\n', Period/1000);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(
        0,
        _mxarray80_,
        mclMrdivide(mclVv(Period, "Period"), _mxarray82_),
        NULL));
    /*
     * fprintf('Resolution in the peak amplitude histogram=  %3.3f counts\n', HistIntervalA);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(0, _mxarray83_, mclVv(HistIntervalA, "HistIntervalA"), NULL));
    /*
     * fprintf('Resolution in the peak interval histogram=  %3.3f us\n', HistIntervalT);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(0, _mxarray85_, mclVv(HistIntervalT, "HistIntervalT"), NULL));
    /*
     * fprintf('Expected number of double peaks for 0.025 us = %3.3f \n', NPeaks*0.025/Period);
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(
        0,
        _mxarray87_,
        mclMrdivide(
          mclMtimes(mclVv(NPeaks, "NPeaks"), _mxarray2_),
          mclVv(Period, "Period")),
        NULL));
    /*
     * %fprintf('Expected number of double peaks for %5.3f us = %5.3f \n', MinInterval, NPeaks*MinInterval/Period);
     * %fprintf('Detected number of double peaks for %5.3f us = %5.3f \n', MinInterval, size(find(peaks(:,end)==2)));
     * %fprintf('Expected number of triple peaks for %5.3f us = %5.3f \n', MinInterval, NPeaks*(MinInterval/Period)^2/2);
     * %fprintf('Detected number of triple peaks for %5.3f us = %5.3f \n', MinInterval, size(find(peaks(:,end)==2)));
     * %fprintf('The selected number of double peaks for %5.3f us = %3.0f \n', MinInterval, DoublePeakNum);
     * %fprintf('The selected number of triple peaks for %5.3f us = %3.0f \n', MinInterval, TriplePeakNum);
     * fprintf('=====================\n');                
     */
    mclAssignAns(&ans, mlfNFprintf(0, _mxarray89_, NULL));
    /*
     * 
     * if isstr(FileName) HistAFile=FileName; HistAFile(1:4)='hisA'; 
     */
    if (mlfTobool(mlfIsstr(mclVa(FileName, "FileName")))) {
        mlfAssign(&HistAFile, mclVa(FileName, "FileName"));
        mclArrayAssign1(
          &HistAFile, _mxarray91_, mlfColon(_mxarray0_, _mxarray15_, NULL));
    /*
     * else HistAFile='HistA.dat'; end; 
     */
    } else {
        mlfAssign(&HistAFile, _mxarray93_);
    }
    /*
     * % fid=fopen(HistAFile,'w'); 
     * % fprintf(fid,'%6.2f %3.0f %5.2f\n' ,HistA');
     * % fclose(fid);    
     * if isstr(FileName) HistCFile=FileName; HistCFile(1:4)='hisC'; 
     */
    if (mlfTobool(mlfIsstr(mclVa(FileName, "FileName")))) {
        mlfAssign(&HistCFile, mclVa(FileName, "FileName"));
        mclArrayAssign1(
          &HistCFile, _mxarray95_, mlfColon(_mxarray0_, _mxarray15_, NULL));
    /*
     * else HistCFile='HistC.dat'; end; 
     */
    } else {
        mlfAssign(&HistCFile, _mxarray97_);
    }
    /*
     * fid=fopen(HistCFile,'w'); 
     */
    mlfAssign(
      &fid,
      mlfFopen(NULL, NULL, mclVv(HistCFile, "HistCFile"), _mxarray99_, NULL));
    /*
     * fprintf(fid,'%6.2f %3.0f %5.2f\n' ,HistC');
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(
        0,
        mclVv(fid, "fid"),
        _mxarray101_,
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
          &PeakFile, _mxarray103_, mlfColon(_mxarray0_, _mxarray15_, NULL));
    /*
     * else PeakFile='peaks.dat'; end; 
     */
    } else {
        mlfAssign(&PeakFile, _mxarray105_);
    }
    /*
     * %if isstr(FileName)&&strcmp(PeakFile,FileName) PeakFile=['Peaks',FileName]; end; 
     * 
     * fid=fopen(PeakFile,'w');
     */
    mlfAssign(
      &fid,
      mlfFopen(NULL, NULL, mclVv(PeakFile, "PeakFile"), _mxarray99_, NULL));
    /*
     * fprintf(fid,'start       peak      interv      zero  ampl    charge duration CombN\n'); 
     */
    mclAssignAns(&ans, mlfNFprintf(0, mclVv(fid, "fid"), _mxarray107_, NULL));
    /*
     * fprintf(fid,'%10.3f %10.3f %9.3f %7.2f %7.2f %7.2f %5.3f %2.0f \n' ,peaks');
     */
    mclAssignAns(
      &ans,
      mlfNFprintf(
        0,
        mclVv(fid, "fid"),
        _mxarray109_,
        mlfCtranspose(mclVv(peaks, "peaks")),
        NULL));
    /*
     * fclose(fid);    
     */
    mclAssignAns(&ans, mlfFclose(mclVv(fid, "fid")));
    /*
     * if isstr(FileName) end;
     */
    if (mlfTobool(mlfIsstr(mclVa(FileName, "FileName")))) {
    }
    mclValidateOutput(peaks, 1, nargout_, "peaks", "peaks3auto");
    mclValidateOutput(*HistA, 2, nargout_, "HistA", "peaks3auto");
    mxDestroyArray(Text);
    mxDestroyArray(Delta);
    mxDestroyArray(Fourie);
    mxDestroyArray(FrontCharge);
    mxDestroyArray(DeadAfter);
    mxDestroyArray(Plot1);
    mxDestroyArray(Plot2);
    mxDestroyArray(AverageGate);
    mxDestroyArray(NoiseAverN);
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
    mxDestroyArray(BFitSignalN);
    mxDestroyArray(BeyondMaxN);
    mxDestroyArray(InterpN);
    mxDestroyArray(FineInterpN);
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
    mxDestroyArray(trekStart);
    mxDestroyArray(Std0);
    mxDestroyArray(DeltaStd);
    mxDestroyArray(NoiseAver);
    mxDestroyArray(NoiseInterp);
    mxDestroyArray(StartNoise);
    mxDestroyArray(EndNoise);
    mxDestroyArray(MaxAmp);
    mxDestroyArray(MinTime);
    mxDestroyArray(MaxTime);
    mxDestroyArray(OutLimits);
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
    mxDestroyArray(MoveToNoise);
    mxDestroyArray(SizeMoveToNoise);
    mxDestroyArray(MoveToSignal);
    mxDestroyArray(Range);
    mxDestroyArray(PeakInd);
    mxDestroyArray(PeakVal);
    mxDestroyArray(GoodPeakInd);
    mxDestroyArray(GoodPeakVal);
    mxDestroyArray(PeakOnFrontInd);
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
    mxDestroyArray(AscendTop);
    mxDestroyArray(PeakStart);
    mxDestroyArray(PeakEnd);
    mxDestroyArray(SampleFront);
    mxDestroyArray(SampleTail);
    mxDestroyArray(SampleN);
    mxDestroyArray(StandardPulse);
    mxDestroyArray(SignalsOk);
    mxDestroyArray(SelectedStandrdPulse);
    mxDestroyArray(MeanStandardPulse);
    mxDestroyArray(stdStandardPulse);
    mxDestroyArray(SelectedN);
    mxDestroyArray(MinStdLeft);
    mxDestroyArray(LeftMin);
    mxDestroyArray(MinStdRight);
    mxDestroyArray(RightMin);
    mxDestroyArray(DeltaMean);
    mxDestroyArray(SignalsLeftOk);
    mxDestroyArray(SignalCenterOk);
    mxDestroyArray(SignalsRightOk);
    mxDestroyArray(x);
    mxDestroyArray(Zero);
    mxDestroyArray(ToZero);
    mxDestroyArray(MaxStandardPulse);
    mxDestroyArray(MaxStandardPulseIndx);
    mxDestroyArray(FirstNonZero);
    mxDestroyArray(LastNonZero);
    mxDestroyArray(StandardPulseNorm);
    mxDestroyArray(FitPulseInterval);
    mxDestroyArray(FitBackgndInterval);
    mxDestroyArray(FitN);
    mxDestroyArray(PulseInterp);
    mxDestroyArray(SampleInterpN);
    mxDestroyArray(PulseInterpFine);
    mxDestroyArray(SampleInterpFineN);
    mxDestroyArray(FirstNonZeroInterp);
    mxDestroyArray(LastNonZeroInterp);
    mxDestroyArray(MaxPulseInterpIndx);
    mxDestroyArray(Indx);
    mxDestroyArray(FitInterpPulseInterval);
    mxDestroyArray(FirstNonZeroInterpFine);
    mxDestroyArray(LastNonZeroInterpFine);
    mxDestroyArray(MaxPulseInterpFineIndx);
    mxDestroyArray(FitFineInterpPulseInterval);
    mxDestroyArray(InterpHalfRange);
    mxDestroyArray(InterpRange);
    mxDestroyArray(k);
    mxDestroyArray(DiagLogic);
    mxDestroyArray(PulseInterpShifted);
    mxDestroyArray(FitPulses);
    mxDestroyArray(Sums3);
    mxDestroyArray(Sums3Short);
    mxDestroyArray(PulseInterpFineShifted);
    mxDestroyArray(PulseInterpShiftedTest);
    mxDestroyArray(Khi2Fin);
    mxDestroyArray(KhiCoeff);
    mxDestroyArray(KhiCoeffShort);
    mxDestroyArray(StartFitPoint);
    mxDestroyArray(A);
    mxDestroyArray(B);
    mxDestroyArray(Sum1);
    mxDestroyArray(Sum2);
    mxDestroyArray(Sum3);
    mxDestroyArray(Khi2Fit);
    mxDestroyArray(PolyKhi2);
    mxDestroyArray(FitSignal);
    mxDestroyArray(FitPulseFin);
    mxDestroyArray(MinKhi2);
    mxDestroyArray(BckgIndx);
    mxDestroyArray(ShortFit);
    mxDestroyArray(FitSignalStart);
    mxDestroyArray(FitNi);
    mxDestroyArray(NetFitSignal);
    mxDestroyArray(Sums1);
    mxDestroyArray(Sums2);
    mxDestroyArray(MinKhi2Idx);
    mxDestroyArray(CoarseShift);
    mxDestroyArray(NfromEdge);
    mxDestroyArray(KhiFitN);
    mxDestroyArray(Khi2MinIdxFine);
    mxDestroyArray(Ampl);
    mxDestroyArray(FineShift);
    mxDestroyArray(dt);
    mxDestroyArray(FitIdx);
    mxDestroyArray(SubtractedPulse);
    mxDestroyArray(FitIdxOk);
    mxDestroyArray(VisiblePeakN);
    mxDestroyArray(Period);
    mxDestroyArray(MaxAmpl);
    mxDestroyArray(MinAmpl);
    mxDestroyArray(PeakAmplRange);
    mxDestroyArray(HistIntervalA);
    mxDestroyArray(HistN);
    mxDestroyArray(PassN);
    mxDestroyArray(p);
    mxDestroyArray(PassBool);
    mxDestroyArray(PassBoolSize);
    mxDestroyArray(HistBool);
    mxDestroyArray(HH);
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
     * 
     * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     * 
     */
}

/*
 * The function "Mpeaks3auto_MeanSearch" is the implementation version of the
 * "peaks3auto/MeanSearch" M-function from file
 * "e:\scn\efield\matlab\peaks3auto.m" (lines 797-845). It contains the actual
 * compiled code for that M-function. It is a static function and must only be
 * called from one of the interface functions, appearing below.
 */
/*
 * function [MeanVal,StdVal,PP,Noise]=MeanSearch(tr,OverSt,Noise,Plot1,Plot2,trD);    
 */
static mxArray * Mpeaks3auto_MeanSearch(mxArray * * StdVal,
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
      = mclSetCurrentLocalFunctionTable(&_local_function_table_peaks3auto);
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
     * trSize=size(tr(:,1),1); %  (N,1) dimension
     */
    mlfAssign(
      &trSize,
      mlfSize(
        mclValueVarargout(),
        mclArrayRef2(mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray0_),
        _mxarray0_));
    /*
     * 
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
            mclArrayRef2(mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray4_),
            NULL));
        mlfAssign(
          &St,
          mlfStd(
            mclArrayRef2(mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray4_),
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
                _mxarray1_)),
            _mxarray0_));
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
                _mxarray1_)),
            _mxarray0_));
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
                    mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray4_),
                  mclPlus(
                    mclVv(M, "M"), mclMtimes(_mxarray14_, mclVv(St, "St")))),
                _mxarray1_)),
            _mxarray0_));
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
                    mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray4_),
                  mclMinus(
                    mclVv(M, "M"), mclMtimes(_mxarray14_, mclVv(St, "St")))),
                _mxarray1_)),
            _mxarray0_));
        /*
         * MaxVal=max(tr(:,2)); MinVal=min(tr(:,2)); DeltaM=MaxVal-MinVal;  end;
         */
        mlfAssign(
          &MaxVal,
          mlfMax(
            NULL,
            mclArrayRef2(mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray4_),
            NULL,
            NULL));
        mlfAssign(
          &MinVal,
          mlfMin(
            NULL,
            mclArrayRef2(mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray4_),
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
        mlfAssign(&PeakPolarity, _mxarray0_);
    } else {
        mlfAssign(&PeakPolarity, _mxarray43_);
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
        _mxarray0_));
    /*
     * while DeltaM>0.1
     */
    while (mclGtBool(mclVv(DeltaM, "DeltaM"), _mxarray8_)) {
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
                    mclVa(tr, "tr"), mclVa(*Noise, "Noise"), _mxarray4_),
                  NULL),
                NULL));
            mlfAssign(
              &St,
              mlfHorzcat(
                mclVv(St, "St"),
                mlfStd(
                  mclArrayRef2(
                    mclVa(tr, "tr"), mclVa(*Noise, "Noise"), _mxarray4_),
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
        if (mclGtBool(mclVv(L, "L"), _mxarray4_)) {
            mlfAssign(
              &DeltaM,
              mlfAbs(
                mclMinus(
                  mclArrayRef1(mclVv(M, "M"), mclVv(L, "L")),
                  mclArrayRef1(
                    mclVv(M, "M"), mclMinus(mclVv(L, "L"), _mxarray0_)))));
        } else {
            mlfAssign(&DeltaM, _mxarray111_);
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
            if (mclEqBool(mclVv(PeakPolarity, "PeakPolarity"), _mxarray0_)) {
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
            if (mclEqBool(mclVv(PeakPolarity, "PeakPolarity"), _mxarray0_)) {
                mlfAssign(
                  Noise,
                  mclLt(
                    mclArrayRef2(
                      mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray4_),
                    mclVv(NoiseLevel, "NoiseLevel")));
            } else {
                mlfAssign(
                  Noise,
                  mclGt(
                    mclArrayRef2(
                      mclVa(tr, "tr"), mlfCreateColonIndex(), _mxarray4_),
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
              _mxarray0_),
            NULL));
    /*
     * %if St(L)==0 DeltaM=0;end;
     * end; 
     */
    }
    /*
     * NoiseL=circshift(Noise,-1);   NoiseL(end)=Noise(end);     
     */
    mlfAssign(&NoiseL, mlfCircshift(mclVa(*Noise, "Noise"), _mxarray43_));
    mclArrayAssign1(
      &NoiseL,
      mclArrayRef1(
        mclVa(*Noise, "Noise"),
        mlfEnd(mclVa(*Noise, "Noise"), _mxarray0_, _mxarray0_)),
      mlfEnd(mclVv(NoiseL, "NoiseL"), _mxarray0_, _mxarray0_));
    /*
     * NoiseR=circshift(Noise,1);    NoiseR(1)=Noise(1);
     */
    mlfAssign(&NoiseR, mlfCircshift(mclVa(*Noise, "Noise"), _mxarray0_));
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
     * 
     * MeanVal=M(L); StdVal=St(L); PP=PeakPolarity;
     */
    mlfAssign(&MeanVal, mclArrayRef1(mclVv(M, "M"), mclVv(L, "L")));
    mlfAssign(StdVal, mclArrayRef1(mclVv(St, "St"), mclVv(L, "L")));
    mlfAssign(PP, mclVv(PeakPolarity, "PeakPolarity"));
    mclValidateOutput(MeanVal, 1, nargout_, "MeanVal", "peaks3auto/MeanSearch");
    mclValidateOutput(*StdVal, 2, nargout_, "StdVal", "peaks3auto/MeanSearch");
    mclValidateOutput(*PP, 3, nargout_, "PP", "peaks3auto/MeanSearch");
    mclValidateOutput(*Noise, 4, nargout_, "Noise", "peaks3auto/MeanSearch");
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
