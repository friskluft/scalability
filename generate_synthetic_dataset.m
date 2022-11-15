clear all;

%% Parameters
outdir = '/Users/natfugl/WORK/AXLE/data/synthetic1';    % No trailing slash!

fnamePattern = 'synthetic_nrois=%d_roiarea=%d.tif';     % Pattern blahblah_axisname1=value_axisname2=value 
                                                        % is interpretable by Nyxus to layout timing 
                                                        % results properly

roiArea = [100*100]; %[10 100 500 10^3 10^4 10^5 10^6];
nRois = [1]; %[10 50 100 500 1000 10000 100000 500000 100000];
gap = 5;

%% 
for i_area = 1:length(roiArea)
    for i_pop = 1 : length(nRois)
        s = roiArea(i_area);
        n = nRois(i_pop);
        facts = FindClosestFactorization(n);
        nRx = int32(facts(1));
        nRy = int32(facts(2));
        sprintf ('generating intensity-mask pair with ROI area=%d pop=%d (= %d*%d image)', s, n, nRx, nRy)

        try
            generate_image_pair(outdir, fnamePattern, s, nRx, nRy, gap);
        catch errinfo
            sprintf('>>>>>> infeasible case s=%d n=%d error #: %d reason: %s', s, n, errinfo.identifier, errinfo.message)
        end
    end
end

