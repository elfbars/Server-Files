local cfg = {}

-- list of atms positions
cfg.atms = {
    {89.577018737793,2.16031360626221,68.322021484375},
    {-526.497131347656,-1222.79455566406,18.4549674987793},
    {-2072.48413085938,-317.190521240234,13.315972328186},
    {-821.565551757813,-1081.90270996094,11.1324348449707},
    {1686.74694824219,4815.8828125,42.0085678100586},
    {-386.899444580078,6045.78466796875,31.5001239776611},
    {1171.52319335938,2702.44897460938,38.1754684448242},
    {1968.11157226563,3743.56860351563,32.3437271118164},
    {2558.85815429688,351.045166015625,108.621520996094},
    {1153.75634765625,-326.805023193359,69.2050704956055},
    {-56.9172439575195,-1752.17590332031,29.4210166931152},
    {-3241.02856445313,997.587158203125,12.5503988265991},
    {-1827.1884765625,784.907104492188,138.302581787109},
    {-1091.54748535156,2708.55786132813,18.9437484741211},
    {112.45637512207,-819.25048828125,31.3392715454102},
    {-256.173187255859,-716.031921386719,33.5202751159668},
    {174.227737426758,6637.88623046875,31.5730476379395},
    {-660.727661132813,-853.970336914063,24.484073638916},
    {-2153.5690917969,5236.5961914063,18.779041290283},
    {937.97979736328,-941.22381591797,44.411933898926},
    {147.65927124023,-1035.607421875,29.343105316162},
    {146.05894470215,-1035.1301269531,29.34481048584},
    {-254.36019897461,-692.43688964844,33.609630584717},
    {-258.83990478516,-723.43603515625,33.473651885986},
    {1845.8720703125,2584.2048339844,45.672046661377},
    {1095.6285400391,245.37515258789,-50.440719604492},
    {1095.3305664063,243.84825134277,-50.440719604492},
    {-1110.9267578125,-836.36138916016,19.001638412476},
    {-1074.1479492188,-827.66925048828,19.036712646484},
    {-1074.2746582031,-827.43896484375,27.036390304565},
    {-577.13519287109,-194.84748840332,38.219650268555},
    {-946.3839, -2039.573, 9.402352},
    {2.8462929725647,6726.9912109375,-102.55392456055},
    {-5.7646079063416,6713.0581054688,-102.55397033691},
    {155.59878540039,6642.5107421875,31.611171722412},
    {-283.19714355469,6225.9404296875,31.493925094604},
    {1735.4854736328,6410.970703125,35.037216186523},
    {-203.67570495605,-861.75054931641,30.267637252808},
    {-303.37271118164,-829.83294677734,32.417083740234},
    {-301.65835571289,-830.18572998047,32.417282104492},
    {295.73028564453,-896.04736328125,29.21541595459},
    {296.47418212891,-894.18341064453,29.231298446655},
    {-717.49224853516,-915.65032958984,19.215579986572},
    {-712.91314697266,-819.23101806641,23.729019165039},
    {-710.07861328125,-818.92291259766,23.729524612427},
    {-1205.3249511719,-324.63583374023,37.857276916504},
    {-1205.0072021484,-326.28549194336,37.838691711426},
    {2711.4704589844,2184.4465332031,5.2114195823669},
    {527.35339355469,-160.65631103516,57.066841125488},
    {-425.7683, 2.448908, 35.90148},
    {4475.1665039062,-4469.4873046875,4.2344226837158},
    {4476.0615234375,-4469.1147460938,4.2341270446777},
    {-113.56768035889,6470.7607421875,31.626699447632},
    {-111.52037811279,6468.693359375,31.626699447632},
}

cfg.atmblips={
    {89.577018737793,2.16031360626221,68.322021484375},
    {-526.497131347656,-1222.79455566406,18.4549674987793},
    {-2072.48413085938,-317.190521240234,13.315972328186},
    {-821.565551757813,-1081.90270996094,11.1324348449707},
    {1686.74694824219,4815.8828125,42.0085678100586},
    {-386.899444580078,6045.78466796875,31.5001239776611},
    {1171.52319335938,2702.44897460938,38.1754684448242},
    {1968.11157226563,3743.56860351563,32.3437271118164},
    {2558.85815429688,351.045166015625,108.621520996094},
    {1153.75634765625,-326.805023193359,69.2050704956055},
    {-56.9172439575195,-1752.17590332031,29.4210166931152},
    {-3241.02856445313,997.587158203125,12.5503988265991},
    {-1827.1884765625,784.907104492188,138.302581787109},
    {-1091.54748535156,2708.55786132813,18.9437484741211},
    {112.45637512207,-819.25048828125,31.3392715454102},
    {-256.173187255859,-716.031921386719,33.5202751159668},
    {174.227737426758,6637.88623046875,31.5730476379395},
    {-660.727661132813,-853.970336914063,24.484073638916},
    {-2153.5690917969,5236.5961914063,18.779041290283},
    {937.97979736328,-941.22381591797,44.411933898926},
    {147.65927124023,-1035.607421875,29.343105316162},
    {146.05894470215,-1035.1301269531,29.34481048584},
    {-254.36019897461,-692.43688964844,33.609630584717},
    {-258.83990478516,-723.43603515625,33.473651885986},
    {1845.8720703125,2584.2048339844,45.672046661377},
    {1095.6285400391,245.37515258789,-50.440719604492},
    {1095.3305664063,243.84825134277,-50.440719604492},
    {-1110.9267578125,-836.36138916016,19.001638412476},
    {-1074.1479492188,-827.66925048828,19.036712646484},
    {-1074.2746582031,-827.43896484375,27.036390304565},
    {-577.13519287109,-194.84748840332,38.219650268555},
    {-946.3839, -2039.573, 9.402352},
    {2.8462929725647,6726.9912109375,-102.55392456055},
    {-5.7646079063416,6713.0581054688,-102.55397033691},
    {155.59878540039,6642.5107421875,31.611171722412},
    {-283.19714355469,6225.9404296875,31.493925094604},
    {1735.4854736328,6410.970703125,35.037216186523},
    {-203.67570495605,-861.75054931641,30.267637252808},
    {-303.37271118164,-829.83294677734,32.417083740234},
    {-301.65835571289,-830.18572998047,32.417282104492},
    {295.73028564453,-896.04736328125,29.21541595459},
    {296.47418212891,-894.18341064453,29.231298446655},
    {-717.49224853516,-915.65032958984,19.215579986572},
    {-712.91314697266,-819.23101806641,23.729019165039},
    {-710.07861328125,-818.92291259766,23.729524612427},
    {-1205.3249511719,-324.63583374023,37.857276916504},
    {-1205.0072021484,-326.28549194336,37.838691711426},
    {2711.4704589844,2184.4465332031,5.2114195823669},
    {527.35339355469,-160.65631103516,57.066841125488},
    {-425.7683, 2.448908, 35.90148},
    {4475.1665039062,-4469.4873046875,4.2344226837158},
    {4476.0615234375,-4469.1147460938,4.2341270446777},
    {-113.56768035889,6470.7607421875,31.626699447632},
    {-111.52037811279,6468.693359375,31.626699447632},
  
}

return cfg