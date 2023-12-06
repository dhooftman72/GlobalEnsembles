% Data extraction from Asci files
% Example for the full global area with seas and oceans removed (NonSea)
% Input is an Asci file exported from GIS software.
% No data values that are on land will remain -9999 as denoted in the asci
% file
% Outputs are data arrays and Prcs outputed to GIS software
function LoadingFunction
file = 'ariescarbon.asc';
Aries = cut_top_off_ascii(file);
save('AriesCarbon.mat','Aries','-v7.3')
load('NonSea.mat')
ExtentRange = find(NonSea == 1);
AriesLand = Aries(ExtentRange); %#ok<FNDSB,NASGU>
save('AriesLandOnly.mat','AriesLand','-v7.3');
end

function VargOut = cut_top_off_ascii(NameIn)

warning off
number_of_heading_lines = 6;
     
    fid = fopen(NameIn,'r');
    InputText=textscan(fid,'%s',number_of_heading_lines,'delimiter','\n');
    for head = 1:1:number_of_heading_lines
        temp = InputText{1,1}{head,1};
        length_head = length(temp);
        temp_text = temp(1,15:length_head);
        Intro(head) = str2num(temp_text);
        clear temp
        clear length_head
        clear temp_text
    end
       
    ncols = Intro(1); %x
    nrows = Intro(2); %y
    xllcorner = Intro(3);
    xllcorner = round(xllcorner);
    yllcorner = Intro(4);
    yllcorner = round(yllcorner);
    cellsize =   Intro(5);
    NODATA_value =  Intro(6);
     
    Block = 1;   % Initialize block index
    sprintf('Block: %s', num2str(Block));                % Display block number
    InputText=textscan(fid,'Num SNR=%f'); % Read parameter value
    NumCols=InputText{1};
    FormatString=repmat('%f',1,NumCols);  % Create format string based on parameter
    InputText=textscan(fid,FormatString,'delimiter',','); % Read data block
    Data{Block,1}=cell2mat(InputText); %#ok<*SAGROW> % Convert to numerical array from cell
    data_array = Data{1,1};
    clear Data
    
    isOpen = matlabpool('size') > 0;
    if  isOpen == 0;
    matlabpool open
    end
    parfor row = 1:nrows
        start = ((row-1) *ncols)+1;
        ends = ((row-1) *ncols)+ ncols;
        VargOut(row,:) = data_array(start:ends);
    end
      
    matlabpool close
    fclose('all')
    clearvars -except VargOut
end