# gm_texture
This script makes it possible to create textures (materials) in gmod, thanks to the image on the link.

# Simple application example
```C#
local image = texture.Create( 'BeautifulCat' )
image:SetSize( 500, 500 )
image:SetFormat( 'png' )
image:Download( 'https://i.imgur.com/8VSq0Nl.jpg' )

hook.Add( 'HUDPaint', 'hudTest', function()
    if ( image:GetMaterial() ) then
        surface.SetDrawColor( Color(255,255,255) )
        surface.SetMaterial( image:GetMaterial() )
        surface.DrawTexturedRect( 35, 35, 500, 500 )
    end
end )
```
```C#
local imag = texture.Create( 'gradient' )
imag:SetSize( 100, 100 )
imag:Download( 'https://i.imgur.com/9TsJ3Id.png' )

local menu = vgui.Create( 'DFrame' )
menu:SetSize( ScrW() * 0.4, ScrH() * 0.6 )
menu:Center()
menu:MakePopup()

local btn = vgui.Create( 'DButton', menu )
btn:Dock( FILL )
btn.Paint = function( self, w, h )
    surface.SetDrawColor( Color(255,255,255) )
    surface.SetMaterial( texture.Get( 'gradient' ) )
    surface.DrawTexturedRect( 0, 0, w, h )
end
```
