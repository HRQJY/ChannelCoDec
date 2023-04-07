目录结构
├─WuYuFei
├─WuYufei_matlab
├─cap_turbo
├─mother
└─paper

[WuYuFei]中是WuYuFei的论文
[WuYufei_matlab]是WuYufei的Matlab程序
做Turbo码，恐怕很难绕过WuYufei的程序，呵呵

[cap_turbo]和[mother]是我在研究阶段的工作
走了很多弯路，所以这两个目录必然有很多错误而且很混乱
如果想了解一下我的研究历程可以看看，切不可拿来修炼，否则走火入魔俺不管。

[paper]是对简化算法的研究总结。译码程序完全是自己写的，已经系统整理过了。
    constituent_decoder_SemiTh.m
    constituent_decoder_logmap.m
    constituent_decoder_max.m
    constituent_decoder_Th.m
这四个文件是子译码器

    interleaver_3GPP.m
3GPP标准的交织器。Turbo.m中可以选择是用伪随机交织还是3GPP标准交织

    decoder_all_algorithm.m
译码器，其中包含了3种译码算法

    test_OverLoad_menu.m
对运算负荷的测试程序

    test_algorithm_menu.m 
对算法的测试程序

    Shannon_Limit.m
香农限

    test_uncoded_BPSK.m
    test_uncoded_BPSK_theory.m
未编码BPSK的性能，一个是理论的，另外一个是测试的。

%****************************************************************
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************