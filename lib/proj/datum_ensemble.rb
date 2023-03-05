module Proj
  class DatumEnsemble < PjObject

    # Returns the number of members of a datum ensemble
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_datum_ensemble_get_member_count proj_datum_ensemble_get_member_count
    #
    # @return [Integer]
    def count
      Api.proj_datum_ensemble_get_member_count(self.context, self)
    end

    # Returns a member from a datum ensemble.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_datum_ensemble_get_member proj_datum_ensemble_get_member
    #
    # @param index [Integer] Index of the datum member to extract. Should be between 0 and DatumEnsembel#count - 1.
    #
    # @return [Integer]
    def [](index)
      ptr = Api.proj_datum_ensemble_get_member(self.context, self, index)
      PjObject.create_object(ptr, self.context)
    end

    # Returns the positional accuracy of the datum ensemble
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_datum_ensemble_get_accuracy proj_datum_ensemble_get_accuracy
    #
    # @return [Float] The data ensemble accuracy or -1 in case of error
    def accuracy
      Api.proj_datum_ensemble_get_accuracy(self.context, self)
    end
  end
end
