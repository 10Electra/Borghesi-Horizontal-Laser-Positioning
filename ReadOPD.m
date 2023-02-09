function [array,wavelength,aspect,pxlsize] = ReadOPD(filename,badpixelvalue,scaleByWavelength)
%READOPD Reads WYKO OPD file 
%
% [array,wavelength,aspect,pxlsize] = READOPD(filename,badpixelvalue,scaleByWavelength)
% returns array of RAW phase data, wavelength and aspect ratio stored in the 
% opd file with 'filename'.  Data is stored in 'waves' and must be multiplied by the
% wavelength to get nanometers (unless the scaleByWavelength flag is set to 1)
%
% INPUT VALUES:
% filename - name of the file to open
% badpixelvalue - optional value - value to substitude for invalid data (def=NaN)
%               - you may use NaN here. *** default used to be 0 ***
% scaleByWavelength - optional value - if set to 1, will scale the opd by the wavelength
%                   - (def=0)
%
% RETURN VALUES:
% raw - raw data array
% wavelength - in nanometers
% aspect - aspect ratio of the data set
% pxlsize - pixel size in x direction
% 
% SEE ALSO: ReadValueopd -- to read specific value from the opd file
%           readopdBPF -- to read opd file and leave BPF values

% $Revision: 1.10 $ Last Modified July 2010 by BRUKER
% $Revision: N/A $ Last Modified February 2023 by Christopher Gardner CLF
% Copyright (c) 2001-2010 Bruker Instruments Inc. All Rights Reserved.

% BRUKER MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF THIS SOFTWARE 
% FOR ANY PURPOSE. THE SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTIES,
% INCLUDING WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE OR 
% NONINFRINGEMENT.  BRUKER SHALL NOT BE LIABLE UNDER ANY THEORY OR ANY DAMAGES SUFFERED 
% BY YOU OR ANY USER OF THE SOFTWARE

% check number of input parameters
if ( nargin == 1 )
  badpixelvalue = NaN;
  scaleByWavelength = 1;
elseif (nargin == 2)
  scaleByWavelength = 1;
elseif (nargin ~= 3)
  error ('Wrong number of input parameters, use HELP READOPD');
end

fileIndex = 0; % this will be used if we need to read our data last
% initialize the variable for exception handling
fid=-1;
try 
  % open the file for reading
  fid=fopen (filename, 'rb', 'ieee-le');
  
  % if opening failed abort
  if fid==-1 
    error ('can not open file: %s', filename); 
  end
  
  % **************read the block file****************
  % first read the signature
  fread(fid, 2, 'char'); % Move pointer to second char
  
  % read directory
  BLCK_SIZE = 24;
  BPF = 1e+38;
  directory = read_blk(fid);
  
  if strcmp(directory.name,'Directory')==0 
    error ('Unable to read Directory entry, aborting...'); 
  end
  
  %calculate number of directory entries
  num_blcks=directory.len/BLCK_SIZE;
  
  counter=1;
  
  blocks(num_blcks-1).type = NaN;
  blocks(num_blcks-1).len = NaN;
  blocks(num_blcks-1).attr = NaN;
  blocks(num_blcks-1).name = NaN;

  %read all directory entries
  for i=1:num_blcks-1
    blocks(i) =  read_blk(fid);
    
    if blocks(i).len>0
      counter = counter+1;
    end
  end
  phaseSize = 4;
  mult = 1;
  
  % read the data from data blocks
  for i=1:num_blcks-1
    if (blocks(i).len > 0)
      
      % remove blanks from the name
      deblank(blocks(i).name);
      
      switch blocks(i).name
        
      case 'RAW DATA'
        rows=fread(fid,1,'ushort');
        cols=fread(fid,1,'ushort');
        [prec,phaseSize] = get_prec(fid);
        if ( cols * rows > 1000 * 1000 )
          fileIndex = ftell(fid); % use optimized code below for large arrays
          rows1=rows; cols1=cols; prec1=prec;
        else
          arrayTmp=fread(fid,[cols rows],prec);
        end
        
      case 'RAW_DATA'
        rows=fread(fid,1,'ushort');
        cols=fread(fid,1,'ushort');
        [prec,phaseSize] = get_prec(fid);
        if ( cols * rows > 1000 * 1000 )
          fileIndex = ftell(fid); % use optimized code below for large arrays
          rows1=rows; cols1=cols; prec1=prec;
        else
          arrayTmp=fread(fid,[cols rows],prec);
        end
        
      case 'Raw'
        rows=fread(fid,1,'ushort');
        cols=fread(fid,1,'ushort');
        [prec,phaseSize] = get_prec(fid);
        if ( cols * rows > 1000 * 1000 )
          fileIndex = ftell(fid); % use optimized code below for large arrays
          rows1=rows; cols1=cols; prec1=prec;
        else
          arrayTmp=fread(fid,[cols rows],prec);
        end
        
        
      case 'SAMPLE_DATA'
        rows=fread(fid,1,'ushort');
        cols=fread(fid,1,'ushort');
        [prec,phaseSize] = get_prec(fid);
        if ( cols * rows > 1000*1000 )
          fileIndex = ftell(fid); % use optimized code below for large arrays
          rows1=rows; cols1=cols; prec1=prec;
        else
          arrayTmp=fread(fid,[cols rows],prec);
        end
        
      case 'OPD'
        rows=fread(fid,1,'ushort');
        cols=fread(fid,1,'ushort');
        [prec,phaseSize] = get_prec(fid);
        if ( cols * rows > 1000*1000 )
          fileIndex = ftell(fid); % use optimized code below for large arrays
          rows1=rows; cols1=cols; prec1=prec;
        else
          arrayTmp=fread(fid,[cols rows],prec);
        end
        
      case 'Wavelength'
        wavelength=fread(fid,1,'float');
        
      case 'Mult'
        mult = fread(fid,1,'short');
        
      case 'Aspect'
        aspect=fread(fid,1,'float');
        
      case 'Pixel_size'
        pxlsize=fread(fid,1,'float');
        
      otherwise
        % use conversion depending on the data type 
        switch blocks(i).type
        case 12
          fseek(fid,blocks(i).len,'cof'); % long
        case 8
          fseek(fid,blocks(i).len,'cof'); % double
        case 7
          fseek(fid,blocks(i).len,'cof'); % float
        case 6
          fseek(fid,blocks(i).len,'cof'); % short
        case 5
          fseek(fid,blocks(i).len,'cof'); % string
        case 3
          rows=fread(fid,1,'ushort');
          cols=fread(fid,1,'ushort');
          elsize=fread(fid,1,'short');
          fseek(fid,rows*cols*elsize,'cof');
        otherwise
          fseek(fid,blocks(i).len,'cof'); % anything else
        end
      end
    end
  end
  
  % get our scale - note mult is 1 for float data so we can use it here for all cases.
  if ( scaleByWavelength == 1 )
    scale = wavelength / mult;
  else
    scale = 1/mult;
  end

  % optimized code
  if ( phaseSize == 2)
    badValue = 32766;
  else
    badValue = BPF;
  end

  if ( fileIndex > 0 )
    % we will read a col at a time and transfer it to a col in new matrix
    if ( 0 == fseek(fid, fileIndex, 'bof') )
      % create our array
      array = ones(cols1, rows1) * badpixelvalue;
      for i=1:rows1
        col = flip(fread(fid, [cols1,1], prec1),1);
        indexGood = find(col < badValue);
        array(indexGood,i) = col(indexGood) * scale;
      end
    end
  else
    indexGood = find(arrayTmp < badValue);
    arrayTmp(indexGood) = arrayTmp(indexGood) * scale;
    arrayTmp(arrayTmp > badValue) = badpixelvalue;
    array = flip(arrayTmp,1);
  end
  % close the file
  if scaleByWavelength == 1
      array = array / 1000; % Output array in microns
  end
  fclose(fid);
catch 
  if fid >= 0
    fclose(fid);
    disp('fid greater than 0; closing file')
  end
end

%subfunctions used to read OPD files
function block = read_blk (fid)
name = fread(fid, 16, 'char');
block.type = fread(fid, 1,  'short');
block.len =  fread(fid, 1,  'long');
block.attr = fread(fid, 1,  'ushort');
%remove any trailing spaces from the name
block.name = deblank(char(name'));


function [prec,elsize] = get_prec(fid)
elsize=fread(fid,1,'short');
if elsize==4
  prec='float';
elseif elsize==2
  prec='short';
else
  prec='char';
end
