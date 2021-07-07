%builtins output

from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.math import unsigned_div_rem

# Grosse utilisation de hint
func mod2(x: felt) -> (res: felt):
    alloc_locals
    local res
    %{ ids.res = ids.x % 2 %}
    return (res=res)
end

func getBit(x: felt, i: felt) -> (res: felt):
    let (xmod2) = mod2(x)
    if i == 0:
        return (res=xmod2)
    end

    let (bit) = getBit( (x-xmod2) / 2, i-1)

    return (res=bit)
end


func pow(x: felt, n: felt) -> (res: felt):
    if n == 0:
        return (res=1)
    end
    if n == 1:
        return (res=x)
    end

    let (nmod2) = mod2(n)
    if nmod2 == 0: 
        let (nextpow) = pow(x, n/2)
        return (res=nextpow * nextpow)
    else:
        let (nextpow) = pow(x, (n-1)/2)
        return (res=nextpow * x * nextpow)
    end
end


func aux_xor32(x: felt, y: felt, i: felt) -> (res: felt):
    alloc_locals
    let (xBit) = getBit(x, i)
    local xBit = xBit
    let (yBit) = getBit(y, i)
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
        let (next) = aux_xor32(x, y, i+1)
        local next = next
        if xBit == 1:
            if yBit == 1:
                return (res=next)
            else:
                let (pw) = pow(2,i)
                return (res= pw + next)
            end

        else:
            if yBit == 1:
                let (pw) = pow(2,i)
                return (res = pw + next)
            else :
                return (res=next)
            end
        end
    end

end


func xor32(x: felt, y: felt) -> (res: felt):
    let (res) = aux_xor32(x, y, 0)
    return (res=res)
end

func aux_and32(x: felt, y: felt, i: felt) -> (res: felt):
    alloc_locals
    let (xBit) = getBit(x, i)
    local xBit = xBit
    let (yBit) = getBit(y, i)
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
        let (next) = aux_and32(x, y, i+1)
        local next = next
        if xBit == 1:
            if yBit == 1:
                let (pw) = pow(2,i)
                return (res= pw + next)
            else:
                return (res=next)
            end
        else: 
            return (res=next)
        end
    end

end

func and32(x: felt, y: felt) -> (res: felt):
    let (res) = aux_and32(x, y, 0)
    return (res=res)
end

func main{output_ptr: felt*}():
    let (rx) = and32(2223183769, 5563983)
    serialize_word(rx)
    return ()
end