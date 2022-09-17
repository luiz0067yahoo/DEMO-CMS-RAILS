class Paperclip::CommandLine
#	Paperclip.options[:command_path] = 'C:\Program Files (x86)\GnuWin32\bin'
#	Paperclip.options[:command_path] = 'C:\Program Files\ImageMagick-6.9.10-Q16-HDRI'
  def full_path(binary)
    [self.class.path, binary].compact.join((File::ALT_SEPARATOR||File::SEPARATOR))
  end
end if defined?(Paperclip::CommandLine)