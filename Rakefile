# http://jmlacroix.com/archives/cloudfront-publishing.html

# requires:
# - jekyll (gem install jekyll)
# - compass (gem install compass)
# - google closure http://closure-compiler.googlecode.com/files/compiler-latest.zip
# - thin (gem install thin)
# - optipng (brew install optipng)
# - s3cmd (brew install s3cmd, s3cmd --configure)
# - htmlcompressor http://code.google.com/p/htmlcompressor/
# - for building pages with JSON: gem install json

build_dir = '_site/'
cdn = ''
bucket = ''
sass_dir = "styles"
COMPILER_JAR = "D:\\utils\\GoogleClosure\\compiler.jar"
COMPRESSOR_JAR = "D:\\utils\\htmlcompressor\\htmlcompressor-1.3.jar"
libs_dir = "_libs/"

# Travis's additions:
images_dir = "images/"
PNG_COMPRESS_BAT = "D:\\utils\\SendToPng.bat"
png_compress = "#{libs_dir}png.bat #{PNG_COMPRESS_BAT} #{images_dir}"
# see iisexpress.bat for more info
# IIS Express http://www.microsoft.com/downloads/en/details.aspx?FamilyID=abc59783-89de-4adc-b770-0a720bb21deb
port_num = "9010"
iis_express = "#{libs_dir}iisexpress.bat #{build_dir} #{port_num}"


task :default => :server

desc 'optimize all PNGs'
task :optimize_images do
  # use custom PNG compress batch file
  system "#{png_compress}"
end

desc 'Delete generated _site files'
task :clean do
  system "rm -rf #{build_dir}*"
end

desc 'Start server with --auto'
task :server => ['build:testing'] do
  #  system "thin start -R #{libs_dir}thin.ru"
  # Use IIS Express on windows:
  system "#{iis_express}"
  # launch browser to url
  system "start http://localhost:#{port_num}/"
end

desc 'Build site with Jekyll'
namespace 'build' do
  
  task :jekyll => [:clean] do
    jekyll('--no-future')
  end
  
  desc 'compile css'
  task :compass, [:environment, :output_style] do |t, args|
    args.with_defaults(:environment => "development", :output_style => "expanded")
    system "compass compile --sass-dir #{sass_dir} --css-dir #{build_dir}#{sass_dir} -e #{args.environment} -s #{args.output_style}"
  end
  
  desc 'uses Google Compiler to optimize javascript'
  task :javascript_compile do
    system "ruby #{libs_dir}javascript_compile.rb #{build_dir} #{COMPILER_JAR}"
  end
  
  desc 'version and replace static content'
  task :version_static_content, :cdn do |t, args|
    system "ruby #{libs_dir}version_static_content.rb #{build_dir} #{args.cdn}"
  end
  
  desc 'compress all html'
  task :html_compress do
    system "ruby #{libs_dir}html_compress.rb #{build_dir} #{COMPRESSOR_JAR}"
  end
  
  task :testing => [:jekyll, :compass, :javascript_compile, :version_static_content, :html_compress]
  
  # production build should gzip content and add the CDN
  task :production => [:jekyll] do
    Rake::Task['build:compass'].invoke('production', 'compressed')
    Rake::Task['build:javascript_compile'].invoke
    Rake::Task['build:version_static_content'].invoke(cdn)
    Rake::Task['build:html_compress'].invoke
    system "ruby #{libs_dir}gzip_content.rb #{build_dir}"
  end
  
end

desc 'Build and deploy'
task :publish => 'build:production' do
#  puts "Publishing site to bucket #{bucket}"
#  system "ruby #{libs_dir}aws_s3_sync.rb #{build_dir} #{bucket}"
end

def jekyll(opts = '')
  system 'jekyll ' + opts
end