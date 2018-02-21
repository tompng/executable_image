def header w, h
  i2s = ->(n) { 4.times.map { |i|((n >> (8 * i)) & 0xff).chr }.join }
  a = "BM#{i2s[54+w*h*4]}\0\0\0\0#{i2s[54]}#{i2s[40]}#{i2s[w]}#{i2s[h]}"
  b = "\x01\0\x20\0\0\0\0\0#{i2s[w*h*4]}\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
  a + b
end

code_begin = %(\n;use MIME::Base64;exec('ruby','-e',decode_base64(<<'EOS'));\n)
code_end = "\nEOS\n"



File.write 'out.bmp', header(40, 56)+code_begin + 'a'*(40*56*4-code_begin.size-code_end.size) + code_end
