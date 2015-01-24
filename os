%!PS-Adobe-3.0
%%Creator: (ImageMagick)
%%Title: (os)
%%CreationDate: (2015-01-24T15:20:31-03:00)
%%BoundingBox: 1345 274 1349 378
%%HiResBoundingBox: 1345 274 1349 378
%%DocumentData: Clean7Bit
%%LanguageLevel: 1
%%Orientation: Portrait
%%PageOrder: Ascend
%%Pages: 1
%%EndComments

%%BeginDefaults
%%EndDefaults

%%BeginProlog
%
% Display a color image.  The image is displayed in color on
% Postscript viewers or printers that support color, otherwise
% it is displayed as grayscale.
%
/DirectClassPacket
{
  %
  % Get a DirectClass packet.
  %
  % Parameters:
  %   red.
  %   green.
  %   blue.
  %   length: number of pixels minus one of this color (optional).
  %
  currentfile color_packet readhexstring pop pop
  compression 0 eq
  {
    /number_pixels 3 def
  }
  {
    currentfile byte readhexstring pop 0 get
    /number_pixels exch 1 add 3 mul def
  } ifelse
  0 3 number_pixels 1 sub
  {
    pixels exch color_packet putinterval
  } for
  pixels 0 number_pixels getinterval
} bind def

/DirectClassImage
{
  %
  % Display a DirectClass image.
  %
  systemdict /colorimage known
  {
    columns rows 8
    [
      columns 0 0
      rows neg 0 rows
    ]
    { DirectClassPacket } false 3 colorimage
  }
  {
    %
    % No colorimage operator;  convert to grayscale.
    %
    columns rows 8
    [
      columns 0 0
      rows neg 0 rows
    ]
    { GrayDirectClassPacket } image
  } ifelse
} bind def

/GrayDirectClassPacket
{
  %
  % Get a DirectClass packet;  convert to grayscale.
  %
  % Parameters:
  %   red
  %   green
  %   blue
  %   length: number of pixels minus one of this color (optional).
  %
  currentfile color_packet readhexstring pop pop
  color_packet 0 get 0.299 mul
  color_packet 1 get 0.587 mul add
  color_packet 2 get 0.114 mul add
  cvi
  /gray_packet exch def
  compression 0 eq
  {
    /number_pixels 1 def
  }
  {
    currentfile byte readhexstring pop 0 get
    /number_pixels exch 1 add def
  } ifelse
  0 1 number_pixels 1 sub
  {
    pixels exch gray_packet put
  } for
  pixels 0 number_pixels getinterval
} bind def

/GrayPseudoClassPacket
{
  %
  % Get a PseudoClass packet;  convert to grayscale.
  %
  % Parameters:
  %   index: index into the colormap.
  %   length: number of pixels minus one of this color (optional).
  %
  currentfile byte readhexstring pop 0 get
  /offset exch 3 mul def
  /color_packet colormap offset 3 getinterval def
  color_packet 0 get 0.299 mul
  color_packet 1 get 0.587 mul add
  color_packet 2 get 0.114 mul add
  cvi
  /gray_packet exch def
  compression 0 eq
  {
    /number_pixels 1 def
  }
  {
    currentfile byte readhexstring pop 0 get
    /number_pixels exch 1 add def
  } ifelse
  0 1 number_pixels 1 sub
  {
    pixels exch gray_packet put
  } for
  pixels 0 number_pixels getinterval
} bind def

/PseudoClassPacket
{
  %
  % Get a PseudoClass packet.
  %
  % Parameters:
  %   index: index into the colormap.
  %   length: number of pixels minus one of this color (optional).
  %
  currentfile byte readhexstring pop 0 get
  /offset exch 3 mul def
  /color_packet colormap offset 3 getinterval def
  compression 0 eq
  {
    /number_pixels 3 def
  }
  {
    currentfile byte readhexstring pop 0 get
    /number_pixels exch 1 add 3 mul def
  } ifelse
  0 3 number_pixels 1 sub
  {
    pixels exch color_packet putinterval
  } for
  pixels 0 number_pixels getinterval
} bind def

/PseudoClassImage
{
  %
  % Display a PseudoClass image.
  %
  % Parameters:
  %   class: 0-PseudoClass or 1-Grayscale.
  %
  currentfile buffer readline pop
  token pop /class exch def pop
  class 0 gt
  {
    currentfile buffer readline pop
    token pop /depth exch def pop
    /grays columns 8 add depth sub depth mul 8 idiv string def
    columns rows depth
    [
      columns 0 0
      rows neg 0 rows
    ]
    { currentfile grays readhexstring pop } image
  }
  {
    %
    % Parameters:
    %   colors: number of colors in the colormap.
    %   colormap: red, green, blue color packets.
    %
    currentfile buffer readline pop
    token pop /colors exch def pop
    /colors colors 3 mul def
    /colormap colors string def
    currentfile colormap readhexstring pop pop
    systemdict /colorimage known
    {
      columns rows 8
      [
        columns 0 0
        rows neg 0 rows
      ]
      { PseudoClassPacket } false 3 colorimage
    }
    {
      %
      % No colorimage operator;  convert to grayscale.
      %
      columns rows 8
      [
        columns 0 0
        rows neg 0 rows
      ]
      { GrayPseudoClassPacket } image
    } ifelse
  } ifelse
} bind def

/DisplayImage
{
  %
  % Display a DirectClass or PseudoClass image.
  %
  % Parameters:
  %   x & y translation.
  %   x & y scale.
  %   label pointsize.
  %   image label.
  %   image columns & rows.
  %   class: 0-DirectClass or 1-PseudoClass.
  %   compression: 0-none or 1-RunlengthEncoded.
  %   hex color packets.
  %
  gsave
  /buffer 512 string def
  /byte 1 string def
  /color_packet 3 string def
  /pixels 768 string def

  currentfile buffer readline pop
  token pop /x exch def
  token pop /y exch def pop
  x y translate
  currentfile buffer readline pop
  token pop /x exch def
  token pop /y exch def pop
  currentfile buffer readline pop
  token pop /pointsize exch def pop
  /Times-Roman findfont pointsize scalefont setfont
  x y scale
  currentfile buffer readline pop
  token pop /columns exch def
  token pop /rows exch def pop
  currentfile buffer readline pop
  token pop /class exch def pop
  currentfile buffer readline pop
  token pop /compression exch def pop
  class 0 gt { PseudoClassImage } { DirectClassImage } ifelse
  grestore
  showpage
} bind def
%%EndProlog
%%Page:  1 1
%%PageBoundingBox: 1345 274 1349 378
DisplayImage
1345 274
4 104
12
4 104
0
0
FAFAF9FBFAF9FBFAF9FAFBF9FAFBF9FAFBF9FAFBF9FBFAF9FAFBF9FAFBF9FBFBF9FBFBF9FAFAF9
FAFBF9FAFBF9FBFAF9FAFAF9FAFBF9FAFBF9FBFAF9FBFBF9FAFBF9FAFAF9FBFBFAF9F9F7FAFAF8
FBFBF9F8F8F6FCFBF9FBFAF9F8F8F6F5F4F3FDFBFAF9F8F6F1F0EFF8F8F6FAF8F6E9E8E6F1F0EE
F9F9F7E5E4E2E9E8E6F7F7F5FAFAF8EEEDEBF2F1F0FAF9F8FBFAF9E8E8E7FAFAF8FBFBF9FBFBFA
F4F3F2FAFAF8FAFBF9FAFAF8FBFAF8FCFCFAF9F9F7FAFAF8FBFBF9FBFAF9FAFAF9FAFAF9FAFAF8
F9F9F7FBFBF9FAFAF9FCFCFAFBFAF9FAF9F8FAF9F8FAFAF9FBFAF9FBFAF9FAFAF8F9F8F7FAF9F8
FBFBFAFAFAF9FBFCFAFBFBFAF9F9F7FAFAF8FAFAF9FAFAF9FAFAF9FAFAF9FAFAF9FAFAF9FAFAF9
FAFAF9FAFAF9FAFAF9FAFAF9FAFAF9FAFAF9FAFAF9FAFAF9FAFAF9FAFBF9FAFAF9FAFAF9FBFAF9
FAFAF9FAFAF9FAFAF9FBFAF9FAFAF8FAFAF8FAFAF8FAFAF9F9FAF8F9FAF8FAFAF8FAFAF9FAFAF8
FAF9F8FAF9F8FBFAF9FAFAF9FAFAF9F9FAF8FAFAF8FAFAF9FAFBF9FAFAF9F9FAF8FAFAF9FAFAF8
FAFBF9FAFAF9FAFBF9F9FAF8FAFBF9FAFBF9FCFBFAFAF9F8FAFAF9FBFBF9FBFBF9FAFAF8FAFAF8
FBFBF9FAFAF8FAFAF9FAFAF8FBFBFAFBFAF8FAFAF9FBFAFAFAFBF9F3F2F1FCFBFBFBFBFAFAFAF8
E6E5E2FCFAF9FAFAF9F9F9F7D5D4D2F8F7F5FCFBFAFAFAF8D7D6D4EBEAE8FBFAF7FAF9F7ECEBE8
D9D8D5F6F5F2FBFAF8F9F7F5DAD9D5EAE8E5FBFAF8FBF9F7EDECE8D8D7D3F2F1EFF6F5F2FAF9F6
DEDBD8DFDDDBF5F4F1FDFBF8F1F0EECECCCAF4F3F0F9F8F5FCFAF8E1DFDDF2F1EFF6F5F4FBFAF8
F9F7F5F3F2F0F7F6F4F6F5F4F8F7F5EFEEECF7F6F4F2F1EFF8F7F5F6F4F2F2F1EEEDEDEBFAFAF7
F0EFECF4F3F0F2F2EFF7F7F4E3E0DDF2F0EEF4F3F2F4F4F3D9D6D3EEECE9F3F1F0F6F5F3DEDBD8
E2DFDCF0EEEBF6F5F2EAE7E4D8D5D1E0DDD9F0EEEAEBE8E5E0DEDAD3D0CCE7E4E1F2F0EDE9E6E3
DEDAD7D7D4D0F8F8F5F2F0EDE4E1DED8D4D1F6F6F4F7F5F3EEEAE8E5E1DFF5F4F2F7F6F5FAF9F7
EEECEAF9F7F6F7F6F4F9F8F6FBF9F7F6F6F4F7F7F6F9F9F7F9F8F6F9F8F6FAF9F8F9F8F7F8F7F5
F7F7F5F7F6F5F9F8F7F9F8F6F6F5F3F6F5F4FAF9F7F7F6F4F7F6F3F8F7F5FAF9F7F9F7F6F3F1EF
F6F4F2FAF9F6F9F8F6EAE6E3E9E5E2EDEAE8F9F7F5E4E1DEDCD9D6E5E2E0F1EEECF0EEEBE5E2DF
D9D6D4E0DDDAF6F4F3F5F3F1E5E2E0DBD8D5F3F2F1F4F2F0F4F1EFEBE8E5F7F6F5F5F4F3F1F0EE
F5F3F0F3F2F1F6F5F3F2F1EFF2F1EEF7F6F4F7F7F5F4F4F2F5F5F3DFDEDBEFEFEBF9F9F5F6F5F4
C9C6C3D7D5D1E7E6E2F2F0EED5D1CDCFCAC6CCC8C4DDDAD7E4DFDADDD8D3CAC5C1D2CECBDFD9D6
D7D1CDD6D1CCE9E4E1D5D1CEDDD7D3D6D0CDF3F0EDE4E0DED9D3D0C8C4C1E1DFDCEAE7E5EDE8E5
D4D0CEDEDDDBE6E5E1E4E2DDD8D5D1DCDAD5EEEBEAEEEBE9E3E0DEDAD7D5F7F5F4F4F1F0F1EEED
D3D1D0F5F4F2F1F0EDF5F3F0D6D5D2F5F5F3F9F9F6F5F4F1E5E4E1F6F6F5F7F6F5FBFAF8F1F0EE
F2F1F0F5F3F2FBF9F6F2EFEDE5E2DFDDDAD7E1DEDAE3DFDBE4DFDDE3DEDCE3E0DEE3E0DDF9F6F5
F9F6F4FBF8F6FBF8F6FAF9F8F9F9F7FBF9F8FBF9F8F9F9F9FAFAF8F9F9F7F9F9F7F8F9F7F9F9F7
F9F9F7FAF9F7F8F8F6F8F7F5FAF9F6FAF8F6F8F7F5F6F5F4F9F7F5F7F5F3F8F7F5F6F5F4F8F7F5
F6F5F4F9F9F7F9F9F7F9F8F6F9F8F6F7F7F5F8F7F6F7F7F5F8F7F5F7F7F5F6F6F4F5F4F3F5F4F3

%%PageTrailer
%%Trailer
%%EOF
