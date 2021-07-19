%builtins output range_check

from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.math import unsigned_div_rem

# Grosse utilisation de hint
# func mod2{range_check_ptr}(x: felt) -> (res: felt):
#     let (_, r) = unsigned_div_rem(value=x, div=2)
#     return (res = r)
# end

func mod2{range_check_ptr}(x: felt) -> (res: felt):
    let (_, r) = unsigned_div_rem{range_check_ptr=range_check_ptr}(value=x, div=2)
    return (res = r)
end


func main{output_ptr: felt*, range_check_ptr}():
    let (rx) = mod2{range_check_ptr=range_check_ptr}(12319780317203198730)
    serialize_word(rx)
    return ()
end