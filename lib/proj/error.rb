module Proj
  # Represents error thrown by Proj
  #
  # @see https://proj.org/development/errorhandling.html Error Handling
  class Error < StandardError
    # Error codes typically related to coordinate operation initialization
    PROJ_ERR_INVALID_OP = 1024 # Other/unspecified error related to coordinate operation initialization
    PROJ_ERR_INVALID_OP_WRONG_SYNTAX = PROJ_ERR_INVALID_OP + 1 # Invalid pipeline structure, missing +proj argument, etc
    PROJ_ERR_INVALID_OP_MISSING_ARG = PROJ_ERR_INVALID_OP + 2 # Missing required operation parameter
    PROJ_ERR_INVALID_OP_ILLEGAL_ARG_VALUE = PROJ_ERR_INVALID_OP + 3 # One of the operation parameter has an illegal value
    PROJ_ERR_INVALID_OP_MUTUALLY_EXCLUSIVE_ARGS = PROJ_ERR_INVALID_OP + 4 # Mutually exclusive arguments
    PROJ_ERR_INVALID_OP_FILE_NOT_FOUND_OR_INVALID = PROJ_ERR_INVALID_OP + 5 # File not found (particular case of PROJ_ERR_INVALID_OP_ILLEGAL_ARG_VALUE)

    # Error codes related to transformation on a specific coordinate
    PROJ_ERR_COORD_TRANSFM = 2048 # Other error related to coordinate transformation
    PROJ_ERR_COORD_TRANSFM_INVALID_COORD  = PROJ_ERR_COORD_TRANSFM + 1 # For e.g lat > 90deg
    PROJ_ERR_COORD_TRANSFM_OUTSIDE_PROJECTION_DOMAIN = PROJ_ERR_COORD_TRANSFM + 2 # Coordinate is outside of the projection domain. e.g approximate mercator with |longitude - lon_0| > 90deg, or iterative convergence method failed
    PROJ_ERR_COORD_TRANSFM_NO_OPERATION = PROJ_ERR_COORD_TRANSFM + 3 # No operation found, e.g if no match the required accuracy, or if ballpark transformations were asked to not be used and they would be only such candidate
    PROJ_ERR_COORD_TRANSFM_OUTSIDE_GRID = PROJ_ERR_COORD_TRANSFM + 4 # Point to transform falls outside grid or subgrid
    PROJ_ERR_COORD_TRANSFM_GRID_AT_NODATA = PROJ_ERR_COORD_TRANSFM + 5 # Point to transform falls in a grid cell that evaluates to nodata

    # Other type of errors
    PROJ_ERR_OTHER = 4096
    PROJ_ERR_OTHER_API_MISUSE = PROJ_ERR_OTHER + 1 # Error related to a misuse of PROJ API
    PROJ_ERR_OTHER_NO_INVERSE_OP = PROJ_ERR_OTHER + 2 # No inverse method available
    PROJ_ERR_OTHER_NETWORK_ERROR = PROJ_ERR_OTHER + 3 # Failure when accessing a network resource

    # Check the context to see if an error occurred. If an error has happened will
    # raise an exception.
    def self.check(context)
      unless context.errno == 0
        # raise(self, "#{self.category(context.errno)}: #{self.message(context)}")
        raise(self, self.message(context, context.errno))
      end
    end

    # Returns the current error-state of the context. An non-zero error codes indicates an error.
    #
    # See https://proj.org/development/reference/functions.html#c.proj_errno_string proj_errno_string
    #
    # @param context [Context] The context the error occurred in
    # @param errno [Integer] The error number
    #
    # return [String]
    def self.message(context, errno)
      if Api.method_defined?(:proj_context_errno_string)
        Api.proj_context_errno_string(context, errno)
      elsif Api.method_defined?(:proj_errno_string)
        Api.proj_errno_string(errno)
      end
    end

    # Converts an errno to a error category
    def self.category(errno)
      self.constants.find do |constant|
        self.const_get(constant) == errno
      end
    end
  end
end