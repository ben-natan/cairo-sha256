%builtins output


# Grosse utilisation de hint
func mod2(x: felt) -> (res: felt):
    alloc_locals
    local res
    %{ ids.res = ids.x % 2 %}
    return (res=res)
end



func rightShift(x: felt, n: felt) -> (res: felt):
    if n == 0:
        return (res=x)
    end

    let (xmod2) = mod2(x)
    if xmod2 == 0:
        let (rS) = rightShift(x/2, n-1)
        return (res=rS)
    else :
        let (rS) = rightShift((x-1)/2, n-1)
        return (res=rS)
    end 
end



func rightRotate32(x: felt, n: felt) -> (res: felt):
    if n == 0:
        return (res=x)
    end

    let (xmod2) = mod2(x)
    if xmod2 == 0:
        let (rR32) = rightRotate32(x/2, n-1)
        return (rR32)
    else:
        let (rR32) = rightRotate32( (x-1)/2 + %[ 2**31 %], n-1) 
        return (rR32)
    end
end


func getBit(x: felt, i: felt) -> (res: felt):
    let (xmod2) = mod2(x)
    if i == 0:
        return (res=xmod2)
    end

    if xmod2 == 1:
        return (res=getBit((x-1)/2, i-1))
    else:
        return (res=getBit(x/2, i-1))
    end
end


func pow(x: felt, n: felt) -> (res: felt):
    if n == 0:
        return (res=x)
    end

    let (nmod2) = mod2(n)
    if nmod2 == 0: 
        let (nextpow) = pow(x, n/2)
        return (res=nextpow)
    else:
        let (nextpow) = pow(x, (n-1)/2)
        return (res=nextpow * x * nextpow)
    end
end


func aux_xor32(x: felt, y: felt, i: felt) -> (res: felt):
    let xBit = getBit(x, i)
    let yBit = getBit(y, i)

    if i == 31:
        if xBit == 1 && yBit == 1:
            return (res=0)
        end
        if xBit == 0 && yBit == 0:
            return (res=0)
        else:
            return (res=pow(2, i))
        end

    else:
        if xBit == 1 && yBit ==1:
            return (res=aux_xor32(x, y, i+1))
        end
        if xBit == 0 && yBit == 0:
            return (res=aux_xor32(x, y, i+1))
        else:
            return (res=pow(2,i) + aux_xor32(x,y,i+1))
        end
    end

end


func xor32(x: felt, y: felt) -> (res: felt):
    return (res=aux_xor32(x,y,0))
end


func compute_s0(w: felt) -> (res: felt):
    let rr7 = rightRotate32(w, 7)
    let rr18 = rightRotate32(w, 18)
    let rs3 = rightShift(w, 3)
    
    let (7xor18) = xor32(rr7, rr18)
    let (res) = xor32(7xor18, rs3)
    
    return (res=res)
end

func compute_s1(w: felt) -> (res: felt):
    let rr17 = rightRotate32(w, 17)
    let rr19 = rightRotate32(w, 19)
    let rs10 = rightShift(w, 10)

    let (17xor19) = xor32(rr17, rr19)
    let (res) = xor32(17xor19, rs10)

    return (res=res)
end



struct Input:
    member _0: felt
    member _1: felt
    member _2: felt
    member _3: felt
    member _4: felt
    member _5: felt
    member _6: felt
    member _7: felt
    member _8: felt
    member _9: felt
    member _10: felt
    member _11: felt
    member _12: felt
    member _13: felt
    member _14: felt
    member _15: felt
end


func populateWs(w: felt*, i: felt):

    if (i == 64):
        return ()
    end

    let s0 = compute_s0([w - 15])
    let s1 = compute_s1([w - 2])

    # Immutable: OK puisque les w après w15 ne sont pas attribués
    assert [w] = [w - 16] + s0 + [w - 7] + s1
    populateWs(w+1, i+1)
    return()
end


func compute_sig0(a: felt) -> (sig0: felt):
    let rr2 = rightRotate32(a, 2)
    let rr13 = rightRotate32(a, 13)
    let rr22 = rightRotate32(a, 22)

    let (2xor13) = xor32(rr2, rr13)
    let (sig0) = xor32(2xor13, rr22)

    return (sig0 = sig0)
end


func compute_sig1(e: felt) -> (sig1: felt):
    let rr6 = rightRotate32(e, 6)
    let rr11 = rightRotate32(e, 11)
    let rr25 = rightRotate32(e, 25)

    let (6xor11) = xor32(rr6, rr11)
    let (sig1) = xor32(6xor11, rr25)

    return (sig1 = sig1)
end


func compute_ch(e: felt, f: felt, g: felt) -> (ch: felt):
    let (fxorg) = xor32(f,g)
    let (eand_) = and32(e, fxorg)
    let (ch) xor32(eand_, g)

    return (ch=ch)
end


func compute_maj(a: felt, b: felt, c: felt) -> (maj: felt):
    let (axorb) = xor32(a,b)
    let (axorc) = xor32(a,c)
    let (and) = and32(axorb, axorc)
    let (maj) = xor32(and, a)

    return (maj=maj)
end


func main_loop(a: felt, b: felt, c: felt, d: felt, e: felt, f: felt, g: felt, h: felt, i: felt) -> (a: felt, b: felt, c: felt, d: felt, e: felt, f: felt, g: felt, h: felt):
    if i == 64:
        return (a=a, b=b, c=c, d=d, e=e, f=f, g=g, h=h)
    end

    let sig1 = compute_sig1(e)
    let ch = compute_ch(e,f,g)
    let temp1 = h + sig1 + ch + # k[i] + w[i]
    let sig0 = compute_sig0(a)
    let maj = compute_maj(a,b,c)
    let temp2 = sig0 + maj

    let new_h = g
    let new_g = f
    let new_f = e
    let new_e = d + temp1
    let new_d = c
    let new_c = b
    let new_b = a
    let new_a = temp1 + temp2

    let final_tuple = main_loop(new_a, new_b, new_c, new_d, new_e, new_f, new_g, new_h, i+1) 
    return (final_tuple)
end





func sha256(x: felt*) -> (h0: felt, h1: felt, h2: felt, h3: felt, h4: felt, h5: felt, h6: felt, h7: felt):
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

    populateWs(w, 16)  # Voir changement de mémoire

    let a = h0
    let b = h1
    let c = h2
    let d = h3 
    let e = h4
    let f = h5
    let g = h6
    let h = h7

    let (res_a, res_b, res_c, res_d, res_e, res_f, res_g, res_h) = main_loop(a, b, c, d, e, f, g, h, 0)

    return (h0= h0 + res_a, h1= h1 + res_b, h2= h2 + res_c, h3= h3 + res_d, h4= h4 + res_e, h5= h5 + res_f, h6= h6 + res_g, h7= h7 + res_h)
end



func main{output_ptr: felt*}():
    alloc_locals
    local pub0 =
    local pub1 =
    local pub2 =
    local pub3 =
    local pub4 =
    local pub5 =
    local pub6 =
    local pub7 =

    let (local x: felt*) = alloc()
    %{
        ids.[x] = program_input['x0']
        ids.[x+1] = program_input['x1']
        ids.[x+2] = program_input['x2']
        ids.[x+3] = program_input['x3']
        ids.[x+4] = program_input['x4']
        ids.[x+5] = program_input['x5']
        ids.[x+6] = program_input['x6']
        ids.[x+7] = program_input['x7']
        ids.[x+8] = program_input['x8']
        ids.[x+9] = program_input['x9']
        ids.[x+10] = program_input['x10']
        ids.[x+11] = program_input['x11']
        ids.[x+12] = program_input['x12']
        ids.[x+13] = program_input['x13']
        ids.[x+14] = program_input['x14']
        ids.[x+15] = program_input['x15']
    %}

    let (y0, y1, y2, y3, y4, y5, y6, y7) = sha256(x)

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

