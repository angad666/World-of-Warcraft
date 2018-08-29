--[[

GetDetailedItemLevelInfo Polyfill, v 1.0
by Erorus for The Undermine Journal
https://theunderminejournal.com/

Based on these "specs" for a GetDetailedItemLevelInfo function coming in 7.1
https://www.reddit.com/r/woweconomy/comments/50hp5d/warning_be_careful_flipping/d74olsy

Pass in an itemstring/link to GetDetailedItemLevelInfo
Returns effectiveItemLevel, previewItemLevel, baseItemLevel

This should use the in-game function if it already exists,
otherwise it'll define a function that does what *I think* the official function would do.

]]

local addonName, addonTable = ...
local bonusLevelBoost = {[1]=20,[15]=4,[44]=1,[171]=2,[448]=2,[449]=3,[450]=4,[451]=-3,[497]=50,[499]=1,[518]=-12,[519]=-10,[520]=-8,[521]=-6,[522]=-5,[526]=1,[527]=2,[545]=2,[546]=1,[547]=1,[552]=0,[553]=0,[554]=0,[555]=14,[556]=0,[557]=0,[558]=1,[559]=2,[560]=1,[561]=1,[562]=1,[566]=1,[567]=2,[571]=1,[573]=0,[575]=4,[576]=6,[577]=2,[579]=2,[591]=4,[592]=5,[593]=3,[594]=3,[595]=2,[596]=-4,[597]=-3,[598]=-2,[599]=-1,[609]=8,[617]=4,[618]=6,[619]=4,[620]=6,[622]=1,[623]=2,[624]=3,[625]=4,[626]=5,[627]=6,[628]=7,[629]=8,[630]=9,[631]=10,[632]=11,[633]=12,[634]=13,[635]=14,[636]=15,[637]=16,[638]=17,[639]=18,[640]=19,[641]=20,[642]=3,[644]=4,[646]=6,[648]=5,[651]=3,[665]=3,[666]=0,[667]=1,[668]=2,[669]=3,[670]=4,[671]=5,[672]=6,[673]=7,[674]=8,[675]=10,[676]=12,[677]=14,[678]=16,[679]=18,[680]=20,[681]=22,[682]=24,[694]=15,[695]=30,[696]=45,[697]=60,[698]=75,[699]=100,[700]=5,[701]=10,[702]=3,[703]=6,[704]=12,[706]=30,[707]=15,[708]=2,[709]=4,[710]=14,[754]=1,[755]=2,[756]=3,[757]=5,[758]=6,[759]=7,[760]=8,[761]=2,[762]=3,[763]=4,[764]=6,[765]=7,[766]=8,[769]=5,[1372]=-100,[1373]=-99,[1374]=-98,[1375]=-97,[1376]=-96,[1377]=-95,[1378]=-94,[1379]=-93,[1380]=-92,[1381]=-91,[1382]=-90,[1383]=-89,[1384]=-88,[1385]=-87,[1386]=-86,[1387]=-85,[1388]=-84,[1389]=-83,[1390]=-82,[1391]=-81,[1392]=-80,[1393]=-79,[1394]=-78,[1395]=-77,[1396]=-76,[1397]=-75,[1398]=-74,[1399]=-73,[1400]=-72,[1401]=-71,[1402]=-70,[1403]=-69,[1404]=-68,[1405]=-67,[1406]=-66,[1407]=-65,[1408]=-64,[1409]=-63,[1410]=-62,[1411]=-61,[1412]=-60,[1413]=-59,[1414]=-58,[1415]=-57,[1416]=-56,[1417]=-55,[1418]=-54,[1419]=-53,[1420]=-52,[1421]=-51,[1422]=-50,[1423]=-49,[1424]=-48,[1425]=-47,[1426]=-46,[1427]=-45,[1428]=-44,[1429]=-43,[1430]=-42,[1431]=-41,[1432]=-40,[1433]=-39,[1434]=-38,[1435]=-37,[1436]=-36,[1437]=-35,[1438]=-34,[1439]=-33,[1440]=-32,[1441]=-31,[1442]=-30,[1443]=-29,[1444]=-28,[1445]=-27,[1446]=-26,[1447]=-25,[1448]=-24,[1449]=-23,[1450]=-22,[1451]=-21,[1452]=-20,[1453]=-19,[1454]=-18,[1455]=-17,[1456]=-16,[1457]=-15,[1458]=-14,[1459]=-13,[1460]=-12,[1461]=-11,[1462]=-10,[1463]=-9,[1464]=-8,[1465]=-7,[1466]=-6,[1467]=-5,[1468]=-4,[1469]=-3,[1470]=-2,[1471]=-1,[1472]=0,[1473]=1,[1474]=2,[1475]=3,[1476]=4,[1477]=5,[1478]=6,[1479]=7,[1480]=8,[1481]=9,[1482]=10,[1483]=11,[1484]=12,[1485]=13,[1486]=14,[1487]=15,[1488]=16,[1489]=17,[1490]=18,[1491]=19,[1492]=20,[1493]=21,[1494]=22,[1495]=23,[1496]=24,[1497]=25,[1498]=26,[1499]=27,[1500]=28,[1501]=29,[1502]=30,[1503]=31,[1504]=32,[1505]=33,[1506]=34,[1507]=35,[1508]=36,[1509]=37,[1510]=38,[1511]=39,[1512]=40,[1513]=41,[1514]=42,[1515]=43,[1516]=44,[1517]=45,[1518]=46,[1519]=47,[1520]=48,[1521]=49,[1522]=50,[1523]=51,[1524]=52,[1525]=53,[1526]=54,[1527]=55,[1528]=56,[1529]=57,[1530]=58,[1531]=59,[1532]=60,[1533]=61,[1534]=62,[1535]=63,[1536]=64,[1537]=65,[1538]=66,[1539]=67,[1540]=68,[1541]=69,[1542]=70,[1543]=71,[1544]=72,[1545]=73,[1546]=74,[1547]=75,[1548]=76,[1549]=77,[1550]=78,[1551]=79,[1552]=80,[1553]=81,[1554]=82,[1555]=83,[1556]=84,[1557]=85,[1558]=86,[1559]=87,[1560]=88,[1561]=89,[1562]=90,[1563]=91,[1564]=92,[1565]=93,[1566]=94,[1567]=95,[1568]=96,[1569]=97,[1570]=98,[1571]=99,[1572]=100,[1573]=101,[1574]=102,[1575]=103,[1576]=104,[1577]=105,[1578]=106,[1579]=107,[1580]=108,[1581]=109,[1582]=110,[1583]=111,[1584]=112,[1585]=113,[1586]=114,[1587]=115,[1588]=116,[1589]=117,[1590]=118,[1591]=119,[1592]=120,[1593]=121,[1594]=122,[1595]=123,[1596]=124,[1597]=125,[1598]=126,[1599]=127,[1600]=128,[1601]=129,[1602]=130,[1603]=131,[1604]=132,[1605]=133,[1606]=134,[1607]=135,[1608]=136,[1609]=137,[1610]=138,[1611]=139,[1612]=140,[1613]=141,[1614]=142,[1615]=143,[1616]=144,[1617]=145,[1618]=146,[1619]=147,[1620]=148,[1621]=149,[1622]=150,[1623]=151,[1624]=152,[1625]=153,[1626]=154,[1627]=155,[1628]=156,[1629]=157,[1630]=158,[1631]=159,[1632]=160,[1633]=161,[1634]=162,[1635]=163,[1636]=164,[1637]=165,[1638]=166,[1639]=167,[1640]=168,[1641]=169,[1642]=170,[1643]=171,[1644]=172,[1645]=173,[1646]=174,[1647]=175,[1648]=176,[1649]=177,[1650]=178,[1651]=179,[1652]=180,[1653]=181,[1654]=182,[1655]=183,[1656]=184,[1657]=185,[1658]=186,[1659]=187,[1660]=188,[1661]=189,[1662]=190,[1663]=191,[1664]=192,[1665]=193,[1666]=194,[1667]=195,[1668]=196,[1669]=197,[1670]=198,[1671]=199,[1672]=200,[1800]=24,[1810]=140,[1817]=2,[1818]=4,[1819]=3,[1820]=5,[2829]=-400,[2830]=-399,[2831]=-398,[2832]=-397,[2833]=-396,[2834]=-395,[2835]=-394,[2836]=-393,[2837]=-392,[2838]=-391,[2839]=-390,[2840]=-389,[2841]=-388,[2842]=-387,[2843]=-386,[2844]=-385,[2845]=-384,[2846]=-383,[2847]=-382,[2848]=-381,[2849]=-380,[2850]=-379,[2851]=-378,[2852]=-377,[2853]=-376,[2854]=-375,[2855]=-374,[2856]=-373,[2857]=-372,[2858]=-371,[2859]=-370,[2860]=-369,[2861]=-368,[2862]=-367,[2863]=-366,[2864]=-365,[2865]=-364,[2866]=-363,[2867]=-362,[2868]=-361,[2869]=-360,[2870]=-359,[2871]=-358,[2872]=-357,[2873]=-356,[2874]=-355,[2875]=-354,[2876]=-353,[2877]=-352,[2878]=-351,[2879]=-350,[2880]=-349,[2881]=-348,[2882]=-347,[2883]=-346,[2884]=-345,[2885]=-344,[2886]=-343,[2887]=-342,[2888]=-341,[2889]=-340,[2890]=-339,[2891]=-338,[2892]=-337,[2893]=-336,[2894]=-335,[2895]=-334,[2896]=-333,[2897]=-332,[2898]=-331,[2899]=-330,[2900]=-329,[2901]=-328,[2902]=-327,[2903]=-326,[2904]=-325,[2905]=-324,[2906]=-323,[2907]=-322,[2908]=-321,[2909]=-320,[2910]=-319,[2911]=-318,[2912]=-317,[2913]=-316,[2914]=-315,[2915]=-314,[2916]=-313,[2917]=-312,[2918]=-311,[2919]=-310,[2920]=-309,[2921]=-308,[2922]=-307,[2923]=-306,[2924]=-305,[2925]=-304,[2926]=-303,[2927]=-302,[2928]=-301,[2929]=-300,[2930]=-299,[2931]=-298,[2932]=-297,[2933]=-296,[2934]=-295,[2935]=-294,[2936]=-293,[2937]=-292,[2938]=-291,[2939]=-290,[2940]=-289,[2941]=-288,[2942]=-287,[2943]=-286,[2944]=-285,[2945]=-284,[2946]=-283,[2947]=-282,[2948]=-281,[2949]=-280,[2950]=-279,[2951]=-278,[2952]=-277,[2953]=-276,[2954]=-275,[2955]=-274,[2956]=-273,[2957]=-272,[2958]=-271,[2959]=-270,[2960]=-269,[2961]=-268,[2962]=-267,[2963]=-266,[2964]=-265,[2965]=-264,[2966]=-263,[2967]=-262,[2968]=-261,[2969]=-260,[2970]=-259,[2971]=-258,[2972]=-257,[2973]=-256,[2974]=-255,[2975]=-254,[2976]=-253,[2977]=-252,[2978]=-251,[2979]=-250,[2980]=-249,[2981]=-248,[2982]=-247,[2983]=-246,[2984]=-245,[2985]=-244,[2986]=-243,[2987]=-242,[2988]=-241,[2989]=-240,[2990]=-239,[2991]=-238,[2992]=-237,[2993]=-236,[2994]=-235,[2995]=-234,[2996]=-233,[2997]=-232,[2998]=-231,[2999]=-230,[3000]=-229,[3001]=-228,[3002]=-227,[3003]=-226,[3004]=-225,[3005]=-224,[3006]=-223,[3007]=-222,[3008]=-221,[3009]=-220,[3010]=-219,[3011]=-218,[3012]=-217,[3013]=-216,[3014]=-215,[3015]=-214,[3016]=-213,[3017]=-212,[3018]=-211,[3019]=-210,[3020]=-209,[3021]=-208,[3022]=-207,[3023]=-206,[3024]=-205,[3025]=-204,[3026]=-203,[3027]=-202,[3028]=-201,[3029]=-200,[3030]=-199,[3031]=-198,[3032]=-197,[3033]=-196,[3034]=-195,[3035]=-194,[3036]=-193,[3037]=-192,[3038]=-191,[3039]=-190,[3040]=-189,[3041]=-188,[3042]=-187,[3043]=-186,[3044]=-185,[3045]=-184,[3046]=-183,[3047]=-182,[3048]=-181,[3049]=-180,[3050]=-179,[3051]=-178,[3052]=-177,[3053]=-176,[3054]=-175,[3055]=-174,[3056]=-173,[3057]=-172,[3058]=-171,[3059]=-170,[3060]=-169,[3061]=-168,[3062]=-167,[3063]=-166,[3064]=-165,[3065]=-164,[3066]=-163,[3067]=-162,[3068]=-161,[3069]=-160,[3070]=-159,[3071]=-158,[3072]=-157,[3073]=-156,[3074]=-155,[3075]=-154,[3076]=-153,[3077]=-152,[3078]=-151,[3079]=-150,[3080]=-149,[3081]=-148,[3082]=-147,[3083]=-146,[3084]=-145,[3085]=-144,[3086]=-143,[3087]=-142,[3088]=-141,[3089]=-140,[3090]=-139,[3091]=-138,[3092]=-137,[3093]=-136,[3094]=-135,[3095]=-134,[3096]=-133,[3097]=-132,[3098]=-131,[3099]=-130,[3100]=-129,[3101]=-128,[3102]=-127,[3103]=-126,[3104]=-125,[3105]=-124,[3106]=-123,[3107]=-122,[3108]=-121,[3109]=-120,[3110]=-119,[3111]=-118,[3112]=-117,[3113]=-116,[3114]=-115,[3115]=-114,[3116]=-113,[3117]=-112,[3118]=-111,[3119]=-110,[3120]=-109,[3121]=-108,[3122]=-107,[3123]=-106,[3124]=-105,[3125]=-104,[3126]=-103,[3127]=-102,[3128]=-101,[3130]=201,[3131]=202,[3132]=203,[3133]=204,[3134]=205,[3135]=206,[3136]=207,[3137]=208,[3138]=209,[3139]=210,[3140]=211,[3141]=212,[3142]=213,[3143]=214,[3144]=215,[3145]=216,[3146]=217,[3147]=218,[3148]=219,[3149]=220,[3150]=221,[3151]=222,[3152]=223,[3153]=224,[3154]=225,[3155]=226,[3156]=227,[3157]=228,[3158]=229,[3159]=230,[3160]=231,[3161]=232,[3162]=233,[3163]=234,[3164]=235,[3165]=236,[3166]=237,[3167]=238,[3168]=239,[3169]=240,[3170]=241,[3171]=242,[3172]=243,[3173]=244,[3174]=245,[3175]=246,[3176]=247,[3177]=248,[3178]=249,[3179]=250,[3180]=251,[3181]=252,[3182]=253,[3183]=254,[3184]=255,[3185]=256,[3186]=257,[3187]=258,[3188]=259,[3189]=260,[3190]=261,[3191]=262,[3192]=263,[3193]=264,[3194]=265,[3195]=266,[3196]=267,[3197]=268,[3198]=269,[3199]=270,[3200]=271,[3201]=272,[3202]=273,[3203]=274,[3204]=275,[3205]=276,[3206]=277,[3207]=278,[3208]=279,[3209]=280,[3210]=281,[3211]=282,[3212]=283,[3213]=284,[3214]=285,[3215]=286,[3216]=287,[3217]=288,[3218]=289,[3219]=290,[3220]=291,[3221]=292,[3222]=293,[3223]=294,[3224]=295,[3225]=296,[3226]=297,[3227]=298,[3228]=299,[3229]=300,[3230]=301,[3231]=302,[3232]=303,[3233]=304,[3234]=305,[3235]=306,[3236]=307,[3237]=308,[3238]=309,[3239]=310,[3240]=311,[3241]=312,[3242]=313,[3243]=314,[3244]=315,[3245]=316,[3246]=317,[3247]=318,[3248]=319,[3249]=320,[3250]=321,[3251]=322,[3252]=323,[3253]=324,[3254]=325,[3255]=326,[3256]=327,[3257]=328,[3258]=329,[3259]=330,[3260]=331,[3261]=332,[3262]=333,[3263]=334,[3264]=335,[3265]=336,[3266]=337,[3267]=338,[3268]=339,[3269]=340,[3270]=341,[3271]=342,[3272]=343,[3273]=344,[3274]=345,[3275]=346,[3276]=347,[3277]=348,[3278]=349,[3279]=350,[3280]=351,[3281]=352,[3282]=353,[3283]=354,[3284]=355,[3285]=356,[3286]=357,[3287]=358,[3288]=359,[3289]=360,[3290]=361,[3291]=362,[3292]=363,[3293]=364,[3294]=365,[3295]=366,[3296]=367,[3297]=368,[3298]=369,[3299]=370,[3300]=371,[3301]=372,[3302]=373,[3303]=374,[3304]=375,[3305]=376,[3306]=377,[3307]=378,[3308]=379,[3309]=380,[3310]=381,[3311]=382,[3312]=383,[3313]=384,[3314]=385,[3315]=386,[3316]=387,[3317]=388,[3318]=389,[3319]=390,[3320]=391,[3321]=392,[3322]=393,[3323]=394,[3324]=395,[3325]=396,[3326]=397,[3327]=398,[3328]=399,[3329]=400,[3330]=3,[3331]=1,[3332]=6,[3333]=7,[3334]=8,[3340]=2,[3341]=8,[3381]=0,[3382]=1,[3383]=2,[3384]=4,[3390]=12,[3391]=15,[3393]=4,[3438]=8,[3439]=11,[3440]=14,[3455]=30,[3492]=2,[3493]=26,[3494]=34,[3526]=16,[3530]=25,[3541]=-2,[3542]=-5,[3543]=-3,[3570]=50,[3571]=90,[3586]=45,[3587]=6,[3588]=9,[3593]=1,[3594]=2,[3595]=3,[3598]=0,[3599]=2,[3600]=4,[3601]=6,[3602]=8,[3603]=10,[3604]=13,[3605]=18,[3606]=23,[3607]=28,[3608]=33,[3630]=75,[3824]=-1,[3825]=1,[3826]=2,[3827]=3,[3986]=5,[3987]=10,[3988]=15,[3989]=20,[3990]=25,[3991]=30,[3992]=35,[3993]=40,[3994]=45,[3995]=50,[3996]=55,[3997]=60,[4213]=88,[4232]=15,[4775]=5,[4797]=-30,[4926]=8,[4928]=10,[4929]=15,[4930]=15,[4931]=0,[4936]=15,[4948]=-20,[4949]=-10,[4950]=0,[5117]=-15,[5118]=-5,[5127]=40,}
local bonusPreviewLevel = {[1726]=845,[1727]=865,[1798]=705,[1799]=720,[1801]=690,[1805]=865,[1806]=880,[1807]=850,[1824]=0,[1825]=0,[1826]=825,[3379]=835,[3394]=0,[3395]=0,[3396]=0,[3397]=0,[3399]=840,[3410]=870,[3411]=870,[3412]=875,[3413]=875,[3414]=880,[3415]=880,[3416]=885,[3417]=885,[3418]=890,[3427]=805,[3428]=840,[3432]=0,[3437]=830,[3443]=870,[3444]=885,[3445]=900,[3446]=855,[3449]=850,[3450]=860,[3451]=865,[3452]=855,[3453]=860,[3454]=875,[3457]=810,[3460]=810,[3461]=815,[3462]=855,[3463]=865,[3464]=875,[3465]=885,[3466]=860,[3467]=860,[3468]=875,[3469]=890,[3470]=845,[3473]=0,[3474]=0,[3476]=870,[3477]=875,[3478]=880,[3479]=890,[3480]=900,[3481]=880,[3482]=815,[3483]=820,[3484]=825,[3485]=830,[3486]=835,[3487]=820,[3488]=825,[3489]=830,[3490]=835,[3491]=840,[3505]=850,[3506]=865,[3507]=880,[3508]=895,[3509]=895,[3510]=895,[3514]=875,[3515]=880,[3516]=890,[3517]=895,[3518]=905,[3519]=910,[3520]=860,[3521]=865,[3534]=900,[3535]=905,[3536]=910,[3561]=870,[3562]=885,[3563]=900,[3564]=855,[3565]=810,[3566]=810,[3567]=810,[3568]=810,[3572]=0,[3575]=855,[3576]=855,[3577]=855,[3579]=810,[3580]=810,[3581]=810,[3582]=810,[3583]=810,[3584]=810,[3610]=870,[3611]=885,[3612]=900,[3613]=855,[3614]=860,[4777]=825,[4778]=845,[4779]=865,[4780]=870,[4798]=880,[4799]=895,[4800]=910,[4801]=865,[4803]=0,[4946]=870,[4982]=810,[4983]=810,[4984]=810,[4985]=810,[4986]=810,[4987]=810,[4988]=810,[4989]=810,[4992]=810,[4993]=810,[4994]=810,[4995]=810,[4996]=810,[4997]=810,[4998]=810,[4999]=810,[5000]=810,[5001]=810,[5002]=870,[5003]=810,[5004]=810,[5005]=870,[5006]=870,[5007]=870,[5008]=870,[5009]=870,[5010]=870,[5065]=810,[5066]=810,[5067]=810,[5068]=810,[5069]=810,[5070]=810,[5071]=810,[5072]=810,[5073]=810,[5074]=810,[5075]=810,[5076]=810,[5077]=810,[5078]=810,[5079]=810,[5080]=810,[5081]=810,[5082]=810,[5083]=810,[5084]=810,[5085]=810,[5086]=810,[5087]=810,[5088]=810,[5089]=810,[5090]=810,[5091]=810,[5092]=810,[5093]=810,[5094]=810,[5095]=810,[5096]=810,[5097]=810,[5098]=810,[5099]=810,[5100]=810,[5101]=810,[5102]=810,[5103]=810,[5104]=810,[5105]=810,[5106]=810,[5107]=810,[5108]=810,[5109]=810,[5110]=810,[5111]=810,[5112]=810,[5113]=810,[5114]=810,[5119]=895,}
local bonusLevelCurve = {[615]=2794,[645]=3157,[656]=3157,[664]=1648,[692]=1617,[767]=1558,[768]=1688,[1723]=1746,[1724]=1748,[1725]=1749,[1729]=1751,[1730]=1752,[1731]=1753,[1732]=1648,[1733]=1758,[1734]=1759,[1735]=1759,[1736]=1756,[1737]=1757,[1738]=1757,[1739]=1760,[1740]=1761,[1741]=1761,[1788]=1787,[1789]=1788,[1790]=1789,[1791]=1790,[1792]=1756,[1793]=1760,[1794]=1758,[1795]=1832,[1796]=1824,[1812]=2002,[3342]=2202,[3380]=2196,[3387]=2208,[3388]=2209,[3389]=2210,[3398]=2247,[3448]=2466,[3502]=2794,[3578]=3039,[3585]=3157,[3589]=3170,[3590]=3171,[3596]=2794,[3621]=4801,[3622]=3171,[3623]=4242,[3624]=4243,[3625]=4244,[3626]=4245,[3627]=4246,[3628]=4242,[3631]=5063,[3632]=3039,[3633]=5063,[3634]=5063,[3635]=5063,[3636]=5063,[3637]=5063,[3638]=5063,[3639]=5063,[3640]=5063,[3641]=5063,[3642]=5063,[3643]=5063,[3644]=5063,[3645]=5063,[3646]=5063,[3647]=5063,[3648]=5063,[3649]=5063,[3650]=5063,[3651]=5063,[3652]=5063,[3653]=5063,[3654]=5063,[3655]=5063,[3656]=5063,[3657]=5063,[3658]=5063,[3659]=5063,[3660]=5063,[3661]=5063,[3662]=5063,[3663]=5063,[3664]=5063,[3665]=5063,[3666]=5063,[3667]=5063,[3668]=5063,[3669]=5063,[3670]=5063,[3671]=5063,[3672]=5063,[3673]=5063,[3674]=5063,[3675]=5063,[3676]=5063,[3677]=5063,[3678]=5063,[3679]=5063,[3680]=5063,[3681]=5063,[3682]=5063,[3683]=5063,[3684]=5063,[3685]=5063,[3686]=5063,[3687]=5063,[3688]=5063,[3689]=5063,[3690]=5063,[3691]=5063,[3692]=5063,[3693]=5063,[3694]=5063,[3695]=5063,[3696]=5063,[3697]=5063,[3698]=5063,[3699]=5063,[3700]=5063,[3701]=5063,[3702]=5063,[3703]=5063,[3704]=5063,[3705]=5063,[3706]=5063,[3707]=5063,[3708]=5063,[3709]=5063,[3710]=5063,[3711]=5063,[3712]=5064,[3713]=5064,[3714]=5064,[3715]=5064,[3716]=5064,[3717]=5064,[3718]=5064,[3719]=5064,[3720]=5064,[3721]=5064,[3722]=5064,[3723]=5064,[3724]=5064,[3725]=5064,[3726]=5064,[3727]=5064,[3728]=5064,[3729]=5064,[3730]=5064,[3731]=5064,[3732]=5064,[3733]=5064,[3734]=5064,[3735]=5064,[3736]=5064,[3737]=5064,[3738]=5064,[3739]=5064,[3740]=5064,[3741]=5064,[3742]=5064,[3743]=5064,[3744]=5064,[3745]=5064,[3746]=5064,[3747]=5064,[3748]=5064,[3749]=5064,[3750]=5064,[3751]=5064,[3752]=5064,[3753]=5064,[3754]=5064,[3755]=5064,[3756]=5064,[3757]=5064,[3758]=5064,[3759]=5064,[3760]=5064,[3761]=5064,[3762]=5064,[3763]=5064,[3764]=5064,[3765]=5064,[3766]=5064,[3767]=5064,[3768]=5064,[3769]=5064,[3770]=5064,[3771]=5064,[3772]=5064,[3773]=5064,[3774]=5064,[3775]=5064,[3776]=5064,[3777]=5064,[3778]=5064,[3779]=5064,[3780]=5064,[3781]=5064,[3782]=5064,[3783]=5064,[3784]=5064,[3785]=5064,[3786]=5064,[3787]=5064,[3788]=5064,[3789]=5064,[3790]=5064,[3791]=5063,[3792]=5064,[3793]=5063,[3794]=5063,[3795]=5063,[3796]=5063,[3797]=5063,[3798]=5063,[3799]=5063,[3800]=5063,[3801]=5063,[3802]=5063,[3803]=5063,[3804]=5086,[3805]=5086,[3806]=5086,[3807]=5091,[3808]=5100,[3809]=5099,[3810]=5098,[3811]=5097,[3812]=5096,[3813]=5095,[3814]=5094,[3815]=5093,[3816]=5092,[3817]=5101,[3818]=5102,[3819]=5103,[3820]=5086,[3821]=5086,[3823]=5086,[3828]=5234,[3829]=5235,[3830]=5236,[3831]=5237,[3832]=5238,[3833]=5239,[3834]=5240,[3835]=5241,[3836]=5242,[3837]=5243,[3838]=5244,[3839]=5245,[3840]=5273,[3841]=5274,[3842]=5278,[3843]=5282,[3844]=5286,[3845]=5292,[3846]=5296,[3847]=5300,[3848]=5304,[3849]=5277,[3850]=5281,[3851]=6033,[3852]=5291,[3853]=5295,[3854]=5299,[3855]=6093,[3856]=5307,[3857]=5246,[3858]=5247,[3859]=5248,[3860]=5249,[3861]=5250,[3862]=5251,[3863]=5252,[3864]=5253,[3865]=5254,[3866]=5255,[3867]=5256,[3868]=5257,[3869]=5258,[3870]=5276,[3871]=5280,[3872]=6035,[3873]=6036,[3874]=5294,[3875]=5298,[3876]=6091,[3877]=5306,[3878]=5259,[3879]=5260,[3880]=5261,[3881]=5262,[3882]=5263,[3883]=5264,[3884]=5265,[3885]=5266,[3886]=5267,[3887]=5268,[3888]=5270,[3889]=5271,[3890]=5272,[3891]=5275,[3892]=5279,[3893]=5283,[3894]=5289,[3895]=5293,[3896]=5297,[3897]=5301,[3898]=5305,[3899]=5309,[3900]=5310,[3901]=5312,[3902]=5313,[3903]=5314,[3904]=5315,[3905]=5318,[3906]=5319,[3907]=5320,[3908]=5321,[3909]=5322,[3910]=5323,[3911]=5324,[3912]=6029,[3913]=5326,[3914]=5327,[3915]=5328,[3916]=6153,[3917]=5330,[3918]=5331,[3919]=5332,[3920]=5333,[3921]=5334,[3922]=5335,[3923]=5336,[3924]=5337,[3925]=5338,[3926]=5339,[3927]=5340,[3928]=5341,[3929]=5342,[3930]=5343,[3931]=5344,[3932]=5345,[3933]=6031,[3934]=5347,[3935]=5348,[3936]=5349,[3937]=6083,[3938]=5351,[3939]=5352,[3940]=5353,[3941]=5311,[3942]=5316,[3943]=5354,[3944]=5355,[3945]=5356,[3946]=5357,[3947]=5358,[3948]=5359,[3949]=5360,[3950]=5361,[3951]=5362,[3952]=5363,[3953]=5364,[3954]=5365,[3955]=5366,[3956]=6025,[3957]=6134,[3958]=5369,[3959]=5370,[3960]=6151,[3961]=5372,[3962]=5373,[3963]=5374,[3964]=5375,[3965]=5376,[3966]=5377,[3967]=5378,[3968]=5379,[3969]=5380,[3970]=5381,[3971]=5382,[3972]=5383,[3973]=5384,[3974]=5385,[3975]=5386,[3976]=5387,[3977]=6027,[3978]=5389,[3979]=5390,[3980]=5391,[3981]=6152,[3982]=5393,[3998]=5449,[3999]=5449,[4000]=5451,[4001]=5448,[4002]=5451,[4003]=5448,[4004]=5448,[4005]=5449,[4006]=5451,[4007]=5448,[4008]=5449,[4009]=5451,[4010]=5448,[4011]=5449,[4012]=5451,[4013]=5448,[4014]=5449,[4015]=5451,[4016]=5448,[4017]=5449,[4018]=5451,[4019]=5448,[4020]=5449,[4021]=5451,[4022]=5448,[4023]=5449,[4024]=5451,[4025]=5448,[4026]=5449,[4027]=5451,[4028]=5448,[4029]=5449,[4030]=5451,[4031]=5448,[4032]=5449,[4033]=5451,[4034]=5448,[4035]=5449,[4036]=5451,[4037]=5448,[4038]=5449,[4039]=5451,[4040]=5448,[4041]=5451,[4042]=5448,[4043]=5449,[4044]=5451,[4045]=5448,[4046]=5449,[4047]=5451,[4048]=5448,[4049]=5449,[4050]=5451,[4051]=5448,[4052]=5449,[4053]=5451,[4054]=5449,[4055]=5448,[4056]=5449,[4057]=5451,[4058]=5448,[4059]=5449,[4060]=5451,[4061]=5448,[4062]=5449,[4063]=5451,[4064]=5448,[4065]=5449,[4066]=5451,[4067]=5448,[4068]=5449,[4069]=5451,[4070]=5448,[4071]=5449,[4072]=5451,[4074]=5449,[4075]=5448,[4076]=5448,[4077]=5449,[4079]=5448,[4080]=5449,[4082]=5448,[4083]=5449,[4085]=5448,[4086]=5449,[4088]=5448,[4089]=5449,[4090]=5448,[4091]=5449,[4092]=5448,[4093]=5449,[4094]=5448,[4095]=5449,[4096]=5448,[4097]=5449,[4098]=5448,[4099]=5449,[4100]=5448,[4101]=5449,[4102]=5448,[4103]=5449,[4104]=5448,[4105]=5449,[4106]=5448,[4107]=5449,[4108]=5448,[4109]=5449,[4110]=5448,[4111]=5449,[4112]=5448,[4113]=5449,[4114]=5448,[4115]=5449,[4116]=5448,[4117]=5449,[4118]=5448,[4119]=5449,[4120]=5448,[4121]=5449,[4122]=5448,[4123]=5449,[4124]=5448,[4125]=5449,[4126]=5448,[4127]=5449,[4128]=5448,[4129]=5449,[4130]=5448,[4131]=5449,[4132]=5448,[4133]=5449,[4134]=5448,[4135]=5449,[4136]=5448,[4137]=5449,[4138]=5448,[4139]=5449,[4140]=5448,[4141]=5449,[4142]=5449,[4143]=5448,[4144]=5715,[4145]=5715,[4146]=5448,[4147]=5449,[4148]=5448,[4149]=5449,[4150]=5715,[4151]=5715,[4152]=5448,[4153]=5449,[4154]=5448,[4155]=5449,[4156]=5448,[4157]=5449,[4158]=5448,[4159]=5449,[4160]=5715,[4161]=5715,[4162]=5448,[4163]=5449,[4164]=5448,[4165]=5449,[4166]=5448,[4167]=5449,[4168]=5448,[4169]=5449,[4170]=5448,[4171]=5449,[4172]=5448,[4173]=5449,[4174]=5448,[4175]=5449,[4176]=5448,[4177]=5449,[4178]=5448,[4179]=5449,[4180]=5448,[4181]=5449,[4182]=5448,[4183]=5449,[4184]=5448,[4185]=5449,[4186]=5448,[4187]=5449,[4188]=5448,[4189]=5449,[4190]=5448,[4191]=5449,[4192]=5448,[4193]=5449,[4194]=5452,[4195]=5453,[4196]=5454,[4197]=5455,[4198]=5456,[4199]=5457,[4200]=5458,[4201]=5459,[4202]=5461,[4204]=5462,[4205]=5086,[4206]=5086,[4207]=5086,[4208]=5086,[4209]=5086,[4210]=5086,[4211]=5086,[4212]=5086,[4214]=5553,[4215]=5554,[4216]=5555,[4217]=5556,[4218]=5557,[4219]=5558,[4220]=5559,[4221]=5560,[4222]=5561,[4223]=5562,[4224]=5563,[4225]=5564,[4226]=5565,[4227]=5566,[4228]=5567,[4229]=5568,[4233]=5086,[4234]=5086,[4235]=5064,[4236]=5714,[4237]=5715,[4238]=5449,[4239]=5449,[4240]=5730,[4241]=5449,[4242]=5449,[4243]=5449,[4244]=5449,[4246]=5857,[4247]=5362,[4248]=5361,[4249]=5364,[4250]=5365,[4251]=5366,[4252]=5367,[4253]=6134,[4254]=6133,[4255]=5370,[4256]=6134,[4257]=6132,[4258]=5382,[4259]=5383,[4260]=5979,[4261]=5385,[4262]=5386,[4263]=5387,[4264]=5388,[4265]=5389,[4266]=6137,[4267]=5391,[4268]=5319,[4269]=5320,[4270]=5980,[4271]=5322,[4272]=5340,[4273]=5341,[4274]=5981,[4275]=5343,[4276]=5243,[4277]=5244,[4278]=6108,[4279]=5993,[4280]=5255,[4281]=5256,[4282]=6109,[4283]=5994,[4284]=5326,[4285]=6139,[4286]=5347,[4287]=6142,[4288]=5291,[4289]=6145,[4290]=5290,[4291]=6149,[4292]=5323,[4293]=5324,[4294]=5325,[4295]=5326,[4296]=6140,[4297]=5328,[4298]=5344,[4299]=5345,[4300]=5346,[4301]=5347,[4302]=6143,[4303]=5349,[4304]=5277,[4305]=5291,[4306]=5285,[4307]=6146,[4308]=5299,[4309]=5281,[4310]=5276,[4311]=5280,[4312]=5284,[4313]=5290,[4314]=6150,[4315]=5298,[4316]=6136,[4317]=5389,[4318]=5086,[4319]=5086,[4320]=5064,[4321]=5086,[4322]=5064,[4323]=5086,[4324]=5086,[4325]=5064,[4326]=5086,[4327]=5086,[4328]=5064,[4329]=5086,[4330]=5086,[4331]=5064,[4332]=5086,[4333]=5086,[4334]=5064,[4335]=5086,[4336]=5086,[4337]=5064,[4338]=5086,[4493]=6045,[4503]=6089,[4738]=6101,[4739]=6102,[4740]=6103,[4741]=5459,[4742]=5448,[4743]=5448,[4744]=5448,[4745]=5448,[4746]=5448,[4747]=5448,[4748]=5448,[4749]=5448,[4750]=6104,[4751]=6105,[4752]=6106,[4753]=6107,[4754]=5086,[4755]=6131,[4756]=6132,[4757]=6135,[4758]=6136,[4759]=6138,[4760]=6139,[4761]=6141,[4762]=6142,[4763]=6144,[4764]=6145,[4765]=6147,[4766]=6148,[4767]=6149,[4768]=6171,[4769]=6172,[4770]=6173,[4771]=6174,[4772]=6175,[4773]=6176,[4774]=6177,[4776]=6226,[4787]=6241,[4788]=6239,[4789]=6240,[4790]=6243,[4791]=6242,[4792]=6244,[4793]=6247,[4794]=6245,[4795]=6246,[4796]=6321,[4804]=6611,[4805]=6612,[4806]=6613,[4807]=6614,[4808]=6693,[4809]=6694,[4810]=6695,[4811]=6239,[4812]=6242,[4813]=6245,[4814]=6240,[4815]=6244,[4816]=6246,[4821]=6226,[4937]=7117,[4938]=7118,[4939]=7119,[4940]=7120,[4941]=7121,[4942]=7122,[4943]=7123,[4944]=7124,[4945]=7125,[4990]=6226,[5036]=6226,[5130]=8388,[5131]=8389,[5132]=8390,[5133]=8391,[5134]=8388,}
local curvePoints = {[1558]={{98,138},{99,138},{100,139},{109,157},},[1617]={{1,10},{5,10},{57,58},{58,60},{67,80},{68,87},{80,100},{81,104},{85,108},{86,112},{90,116},{91,128},{97,136},{98,136},{99,136},{100,138},{101,142},{109,158},{110,160},},[1648]={{98,138},{99,139},{100,140},{109,158},},[1688]={{98,138},{99,140},{100,140},{109,158},},[1746]={{1,10},{5,10},{59,58},{60,58},{69,73},{70,82},{79,100},{80,102},{84,108},{85,109},{89,116},{90,124},{99,136},{100,140},{109,158},{110,158},},[1748]={{1,10},{5,13},{59,58},{60,60},{69,80},{70,87},{79,100},{80,103},{84,108},{85,110},{89,116},{90,126},{99,136},{100,142},{104,150},{109,160},{110,160},},[1749]={{1,10},{5,15},{59,58},{60,63},{69,80},{70,92},{79,100},{80,104},{84,108},{85,112},{89,116},{90,128},{99,138},{100,144},{110,160},},[1751]={{650,0},{689,0},{690,1},{691,0},{850,0},},[1752]={{650,0},{809,0},{810,1},{811,0},{850,0},},[1753]={{95,1},{100,12},{109,20},{110,20},{115,30},},[1756]={{98,138},{99,141},{100,142},{109,160},},[1757]={{98,139},{99,143},{100,144},{109,160},},[1758]={{98,138},{99,140},{100,141},{109,160},},[1759]={{98,138},{99,142},{100,143},{109,160},},[1760]={{98,138},{99,142},{100,142},{109,160},},[1761]={{98,140},{99,144},{100,144},{109,160},},[1787]={{1,10},{5,10},{39,41},},[1788]={{1,10},{5,13},{39,44},},[1789]={{1,10},{5,15},{39,48},},[1790]={{1,10},{5,10},{59,58},},[1824]={{98,131},{99,138},{100,138},{101,139},{109,156},},[1832]={{98,138},{99,141},{100,142},{109,160},},[2002]={{98,138},{99,138},{100,138},{109,158},},[2196]={{1,10},{5,10},{57,57},{58,58},{67,67},{68,80},{80,100},{81,100},{85,108},{86,108},{90,116},{91,120},{97,132},{98,134},{99,136},{100,138},},[2202]={{98,138},{99,138},{100,139},{109,151},},[2208]={{1,10},{5,10},{57,58},{58,58},{67,73},{68,82},{80,100},{81,102},{85,108},{86,109},{90,116},{91,124},{97,136},{98,137},{99,138},{100,142},{110,142},},[2209]={{1,10},{5,15},{57,58},{58,60},{67,77},{68,84},{80,100},{81,103},{85,108},{86,110},{90,116},{91,126},{97,136},{98,138},{99,138},{100,144},{110,144},},[2210]={{1,10},{5,20},{57,58},{58,63},{67,80},{68,87},{80,100},{81,104},{85,108},{86,112},{90,116},{91,128},{97,136},{98,138},{99,140},{100,146},{110,146},},[2247]={{97,116},{98,150},{109,160},},[2466]={{1,10},{5,10},{57,57},{58,58},{67,67},{68,80},{80,100},{81,100},{85,108},{86,108},{90,116},{91,120},{97,132},{98,134},{99,136},{100,138},{109,154},{110,164},},[2794]={{1,10},{5,10},{57,58},{58,58},{67,73},{68,82},{80,100},{81,102},{85,108},{86,109},{90,116},{91,124},{97,135},{98,136},{99,136},{100,138},{101,145},{109,160},{110,168},},[3039]={{1,10},{11,10},{20,19},{56,55},{58,58},{67,73},{68,82},{80,100},{81,102},{85,108},{86,109},{90,116},{91,124},{97,136},{98,137},{99,138},{100,142},{110,160},{111,210},{120,280},},[3157]={{1,10},{5,16},{57,58},{58,60},{67,77},{68,85},{80,100},{81,102},{85,108},{86,110},{90,116},{91,126},{97,136},{98,136},{99,136},{100,138},{101,148},{109,160},{110,174},},[3170]={{1,10},{5,10},{57,58},{58,58},{67,73},{68,82},{80,100},{81,102},{85,108},{86,109},{90,116},{91,124},{97,135},{98,136},{99,136},{100,138},{101,145},{109,160},{110,188},},[3171]={{1,10},{5,16},{57,58},{58,60},{67,77},{68,85},{80,100},{81,102},{85,108},{86,110},{90,116},{91,126},{97,136},{98,136},{99,136},{100,138},{101,148},{109,160},{110,195},},[4242]={{1,10},{5,10},{57,58},{58,58},{67,73},{68,82},{80,100},{81,102},{85,108},{86,109},{90,116},{91,124},{97,135},{98,136},{99,136},{100,138},{101,145},{109,160},{110,180},},[4243]={{1,10},{5,16},{57,58},{58,60},{67,77},{68,85},{80,100},{81,102},{85,108},{86,110},{90,116},{91,126},{97,136},{98,136},{99,136},{100,138},{101,148},{109,160},{110,186},},[4244]={{1,10},{5,10},{57,58},{58,58},{67,73},{68,82},{80,100},{81,102},{85,108},{86,109},{90,116},{91,124},{97,135},{98,136},{99,136},{100,138},{101,145},{109,160},{110,210},},[4245]={{1,10},{5,16},{57,58},{58,60},{67,77},{68,85},{80,100},{81,102},{85,108},{86,110},{90,116},{91,126},{97,136},{98,136},{99,136},{100,138},{101,148},{109,160},{110,225},},[4246]={{1,10},{5,10},{57,58},{58,60},{67,80},{68,87},{80,100},{81,104},{85,108},{86,112},{90,116},{91,128},{97,136},{98,136},{99,136},{100,138},{101,142},{109,158},{110,180},},[4801]={{1,10},{5,10},{57,58},{58,58},{67,73},{68,82},{80,100},{81,102},{85,108},{86,109},{90,116},{91,124},{97,135},{98,136},{99,136},{100,138},{101,145},{109,160},{110,188},},[5063]={{1,1},{60,58},{61,59},{65,67},{70,79},{71,81},{75,89},{80,99},{81,100},{85,107},{86,108},{90,116},{91,120},{97,132},{100,136},{101,140},{109,158},{110,158},{150,158},},[5064]={{1,7},{60,58},{61,61},{65,72},{70,80},{71,85},{75,94},{80,100},{81,102},{85,108},{86,109},{90,116},{91,122},{97,135},{100,136},{101,142},{109,160},{110,160},{150,160},},[5086]={{1,13},{60,58},{61,65},{65,77},{70,80},{71,89},{75,98},{80,100},{81,103},{85,108},{86,110},{90,116},{91,124},{97,136},{100,136},{101,144},{109,160},{110,160},{150,160},},[5091]={{1,1},{200,1},},[5092]={{1,46},{200,46},},[5093]={{1,41},{200,41},},[5094]={{1,36},{200,36},},[5095]={{1,31},{200,31},},[5096]={{1,26},{200,26},},[5097]={{1,21},{200,21},},[5098]={{1,16},{200,16},},[5099]={{1,11},{200,11},},[5100]={{1,6},{200,6},},[5101]={{1,51},{200,51},},[5102]={{1,58},{200,58},},[5103]={{1,58},{200,58},},[5234]={{1,10},{200,10},},[5235]={{1,13},{200,13},},[5236]={{1,16},{200,16},},[5237]={{1,19},{200,19},},[5238]={{1,24},{200,24},},[5239]={{1,29},{200,29},},[5240]={{1,34},{200,34},},[5241]={{1,39},{200,39},},[5242]={{1,44},{200,44},},[5243]={{1,49},{200,49},},[5244]={{1,54},{200,54},},[5245]={{1,58},{200,58},},[5246]={{1,10},{200,10},},[5247]={{1,14},{200,14},},[5248]={{1,18},{200,18},},[5249]={{1,23},{200,23},},[5250]={{1,27},{200,27},},[5251]={{1,32},{200,32},},[5252]={{1,37},{200,37},},[5253]={{1,42},{200,42},},[5254]={{1,47},{200,47},},[5255]={{1,52},{200,52},},[5256]={{1,57},{200,57},},[5257]={{1,59},{200,59},},[5258]={{1,69},{200,69},},[5259]={{1,3},{200,3},},[5260]={{1,8},{200,8},},[5261]={{1,13},{200,13},},[5262]={{1,18},{200,18},},[5263]={{1,23},{200,23},},[5264]={{1,28},{200,28},},[5265]={{1,33},{200,33},},[5266]={{1,38},{200,38},},[5267]={{1,43},{200,43},},[5268]={{1,48},{200,48},},[5270]={{1,53},{200,53},},[5271]={{1,58},{200,58},},[5272]={{1,58},{200,58},},[5273]={{1,67},{200,67},},[5274]={{1,80},{200,80},},[5275]={{1,80},{200,80},},[5276]={{1,81},{200,81},},[5277]={{1,80},{200,80},},[5278]={{1,80},{200,80},},[5279]={{1,82},{200,82},},[5280]={{1,91},{200,91},},[5281]={{1,89},{200,89},},[5282]={{1,87},{82,87},{83,100},{200,100},},[5283]={{1,100},{82,100},{83,100},{200,100},},[5284]={{1,100},{200,100},},[5285]={{1,100},{200,100},},[5286]={{1,100},{87,100},{87,100},{200,100},},[5289]={{1,100},{87,100},{88,100},{200,100},},[5290]={{1,108},{200,108},},[5291]={{1,108},{200,108},},[5292]={{1,100},{200,100},},[5293]={{1,100},{200,100},},[5294]={{1,120},{200,120},},[5295]={{1,116},{200,116},},[5296]={{1,104},{200,104},},[5297]={{1,108},{200,108},},[5298]={{1,130},{200,130},},[5299]={{1,130},{200,130},},[5300]={{1,108},{200,108},},[5301]={{1,108},{200,108},},[5304]={{1,110},{200,110},},[5305]={{1,110},{200,110},},[5306]={{1,158},{200,158},},[5307]={{1,156},{200,156},},[5309]={{1,13},{200,13},},[5310]={{1,18},{200,18},},[5311]={{1,23},{200,23},},[5312]={{1,28},{200,28},},[5313]={{1,33},{200,33},},[5314]={{1,38},{200,38},},[5315]={{1,43},{200,43},},[5316]={{1,48},{200,48},},[5318]={{1,53},{200,53},},[5319]={{1,57},{200,57},},[5320]={{1,58},{200,58},},[5321]={{1,72},{200,72},},[5322]={{1,80},{200,80},},[5323]={{1,94},{200,94},},[5324]={{1,100},{200,100},},[5325]={{1,104},{200,104},},[5326]={{1,112},{200,112},},[5327]={{1,130},{200,130},},[5328]={{1,136},{200,136},},[5330]={{1,160},{200,160},},[5331]={{1,15},{200,15},},[5332]={{1,20},{200,20},},[5333]={{1,25},{200,25},},[5334]={{1,30},{200,30},},[5335]={{1,35},{200,35},},[5336]={{1,40},{200,40},},[5337]={{1,45},{200,45},},[5338]={{1,50},{200,50},},[5339]={{1,55},{200,55},},[5340]={{1,58},{200,58},},[5341]={{1,58},{200,58},},[5342]={{1,74},{200,74},},[5343]={{1,80},{200,80},},[5344]={{1,95},{200,95},},[5345]={{1,100},{200,100},},[5346]={{1,104},{200,104},},[5347]={{1,114},{200,114},},[5348]={{1,130},{200,130},},[5349]={{1,136},{200,136},},[5351]={{1,160},{200,160},},[5352]={{1,20},{200,20},},[5353]={{1,25},{200,25},},[5354]={{1,30},{200,30},},[5355]={{1,35},{200,35},},[5356]={{1,40},{200,40},},[5357]={{1,45},{200,45},},[5358]={{1,50},{200,50},},[5359]={{1,55},{200,55},},[5360]={{1,58},{200,58},},[5361]={{1,58},{200,58},},[5362]={{1,58},{200,58},},[5363]={{1,80},{200,80},},[5364]={{1,83},{200,83},},[5365]={{1,100},{200,100},},[5366]={{1,100},{200,100},},[5367]={{1,106},{200,106},},[5369]={{1,132},{200,132},},[5370]={{1,136},{200,136},},[5372]={{1,160},{200,160},},[5373]={{1,21},{200,21},},[5374]={{1,26},{200,26},},[5375]={{1,31},{200,31},},[5376]={{1,36},{200,36},},[5377]={{1,41},{200,41},},[5378]={{1,46},{200,46},},[5379]={{1,51},{200,51},},[5380]={{1,56},{200,56},},[5381]={{1,58},{200,58},},[5382]={{1,58},{200,58},},[5383]={{1,58},{200,58},},[5384]={{1,80},{200,80},},[5385]={{1,86},{200,86},},[5386]={{1,100},{200,100},},[5387]={{1,100},{200,100},},[5388]={{1,108},{200,108},},[5389]={{1,116},{200,116},},[5390]={{1,134},{200,134},},[5391]={{1,136},{200,136},},[5393]={{1,160},{200,160},},[5448]={{1,13},{60,58},{61,65},{65,77},{70,80},{71,89},{75,98},{80,100},{81,103},{85,108},{86,110},{90,116},{91,124},{97,136},{100,136},{101,144},{109,160},{110,168},{150,168},},[5449]={{1,7},{60,58},{61,61},{65,72},{70,80},{71,85},{75,94},{80,100},{81,102},{85,108},{86,109},{90,116},{91,122},{97,135},{100,136},{101,142},{109,160},{110,164},{150,164},},[5451]={{1,1},{60,58},{61,59},{70,79},{71,81},{80,99},{81,100},{85,107},{86,108},{90,116},{91,120},{97,132},{98,134},{100,136},{101,140},{109,158},{110,158},{200,158},},[5452]={{1,77},{200,77},},[5453]={{1,80},{200,80},},[5454]={{1,100},{200,100},},[5455]={{1,100},{200,100},},[5456]={{1,108},{200,108},},[5457]={{1,108},{200,108},},[5458]={{1,116},{200,116},},[5459]={{1,116},{200,116},},[5461]={{1,136},{200,136},},[5462]={{1,139},{200,139},},[5553]={{1,266},{200,266},},[5554]={{1,327},{200,327},},[5555]={{1,278},{200,278},},[5556]={{1,339},{200,339},},[5557]={{1,116},{200,116},},[5558]={{1,116},{200,116},},[5559]={{1,116},{200,116},},[5560]={{1,116},{200,116},},[5561]={{1,254},{200,254},},[5562]={{1,315},{200,315},},[5563]={{1,266},{200,266},},[5564]={{1,327},{200,327},},[5565]={{1,242},{200,242},},[5566]={{1,303},{200,303},},[5567]={{1,254},{200,254},},[5568]={{1,315},{200,315},},[5714]={{1,108},{200,108},},[5715]={{1,108},{200,108},},[5730]={{1,116},{200,116},},[5857]={{1,58},{200,58},},[5979]={{1,58},{200,58},},[5980]={{1,58},{200,58},},[5981]={{1,58},{200,58},},[5993]={{1,58},{200,58},},[5994]={{1,58},{200,58},},[6025]={{1,100},{200,100},},[6027]={{1,100},{200,100},},[6029]={{1,100},{200,100},},[6031]={{1,100},{200,100},},[6033]={{1,99},{200,99},},[6035]={{1,100},{200,100},},[6036]={{1,100},{200,100},},[6045]={{1,100},{200,100},},[6083]={{1,136},{200,136},},[6089]={{1,136},{200,136},},[6091]={{1,136},{200,136},},[6093]={{1,136},{200,136},},[6101]={{1,73},{200,73},},[6102]={{1,80},{200,80},},[6103]={{1,80},{200,80},},[6104]={{1,136},{200,136},},[6105]={{1,141},{200,141},},[6106]={{1,100},{200,100},},[6107]={{1,100},{200,100},},[6108]={{1,58},{200,58},},[6109]={{1,58},{200,58},},[6131]={{1,108},{200,108},},[6132]={{1,116},{200,116},},[6133]={{1,116},{200,116},},[6134]={{1,114},{200,114},},[6135]={{1,108},{200,108},},[6136]={{1,116},{200,116},},[6137]={{1,117},{200,117},},[6138]={{1,106},{200,106},},[6139]={{1,116},{200,116},},[6140]={{1,116},{200,116},},[6141]={{1,108},{200,108},},[6142]={{1,116},{200,116},},[6143]={{1,116},{200,116},},[6144]={{1,102},{200,102},},[6145]={{1,110},{200,110},},[6146]={{1,116},{200,116},},[6147]={{1,116},{200,116},},[6148]={{1,104},{200,104},},[6149]={{1,112},{200,112},},[6150]={{1,116},{200,116},},[6151]={{1,138},{200,138},},[6152]={{1,138},{200,138},},[6153]={{1,136},{200,136},},[6171]={{1,7},{200,7},},[6172]={{1,11},{200,11},},[6173]={{1,15},{200,15},},[6174]={{1,7},{200,7},},[6175]={{1,12},{200,12},},[6176]={{1,16},{200,16},},[6177]={{1,22},{200,22},},[6226]={{108,180},{109,192},{110,210},{119,273},{120,273},},[6239]={{110,208},{119,289},},[6240]={{110,215},{119,296},},[6241]={{110,200},{119,281},},[6242]={{110,213},{119,294},},[6243]={{110,205},{119,286},},[6244]={{110,220},{119,301},},[6245]={{110,217},{119,298},},[6246]={{110,224},{119,305},},[6247]={{110,209},{119,290},},[6321]={{110,186},{119,266},{120,266},},[6611]={{100,355},{150,355},},[6612]={{100,370},{150,370},},[6613]={{100,385},{150,385},},[6614]={{100,340},{150,340},},[6693]={{100,310},{150,310},},[6694]={{100,325},{150,325},},[6695]={{100,340},{150,340},},[7117]={{100,340},{150,340},},[7118]={{100,340},{150,340},},[7119]={{100,355},{150,355},},[7120]={{100,355},{150,355},},[7121]={{100,355},{150,355},},[7122]={{100,370},{150,370},},[7123]={{100,370},{150,370},},[7124]={{100,370},{150,370},},[7125]={{100,385},{150,385},},[8388]={{1,10},{5,10},{57,58},{58,58},{67,73},{68,82},{80,100},{81,102},{85,108},{86,109},{90,116},{91,124},{97,135},{98,136},{99,136},{100,138},{101,145},{109,160},{110,180},{111,210},{120,289},},[8389]={{1,10},{5,18},{57,66},{58,66},{67,81},{68,90},{80,108},{81,110},{85,116},{86,117},{90,124},{91,132},{97,143},{98,144},{99,144},{100,146},{101,153},{109,168},{110,188},{111,218},{120,297},},[8390]={{1,10},{5,10},{57,58},{58,58},{67,73},{68,82},{80,100},{81,102},{85,108},{86,109},{90,116},{91,124},{97,135},{98,136},{99,136},{100,138},{101,145},{109,160},{110,210},{111,215},{119,296},{120,340},},[8391]={{1,10},{5,18},{57,66},{58,66},{67,81},{68,90},{80,108},{81,110},{85,116},{86,117},{90,124},{91,132},{97,143},{98,144},{99,144},{100,146},{101,153},{109,168},{110,218},{111,223},{119,304},{120,350},},}

local function round(num)
    return floor(num + 0.5)
end

local function GetCurvePoint(curveId, point)
    local curve = curvePoints[curveId]
    if not curve then
        return nil
    end

    local lastKey, lastValue = curve[1][1], curve[1][2]
    if lastKey > point then
        return lastValue
    end

    for x = 1,#curve,1 do
        if point == curve[x][1] then
            return curve[x][2]
        end
        if point < curve[x][1] then
            return round((curve[x][2] - lastValue) / (curve[x][1] - lastKey) * (point - lastKey) + lastValue)
        end
        lastKey = curve[x][1]
        lastValue = curve[x][2]
    end

    return lastValue
end

addonTable.GetDetailedItemLevelInfo = function(item)
    local _, link, _, origLevel = GetItemInfo(item)
    if not link then
        return nil, nil, nil
    end

    local itemString = string.match(link, "item[%-?%d:]+")
    local itemStringParts = { strsplit(":", itemString) }

    local numBonuses = tonumber(itemStringParts[14],10) or 0

    if numBonuses == 0 then
        return origLevel, nil, origLevel
    end

    local effectiveLevel, previewLevel, curve
    effectiveLevel = origLevel
    previewLevel = 0

    for y = 1,numBonuses,1 do
        local bonus = tonumber(itemStringParts[14+y],10) or 0

        origLevel = origLevel - (bonusLevelBoost[bonus] or 0)
        previewLevel = bonusPreviewLevel[bonus] or previewLevel
        curve = bonusLevelCurve[bonus] or curve
    end

    if curve and itemStringParts[12] == "512" then
        effectiveLevel = GetCurvePoint(curve, tonumber(itemStringParts[15+numBonuses],10)) or effectiveLevel
    end

    return effectiveLevel, previewLevel, origLevel
end
