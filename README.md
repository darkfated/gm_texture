# gm_texture
This script makes it possible to create textures (materials) in gmod, thanks to the image on the link.

# Simple application example
```C#
local image = texture.Create( 'BeautifulCat' )
image:SetSize( 800, 800 )
image:SetFormat( 'png' )
image:Download( 'https://i.imgur.com/8VSq0Nl.jpg' )

hook.Add( 'HUDPaint', 'hudTest', function()
    if ( image:GetMaterial() ) then
        surface.SetDrawColor( Color(255,255,255) )
        surface.SetMaterial( image:GetMaterial() )
        surface.DrawTexturedRect( 35, 35, 800, 800 )
    end
end )
```
