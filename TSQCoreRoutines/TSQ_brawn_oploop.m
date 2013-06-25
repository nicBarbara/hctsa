function [opoutput, opquality, optime] = TSQ_brawn_oploop(x, y, moplink, Moutput, Mcts, Mmlab, parmcodej, fid, bevocal)

if moplink > 0 % pointer to a master function
	try
		if ~isstruct(Moutput) && isnan(Moutput); % output from Master was a NaN
			opoutput = NaN; % all structure elements set to NaN
            optime = NaN; % calculation times also set to NaN
            opquality = NaN; % quality will be set later
            
		else % Retrieve required element from master structure
            [~,thest] = strtok(parmcodej,'.'); thest = thest(2:end); % the field, after the '.'
            opoutput = parevalM(Moutput,['themasterdat.' thest]);
			opquality = 0; % no evaluation error, quality = 0
            optime = Mcts;
		end
    catch emsg
		fprintf(fid,'Error evaluating link to Master structure %s by %s\n',Mmlab,parmcodej);
        fprintf(fid,'%s\n',emsg.message)
        opoutput = 0; % Output = 0
		opquality = 1; % fatal error QualityCode
        optime = NaN; % don't worry about calculation time
	end
else % A single-output operation
    if bevocal, fprintf(fid,'Evaluating %s...',parmcodej); end % for error checking
    try
		operationtimer = tic;
		opoutput = pareval(x,y,parmcodej); % evaluate the operation
		opquality = 0; % no evaluation error, quality = 0
		optime = toc(operationtimer);
        if bevocal, fprintf(fid,' evaluated.\n'); end % for error checking
    catch
        fprintf(fid,' error.\n',parmcodej);
		opoutput = 0;
        opquality = 1; % fatal error, QualityCode = 1
        optime = NaN; % don't worry about calculation time
    end
end

end