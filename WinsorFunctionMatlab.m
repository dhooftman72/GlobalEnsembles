% Normalisation with double Winsorisation protocol following Hooftman et al
% 2022 & Verhagen et al. (2017)
% Inputs: InVar = value array (could be very big, such as 220-Million
% gridcell values for Global arrays)
% Prcs is coppied to GIS software were needed
% No values below 0 are allowed, which are assigned to No data values (such
% as -9999)
function  [OutVar, Prct] = WinsorFunction(InVar,percLow)
InVar = reshape(InVar,((size(InVar,1)).*(size(InVar,2))),1);
InVar(InVar<0) = NaN;
Prct =  prctile(InVar,percLow);
InVar_norm = InVar - Prct;
clear InVar % to save memory
InVar_norm( InVar_norm<0) = 0;
Prct(2) = prctile(InVar_norm,(100-percLow));
OutVar = (InVar_norm./Prct(2));
clear InVar_norm % to save memory
OutVar(OutVar>1) = 1;
end



