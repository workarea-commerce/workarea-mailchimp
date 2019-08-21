module Gibbon
  decorate Request, with: :mail_chimp do
    # hack to add to the path keeping '_' intact
    def add_path_part(part)
      @path_parts << part.to_s.downcase
      @path_parts.flatten!
      self
    end
  end
end
