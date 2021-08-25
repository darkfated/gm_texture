hash = {}

local formathex = '%%%02X'

function string:URLEncode()
    return string.gsub( string.gsub( string.gsub( self, '\n', '\r\n' ), '([^%w  ] )', function( c )
        return string.format( formathex, string.byte( c ) )
    end ), ' ', '+' )
end

-- MD5 modified from https://github.com/kikito/md5.lua

do
	local char, byte, format, rep, sub = string.char, string.byte, string.format, string.rep, string.sub
	local bit_or, bit_and, bit_not, bit_xor, bit_rshift, bit_lshift = bit.bor, bit.band, bit.bnot, bit.bxor, bit.rshift, bit.lshift

	local function lei2str( i )
	    local f = function( s )
            return char( bit_and( bit_rshift( i, s ), 255 ) )
        end

	    return f( 0 ) .. f( 8 ) .. f( 16 ) .. f( 24 )
	end

	local function str2bei( s )
	    local v = 0

	    for i = 1, #s do
            v = v * 256 + byte( s, i )
	    end

	    return v
	end

	local function str2lei( s )
	    local v = 0

	    for i = #s, 1, -1 do
            v = v * 256 + byte( s, i )
	    end

	    return v
	end

	local function cut_le_str( s, ... )
	    local o, r = 1, {}
	    local args = { ... }

	    for i = 1, #args do
            table.insert( r, str2lei( sub( s, o, o + args[ i ] - 1 ) ) )

            o = o + args[ i ]
	    end

	    return r
	end

	local swap = function( w )
        return str2bei( lei2str( w ) )
    end

	local CONSTS = {
	    0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
	    0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
	    0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
        0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
	    0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
	    0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
	    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
	    0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
	    0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
	    0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
	    0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
        0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
	    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
	    0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
	    0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
	    0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391,
	    0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476,
	}

	local f = function( x, y, z )
        return bit_or( bit_and( x, y ), bit_and( -x - 1, z ) )
    end
    
	local g = function( x, y, z )
        return bit_or( bit_and( x, z ), bit_and( y, -z - 1 ) )
    end

	local h = function( x, y, z )
        return bit_xor( x, bit_xor( y, z ) )
    end

	local i = function( x, y, z )
        return bit_xor( y, bit_or( x, -z - 1 ) )
    end

	local z = function ( f, a, b, c, d, x, s, ac )
	    a = bit_and( a + f( b, c, d ) + x + ac, 0xFFFFFFFF )

	    return bit_or( bit_lshift( bit_and( a, bit_rshift( 0xFFFFFFFF, s ) ), s ), bit_rshift( a, 32 - s ) ) + b
	end

	local function transform( A, B, C, D, X )
	    local a, b, c, d = A, B, C, D
	    local t = CONSTS

	    a = z( f, a, b, c, d, X[ 0 ], 7, t[ 1 ] )
	    d = z( f, d, a, b, c, X[ 1 ], 12, t[ 2 ] )
	    c = z( f, c, d, a, b, X[ 2 ], 17, t[ 3 ] )
	    b = z( f, b, c, d, a, X[ 3 ], 22, t[ 4 ] )
	    a = z( f, a, b, c, d, X[ 4 ], 7, t[ 5 ] )
	    d = z( f, d, a, b, c, X[ 5 ], 12, t[ 6 ] )
	    c = z( f, c, d, a, b, X[ 6 ], 17, t[ 7 ] )
        b = z( f, b, c, d, a, X[ 7 ], 22, t[ 8 ] )
        a = z( f, a, b, c, d, X[ 8 ], 7, t[ 9 ] )
        d = z( f, d, a, b, c, X[ 9 ], 12, t[ 10 ] )
        c = z( f, c, d, a, b, X[ 10 ], 17, t[ 11 ] )
        b = z( f, b, c, d, a, X[ 11 ], 22, t[ 12 ] )
	    a = z( f, a, b, c, d, X[ 12 ], 7, t[ 13 ] )
        d = z( f, d, a, b, c, X[ 13 ], 12, t[ 14 ] )
	    c = z( f, c, d, a, b, X[ 14 ], 17, t[ 15 ] )
	    b = z( f, b, c, d, a, X[ 15 ], 22, t[ 16 ] )

	    a = z( g, a, b, c, d, X[ 1 ], 5, t[ 17 ] )
        d = z( g, d, a, b, c, X[ 6 ], 9, t[ 18 ] )
	    c = z( g, c, d, a, b, X[ 11 ], 14, t[ 19 ] )
	    b = z( g, b, c, d, a, X[ 0 ], 20, t[ 20 ] )
        a = z( g, a, b, c, d, X[ 5 ], 5, t[ 21 ] )
	    d = z( g, d, a, b, c, X[ 10 ], 9, t[ 22 ] )
	    c = z( g, c, d, a, b, X[ 15 ], 14, t[ 23 ] )
	    b = z( g, b, c, d, a, X[ 4 ], 20, t[ 24 ] )
	    a = z( g, a, b, c, d, X[ 9 ], 5, t[ 25 ] )
	    d = z( g, d, a, b, c, X[ 14 ], 9, t[ 26 ] )
	    c = z( g, c, d, a, b, X[ 3 ], 14, t[ 27 ] )
	    b = z( g, b, c, d, a, X[ 8 ], 20, t[ 28 ] )
	    a = z( g, a, b, c, d, X[ 13 ], 5, t[ 29 ] )
	    d = z( g, d, a, b, c, X[ 2 ], 9, t[ 30 ] )
	    c = z( g, c, d, a, b, X[ 7 ], 14, t[ 31 ] )
	    b = z( g, b, c, d, a, X[ 12 ], 20, t[ 32 ] )

	    a = z( h, a ,b, c, d, X[ 5 ], 4, t[ 33 ] )
        d = z( h, d, a, b, c, X[ 8 ], 11, t[ 34 ] )
        c = z( h, c, d, a, b, X[ 11 ], 16, t[ 35 ] )
	    b = z( h, b, c, d, a, X[ 14 ], 23, t[ 36 ] )
	    a = z( h, a, b, c, d, X[ 1 ], 4, t[ 37 ] )
	    d = z( h, d, a, b, c, X[ 4 ], 11, t[ 38 ] )
	    c = z( h, c, d, a, b, X[ 7 ], 16, t[ 39 ] )
	    b = z( h, b, c, d, a, X[ 10 ], 23, t[ 40 ] )
	    a = z( h, a, b, c, d, X[ 13 ], 4, t[ 41 ] )
	    d = z( h, d, a, b, c, X[ 0 ], 11, t[ 42 ] )
	    c = z( h, c, d, a, b, X[ 3 ], 16, t[ 43 ] )
	    b = z( h, b, c, d, a, X[ 6 ], 23, t[ 44 ] )
	    a = z( h, a, b, c, d, X[ 9 ], 4, t[ 45 ] )
        d = z( h, d, a, b, c, X[ 12 ], 11, t[ 46 ] )
	    c = z( h, c, d, a, b, X[ 15 ], 16, t[ 47 ] )
        b = z( h, b, c, d, a, X[ 2 ], 23, t[ 48 ] )

	    a = z( i, a, b, c, d, X[ 0 ], 6, t[ 49 ] )
	    d = z( i, d, a, b, c, X[ 7 ], 10, t[ 50 ] )
	    c = z( i, c, d, a, b, X[ 14 ], 15, t[ 51 ] )
	    b = z( i, b, c, d, a, X[ 5 ], 21, t[ 52 ] )
        a = z( i, a, b, c, d, X[ 12 ], 6, t[ 53 ] )
	    d = z( i, d, a, b, c, X[ 3 ], 10, t[ 54 ] )
	    c = z( i, c, d, a, b, X[ 10 ], 15, t[ 55 ] )
	    b = z( i, b, c, d, a, X[ 1 ], 21, t[ 56 ] )
	    a = z( i, a, b, c, d, X[ 8 ], 6, t[ 57 ] )
	    d = z( i, d, a, b, c, X[ 15 ], 10, t[ 58 ] )
	    c = z( i, c, d, a, b, X[ 6 ], 15, t[ 59 ] )
	    b = z( i, b, c, d, a, X[ 13 ], 21, t[ 60 ] )
	    a = z( i, a, b, c, d, X[ 4 ], 6, t[ 61 ] )
	    d = z( i, d, a, b, c, X[ 11 ], 10, t[ 62 ] )
	    c = z( i, c, d, a, b, X[ 2 ], 15, t[ 63 ] )
	    b = z( i, b, c, d, a, X[ 9 ], 21, t[ 64 ] )

	    return A + a, B + b, C + c, D + d
	end

	function hash.MD5( s )
	    local msgLen = #s
	    local padLen = 56 - msgLen % 64

	    if ( msgLen % 64 > 56 ) then
            padLen = padLen + 6
        end

	    if ( padLen == 0 ) then
            padLen = 64
        end

	    s = s .. char( 128 ) .. rep( char( 0 ), padLen - 1 ) .. lei2str( 8 * msgLen )  .. lei2str( 0 )

	    local t = CONSTS
        local a, b, c, d = t[ 65 ], t[ 66 ], t[ 67 ], t[ 68 ]

	    for i = 1, #s, 64 do
            local X = cut_le_str( sub( s, i, i + 63 ), 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 )

            X[ 0 ] = table.remove( X, 1 )
            a, b, c, d = transform( a, b, c, d, X )
	    end

	    return format( '%08x%08x%08x%08x', swap( a ), swap( b ), swap( c ), swap( d ) )
	end
end

-- Thanks to SuperiorServers.co

texture = {}

local TEXTURE = {
	__tostring = function( self )
		return self.Name
	end
}
TEXTURE.__index = TEXTURE
TEXTURE.__concat = TEXTURE.__tostring

debug.getregistry().Texture = TEXTURE

texture.textures = {}
texture.proxyurl = 'https://imgkit.gmod.app/?image=%s&size=%i'

if ( not file.IsDir( 'texture', 'DATA' ) ) then
	file.CreateDir( 'texture' )
end

function texture.Create( name )
	texture.Delete( name )

	local ret = setmetatable( {
		Name = name,
		URL = '',
		Width = 1024,
		Height = 1024,
		Busy = false,
		Cache = true,
		Proxy = true,
		Format = 'jpg',
	}, TEXTURE )

	texture.textures[ name ] = ret

	return ret
end

function texture.Get( name )
	if ( texture.textures[ name ] ) then
		return texture.textures[ name ]:GetMaterial()
	end
end

function texture.Delete( name )
	texture.textures[ name ] = nil
end

function TEXTURE:SetSize( w, h )
	self.Width, self.Height = w, h

	return self
end

function TEXTURE:SetFormat( format )
	self.Format = format

	return self
end

function TEXTURE:EnableCache( enable )
	self.Cache = enable

	return self
end

function TEXTURE:EnableProxy( enable )
	self.Proxy = enable

	return self
end

function TEXTURE:GetName()
	return self.Name
end

function TEXTURE:GetUID( reaccount )
	if ( not self.UID or reaccount ) then
		self.UID = hash.MD5( self.Name .. self.URL .. self.Width .. self.Height .. self.Format )
	end

	return self.UID
end

function TEXTURE:GetSize()
	return self.Width, self.Height
end

function TEXTURE:GetFormat()
	return self.Format
end

function TEXTURE:GetURL()
	return self.URL
end

function TEXTURE:GetFile()
	return self.File
end

function TEXTURE:GetMaterial()
	return self.IMaterial
end

function TEXTURE:GetError()
	return self.Error
end

function TEXTURE:IsBusy()
	return ( self.Busy == true )
end

function TEXTURE:Download( url, onsuccess, onfailure )
	if ( self.Name == nil ) then
		self.Name = 'Web Material: ' .. url
	end

	self.URL = url
	self.File = 'texture/' .. self:GetUID() .. '.png'

	if ( self.Cache and file.Exists( self.File, 'DATA' ) ) then
		self.IMaterial = Material( 'data/' .. self.File, 'smooth' )

		if ( onsuccess ) then
			onsuccess( self, self.IMaterial )
		end
	else
		self.Busy = true

		http.Fetch( self.Proxy and string.format( texture.proxyurl, url:URLEncode(), self.Width, self.Height, self.Format ) or url, function( body, len, headers, code )
			if ( self.Cache ) then
				file.Write( self.File, body )
			end

			local tempfile = 'texture/tmp_' .. os.time() .. '_' .. self:GetUID() .. '.png'

			file.Write( tempfile, body )

			self.IMaterial = Material( 'data/' .. tempfile, 'smooth' )

			file.Delete( tempfile )

			if ( onsuccess ) then
				onsuccess( self, self.IMaterial )
			end

			self.Busy = false
		end, function( error )
			self.Error = error

			if ( onfailure ) then
				onfailure( self, self.Error )
			end

			self.Busy = false
		end )
	end

	return self
end

function TEXTURE:RenderManual( func, callback )
	local cachefile = 'texture/' .. self:GetUID() .. '-render.png'

	if ( file.Exists( cachefile, 'DATA' ) ) then
		self.File = cachefile
		self.IMaterial = Material( 'data/' .. self.File, 'smooth' )

		if ( callback ) then
			callback( self, self.IMaterial )
		end
	else
		hook.Add( 'HUDPaint', 'texture.render' .. self:GetName(), function()
			if ( self:IsBusy() ) then
                return
            end

			local w, h = self.Width, self.Height
			local drawRT = GetRenderTarget( 'texture_rt', w, h, true )
			local oldRT = render.GetRenderTarget()

			render.SetRenderTarget( drawRT )
				render.Clear( 0, 0, 0, 0 )
				render.ClearDepth()
				render.SetViewPort( 0, 0, w, h )
					func( self, w, h )

					if ( self.Cache ) then
						self.File = 'texture/' .. self:GetUID() .. '-render.png'

						file.Write( self.File, render.Capture( {
							format = 'png',
							quality = 100,
							x = 0,
							y = 0,
							h = h,
							w = w,
						} ) )
					end
				render.SetViewPort( 0, 0, ScrW(), ScrH() )
			render.SetRenderTarget( oldRT )

			self.IMaterial = Material( 'data/' .. self.File )

			if ( callback ) then
				callback( self, self.IMaterial )
			end

			hook.Remove( 'HUDPaint', 'texture.render' .. self:GetName() )
		end )
	end

	return self
end

function TEXTURE:Render( func, callback )
	return self:RenderManual( function( self, w, h )
		cam.Start2D()
			func( self, w, h )
		cam.End2D()
	end, callback )
end
