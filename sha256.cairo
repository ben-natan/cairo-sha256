%builtins output range_check
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import unsigned_div_rem

func loadKs(k: felt*):
   assert [k] = %[0x428a2f98%]
   assert [k + 1] = %[0x71374491%]
   assert [k + 2] = %[0xb5c0fbcf%]
   assert [k + 3] = %[0xe9b5dba5%]
   assert [k + 4] = %[0x3956c25b%]
   assert [k + 5] = %[0x59f111f1%]
   assert [k + 6] = %[0x923f82a4%]
   assert [k + 7] = %[0xab1c5ed5%]
   assert [k + 8] = %[0xd807aa98%]
   assert [k + 9] = %[0x12835b01%]
   assert [k + 10] = %[0x243185be%]
   assert [k + 11] = %[0x550c7dc3%]
   assert [k + 12] = %[0x72be5d74%]
   assert [k + 13] = %[0x80deb1fe%]
   assert [k + 14] = %[0x9bdc06a7%]
   assert [k + 15] = %[0xc19bf174%]
   assert [k + 16] = %[0xe49b69c1%]
   assert [k + 17] = %[0xefbe4786%]
   assert [k + 18] = %[0x0fc19dc6%]
   assert [k + 19] = %[0x240ca1cc%]
   assert [k + 20] = %[0x2de92c6f%]
   assert [k + 21] = %[0x4a7484aa%]
   assert [k + 22] = %[0x5cb0a9dc%]
   assert [k + 23] = %[0x76f988da%]
   assert [k + 24] = %[0x983e5152%]
   assert [k + 25] = %[0xa831c66d%]
   assert [k + 26] = %[0xb00327c8%]
   assert [k + 27] = %[0xbf597fc7%]
   assert [k + 28] = %[0xc6e00bf3%]
   assert [k + 29] = %[0xd5a79147%]
   assert [k + 30] = %[0x06ca6351%]
   assert [k + 31] = %[0x14292967%]

   assert [k + 32] = %[0x27b70a85%]
   assert [k + 33] = %[0x2e1b2138%]
   assert [k + 34] = %[0x4d2c6dfc%]
   assert [k + 35] = %[0x53380d13%]
   assert [k + 36] = %[0x650a7354%]
   assert [k + 37] = %[0x766a0abb%]
   assert [k + 38] = %[0x81c2c92e%]
   assert [k + 39] = %[0x92722c85%]
   assert [k + 40] = %[0xa2bfe8a1%]
   assert [k + 41] = %[0xa81a664b%]
   assert [k + 42] = %[0xc24b8b70%]
   assert [k + 43] = %[0xc76c51a3%]
   assert [k + 44] = %[0xd192e819%]
   assert [k + 45] = %[0xd6990624%]
   assert [k + 46] = %[0xf40e3585%]
   assert [k + 47] = %[0x106aa070%]
   assert [k + 48] = %[0x19a4c116%]
   assert [k + 49] = %[0x1e376c08%]
   assert [k + 50] = %[0x2748774c%]
   assert [k + 51] = %[0x34b0bcb5%]
   assert [k + 52] = %[0x391c0cb3%]
   assert [k + 53] = %[0x4ed8aa4a%]
   assert [k + 54] = %[0x5b9cca4f%]
   assert [k + 55] = %[0x682e6ff3%]
   assert [k + 56] = %[0x748f82ee%]
   assert [k + 57] = %[0x78a5636f%]
   assert [k + 58] = %[0x84c87814%]
   assert [k + 59] = %[0x8cc70208%]
   assert [k + 60] = %[0x90befffa%]
   assert [k + 61] = %[0xa4506ceb%]
   assert [k + 62] = %[0xbef9a3f7%]
   assert [k + 63] = %[0xc67178f2%]
   return()
end


# CF playground: field elts 2
func mod2{range_check_ptr}(x: felt) -> (res: felt):
    let (_, r) = unsigned_div_rem{range_check_ptr=range_check_ptr}(value=x, div=2)
    return (res = r)
end





func rightShift{range_check_ptr}(x: felt, n: felt) -> (res: felt):
    if n == 0:
        return (res=x)
    end

    let (xmod2) = mod2{range_check_ptr=range_check_ptr}(x)
    if xmod2 == 0:
        let (rS) = rightShift{range_check_ptr=range_check_ptr}(x/2, n-1)
        return (res=rS)
    else :
        let (rS) = rightShift{range_check_ptr=range_check_ptr}((x-1)/2, n-1)
        return (res=rS)
    end 
end



func rightRotate32{range_check_ptr}(x: felt, n: felt) -> (res: felt):
    if n == 0:
        return (res=x)
    end

    let (xmod2) = mod2{range_check_ptr=range_check_ptr}(x)
    if xmod2 == 0:
        let (rR32) = rightRotate32{range_check_ptr=range_check_ptr}(x/2, n-1)
        return (rR32)
    else:
        let (rR32) = rightRotate32{range_check_ptr=range_check_ptr}( (x-1)/2 + %[ 2**31 %], n-1) 
        return (rR32)
    end
end


func getBit{range_check_ptr}(x: felt, i: felt) -> (res: felt):
    let (xmod2) = mod2{range_check_ptr=range_check_ptr}(x)
    if i == 0:
        return (res=xmod2)
    end

    let (bit) = getBit{range_check_ptr=range_check_ptr}( (x-xmod2) / 2, i-1)

    return (res=bit)
end


func pow{range_check_ptr}(x: felt, n: felt) -> (res: felt):
    if n == 0:
        return (res=1)
    end
    if n == 1:
        return (res=x)
    end

    let (nmod2) = mod2{range_check_ptr=range_check_ptr}(n)
    if nmod2 == 0: 
        let (nextpow) = pow{range_check_ptr=range_check_ptr}(x, n/2)
        return (res=nextpow * nextpow)
    else:
        let (nextpow) = pow{range_check_ptr=range_check_ptr}(x, (n-1)/2)
        return (res=nextpow * x * nextpow)
    end
end



func aux_xor32{range_check_ptr}(x: felt, y: felt, i: felt) -> (res: felt):
    alloc_locals
    let (xBit) = getBit{range_check_ptr=range_check_ptr}(x, i)
    local xBit = xBit
    let (yBit) = getBit{range_check_ptr=range_check_ptr}(y, i)
    local yBit = yBit

    if i == 31:
        if xBit == 1:
            if yBit == 1:
                return (res=0)
            else:
                let pw = %[2**31%]  
                return (res=pw)
            end
        else:
            if yBit == 1:
                let pw = %[2**31%]
                return (res=pw)
            else:
                return (res=0)
            end
        end
    else:
        let (next) = aux_xor32{range_check_ptr=range_check_ptr}(x, y, i+1)
        local next = next
        if xBit == 1:
            if yBit == 1:
                return (res=next)
            else:
                let (pw) = pow{range_check_ptr=range_check_ptr}(2,i)
                return (res= pw + next)
            end

        else:
            if yBit == 1:
                let (pw) = pow{range_check_ptr=range_check_ptr}(2,i)
                return (res = pw + next)
            else :
                return (res=next)
            end
        end
    end

end


func xor32{range_check_ptr}(x: felt, y: felt) -> (res: felt):
    let (res) = aux_xor32{range_check_ptr=range_check_ptr}(x, y, 0)
    return (res=res)
end

func aux_and32{range_check_ptr}(x: felt, y: felt, i: felt) -> (res: felt):
    alloc_locals
    let (xBit) = getBit{range_check_ptr=range_check_ptr}(x, i)
    local xBit = xBit
    let (yBit) = getBit{range_check_ptr=range_check_ptr}(y, i)
    local yBit = yBit

    if i == 31:
        if xBit == 1:
            if yBit == 1:
                let pw = %[2**32%]
                return (res=pw)
            else:
                return (res=0)
            end
        else:
            return (res=0)
        end
    else:
        let (next) = aux_and32{range_check_ptr=range_check_ptr}(x, y, i+1)
        local next = next
        if xBit == 1:
            if yBit == 1:
                let (pw) = pow{range_check_ptr=range_check_ptr}(2,i)
                return (res= pw + next)
            else:
                return (res=next)
            end
        else: 
            return (res=next)
        end
    end

end

func and32{range_check_ptr}(x: felt, y: felt) -> (res: felt):
    let (res) = aux_and32{range_check_ptr=range_check_ptr}(x, y, 0)
    return (res=res)
end


func compute_s0{range_check_ptr}(w: felt) -> (res: felt):
    alloc_locals

    let (rr7) = rightRotate32{range_check_ptr=range_check_ptr}(w, 7)
    local loc_rr7 = rr7

    let (rr18) = rightRotate32{range_check_ptr=range_check_ptr}(w, 18)
    local loc_rr18 = rr18

    let (rs3) = rightShift{range_check_ptr=range_check_ptr}(w, 3)
    local loc_rs3 = rs3

    let (_7xor18) = xor32{range_check_ptr=range_check_ptr}(loc_rr7, loc_rr18)
    let (res) = xor32{range_check_ptr=range_check_ptr}(_7xor18, loc_rs3)
    
    return (res=res)
end


func compute_s1{range_check_ptr}(w: felt) -> (res: felt):
    alloc_locals

    let (rr17) = rightRotate32{range_check_ptr=range_check_ptr}(w, 17)
    local loc_rr17 = rr17

    let (rr19) = rightRotate32{range_check_ptr=range_check_ptr}(w, 19)
    local loc_rr19 = rr19

    let (rs10) = rightShift{range_check_ptr=range_check_ptr}(w, 10)
    local loc_rs10 = rs10

    let (_17xor19) = xor32{range_check_ptr=range_check_ptr}(loc_rr17, loc_rr19)
    let (res) = xor32{range_check_ptr=range_check_ptr}(_17xor19, loc_rs10)

    return (res=res)
end



func populateWs{range_check_ptr}(w: felt*, i: felt):
    alloc_locals

    if i == 64:
        return ()
    end

    let w15 = [w + i - 15]
    let (s0) = compute_s0{range_check_ptr=range_check_ptr}(w15)
    local loc_s0 = s0

    let w2 = [w + i - 2]
    let (s1) = compute_s1{range_check_ptr=range_check_ptr}(w2)
    local loc_s1 = s1

    # Immutable: OK puisque les w après w15 ne sont pas attribués
    assert [w + i] = [w + i - 16] + loc_s0 + [w + i - 7] + loc_s1
    populateWs{range_check_ptr=range_check_ptr}(w, i+1)
    return()
end


func compute_sig0{range_check_ptr}(a: felt) -> (sig0: felt):
    alloc_locals

    let (rr2) = rightRotate32{range_check_ptr=range_check_ptr}(a, 2)
    local loc_rr2 = rr2
    
    let (rr13) = rightRotate32{range_check_ptr=range_check_ptr}(a, 13)
    local loc_rr13 = rr13
    
    let (rr22) = rightRotate32{range_check_ptr=range_check_ptr}(a, 22)
    local loc_rr22 = rr22

    let (_2xor13) = xor32{range_check_ptr=range_check_ptr}(loc_rr2, loc_rr13)
    let (sig0) = xor32{range_check_ptr=range_check_ptr}(_2xor13, loc_rr22)

    return (sig0 = sig0)
end


func compute_sig1{range_check_ptr}(e: felt) -> (sig1: felt):
    alloc_locals

    let (rr6) = rightRotate32{range_check_ptr=range_check_ptr}(e, 6)
    local loc_rr6 = rr6

    let (rr11) = rightRotate32{range_check_ptr=range_check_ptr}(e, 11)
    local loc_rr11 = rr11

    let (rr25) = rightRotate32{range_check_ptr=range_check_ptr}(e, 25)
    local loc_rr25 = rr25

    let (_6xor11) = xor32{range_check_ptr=range_check_ptr}(loc_rr6, loc_rr11)
    let (sig1) = xor32{range_check_ptr=range_check_ptr}(_6xor11, loc_rr25)

    return (sig1 = sig1)
end


func compute_ch{range_check_ptr}(e: felt, f: felt, g: felt) -> (ch: felt):
    alloc_locals
    let (fxorg) = xor32{range_check_ptr=range_check_ptr}(f,g)
    local loc_fxorg = fxorg

    let (eand_) = and32{range_check_ptr=range_check_ptr}(e, loc_fxorg)

    let (ch) = xor32{range_check_ptr=range_check_ptr}(eand_, g)

    return (ch=ch)
end


func compute_maj{range_check_ptr}(a: felt, b: felt, c: felt) -> (maj: felt):
    alloc_locals
    
    let (axorb) = xor32{range_check_ptr=range_check_ptr}(a,b)
    local loc_axorb = axorb

    let (axorc) = xor32{range_check_ptr=range_check_ptr}(a,c)
    local loc_axorc = axorc

    let (and) = and32{range_check_ptr=range_check_ptr}(loc_axorb, loc_axorc)
    let (maj) = xor32{range_check_ptr=range_check_ptr}(and, a)

    return (maj=maj)
end


func main_loop{range_check_ptr}(a: felt, b: felt, c: felt, d: felt, e: felt, f: felt, g: felt, h: felt, i: felt, w: felt*, k: felt*) -> (a: felt, b: felt, c: felt, d: felt, e: felt, f: felt, g: felt, h: felt):
    alloc_locals

    if i == 64:
        return (a=a, b=b, c=c, d=d, e=e, f=f, g=g, h=h)
    end

    let (sig1) = compute_sig1{range_check_ptr=range_check_ptr}(e)
    local loc_sig1 = sig1

    let (ch) = compute_ch{range_check_ptr=range_check_ptr}(e,f,g)
    local loc_ch = ch

    let temp1 = h + loc_sig1 + loc_ch + k[i] + w[i]

    let (sig0) = compute_sig0{range_check_ptr=range_check_ptr}(a)
    local loc_sig0 = sig0

    let (maj) = compute_maj{range_check_ptr=range_check_ptr}(a,b,c)
    local loc_maj = maj

    let temp2 = loc_sig0 + loc_maj

    let new_h = g
    let new_g = f
    let new_f = e
    let new_e = d + temp1
    let new_d = c
    let new_c = b
    let new_b = a
    let new_a = temp1 + temp2

    let (fa, fb, fc, fd, fe, ff, fg, fh) = main_loop{range_check_ptr=range_check_ptr}(new_a, new_b, new_c, new_d, new_e, new_f, new_g, new_h, i+1, w, k)
    return (fa, fb, fc, fd, fe, ff, fg, fh)
end





func sha256{range_check_ptr}(x: felt*) -> (h0: felt, h1: felt, h2: felt, h3: felt, h4: felt, h5: felt, h6: felt, h7: felt):
    alloc_locals

    # Constants
    local h0 = %[0x6a09e667%]
    local h1 = %[0xbb67ae85%]
    local h2 = %[0x3c6ef372%]
    local h3 = %[0xa54ff53a%]
    local h4 = %[0x510e527f%]
    local h5 = %[0x9b05688c%]
    local h6 = %[0x1f83d9ab%]
    local h7 = %[0x5be0cd19%]

    let (local k: felt*) = alloc()
    loadKs(k)

    # Input loading
    let (local w: felt*) = alloc()
    assert [w] = [x]
    assert [w + 1] = [x + 1]
    assert [w + 2] = [x + 2]
    assert [w + 3] = [x + 3]
    assert [w + 4] = [x + 4]
    assert [w + 5] = [x + 5]
    assert [w + 6] = [x + 6]
    assert [w + 7] = [x + 7]
    assert [w + 8] = [x + 8]
    assert [w + 9] = [x + 9]
    assert [w + 10] = [x + 10]
    assert [w + 11] = [x + 11]
    assert [w + 12] = [x + 12]
    assert [w + 13] = [x + 13]
    assert [w + 14] = [x + 14]
    assert [w + 15] = [x + 15]

    populateWs{range_check_ptr=range_check_ptr}(w, 16)  # Voir changement de mémoire

    let a = h0
    let b = h1
    let c = h2
    let d = h3 
    let e = h4
    let f = h5
    let g = h6
    let h = h7

    let (res_a, res_b, res_c, res_d, res_e, res_f, res_g, res_h) = main_loop(a, b, c, d, e, f, g, h, 0, w, k)

    return (h0= h0 + res_a, h1= h1 + res_b, h2= h2 + res_c, h3= h3 + res_d, h4= h4 + res_e, h5= h5 + res_f, h6= h6 + res_g, h7= h7 + res_h)
end



func main{output_ptr: felt*, range_check_ptr}():
    alloc_locals
    local pub0 = -1672033199
    local pub1 = -1284193350
    local pub2 = 412225749
    local pub3 = -1227571369
    local pub4 = 2030908700
    local pub5 = -1765508094
    local pub6 = 420400926
    local pub7 = 1124480427

    local x0
    local x1
    local x2
    local x3
    local x4
    local x5
    local x6
    local x7
    local x8
    local x9
    local x10
    local x11
    local x12
    local x13
    local x14
    local x15


    let (local x: felt*) = alloc()
    %{
        ids.x0 = program_input['x0']
        ids.x1 = program_input['x1']
        ids.x2 = program_input['x2']
        ids.x3 = program_input['x3']
        ids.x4 = program_input['x4']
        ids.x5 = program_input['x5']
        ids.x6 = program_input['x6']
        ids.x7 = program_input['x7']
        ids.x8 = program_input['x8']
        ids.x9 = program_input['x9']
        ids.x10 = program_input['x10']
        ids.x11 = program_input['x11']
        ids.x12 = program_input['x12']
        ids.x13 = program_input['x13']
        ids.x14 = program_input['x14']
        ids.x15 = program_input['x15']
    %}
    assert [x] = x0
    assert [x+1] = x1
    assert [x+2] = x2
    assert [x+3] = x3
    assert [x+4] = x4
    assert [x+5] = x5
    assert [x+6] = x6
    assert [x+7] = x7
    assert [x+8] = x8
    assert [x+9] = x9
    assert [x+10] = x10
    assert [x+11] = x11
    assert [x+12] = x12
    assert [x+13] = x13
    assert [x+14] = x14
    assert [x+15] = x15


    let (y0, y1, y2, y3, y4, y5, y6, y7) = sha256{range_check_ptr=range_check_ptr}(x)

    assert y0 = pub0
    assert y1 = pub1
    assert y2 = pub2
    assert y3 = pub3
    assert y4 = pub4
    assert y5 = pub5
    assert y6 = pub6
    assert y7 = pub7

    return ()
end

