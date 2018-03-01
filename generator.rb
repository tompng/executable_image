require 'chunky_png'
def header w, h
  i2s = ->(n) { 4.times.map { |i|((n >> (8 * i)) & 0xff).chr }.join }
  a = "BM#{i2s[54+w*h*3]}\0\0\0\0#{i2s[54]}#{i2s[40]}#{i2s[w]}#{i2s[h]}"
  b = "\x01\0\x18\0\0\0\0\0#{i2s[w*h*3]}\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
  a + b
end

whs=[*0..256].repeated_permutation(2).select do |a, b|
  next false unless a > b
  headersize = (3*a+3)/4*4*b+54
  next false unless a % 4 == 0 # needs padding bytes
  next false unless (headersize>>8)&0xff=='#'.ord
  next false unless [*?a..?z,*?A..?Z,*?0..?9,?;].include? (headersize&0xff).chr
  a / 2 < b
end
puts 'possible [[w, h], w*h]'
p whs.sort_by{|a,b|a*b}.map{|a,b|[[a,b],(a*b)]}

code_begin = %(\n;$a=<<'EOF';\n)
code_eval = %(
  $e='';
  for$b($a=~/.../g){
    $d=0;
    for$c($b=~/./g){
      $d=$d*8+ord($c)%8;
    }
    $e.=chr$d;
  }
).lines.map(&:strip).join
code_eval += "eval$e"
code_end = "\nEOF\n#{code_eval}"

image = ChunkyPNG::Image.from_file 'input.png'
code = File.read 'code.pl'

w = 68
h = 44
File.write 'out.bmp', [
  header(w, h),
  (3 * w * h - code_end.size).times.map do |i|
    next code_begin[i] if i < code_begin.size
    pos, cidx = i.divmod 3
    y, x = pos.divmod w
    color = image[x * image.width / w, (h - y - 1) * image.height / h]
    col = (color >> (8 * (cidx+1))) & 0xff
    cidx, coffset = (i - code_begin.size).divmod 3
    bit3 = ((code[cidx] || ' ').ord >> (3*(2-coffset))) & 7
    col = 4 if col&0xfc == 8
    ((col & 0xf8) | bit3).chr
  end.join,
  code_end
].join
