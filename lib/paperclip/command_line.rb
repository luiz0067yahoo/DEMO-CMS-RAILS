def full_path(binary)
  [self.class.path, binary].compact.join("/")
end