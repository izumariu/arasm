#!/usr/bin/env ruby

require "digest"

$cmdlist		= []
$blocks 		= []
$out				= []
$help				= "USAGE: darasm <-f file> [ -o outfile ]"
$options 		= {}
$loopcount 	= 0

ARGV.each_with_index do |i,ind|
	case i
	when "-f"
		$options["file"] = ARGV[ind+1]
	when "-o"
		$options["outfile"] = ARGV[ind+1]
	end
end

unless $options["file"]
	abort $help
end

$options["outfile"] ||= $options["file"].split(?.)[0..-2].join(?.)+".arasm"

content = File.read($options["file"]) rescue abort($help)
content.inspect.match(/\\x[A-F0-9]{2}/)&&content = content.bytes.map{|i|sprintf("%02x",i)}.join
content.gsub!(/[^0-9A-F]/i,"")
content = content.downcase

content.length%16==0 || abort("FATAL: INSTRUCTION LENGTH DOES NOT SEEM TO BE 16.")

(content.length/16).times{|i|$cmdlist<<content[i*16,16]} # divide it into proper instructions

lptr = 0

while lptr < cmdlist.length
	com = $cmdlist[lptr]
	case com
	when /^0/
		$out << "mvd $#{com[1,7]} $#{com[8,8]}"
	when /^1/
		$out << "mvw $#{com[1,7]} $#{com[8,8]}"
	when /^2/
		$out << "mvb $#{com[1,7]} #{com[8,8].to_i(16)}"
	when /^3/
		bname = Digest::MD5.hexdigest($loopcount.to_s)[10,8]
		$out << "dlt $#{com[1,7]} $#{com[8,8]} .#{bname}"
		$blocks << bname
		$loopcount += 1
	when /^4/
		bname = Digest::MD5.hexdigest($loopcount.to_s)[10,8]
		$out << "dgt $#{com[1,7]} $#{com[8,8]} .#{bname}"
		$blocks << bname
		$loopcount += 1
	when /^5/
		bname = Digest::MD5.hexdigest($loopcount.to_s)[10,8]
		$out << "deq $#{com[1,7]} $#{com[8,8]} .#{bname}"
		$blocks << bname
		$loopcount += 1
	when /^6/
		bname = Digest::MD5.hexdigest($loopcount.to_s)[10,8]
		$out << "dne $#{com[1,7]} $#{com[8,8]} .#{bname}"
		$blocks << bname
		$loopcount += 1
	when /^7/
		bname = Digest::MD5.hexdigest($loopcount.to_s)[10,8]
		$out << "wlt $#{com[1,7]} $#{com[8,8]} .#{bname}"
		$blocks << bname
		$loopcount += 1
	when /^8/
		bname = Digest::MD5.hexdigest($loopcount.to_s)[10,8]
		$out << "wgt $#{com[1,7]} $#{com[8,8]} .#{bname}"
		$blocks << bname
		$loopcount += 1
	when /^9/
		bname = Digest::MD5.hexdigest($loopcount.to_s)[10,8]
		$out << "weq $#{com[1,7]} $#{com[8,8]} .#{bname}"
		$blocks << bname
		$loopcount += 1
	when /^a/
		bname = Digest::MD5.hexdigest($loopcount.to_s)[10,8]
		$out << "wne $#{com[1,7]} #{com[8,8].to_i(16)} .#{bname}"
		$blocks << bname
		$loopcount += 1
	when /^b/
		$out << "lof $#{com[1,7]}"
	when /^c/
		$rop && abort("FATAL: TRYING TO PLACE A ROP BLOCK ON LINE #{i+1} INTO ROP ON LINE #{$rop[0]+1}, WTF.")
		bname = Digest::MD5.hexdigest($loopcount.to_s)[10,8]
		$rop = [i,bname]
		$out << "rop #{com[8,8]} .#{bname}"
		$loopcount += 1
	when /^d0/
		$out << "~#{$blocks.pop}"
	when /^d1/
		$out << "~#{$rop[1]}"
		$rop = nil
	when /^d2/
		$out << "~#"
		$rop = nil
		$blocks = []
	when /^d3/
		$out << "sof $#{com[8,8]}"
	when /^d4/
		$out << "ast $#{com[8,8]}"
	when /^d5/
		$out << "sst $#{com[8,8]}"
	when /^d6/
		$out << "sid $#{com[8,8]}"
	when /^d7/
		$out << "siw $#{com[8,8]}"
	when /^d8/
		$out << "sib #{com[8,8].to_i(16)}"
	when /^d9/
		$out << "lsd $#{com[8,8]}"
	when /^da/
		$out << "lsw $#{com[8,8]}"
	when /^db/
		$out << "lsb $#{com[8,8].to_i(16)}"
	when /^dc/
		$out << "aof $#{com[8,8]}"
	when /^e/
		abort "FATAL: INSTRUCTION 'E' IS NOT IMPLEMENTED YET"
		$out << "fmv $#{com[1,7]} $#{com[8,8]}"
	when /^f/
		$out << "fcp $#{com[1,7]} $#{com[8,8]}"
	else
		abort("FATAL: UNKNOWN INSTRUCTION #{com[0,2].upcase} ON LINE #{lptr+1}.")
	end

	lptr+=1
end

$out = $out.join("\n")
#puts $out
File.write($options["outfile"],$out)
