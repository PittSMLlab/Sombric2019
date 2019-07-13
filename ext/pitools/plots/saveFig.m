function saveFig(h,dir,fileName,sizeFlag)
%saveFig saves figure h as .fig and .png for further reference

if nargin<4 || isempty(sizeFlag)
set(h,'Units','Normalized','OuterPosition',[0 0 1 1])
end
if ~exist(dir,'dir')
    mkdir(dir)
end

%Save fig:
if ~exist([dir 'fig/'],'dir')
    mkdir([dir 'fig/'])
end
savefig(h,[dir 'fig/' fileName '.fig'],'compact') ;

%Save eps:
if ~exist([dir 'eps/'],'dir')
    mkdir([dir 'eps/'])
end
hgexport(h,[dir 'eps/' fileName '.eps'], hgexport('factorystyle'), 'Format', 'eps');

%Save png:
if ~exist([dir 'png/'],'dir')
    mkdir([dir 'png/'])
end
fullName=[dir 'png/' fileName];
%Workaround for transparent background (on png):
% save the original background color for later use
background = get(h, 'color'); 
% specify transparent background
set(h,'color',[0.8 0.8 0.8]);
% create output file
set(h,'InvertHardCopy','off'); 
%Write it once:
hgexport(h, [fullName '.png'], hgexport('factorystyle'), 'Format', 'png');
% write it back out - setting transparency info
cdata = imread([fullName '.png']);
imwrite(cdata, [fullName '.png'], 'png', 'BitDepth', 16, 'transparency', [0.8 0.8 0.8])%background)
set(h,'color',[1 1 1]);

end

