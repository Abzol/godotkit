extends Node
class_name Sq3Noise
# Implementation of Squirrel3 noise, originally by Squirrel Eiserloh
# 63-bit versions are NOT originally part of Squirrel3 algorithm.
# All functions take a set of int arguments based on their dimension;
# And an optional seed value that changes the distribution pattern of noise
# noiseInt and noiseUint functions return integer values of respective size;
# while noiseFloat and noiseUFloat return the same values packed between 0 ~ 1

# large primes with non-boring bits
const BIT_NOISE1 = 0xB52974AD
const BIT_NOISE2 = 0x68E31DA4
const BIT_NOISE3 = 0x1B56C4E9

# Used to speed up 32-bit operations by 2x
var mangled = PoolIntArray([0])

# -----------------------------------------------------------------------------
# 63-bit (due to abs) functions. Quality should be decent.
# -----------------------------------------------------------------------------
# Returns an integer value between 0 and 2^63-1
func get1dNoiseInt(position : int, _seed : int = 0):
    var mang = position
    mang = (mang * (BIT_NOISE1 << 8 | BIT_NOISE1))
    mang = (mang + _seed)
    mang ^= ((mang >> 8) & 0x00FFFFFFFFFFFFFF)
    mang = (mang + (BIT_NOISE2 << 8 | BIT_NOISE2))
    mang ^= (mang << 8)
    mang = (mang * (BIT_NOISE3 << 8 | BIT_NOISE3))
    mang ^= ((mang >> 8) & 0x00FFFFFFFFFFFFFF)
    return abs(mang)

# Returns a float value between 0.0 and 1.0
func get1dNoiseFloat(position : int, _seed : int = 0):
    var noise = get1dNoiseInt(position, _seed);
    return float(noise)/0x7FFFFFFFFFFFFFFF

func get2dNoiseInt(pos_x : int, pos_y : int, _seed : int = 0):
    return get1dNoiseInt(pos_x + 198491317 * pos_y, _seed)

func get2dNoiseFloat(positionx : int, positiony : int, _seed : int = 0):
    var noise = get2dNoiseInt(positionx, positiony, _seed);
    return float(noise)/0x7FFFFFFFFFFFFFFF;

# -----------------------------------------------------------------------------
# 32-bit functions (original sq3 implementation; slower, (higher quality?))
# -----------------------------------------------------------------------------
func get1dNoiseUint(position : int, _seed: int = 0):
    mangled[0] = position
    mangled[0] = (mangled[0] * BIT_NOISE1)
    mangled[0] = (mangled[0] + _seed)
    mangled[0] ^= ((mangled[0] >> 8) & 0x00FFFFFF)
    mangled[0] = (mangled[0] + BIT_NOISE2)
    mangled[0] ^= (mangled[0] << 8)
    mangled[0] = (mangled[0] * BIT_NOISE3)
    mangled[0] ^= ((mangled[0] >> 8) & 0x00FFFFFF)
    return (((mangled[0] & 0x80000000) >> 31) * 0x100000000) + mangled[0]

func get1dNoiseUFloat(position : int, _seed : int = 0):
    var noise = get1dNoiseUint(position, _seed);
    return float(noise)/0xFFFFFFFF

func get2dNoiseUint(pos_x : int, pos_y : int, _seed : int = 0):
    return get1dNoiseUint(pos_x + 198491317 * pos_y, _seed)

func get2dNoiseUFloat(positionx : int, positiony : int, _seed : int = 0):
    var noise = get2dNoiseUint(positionx, positiony, _seed);
    return float(noise)/0xFFFFFFFF;
    
func get3dNoiseUint(pos_x : int, pos_y : int, pos_z : int, _seed : int = 0):
    return get1dNoiseUint(pos_x + 198491317 * pos_y + 6542989 * pos_z, _seed)

func get3dNoiseUFloat(pos_x : int, pos_y : int, pos_z : int, _seed : int = 0):
    var noise = get3dNoiseUint(pos_x, pos_y, pos_z, _seed);
    return float(noise)/0xFFFFFFFF;
