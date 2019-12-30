module Proj
  class Error < StandardError
    def self.check(errno=nil)
      unless errno
        errno = Context.current.errno
      end

      if errno != 0
        message = if Api.method_defined?(:proj_errno_string)
                    Api.proj_errno_string(errno)
                  else
                    Api.pj_strerrno(errno)
                  end
        raise(self, message)
      end
    end
  end
end