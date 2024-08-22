
  do ->

    { Num, Bool } = dependency 'primitive.Type'
    { string-from-code-point, camel-case } = dependency 'native.String'
    { block-chars } = dependency 'console.Block'
    { square-root } = dependency 'native.Number'

    quadrant-suffixes = <[
      lower-left lower-right upper-left
      upper-left-and-lower-left-and-lower-right upper-left-and-lower-right
      upper-left-and-upper-right-and-lower-left upper-left-and-upper-right-and-lower-right
      upper-right upper-right-and-lower-left upper-right-and-lower-left-and-lower-right
    ]>

    quadrant-code = -> 0x2596 + Num it

    quadrant-chars = { [ (camel-case quadrant-suffixes[ index ]), (string-from-code-point quadrant-code index) ] for suffix, index in quadrant-suffixes }

    {
      empty-block: empty, full-block: full,
      upper-half-block: upper-half, lower-half-block: lower-half,
      left-half-block: left-half, right-half-block: right-half
    } = block-chars

    quadrant-chars <<< { empty, full, upper-half, lower-half, left-half, right-half }

    quadrants = <[
      empty
      upper-left upper-right upper-half lower-left left-half
      upper-right-and-lower-left upper-left-and-upper-right-and-lower-left
      lower-right upper-left-and-lower-right right-half upper-left-and-upper-right-and-lower-right
      lower-half upper-left-and-lower-left-and-lower-right upper-right-and-lower-left-and-lower-right
      full
    ]>

    new-quadrant-char = ->

      bits = void

      clear = !-> bits := [ off for til 4 ]

      clear!

      width = square-root bits.length

      winjs.process.io.stdout bits.length

      #

      index = (x, y) -> Num x ; Num y ; y + ( x * width )

      bit-as-digit = (bit) -> if bit then '1' else '0'

      as-binary = -> [ (bit-as-digit bit) for bit in bits ] |> (.reverse!) |> (* '')

      quadrant-char-index = -> parse-int as-binary!, 2

      #

      get: (x, y) -> i = index x, y ; return void if i is void ; bits[ i ]
      set: (x, y, bit = on) !-> return if (@get x, y) is void ; bits[ index x, y ] := Bool bit

      unset: (x, y) !-> @set x, y, off

      clear: -> clear!

      to-string: -> key = camel-case quadrants[ quadrant-char-index! ] ; quadrant-chars[ key ]

    {
      quadrant-chars,
      new-quadrant-char
    }