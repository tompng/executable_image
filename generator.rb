require 'chunky_png'
def header w, h
  i2s = ->(n) { 4.times.map { |i|((n >> (8 * i)) & 0xff).chr }.join }
  a = "BM#{i2s[54+w*h*3]}\0\0\0\0#{i2s[54]}#{i2s[40]}#{i2s[w]}#{i2s[h]}"
  b = "\x01\0\x18\0\0\0\0\0#{i2s[w*h*3]}\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
  a + b
end

whs=[*0..256].repeated_permutation(2).select do |a, b|
  next false unless a < b
  next false unless ((a*b*3+54)>>8)&0xff=='#'.ord
  next false unless [*?a..?z,*?A..?Z,*?0..?9,?;].include? ((a*b*3+54)&0xff).chr
  a > b / 2
end
p whs.sort_by{|a,b|a*b}.map{|a,b|[[a,b],(a*b)]}

code_begin = %(\n;$a=<<'EOF';\n)
code_eval = %(
  $e='';
  for$b($a=~/..../g){
    $d=0;
    for$c($b=~/./g){
      $d=$d*4+ord($c)%4;
    }
    $e.=chr$d;
  }
).lines.map(&:strip).join
code_eval += "exec'ruby','-e',$e"
# code_eval += "eval$e"
code_end = "\nEOF\n#{code_eval}"

image = ChunkyPNG::Image.from_file 'input.png'
code = File.read 'code.rb'
# code = File.read 'code.pl'

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
    cidx, coffset = (i - code_begin.size).divmod 4
    bit2 = ((code[cidx] || ' ').ord >> (2*(3-coffset))) & 3
    col = 4 if col&0xfc == 8
    ((col & 0xfc) | bit2).chr
  end.join,
  code_end
].join
