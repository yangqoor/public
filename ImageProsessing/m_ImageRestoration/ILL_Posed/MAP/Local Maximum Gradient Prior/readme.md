Codes provided by Chen, Liang. Please cite the following paper if it is used
% @inproceedings{chen2019blind,
%   title={Blind Image Deblurring With Local Maximum Gradient Prior},
%   author={Chen, Liang and Fang, Faming and Wang, Tingting and Zhang, Guixu},
%   booktitle={Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition},
%   pages={1742--1750},
%   year={2019}
% }

Main functions used in the paper:

The function Abs_matrix() is used for generate absolute operator in the paper,
and the output is a diagonalized sparse matrix.

The function gen_partialmat() is used for generate gradient operator.

The function Max_matrix() is used for generate maximize operator in the paper,
and the output is a big sparse matrix. Analogous for the fucntion of Min_matrix().

The function LMG() is used for generate LMG operation in the paper, and
the output is the lmg map and operator G in the paper.