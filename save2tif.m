%
% 'Img' must be uint16
%

function save2tif (fname, Img)
	t = Tiff (fname, 'w8');
	tagstruct.ImageLength = size(Img, 1);
	tagstruct.ImageWidth = size(Img, 2);
	tagstruct.TileWidth = 1024;
	tagstruct.TileLength = 1024;
	tagstruct.Compression = Tiff.Compression.LZW; %None;
	tagstruct.SampleFormat = Tiff.SampleFormat.UInt;
	tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
	tagstruct.BitsPerSample = 32; % 16; % info.BitsPerSample; % 32;
	tagstruct.SamplesPerPixel = 1;
	tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
	t.setTag(tagstruct);
	t.write(Img);
	t.close();
end