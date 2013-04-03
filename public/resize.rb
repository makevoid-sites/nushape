# photos_src -> photos

# creates a copy of the same directories with the resized files


# configs

SIZE = "1100x700"
SIZE_THUMB = "600x400"

# helpers

class String

  def without_first
    split("/")[1..-1].join("/")
  end

  def filenamize
    gsub(/\s+/, '_')
  end

end

def exec(cmd)
  puts "executing: #{cmd}"
  out = nil
  out = `#{cmd}`
  puts out
end

def mkdir(dir)
  exec "mkdir -p #{dir}"
end

def convert(src, dest)
  exec "convert '#{src}' -geometry #{SIZE} -density 72 #{dest.filenamize}"
end

def thumbs(src, dest)
  dims = SIZE_THUMB
  exec "convert '#{src}' -resize '#{dims}^' -gravity center -crop #{dims}+0+0 +repage -density 72 #{dest.filenamize}"
end


# main

exec "rm -rf ./photos"
# exec "rm -rf ./photos_thumbs"

@dir_src = dir_src = "photos_src"
@dir_dest = dir_dest = "photos"

Dir.glob("#{dir_src}/**/**").each do |file|
  dest = "#{dir_dest}/#{file.without_first}"
  dest_thumbs = "#{dir_dest}_thumbs/#{file.without_first}"

  if File.directory? file
    mkdir dest
    mkdir dest_thumbs
  else
    convert file, dest
    thumbs  file, dest_thumbs
  end
end
